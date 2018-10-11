# -*- coding: utf-8 -*-
from sklearn.neighbors import KNeighborsRegressor
from sklearn import svm
from sklearn.linear_model import LinearRegression, BayesianRidge
from sklearn.metrics import mean_squared_error, accuracy_score, precision_score

import pandas as pd
import numpy as np
import pylab as pl


def get_data():
    data = pd.read_csv('Casos_Vclimaticas_2008_2012.csv')
    return data

def linear_regression():
    data = get_data()
    Y = np.array(data['No. Casos'])
    X = np.array([data['Temperatura'], data['Precipitacion'], data['H. Relativa'], data['No. Busquedas']]).T
    regression = LinearRegression()
    regression.fit(X,Y)
    Y_prediction = regression.predict(X)
    error = mean_squared_error(Y, Y_prediction)
    error_square = np.sqrt(error)
    r2 = regression.score(X,Y_prediction)
    #pl.plot(data['Semana'], Y, '-r', label='Data')
    pl.plot(data['Semana'], Y_prediction, label='Regression')
    pl.legend()
    #pl.show()
    return (error, error_square, r2)


def support_vector_machine():
    data = get_data()
    X = np.array([data['Temperatura'], data['Precipitacion'], data['H. Relativa'], data['No. Busquedas']]).T
    Y = data['No. Casos']
    model = svm.SVR(kernel='rbf', C=1e3, gamma='auto')
    model.fit(X,Y)
    prediction = model.predict(X)
    taining_set = model.predict(X[:-1])
    r2 = model.score(X, prediction)
    error = np.sqrt(mean_squared_error(Y, prediction)) 
    square_error = np.sqrt(error)
    pl.plot(data['Semana'], prediction, '-r', label='SVR')
    pl.plot(data['Semana'], Y, 'x', label='Data')
    pl.legend()
    pl.show()
    return (error, square_error, r2)


def get_information():
    linear_r = linear_regression()
    svr = support_vector_machine()
    df = pd.DataFrame([linear_r, svr], columns=['MSE', 'RMSE', 'Score'])
    print (df)




if __name__ == '__main__':
    get_information()
