# -*- coding: utf-8 -*-
from sklearn.neighbors import KNeighborsRegressor
from sklearn import svm
from sklearn.linear_model import LinearRegression, BayesianRidge
from sklearn.metrics import mean_squared_error, accuracy_score, precision_score

import pandas as pd
import numpy as np


def get_data(mongodb, user):
    data = mongodb[user].prediction.find({})
    data = prepare_data(list(data))
    data = pd.DataFrame.from_dict(data)
    return data


def prepare_data(data):
    new_data = {'cases': [], 'weeks':[], 'temp':[], 'searches':[]}

    for d in data:
        new_data['cases'].append(d['cases'])
        new_data['weeks'].append(d['week'])
        new_data['temp'].append(d['temp'])
        new_data['searches'].append(d['searches'])

    return new_data


def linear_regression(data):
    Y = list(data['cases'])
    X = np.array([data['temp'], data['searches']]).T
    regression = LinearRegression()
    regression.fit(X[:-1],Y[1:])
    Y_prediction = regression.predict(X)
    error = mean_squared_error(Y, Y_prediction)
    error_square = np.sqrt(error)
    r2 = regression.score(X,Y_prediction)
    Y_prediction = quit_zeros(Y_prediction)
    Y_prediction = list(map(lambda x : int(x), Y_prediction))
    weeks = add_prediction_weeks(list(data['weeks']))
    return ({'y_future': predict_future(X, regression), 'weeks':list(weeks), 'data':Y, 'data_p':list(Y_prediction), 'mse':error, 'rmse':error_square, 'r^2':r2})


def support_vector_machine(data):
    X = np.array([data['temp'], data['searches']]).T
    Y = list(data['cases'])
    model = svm.SVR(kernel='rbf', C=1e3, gamma='auto')
    model.fit(X[:-1],Y[1:])
    prediction = model.predict(X)
    r2 = model.score(X, prediction)
    error = np.sqrt(mean_squared_error(Y, prediction)) 
    square_error = np.sqrt(error)
    prediction = quit_zeros(prediction)
    prediction = list(map(lambda x : int(x), prediction))
    weeks = add_prediction_weeks(list(data['weeks']))
    return ({'y_future': predict_future(X, model), 'weeks':list(weeks), 'data':Y,'data_p':list(prediction),'mse':error, 'rmse':square_error, 'r^2':r2})


def k_neighbors(data):
    X = np.array([data['temp'], data['searches']]).T
    Y = list(data['cases'])
    model = KNeighborsRegressor(n_neighbors=3)
    model.fit(X[:-1],Y[1:])
    prediction = model.predict(X)
    r2 = model.score(X, prediction)
    error = np.sqrt(mean_squared_error(Y, prediction)) 
    square_error = np.sqrt(error)
    prediction = quit_zeros(prediction)
    prediction = list(map(lambda x : int(x), prediction))
    weeks = add_prediction_weeks(list(data['weeks']))
    return ({'y_future': predict_future(X, model), 'weeks':list(weeks), 'data':Y,'data_p':list(prediction),'mse':error, 'rmse':square_error, 'r^2':r2})


def predict_future(x, model):
    y_future = []
    y_future.append(int(model.predict([x[-1]])))
    y_future.append(int(model.predict([x[-2]])))
    y_future.append(int(model.predict([x[-3]])))
    return y_future


def add_prediction_weeks(weeks):
    return weeks + [int(weeks[-1]) + 1, int(weeks[-1]) + 2, int(weeks[-1]) + 3]

def quit_zeros(data):
    for i in range(len(data)):
        if data[i] < 0:
            data[i] = 0
    return data


def get_method(mongodb, method, user):
    data = get_data(mongodb, user)
    if method == 'r_lineal':
        return linear_regression(data)
    elif method == 'svm':
        return support_vector_machine(data)
    else:
        return k_neighbors(data)
