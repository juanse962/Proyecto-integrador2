# -*- coding: utf-8 -*-
from sklearn.neighbors import KNeighborsRegressor
from sklearn import svm
from sklearn.linear_model import LinearRegression, BayesianRidge
from sklearn.metrics import mean_squared_error, accuracy_score, precision_score

import pandas as pd
import numpy as np


def get_data():
    data = pd.read_csv('Casos_Vclimaticas_2008_2012.csv')
    return data

def linear_regression():
    data = get_data()
    Y = list(data['No. Casos'])
    X = np.array([data['Temperatura'], data['No. Busquedas']]).T
    regression = LinearRegression()
    regression.fit(X[:-1],Y[1:])
    Y_prediction = regression.predict(X)
    error = mean_squared_error(Y, Y_prediction)
    error_square = np.sqrt(error)
    r2 = regression.score(X,Y_prediction)
    Y_prediction = quit_zeros(Y_prediction)
    return ({'data':Y, 'data_p':list(Y_prediction), 'mse':error, 'rmse':error_square, 'r^2':r2})


def support_vector_machine():
    data = get_data()
    X = np.array([data['Temperatura'], data['No. Busquedas']]).T
    Y = list(data['No. Casos'])
    model = svm.SVR(kernel='rbf', C=1e3, gamma='auto')
    model.fit(X[:-1],Y[1:])
    prediction = model.predict(X)
    r2 = model.score(X, prediction)
    error = np.sqrt(mean_squared_error(Y, prediction)) 
    square_error = np.sqrt(error)
    y_future = []
    i = -1
    weeks = []

    for x in range(1,4):
        x_predict = X[i]
        y_future.append(model.predict([x_predict]))
        weeks.append(list(data['Semana'])[-1]+x)
        i -= 1

    #prediction[0] = 'nan'
    #Y[-1] = 'nan'

    prediction = quit_zeros(prediction)
    return ({'data':Y,'data_p':list(prediction),'mse':error, 'rmse':square_error, 'r^2':r2})


def get_method(method):
    if method == 'r_lineal':
        return linear_regression()
    elif method == 'svm':
        return support_vector_machine()
    else:
        return ({'error':'falta por implementar el kn'})

def get_information():
    linear_r = linear_regression()
    svr = support_vector_machine()
    df = pd.DataFrame([linear_r, svr], columns=['MSE', 'RMSE', 'Score'])
    print (df)

def quit_zeros(data):
    for i in range(len(data)):
        if data[i] < 0:
            data[i] = 0
    return data


"""def get_corr():
    data = get_data()
    df = pd.DataFrame(data=data)
    print df[['No. Casos', 'Temperatura', 'Precipitacion', 'H. Relativa', 'No. Busquedas']].corr(method='pearson')
"""
