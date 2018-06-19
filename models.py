import time
import numpy as np
from scipy.integrate import solve_ivp
from bson.json_util import loads, dumps

def dengue(params):
    t0 = 1
    tf = int(params['tMax'])+1

    if tf>1000:
        return {"error":"-2"}
    elif tf == 2:
        return {"error":"0","xAxe":[1], "simHi":[float(params['Hi0'])], "controlPulse":[0]}
    elif tf < 2:
        return {"error":"-2"}

    t = np.arange(t0,tf,1)

    E0 = float(params['E0'])
    L0 = float(params['L0'])
    P0 = float(params['P0'])
    Ms0 = float(params['Ms0'])
    Me0 = float(params['Me0'])
    Mi0 = float(params['Mi0'])
    Hs0 = float(params['Hs0'])
    He0 = float(params['He0'])
    Hi0 = float(params['Hi0'])
    Hr0 = float(params['Hr0'])

    alpha = float(params['alpha'])
    delta = float(params['delta'])
    C = float(params['C'])
    gamma_e = float(params['gamma_e'])
    mu_e = float(params['mu_e'])
    gamma_l = float(params['gamma_l'])
    mu_l = float(params['mu_l'])
    gamma_p = float(params['gamma_p'])
    mu_p = float(params['mu_p'])
    f = float(params['f'])
    beta_m = float(params['beta_m'])
    mu_m = float(params['mu_m'])
    theta_m = float(params['theta_m'])
    mu_h = float(params['mu_h'])
    beta_h = float(params['beta_h'])
    theta_h = float(params['theta_h'])
    gamma_h = float(params['gamma_h'])

    A_c = []
    dt_c = []
    t0_c = []

    number_c = 1
    while True:
        try:
            A_c.append(loads(params['A_c'+str(number_c)]))
            dt_c.append(loads(params['dt_c'+str(number_c)]))
            t0_c.append(loads(params['t0_c'+str(number_c)]))
        except Exception:
            break
        number_c += 1

    number_c -= 1

    if number_c == 0:
        A_c.append(0)
        dt_c.append(0)
        t0_c.append(0)

    y0 = [E0, L0, P0, Ms0, Me0, Mi0, Hs0, He0, Hi0, Hr0]
    controlPulse = []   

    # Assing values to controlPulse
    for t_c in range(tf):
        control = 0
        for i in range(number_c):
            if (t_c+1 >= t0_c[i] and t_c+1 <= t0_c[i]+dt_c[i]):
                control += A_c[i]
        controlPulse.append(control)

    def stopF(t,y):
        stop = time.time() - startTime
        if stop > 25: # Stop at 25 seconds
            stop = 0
        return stop

    stopF.terminal = True

    def evalF(x,y):
        M = y[3] + y[4] + y[5]
        H = y[6] + y[7] + y[8] + y[9]

        u_m = controlPulse[int(x)-1]

        return np.array([
            delta*(1-y[0]/C)*M - (gamma_e + mu_e)*y[0],
            gamma_e*y[0] - (gamma_l+mu_l)*y[1],
            gamma_l*y[1] - (gamma_p+mu_p)*y[2],
            f*gamma_p*y[2] - (beta_m*y[8]*y[3])/H - (mu_m+u_m)*y[3],
            (beta_m*y[8]*y[3])/H - (theta_m + (alpha*mu_m) + u_m)*y[4],
            theta_m*y[4] - (mu_m*alpha + u_m)*y[5],
            mu_h*H - (beta_h*y[5]*y[6])/M - mu_h*y[6],
            (beta_h*y[5]*y[6])/M - (theta_h+mu_h)*y[7],
            theta_h*y[7] - (gamma_h+mu_h)*y[8],
            gamma_h*y[8] - mu_h*y[9]
        ])
    
    startTime = time.time()

    sim = solve_ivp(evalF, t_span = (t[0],t[-1]), t_eval = t,
                    y0 = y0, method = 'BDF', max_step = 0.1, vectorized = True, events=stopF)

    yOut = sim.y[8]
    simHi = np.round(yOut)

    # Remove last value
    controlPulse.pop()

    return {"error":sim.status,"xAxe":t.tolist(), "simHi":simHi.tolist(), "controlPulse":controlPulse}
        
