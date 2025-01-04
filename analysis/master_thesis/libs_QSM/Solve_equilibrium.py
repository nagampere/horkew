#%% 
import numpy as np
import pandas as pd
from scipy import optimize as opt
from IPython.display import display

try: 
    from libs_QSM.Prepare_data import Prepare_data
    from libs_QSM.Estimate_params import Estimate_params
except: 
    from Prepare_data import Prepare_data
    from Estimate_params import Estimate_params

Nfeval = 1

#%%
class Solve_equilibrium(Estimate_params):
    def __init__(self,func) -> None: # inherit model classes.
        self.count = func.count
        self.param_keys = list(func.param.keys())
        self.param = func.param
        self.exog_keys = list(func.exog_next.keys())
        self.exog_prev = func.exog_prev
        self.ref_prev = func.ref_prev
        self.exog_next = func.exog_next
        self.ref_next = func.ref_next
        pass

    '''
    1. 現況再現性の確認
    '''
    def simultaneous_equations(self, l): # 未知数 w_jを解く方程式の定義
        n = self.count
        param = self.given_param
        exog = self.given_exog
        ref = self.given_ref
        N = exog['N']
        G_ij = exog['G_ij']

        # set parameters
        alp = param['alpha']
        gam = param['gamma']
        psi = param['psi']
        gameps = param['gam*eps']
        eps = param['epsilon']
        lmd = param['lambda']
        dlt = param['delta']
        eta = param['eta']
        rho = param['rho']
        beta_cns = param['beta_cns']
        beta_flr = param['beta_flr']
        beta_chd = param['beta_chd']
        mu_cost = exog['mu_cost'] + exog['mu_resids_ij']
        mu_time = exog['mu_time']
        mu_room = exog['mu_room']
        # set exogenous variables
        al_j = exog['al_j']
        bl_i = exog['bl_i']
        E_j = exog['E_j']
        K_i = exog['K_i']
        p_i = exog['p_i']
        t_ij = exog['t_ij']
        tau_ij = exog['tau_ij']
        N = exog['N']
        T = exog['T']
        L = exog['L']
        xi_i = exog['xi_i']
        # H_ave_i = exog['H_ave_i']
        phi_i = exog['phi_i']
        w_j_init = exog['w_j_init']
        N_W_j_init = exog['N_W_j_init']
        N_R_i_init = exog['N_R_i_init']
        Pi_ref_ij = ref['Pi_ij']
        q_ref_i = ref['q_i']

        # 未知数はw_j, N_R_i, N_W_j (n*3-2個)
        w_j = np.array(l[0:n])
        N_W_j_0 = np.sum(exog['N_W_j_init']) - np.sum(l[n:(n*2-1)])
        N_R_i_0 = np.sum(exog['N_R_i_init']) - np.sum(l[(n*2-1):(n*3-2)])
        N_W_j = np.append(N_W_j_0, l[n:(n*2-1)])
        N_R_i = np.append(N_R_i_0, l[(n*2-1):(n*3-2)])

        # nanの例外処理
        if np.nan in w_j : w_j = w_j_init
        if np.nan in N_W_j : N_W_j = N_W_j_init
        if np.nan in N_R_i : N_R_i = N_R_i_init
        # 負の値の例外処理
        for idx, x in enumerate(w_j): 
            if x < 0: w_j[idx] = abs(x)
        for idx, x in enumerate(N_W_j): 
            if x < 0: N_W_j[idx] = abs(x)
        for idx, x in enumerate(N_R_i): 
            if x < 0: N_R_i[idx] = abs(x)
        
        # print('w_j:',w_j - ref['w_j'])
        # print('N_W_j:',N_W_j - ref['N_W_j'])
        # print('N_R_i:',N_R_i - ref['N_R_i'])

        # 生産性A_jと都市アメニティB_iの算出
        Ups_j = np.sum(np.exp(-dlt*t_ij*60*24) * N_W_j / K_i.reshape(1, -1).T, axis=0)
        A_j = al_j*Ups_j**lmd
        Omega_i = np.sum(np.exp(-rho*t_ij*60*24) * N_R_i.reshape(1, -1).T / K_i.reshape(1, -1).T, axis=1)
        B_i = bl_i*Omega_i**eta
        # 業務用地の価格Q_jの定義
        Q_j = (1-alp) * A_j**(1/(1-alp)) / (w_j/alp)**(alp/(1-alp))
        # 居住用地の価格q_iの定義
        q_i = Q_j / xi_i

        # 時間価値v_ij, 労働量x_ij, 子供一人当たりのコストmu_ijの定義 (式(6), 式(12)を参照)
        v_ij = w_j*(1-tau_ij) / (T+t_ij)
        mu_ij = mu_cost + v_ij*mu_time + q_i.reshape(1,-1).T*mu_room
        # 実質所得W_ij, 世帯当たり子供の数n_ij
        W_ij = np.divide(v_ij, (p_i.reshape(1, -1).T**beta_cns * q_i.reshape(1, -1).T**beta_flr * mu_ij**beta_chd), out=np.zeros_like(G_ij), where=(G_ij!=0))
        n_ij = np.divide(beta_chd * gam*L*v_ij, mu_ij, out=np.zeros_like(G_ij), where=(G_ij!=0))
        H_R_ij = beta_flr * gam*L*v_ij / q_i.reshape(1,-1).T + mu_room*n_ij
        Pi_ij = np.divide(W_ij**gameps * B_i.reshape(1, -1).T**eps * E_j, np.sum(W_ij**gameps * B_i.reshape(1, -1).T**eps * E_j), out=np.zeros_like(G_ij), where=(G_ij!=0))
        # 一世帯当たり居住地面積H_R_ij, 居住地面積H_R_iの定義(式(9)を参照)
        H_R_i = np.sum(H_R_ij*N*Pi_ij, axis=1)
        # 労働量x_ijの定義 (式(8)を参照)
        x_ij = gam*L/(T+t_ij)
        # 労働需要M_W_jの定義 (式(15)を参照)
        M_W_j = np.sum(exog['N_W_j_init'])*np.sum(Pi_ij*x_ij, axis=0)
        # 業務用地H_W_jの定義 (式(18)を参照)
        H_W_j = phi_i * K_i**(1-psi) - H_R_i
        # 床面積の需要量
        # demand_H_i = H_R_i + H_W_j
        # 平均価格q_ave_i
        # q_ave_i = (q_i*H_R_i + Q_j*H_W_j) / (H_R_i + H_W_j)
        # 床面積の供給量 (式(23)を参照)
        # omega_i = (((1-psi)*q_ave_i)**((1-psi)/psi)) * K_i
        # supply_H_i = omega_i/(1+omega_i/H_ave_i)
        # supply_H_i = phi_i * K_i**(1-psi)
        
        # 床面積H_iに関する需給均衡式 (n本)
        eq1 = w_j - alp/(1-alp) * H_W_j/M_W_j * Q_j
        # 生産関数の定義
        # eq2 = N_W_j - np.sum(N_R_i * Pi_ij/np.sum(Pi_ij, axis=1), axis=0)
        eq2 = (N_W_j/np.sum(exog['N_W_j_init']))[1:n] - np.sum(Pi_ij, axis=0)[1:n]
        # 人口の均衡式(n本)
        # eq3 = N_R_i - np.sum(N_W_j * Pi_ij/np.sum(Pi_ij, axis=0), axis=1)
        eq3 = (N_R_i/np.sum(exog['N_R_i_init']))[1:n] - np.sum(Pi_ij, axis=1)[1:n]

        # print('q_i:',q_ref_i- q_i)
        # print('P_ij:',Pi_ref_ij - Pi_ij)
        # print('eq1:',eq1)
        # print('eq2:',eq2)
        # print('eq3:',eq3)

        eqs = np.concatenate([eq1, eq2, eq3])
        return eqs

    def objective_equations(self, vars, *arg): # 目的関数の定義 (最小化する残差の二乗和)
        eqs = self.simultaneous_equations(vars, *arg)
        eq = sum(np.sum(eq**2) for eq in eqs)
        if self.given_param['i']%10000==0: print('iteration: ',self.given_param['i'],'func=', eq)
        self.given_param['i'] += 1
        return eq

    def solve_equilibrium(self, given_ref:dict, given_exog:dict, given_param:dict, modeltype:str, method:str, maxiter:int): # 外生変数から一般均衡を解く関数の定義
        
        # set exogenous variables
        n = self.count
        # set parameters
        alp = given_param['alpha']
        gam = given_param['gamma']
        psi = given_param['psi']
        gameps = given_param['gam*eps']
        eps = given_param['epsilon']
        lmd = given_param['lambda']
        dlt = given_param['delta']
        eta = given_param['eta']
        rho = given_param['rho']
        mu_cost = given_exog['mu_cost'] + given_exog['mu_resids_ij']
        mu_time = given_exog['mu_time']
        mu_room = given_exog['mu_room']
        beta_cns = given_param['beta_cns']
        beta_flr = given_param['beta_flr']
        beta_chd = given_param['beta_chd']
        # set exogenous variables
        G_ij = given_exog['G_ij']
        al_j = given_exog['al_j']
        bl_i = given_exog['bl_i']
        E_j = given_exog['E_j']
        K_i = given_exog['K_i']
        p_i = given_exog['p_i']
        t_ij = given_exog['t_ij']
        tau_ij = given_exog['tau_ij']
        N = given_exog['N']
        T = given_exog['T']
        L = given_exog['L']
        xi_i = given_exog['xi_i']
        # H_ave_i = given_exog['H_ave_i']

        # ベンチマークの外生変数の格納
        self.given_ref = given_ref
        self.given_exog = given_exog
        self.given_param = given_param
        # w_jの初期化
        self.given_exog['w_j_init'] = given_ref['w_j'].tolist()
        self.given_exog['N_W_j_init'] = given_ref['N_W_j'].tolist()
        self.given_exog['N_R_i_init'] = given_ref['N_R_i'].tolist()
        w_j_init = given_ref['w_j'].tolist()
        N_W_j_init = given_ref['N_W_j'].tolist()[1:n]
        N_R_i_init = given_ref['N_R_i'].tolist()[1:n]
        x0_init = w_j_init + N_W_j_init + N_R_i_init
        # 制約条件の設定 (非負制約)
        constraints = [{'type': 'ineq', 'fun': lambda vars: vars}]
        b_w_j = [(0.1, 3) for x in range(self.count)]
        b_N_w = [(10000, N/10) for x in range(self.count-1)]
        b_N_r = [(10000, N/10) for x in range(self.count-1)]
        bounds = tuple(b_w_j+b_N_w+b_N_r)
        self.given_param['i'] = 0
        # 一般均衡の方程式を解く, functionが'minimize’の時は局所最適化, 'root'の時は非線形連立方程式
        if modeltype == 'minimize':
            if method=='L-BFGS-B': 
                options = {'maxiter':maxiter, 'maxfun':10**6, 'maxls': 2000, 'ftol': 1e-14, 'gtol': 1e-14}
                result = opt.minimize(fun=self.objective_equations, x0=x0_init, tol=1e-5, method=method, options=options)
            elif method=='Nelder-Mead':
                options = {'maxiter':maxiter}
                result = opt.minimize(fun=self.objective_equations, x0=x0_init, tol=1e-5, method=method, options=options, bounds=bounds)
            else: 
                options = {'maxiter':maxiter}
                result = opt.minimize(fun=self.objective_equations, x0=x0_init, tol=1e-5, method=method, options=options)
        elif modeltype == 'root':
            result = opt.root(fun=self.simultaneous_equations, x0=x0_init, method=method)
        elif modeltype == 'fsolve':
            result = opt.fsolve(func=self.simultaneous_equations, x0=x0_init)
        elif modeltype == 'least_squares':
            result = opt.least_squares(fun=self.simultaneous_equations, x0=x0_init, ftol=1e-14, gtol=1e-14, method=method)
        else:
            raise ValueError('Enter the correct modeltype')

        self.res = result
        # 方程式の解の格納
        w_j = np.array(result.x[0:n])
        N_W_j_0 = np.sum(self.given_exog['N_W_j_init']) - np.sum(result.x[n:(n*2-1)])
        N_R_i_0 = np.sum(self.given_exog['N_R_i_init']) - np.sum(result.x[(n*2-1):(n*3-2)])
        N_W_j = np.append(N_W_j_0, result.x[n:(n*2-1)])
        N_R_i = np.append(N_R_i_0, result.x[(n*2-1):(n*3-2)])

        # 生産性A_jと都市アメニティB_iの算出
        Ups_j = np.sum(np.exp(-dlt*t_ij*60*24) * N_W_j / K_i.reshape(1, -1).T, axis=0)
        A_j = al_j*Ups_j**lmd
        Omega_i = np.sum(np.exp(-rho*t_ij*60*24) * N_R_i.reshape(1, -1).T / K_i.reshape(1, -1).T, axis=1)
        B_i = bl_i*Omega_i**eta
        # 業務用地の地価Q_jの定義 (式(20)を参照)
        Q_j = ((1-alp)*A_j**(1/(1-alp)))*(alp/w_j)**(alp/(1-alp))
        # 居住用地の価格q_iの定義
        q_i = Q_j / xi_i

        # 時間価値v_ij, 通勤確率lambda_ijの定義 (式(6), 式(12)を参照)
        v_ij = w_j*(1-tau_ij) / (T+t_ij)
        mu_ij = mu_cost + v_ij*mu_time + q_i.reshape(1,-1).T*mu_room
        W_ij = v_ij/ (p_i.reshape(1, -1).T**beta_cns * q_i.reshape(1, -1).T**beta_flr * mu_ij**beta_chd)
        Pi_ij = W_ij**gameps * B_i.reshape(1, -1).T**eps * E_j * np.divide(1, np.sum(W_ij**gameps * B_i.reshape(1, -1).T**eps * E_j), out=np.zeros_like(G_ij), where=(G_ij!=0))
        # 労働量x_ijの定義 (式(8)を参照)
        x_ij = gam*L/(T+t_ij)
        # 労働需要M_W_jの定義 (式(15)を参照)
        M_R_i = N_R_i*x_ij
        M_W_j = N*np.sum(Pi_ij*x_ij, axis=0)
        # 一世帯当たり居住地面積H_R_ij, 居住地面積H_R_iの定義(式(9)を参照)
        n_ij = beta_chd * gam*L*v_ij / mu_ij
        H_R_ij = beta_flr * gam*L*v_ij / q_i.reshape(1,-1).T + mu_room*n_ij
        H_R_i = np.sum(H_R_ij*N*Pi_ij, axis=1)
        # 業務用地H_W_jの定義 (式(18)を参照)
        H_W_j = (1-alp)/alp * w_j/Q_j * M_W_j
        H_i = H_R_i + H_W_j
        # 企業の生産量Y_jの算出 (式(17)を参照)
        Y_j = A_j*M_W_j**alp*H_W_j**(1-alp)
        # 平均価格q_ave_i
        # q_ave_i = (q_i*H_R_i + Q_j*H_W_j) / (H_R_i + H_W_j)
        # 床面積の供給量 (式(23)を参照)
        # omega_i = (((1-psi)*q_ave_i)**((1-psi)/psi)) * K_i

        # 解の格納
        eq = {}
        eq['w_j'] = w_j
        eq['N_R_i'] = N_R_i
        eq['N_W_j'] = N_W_j
        eq['Ups_j'] = Ups_j
        eq['Omega_i'] = Omega_i
        eq['A_j'] = A_j
        eq['B_i'] = B_i
        eq['Q_j'] = Q_j
        eq['q_i'] = q_i
        eq['v_ij'] = v_ij
        eq['W_ij'] = W_ij
        eq['mu_ij'] = mu_ij
        eq['W_ij'] = W_ij
        eq['Pi_ij'] = Pi_ij
        eq['x_ij'] = x_ij
        eq['M_R_j'] = M_R_i
        eq['M_W_j'] = M_W_j
        eq['n_ij'] = n_ij
        eq['H_R_ij'] = H_R_ij
        eq['H_R_i'] = H_R_i
        eq['H_W_j'] = H_W_j
        # eq['q_ave_i'] = q_ave_i
        # eq['omega_i'] = omega_i
        eq['H_i'] = H_i
        eq['Y_j'] = Y_j

        # 推定結果の可視化
        print('### Check the result of equilibrium ###')
        print(result)
        print('w_j: 賃金率')
        display(pd.DataFrame(w_j).T)
        print('q_i: 居住地地価')
        display(pd.DataFrame(q_i).T)
        print('N_R_i: 居住人口')
        display(pd.DataFrame(N_R_i).T)
        print('#######################################')
        print('### Calculate the endogenous variables ###')
        print('π_ij: 通勤割合')
        display(pd.DataFrame(Pi_ij))
        print('ΔPi_est_ij (%)')
        display(pd.DataFrame((Pi_ij-self.given_ref['Pi_ij'])/self.given_ref['Pi_ij']*100))
        print('#####################################')

        return eq

    def check_replication_next(self, modeltype:str, method:str, maxiter):  # 現況再現性の確認
        self.rep_next = self.solve_equilibrium(self.ref_next, self.exog_next, self.param, modeltype, method, maxiter)
    
    def check_replication_prev(self, modeltype:str, method:str, maxiter):  # 現況再現性の確認
        self.rep_prev = self.solve_equilibrium(self.ref_prev, self.exog_prev, self.param, modeltype, method, maxiter)
    

    '''
    7. 外生変数のシミュレーション
    '''
    def simulate_new_exog_next(self, new_exog:dict[str,float:np.ndarray], modeltype:str, method:str, maxiter):
        # new_exogに不必要な数値が入っているかどうかを確認する
        if not(set(new_exog.keys()) <= set(self.exog_next.keys())): 
            raise ValueError('Unnecessary exogenous variables exist.') 

        self.new_exog = self.exog_next # new_exogの初期化
        for k,v in new_exog.items(): self.new_exog[k] = v # new_exogの更新

        self.res_next = self.solve_equilibrium(self.ref_next, self.new_exog, self.param, modeltype, method, maxiter)
    
    def simulate_new_exog_prev(self, new_exog:dict[str,float:np.ndarray], modeltype:str, method:str, maxiter):
        # new_exogに不必要な数値が入っているかどうかを確認する
        if not(set(new_exog.keys()) <= set(self.exog_prev.keys())): 
            raise ValueError('Unnecessary exogenous variables exist.') 

        self.new_exog = self.exog_prev # new_exogの初期化
        for k,v in new_exog.items(): self.new_exog[k] = v # new_exogの更新

        self.res_prev = self.solve_equilibrium(self.ref_prev, self.new_exog, self.param, modeltype, method, maxiter)


    '''
    8. パラメータのシミュレーション
    '''
    def simulate_new_param_next(self, new_param:dict[str,float], modeltype:str, method:str, maxiter):
        # new_paramに不必要な数値が入っているかどうかを確認する
        if not(set(new_param.keys()) <= set(self.param_keys)): 
            raise ValueError('Unnecessary parameters exist.') 

        self.new_param = self.param # new_paramの初期化
        for k,v in new_param.items(): self.new_param[k] = v # new_paramの更新

        self.res_next = self.solve_equilibrium(self.ref_next, self.exog_next, self.new_param, modeltype, method, maxiter)
    
    def simulate_new_param_prev(self, new_param:dict[str,float], modeltype:str, method:str, maxiter):
        # new_paramに不必要な数値が入っているかどうかを確認する
        if not(set(new_param.keys()) <= set(self.param_keys)): 
            raise ValueError('Unnecessary parameters exist.') 

        self.new_param = self.param # new_paramの初期化
        for k,v in new_param.items(): self.new_param[k] = v # new_paramの更新

        self.res_prev = self.solve_equilibrium(self.ref_prev, self.exog_prev, self.new_param, modeltype, method, maxiter)

#%%
if __name__ == '__main__':
    # params
    df_param = pd.read_csv('../test_next/param.csv')
    param = {}
    param['alpha'] = df_param['alpha'].to_list()[0]
    param['gamma'] = df_param['gamma'].to_list()[0]
    param['psi'] = df_param['psi'].to_list()[0]
    param['mu_cost'] = df_param['mu_cost'].to_list()[0]
    param['mu_time'] = df_param['mu_time'].to_list()[0]
    param['mu_room'] = df_param['mu_room'].to_list()[0]
    # previous exogenous variables
    df_scaler = pd.read_csv('../test_prev/scaler.csv')
    df_p_i = pd.read_csv('../test_prev/p_i.csv')
    df_K_i = pd.read_csv('../test_prev/K_i.csv')
    df_tau_ij = pd.read_csv('../test_prev/tau_ij.csv',index_col='area')
    df_t_ij = pd.read_csv('../test_prev/t_ij.csv',index_col='area')
    prev_exog = {}
    prev_exog['T'] = df_scaler['T'].to_list()[0]
    prev_exog['N'] = df_scaler['N'].to_list()[0]
    prev_exog['L'] = df_scaler['L'].to_list()[0]
    prev_exog['p_i'] = df_p_i['p_i'].to_numpy()
    # prev_exog['K_i'] = df_K_i['K_i'].to_numpy()
    prev_exog['tau_ij'] = df_tau_ij.to_numpy()
    prev_exog['t_ij'] = df_t_ij.to_numpy()
    # previous reference endogenous variables
    df_q_i = pd.read_csv('../test_prev/q_i.csv')
    df_Q_j = pd.read_csv('../test_prev/Q_j.csv')
    df_w_j = pd.read_csv('../test_prev/w_j.csv')
    df_Pi_ij = pd.read_csv('../test_prev/Pi_ij.csv',index_col='area')
    df_n_ij = pd.read_csv('../test_prev/n_ij.csv',index_col='area')
    df_phi_i = pd.read_csv('../test_prev/phi_i.csv')
    df_theta_i = pd.read_csv('../test_prev/theta_i.csv')
    prev_ref = {}
    prev_ref['q_i'] = df_q_i['q_i'].to_numpy()
    prev_ref['Q_j'] = df_Q_j['Q_j'].to_numpy()
    # prev_ref['w_j'] = df_w_j['w_j'].to_numpy()
    prev_ref['Pi_ij'] = df_Pi_ij.to_numpy()
    prev_ref['n_ij'] = df_n_ij.to_numpy()
    prev_ref['phi_i'] = df_phi_i['phi_i'].to_numpy()
    prev_ref['theta_i'] = df_theta_i['theta_i'].to_numpy()
    # nest exogenous variables
    df_scaler = pd.read_csv('../test_next/scaler.csv')
    df_p_i = pd.read_csv('../test_next/p_i.csv')
    df_K_i = pd.read_csv('../test_next/K_i.csv')
    df_tau_ij = pd.read_csv('../test_next/tau_ij.csv',index_col='area')
    df_t_ij = pd.read_csv('../test_next/t_ij.csv',index_col='area')
    next_exog = {}
    next_exog['T'] = df_scaler['T'].to_list()[0]
    next_exog['N'] = df_scaler['N'].to_list()[0]
    next_exog['L'] = df_scaler['L'].to_list()[0]
    next_exog['p_i'] = df_p_i['p_i'].to_numpy()
    # next_exog['K_i'] = df_K_i['K_i'].to_numpy()
    next_exog['tau_ij'] = df_tau_ij.to_numpy()
    next_exog['t_ij'] = df_t_ij.to_numpy()
    # previous reference endogenous variables
    df_q_i = pd.read_csv('../test_next/q_i.csv')
    df_Q_j = pd.read_csv('../test_next/Q_j.csv')
    df_w_j = pd.read_csv('../test_next/w_j.csv')
    df_Pi_ij = pd.read_csv('../test_next/Pi_ij.csv',index_col='area')
    df_n_ij = pd.read_csv('../test_next/n_ij.csv',index_col='area')
    df_phi_i = pd.read_csv('../test_next/phi_i.csv')
    df_theta_i = pd.read_csv('../test_next/theta_i.csv')
    next_ref = {}
    next_ref['q_i'] = df_q_i['q_i'].to_numpy()
    next_ref['Q_j'] = df_Q_j['Q_j'].to_numpy()
    # next_ref['w_j'] = df_w_j['w_j'].to_numpy()
    next_ref['Pi_ij'] = df_Pi_ij.to_numpy()
    next_ref['n_ij'] = df_n_ij.to_numpy()
    next_ref['phi_i'] = df_phi_i['phi_i'].to_numpy()
    next_ref['theta_i'] = df_theta_i['theta_i'].to_numpy()

    f_1 = Prepare_data(len(next_exog['p_i'])) #16
    f_1.set_param(param)
    f_1.set_exog_prev(prev_exog)
    f_1.set_exog_next(next_exog)
    f_1.set_ref_prev(prev_ref)
    f_1.set_ref_next(next_ref)
    f_1.calc_dep_prev()
    f_1.calc_dep_next()
    f_2 = Estimate_params(f_1)
    f_2.run_epsilon('OLS')
    f_2.run_lmd_dlt()
    f_2.run_eta_rho()
    f_2.recover_fundamentals()

    f_3 = Solve_equilibrium(f_2)
    f_3.check_replication('minimize', 'L-BFGS-B')
    # set the new exogenous variables
    df_sim_t_ij = pd.read_csv('../simulation/t_ij.csv',index_col='area')
    new_exog = f_3.exog_next
    new_exog['t_ij'] = df_sim_t_ij.to_numpy()
    f_3.simulate_new_exog(new_exog, 'minimize', 'L-BFGS-B')
# %%
# %%
