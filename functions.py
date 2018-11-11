import copy
import numpy as np

from random import choice
from bson.json_util import loads, dumps
from shapely.geometry import mapping, shape, Point
from bson.objectid import ObjectId

def getUsers(mongodb):
    return mongodb.users.find({ 'user': { '$ne': 'admin' } },{'user':1,'role':1})

def getParameters(mongodb, user):
    simData = mongodb[user].byWeeks.sim.find_one()
    params = mongodb[user].parameters.find_one()
    if simData != None:
        params['Hi_exp'] = simData['Hi_exp']
    return params

def getDashboard(mongodb, cookie):
    data = {'cookie':cookie, 'users':[], 'modules':{}}
    data['user'] = mongodb.sessions.find_one({'cookie':cookie}, {'user':1})['user']

    users = mongodb.users.find({ 'role': { '$eq': 'editor' } },{'user':1,'role':1})
    for u in users:
        data['users'].append(u['user'])

    data['modules']['data'] = mongodb[data['user']].byWeeks.data.find_one() != None 
    data['modules']['sim'] = mongodb[data['user']].parameters.find_one() != None
    data['modules']['geo'] = mongodb[data['user']].byWeeks.geo.find_one() != None and mongodb[data['user']].layers.find_one() != None
    
    return data

def getChannelData(base, channel, population, method, years):
    data = {'base':base}

    if method == 'mc':
        channelSorted = np.sort(channel, axis=0)
        if years == 3:
            data['inf'] = channelSorted[0,].tolist()
            data['med'] = channelSorted[1,].tolist()
            data['sup'] = channelSorted[2,].tolist()
        elif years == 5:
            data['inf'] = channelSorted[0,].tolist()
            data['med'] = channelSorted[2,].tolist()
            data['sup'] = channelSorted[4,].tolist()
        elif years == 7:
            data['inf'] = channelSorted[1,].tolist()
            data['med'] = channelSorted[3,].tolist()
            data['sup'] = channelSorted[5,].tolist()
        else:
            return {'error': 'Número de años incorrecto'}
        return data
    elif method == 'mpm':
        correctionFactor = population['base']/np.mean(population['others'])
        expectedValues = np.mean(channel, axis=0)*correctionFactor
        maExpectedValues = np.empty(52)

        # pseudo-moving average
        i = 0
        while i < 52:
            indices = [i-2,i-1,i,(i+1)%52,(i+2)%52]
            maExpectedValues[i] = np.mean(expectedValues[indices])
            i += 1

        S = np.mean(np.power(expectedValues-maExpectedValues,2))
        data['inf'] = np.round(maExpectedValues-2*S).clip(min=0).tolist()
        data['med'] = np.round(maExpectedValues).tolist()
        data['sup'] = np.round(maExpectedValues+2*S).tolist()

        return data

    elif method == 'mic':
        rates = np.zeros([years, 52])
        i = 0
        for c in channel:
            rates[i,] = (np.array(c)/population['others'][i]*100000)+1
            i += 1
        logRates = np.log(rates)
        meanLogRates = np.mean(logRates, axis=0)
        stdDevLogRates = np.std(logRates, axis=0)

        if years == 3:
            tValue = 4.302653
        elif years == 5:
            tValue = 2.776445
        elif years == 7:
            tValue = 2.446912
        else:
            {'error': 'Número de años incorrecto'}

        infICLogRates = meanLogRates - tValue*stdDevLogRates/np.sqrt(years)
        supICLogRates = meanLogRates + tValue*stdDevLogRates/np.sqrt(years)

        meanRates = np.exp(meanLogRates)-1
        infICRates = np.exp(infICLogRates)-1
        supICRates = np.exp(supICLogRates)-1

        data['inf'] = np.round(infICRates*population['base']/100000).clip(min=0).tolist()
        data['med'] = np.round(meanRates*population['base']/100000).tolist()
        data['sup'] = np.round(supICRates*population['base']/100000).tolist()

        return data
    else:
        return {'error': 'Método incorrecto'}


def getChannelYears(mongodb, user):
    data = {}
    n = 1
    for doc in mongodb[user].byWeeks.data.find().sort('year', -1):
        data[n] = doc['year']
        n += 1
    return data

def getDataByWeeks(mongodb, user):
    data = {}
    n = 1

    for doc in mongodb[user].byWeeks.data.find().sort('year', -1):
        data[n] = doc
        n += 1
    return data

def getRiskColors(mongodb, user):
    red  = '#FF0000'
    yellow = '#FFFF00'
    green = '#00FF00'

    def countWaves(data):
        epidemia = data[0]>0
        counter = 1 if epidemia else 0

        for x in data:
            if x > 0 and epidemia:
                pass
            elif x > 0 and not epidemia:
                epidemia = True
                counter += 1
            else:
                epidemia = False

        return counter 

    def getSummary(data):
        indices = dict()

        counter = 0
        alphaSum = 0
        oeSum = 0
        for year in data:
            counter += 1
            alphaSum += data[year]['alpha']
            oeSum += data[year]['alpha']*52/data[year]['beta']
        
        indices['alpha'] = alphaSum/counter
        indices['beta'] = alphaSum/oeSum*52
        return indices

    data = mongodb[user].layers.find_one()
    data.pop('_id', None)

    geo = mongodb[user].byWeeks.geo.find_one()

    casos = dict()
    indices = dict()

    alpha = []
    beta = []

    for n in data:
        polygon = data[n]['source']['data']['geometry']
        comuna = shape(polygon)
        casos[n] = dict()
        indices[n] = dict()

        for ft in geo['features']:
            caso = shape(ft['geometry'])
            year = ft['properties']['year']
            week = int(ft['properties']['week'])%52

            if comuna.contains(caso):
                if year in casos[n].keys():
                    casos[n][year][week] += 1
                else:
                    casos[n][year] = np.zeros(52)
                    casos[n][year][week] += 1

        # Calculate first index: alpha
        for year in casos[n]:
            # numero de semanas con casos (Sc)
            Sc = np.sum(casos[n][year]>0)
            indices[n][year] = {'alpha':Sc/52}
        
        # Calculate second index: beta
        for year in casos[n]:
            # onda epidemiologica  (Oe)
            Oe = countWaves(casos[n][year])
            indices[n][year]['beta'] = indices[n][year]['alpha']*52/Oe
            
        indices[n]['summary'] = getSummary(indices[n])
        alpha.append(indices[n]['summary']['alpha'])
        beta.append(indices[n]['summary']['beta'])

    meanAlpha = np.mean(alpha)
    stdAlpha = np.std(alpha)
    ubAlpha =  meanAlpha + 1.5*stdAlpha
    lbAlpha =  meanAlpha - 1.5*stdAlpha
    meanBeta = np.mean(beta)
    stdBeta = np.std(beta)
    ubBeta =  meanBeta + 1.5*stdBeta
    lbBeta =  meanBeta - 1.5*stdBeta

    dataByIndex = {'alpha':copy.deepcopy(data),'beta':copy.deepcopy(data)};

    for n in data:
        if indices[n]['summary']['alpha'] > ubAlpha:
            dataByIndex['alpha'][n]['paint']['fill-color'] = red
        elif indices[n]['summary']['alpha'] < lbAlpha: 
            dataByIndex['alpha'][n]['paint']['fill-color'] = green
        else:
            dataByIndex['alpha'][n]['paint']['fill-color'] = yellow
        
        if indices[n]['summary']['beta'] > ubBeta:
            dataByIndex['beta'][n]['paint']['fill-color'] = red
        elif indices[n]['summary']['alpha'] < lbBeta: 
            dataByIndex['beta'][n]['paint']['fill-color'] = green
        else:
            dataByIndex['beta'][n]['paint']['fill-color'] = yellow
        
    return dataByIndex

def saveData(mongodb, user, ws, datatype):
    result = False

    if datatype == 'cecps':
        i = 2
        while True:
            row = str(i)
            cell = ws['A'+row].value
            if cell is None:
                break
            datayear = str(cell)
            datapob = int(ws['B'+row].value)
            channel = [[i.value for i in j] for j in ws['C'+row:'BB'+row]]
            datachannel = str(channel[0]).replace('None','0')
            result = mongodb[user].byWeeks.data.replace_one({'year':datayear}, {'year':datayear,'population':datapob,'data':datachannel}, True)
            i += 1
    
    elif datatype == 'geopos':
        data = {"type": "FeatureCollection", "features": []}
        i = 2
        while True:
            row = str(i)
            cell = ws['A'+row].value
            if cell is None:
                break
            year = str(cell)
            week = str(ws['B'+row].value)
            x = float(ws['C'+row].value)
            y = float(ws['D'+row].value)
            data["features"].append({ "type": "Feature", "properties": {"year":year,"week":week}, "geometry": { "type": "Point", "coordinates": [x, y]}})
            i += 1
        result = mongodb[user].byWeeks.geo.replace_one({}, data, True)    
    
    elif datatype == 'params':
        data = dict()
        Hi_exp = ''
        name = ''

        i = 2
        while True:
            row = str(i)
            cell = ws['A'+row].value
            if cell is None:
                break
            name = str(cell)
            value = str(ws['B'+row].value)

            if name == 'Hi_exp':
                Hi_exp = value
            else:
                data[name] = value
            i += 1
        
        print('i: %s'%i)
        print('name: %s'%name)
        
        if not(i == 3 and name == 'Hi_exp'):
            result = mongodb[user].parameters.replace_one({}, data, True)

        if Hi_exp != '':
            result = mongodb[user].byWeeks.sim.replace_one({}, {'Hi_exp':Hi_exp}, True)
        
        print(result)
    
    elif datatype == 'layers':
        data = dict()
        def rndColor():
            letters = '0123456789ABCDEF'
            hexColor = '#'
            for i in range(6):
                hexColor += choice(letters) 
            return hexColor

        i = 2
        while True:
            row = str(i)
            cell = ws['A'+row].value
            if cell is None:
                break
            comuna = str(cell) 
            number = str(ws['B'+row].value)
            x = float(ws['C'+row].value)
            y = float(ws['D'+row].value)
            
            try:
                data[number]["source"]["data"]["geometry"]["coordinates"][0].append([x,y])
            except KeyError:
                data[number] = {"id":comuna,"type":"fill", "paint": {"fill-color": rndColor(), "fill-opacity": 0.25},"source": { "type": "geojson", "data": { "type": "Feature", "geometry": { "type": "Polygon", "coordinates":[[]] } } }}
            
            i += 1
        result = mongodb[user].layers.replace_one({}, data, True)

    elif datatype == 'predict':
        mongodb[user].prediction.delete_many({})
        data = dict()
        data_list = []
        i = 2
        while True:
            row = str(i)
            cell = ws['A'+row].value
            if cell is None:
                break
            year = str(cell)
            week = ws['B'+row].value
            temp = ws['C'+row].value
            searches = ws['D'+row].value
            data['year'] = year
            data['week'] = week
            data['temp'] = temp
            data['searches'] = searches
            data['_id'] = ObjectId()
            i += 1
            result = mongodb[user].prediction.insert(data)
            
    return result