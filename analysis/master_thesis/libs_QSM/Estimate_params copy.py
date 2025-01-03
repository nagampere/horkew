#%% 
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import statsmodels.api as sm
from linearmodels.panel import PanelOLS
from scipy import optimize as opt
from scipy.stats import gmean
from IPython.display import display

try: from libs_QSM.Prepare_data import Prepare_data
except: from Prepare_data import Prepare_data

    

#%%
class Estimate_params(Prepare_data):
    def __init__(self,func) -> None: # inherit model classes.
        self.index = func.index
        self.count = func.count
        self.param = func.param
        self.exog_keys = list(func.exog_next.keys())
        self.exog_prev = func.exog_prev
        self.exog_next = func.exog_next
        self.ref_prev = func.ref_prev
        self.ref_next = func.ref_next
        pass

    '''
    1. epsilon estimation; Freche dist. prameter
    '''
    def run_epsilon(self, modeltype:'str'):
        # set variables in the next priod
        index = self.index
        count = self.count
        ref = self.ref_next
        exog = self.exog_next
        Pi_ij = ref['Pi_ij']
        v_ij = ref['v_ij']
        p_i = exog['p_i']
        t_ij = exog['t_ij']
        q_i = ref['q_i']
        mu_ij = ref['mu_ij']
        W_ij = ref['W_ij']

        df_Pi = pd.DataFrame(Pi_ij, index=list(range(0,count)), columns=list(range(0,count))) # time dimension needs to be int or timestamp
        df_Pi = df_Pi.reset_index(names='LX_i').melt(id_vars=['LX_i'], value_vars=list(range(0,count)), var_name='LE_j', value_name='Pi_ij')
        df_W = pd.DataFrame(W_ij, index=list(range(0,len(index))), columns=list(range(0,count))) # time dimension needs to be int or timestamp
        df_W = df_W.reset_index(names='LX_i').melt(id_vars=['LX_i'], value_vars=list(range(0,count)), var_name='LE_j', value_name='W_ij')
        df_t_ij = pd.DataFrame(t_ij, index=list(range(0,count)), columns=list(range(0,count)))
        df_t_ij = df_t_ij.reset_index(names='LX_i').melt(id_vars=['LX_i'], value_vars=list(range(0,count)), var_name='LE_j', value_name='t_ij')
        df_OLS = pd.merge(df_Pi, df_W, on=['LX_i','LE_j'])
        df_OLS = pd.merge(df_OLS, df_t_ij, on=['LX_i','LE_j'])
        df_OLS = df_OLS[(df_OLS['Pi_ij'].notnull()) & (df_OLS['W_ij'].notnull())]
        df_OLS = df_OLS.query('Pi_ij!=0 & W_ij!=0').reset_index(drop=True)
        # df_OLS = df_OLS.query('LX_i!=LE_j') # 内々トリップを除外
        # df_OLS = df_OLS[(df_OLS['t_ij'] < 60/(60*24))] # 1時間未満のトリップに限定
        df_OLS['LPi_ij'] = df_OLS['Pi_ij'].apply(lambda x: np.log(x))
        df_OLS['LW_ij'] = df_OLS['W_ij'].apply(lambda x: np.log(x))
        display(df_OLS)
        self.df_OLS = df_OLS
        df_OLS = df_OLS.set_index(['LX_i','LE_j'])
        # モデル推定, modeltypeが'OLS'なら最小二乗法, 'WLS'なら加重最小二乗法
        if modeltype == 'OLS':
            model_sm = PanelOLS(dependent=df_OLS.LPi_ij, exog=df_OLS.LW_ij, entity_effects=True, time_effects=True).fit()
        elif modeltype == 'WLS':
            model_sm = PanelOLS(dependent=df_OLS.LPi_ij, exog=df_OLS.LW_ij, weights=df_OLS.Pi_ij, entity_effects=True, time_effects=True).fit()
        else:
            raise ValueError('Enter the correct modeltype')
        
        cols = model_sm.estimated_effects.reset_index()['LE_j'].unique()
        # input fixed effect
        self.res = model_sm
        fix_eff = pd.DataFrame(model_sm.estimated_effects.reset_index())
        df_XE = pd.DataFrame(0.0, index=list(range(0,count)), columns=list(range(0,count)))
        for i in fix_eff.itertuples(): 
            df_XE.at[i[1], i[2]] = np.exp(i[3])
        K = df_XE.at[0,0]
        df_XE = df_XE / K 
        self.exog_next['df_XE'] = df_XE
        # input the estimated parameters
        self.param['gam*eps'] = model_sm.params['LW_ij']
        self.param['epsilon'] = model_sm.params['LW_ij']/self.param['gamma']
        Pi_ij_est = np.exp(df_OLS['LW_ij'].to_numpy() * model_sm.params['LW_ij'] + fix_eff['estimated_effects'].to_numpy())
        dPi_ij = (Pi_ij_est-df_OLS['Pi_ij'].to_numpy()) / df_OLS['Pi_ij'].to_numpy()*100
        # 推定結果の確認, 傾きが𝛾𝜖を表す
        print('### Check the regression result ###')
        print(model_sm.summary)
        print('Estimated epsilon is ', self.param['epsilon'])
        print('Standard error is ', model_sm.std_errors)
        print('T-value is ', model_sm.tstats)
        print('R-squared is ', model_sm.rsquared)
        print('Pi_ij')
        display(pd.DataFrame(Pi_ij_est))
        print('ΔPi_est_ij (%)')
        display(pd.DataFrame(dPi_ij))
        print('ΣPi_ij')
        print(np.sum(Pi_ij_est))
        # モデルの可視化
        fig, ax = plt.subplots(figsize=(8,6))
        ax.plot(df_OLS['LPi_ij'].to_numpy(), np.log(Pi_ij_est), 'o', label="data")
        ax.plot(df_OLS['LPi_ij'].to_numpy(), df_OLS['LPi_ij'].to_numpy(), 'r--.', label='y=x')
        ax.legend(loc='best')
        plt.show()
        print('###################################')


    '''
    2. lambda & delta optimization
    '''
    def moment_lmd_dlt(self, lmd, dlt): # moment function
        # set parameters
        alp = self.param['alpha']
        # set variables in the previous priod
        Q_j_prev = self.ref_prev['Q_j']
        w_j_prev = self.ref_prev['w_j']
        t_ij_prev = self.exog_prev['t_ij']
        N_W_j_prev = self.ref_prev['N_W_j']
        K_i_prev = self.exog_prev['K_i']
        # set variables in the next priod
        Q_j_next = self.ref_next['Q_j']
        w_j_next = self.ref_next['w_j']
        t_ij_next = self.exog_next['t_ij']
        N_W_j_next = self.ref_next['N_W_j']
        K_i_next = self.exog_next['K_i']
        # calulate the structural residuals in the previous priod
        EQT_prev = Q_j_prev / gmean(Q_j_prev)
        Ewage_prev = w_j_prev / gmean(w_j_prev)
        Ups_prev =  np.sum(np.exp(-dlt*t_ij_prev*60*24) * N_W_j_prev / K_i_prev.reshape(1, -1).T, axis=0)
        EUPs_prev = Ups_prev / gmean(Ups_prev)
        log_a_prev = ((1-alp)*np.log(EQT_prev)) + (alp*np.log(Ewage_prev)) - (lmd*np.log(EUPs_prev))
        # calulate the structural residuals in the next priod
        EQT_next = Q_j_next / gmean(Q_j_next)
        Ewage_next = w_j_next / gmean(w_j_next)
        Ups_next =  np.sum(np.exp(-dlt*t_ij_next*60*24) * N_W_j_next / K_i_next.reshape(1, -1).T, axis=0)
        EUPs_next = Ups_next / gmean(Ups_next)
        log_a_next = ((1-alp)*np.log(EQT_next)) + (alp*np.log(Ewage_next)) - (lmd*np.log(EUPs_next))
        # calculate the relative changes
        self.ref_prev['Ups'] = Ups_prev
        self.exog_prev['log_a'] = log_a_prev
        self.ref_next['Ups'] = Ups_next
        self.exog_next['log_a'] = log_a_next
        log_a = log_a_next - log_a_prev
        # print(log_a)
        log_a = log_a - log_a.mean()
        err_vec = log_a
        return err_vec

    def criterion_lmd_dlt(self, params): # the vector of moment errors
        lmd, dlt = params
        err = self.moment_lmd_dlt(lmd, dlt)
        W = np.eye(self.count)
        crit_val = err.T @ W @ err
        print(crit_val)
        return crit_val *10**5

    def run_lmd_dlt(self): # estimate lambda and delta
        lmd_init = 0.10
        dlt_init = 0.20
        params_init = np.array([lmd_init, dlt_init])
        min_lmd = 0.00
        max_lmd = 10.0
        min_dlt = 0.00
        max_dlt = 1.00
        results = opt.minimize(
            self.criterion_lmd_dlt, 
            params_init, 
            tol=1e-14, 
            # method='L-BFGS-B',
            method='Nelder-Mead',
            bounds=((min_lmd, max_lmd),
                    (min_dlt, max_dlt))
            )
        lmd_opt, dlt_opt = results.x

        # input the estimated parameters
        self.param['lambda'] = lmd_opt
        self.param['delta'] = dlt_opt
        print('### Check the estimation result ###')
        print('lmd=', lmd_opt, ' dlt=', dlt_opt)
        print("")
        print("SciPy.optimize.minimize results are the following:")
        print(results)


    '''
    3. eta & rho optimization
    '''
    def moment_eta_rho(self, eta, rho): # moment function
        # set parameters
        n = self.count
        eps = self.param['epsilon']
        gameps = self.param['gam*eps']
        beta_cns = self.param['beta_cns']
        beta_flr = self.param['beta_flr']
        beta_chd = self.param['beta_chd']
        # set variables in the previous priod
        N_R_i_prev = self.ref_prev['N_R_i']
        v_ij_prev = self.ref_prev['v_ij']
        p_i_prev = self.exog_prev['p_i']
        q_i_prev = self.ref_prev['q_i']
        mu_ij_prev = self.ref_prev['mu_ij']
        t_ij_prev = self.exog_prev['t_ij']
        K_i_prev = self.exog_prev['K_i']
        # set variables in the next priod
        N_R_i_next = self.ref_next['N_R_i']
        v_ij_next = self.ref_next['v_ij']
        p_i_next = self.exog_next['p_i']
        q_i_next = self.ref_next['q_i']
        mu_ij_next = self.ref_next['mu_ij']
        t_ij_next = self.exog_next['t_ij']
        K_i_next = self.exog_next['K_i']
        # calulate the structural residuals in the previous priod
        EN_R_prev = N_R_i_prev / gmean(N_R_i_prev)
        cost_prev = (p_i_prev.reshape(1, -1).T**beta_cns * q_i_prev.reshape(1, -1).T**beta_flr * mu_ij_prev**beta_chd)**gameps
        W_prev = np.sum(np.divide(v_ij_prev, cost_prev, out=np.zeros([n,n]), where=cost_prev!=0), axis=1)
        EW_prev = W_prev / gmean(W_prev)
        Omega_prev = np.sum(np.exp(-rho*t_ij_prev*60*24) * N_R_i_prev.reshape(1, -1).T / K_i_prev.reshape(1, -1).T, axis=1)
        EOmega_prev = Omega_prev / gmean(Omega_prev)
        log_b_prev = (1/eps*np.log(EN_R_prev))-(1/eps*np.log(EW_prev))-(eta*np.log(EOmega_prev))
        # calulate the structural residuals in the next priod
        EN_R_next = N_R_i_next / gmean(N_R_i_next)
        cost_next = (p_i_next.reshape(1, -1).T**beta_cns * q_i_next.reshape(1, -1).T**beta_flr * mu_ij_next**beta_chd)**gameps
        W_next = np.sum(np.divide(v_ij_next, cost_next, out=np.zeros([n,n]), where=cost_next!=0), axis=1)
        EW_next = W_next / gmean(W_next)
        Omega_next = np.sum(np.exp(-rho*t_ij_next*60*24) * N_R_i_next.reshape(1, -1).T / K_i_next.reshape(1, -1).T, axis=1)
        EOmega_next = Omega_next / gmean(Omega_next)
        log_b_next = (1/eps*np.log(EN_R_next))-(1/eps*np.log(EW_next))-(eta*np.log(EOmega_next))
        # calculate the relative changes
        self.ref_prev['Omega'] = Omega_prev
        self.exog_prev['log_b'] = log_b_prev
        self.ref_next['Omega'] = Omega_next
        self.exog_next['log_b'] = log_b_next
        log_b = log_b_next - log_b_prev
        # print(log_b)
        log_b = log_b - log_b.mean()
        err_vec = log_b
        return err_vec

    def criterion_eta_rho(self, params): # estimate lambda and delta
        eta, rho = params
        err = self.moment_eta_rho(eta, rho)
        W = np.eye(self.count)
        crit_val = err.T @ W @ err
        print(crit_val)
        return crit_val *10**5

    def run_eta_rho(self): # estimate lambda and delta
        eta_init = 0.1
        rho_init = 0.2
        params_init = np.array([eta_init, rho_init])
        min_eta = 0.00
        max_eta = 1.00
        min_rho = 0.00
        max_rho = 1.00
        results = opt.minimize(
            self.criterion_eta_rho, 
            params_init, 
            tol=1e-14, 
            method='Nelder-Mead',
            bounds=((min_eta, max_eta),
                    (min_rho, max_rho))
        )
        eta_opt, rho_opt = results.x
        # input the estimated parameters
        self.param['eta'] = eta_opt
        self.param['rho'] = rho_opt
        print('### Check the estimation result ###')
        print('eta=', eta_opt, ' rho=', rho_opt)
        print("")
        print("SciPy.optimize.minimize results are the following:")
        print(results)

    '''
    4. Recovering the local characteristics
    '''
    def recover_fundamentals(self):
        n = self.count
        param = self.param
        exog = self.exog_next
        ref = self.ref_next

        # set parameters
        alp = param['alpha']
        psi = param['psi']
        gameps = param['gam*eps']
        eps = param['epsilon']
        lmd = param['lambda']
        dlt = param['delta']
        eta = param['eta']
        rho = param['rho']

        # set variables
        v_ij = ref['v_ij']
        w_j = ref['w_j']
        t_ij = exog['t_ij']
        p_i = exog['p_i']
        q_i = ref['q_i']
        Q_j = ref['Q_j']
        mu_ij = ref['mu_ij']
        Pi_ij = ref['Pi_ij']
        W_ij = ref['W_ij']
        beta_cns_ij = param['beta_cns']
        beta_flr_ij = param['beta_flr']
        beta_chd_ij = param['beta_chd']
        N_R_i = ref['N_R_i']
        N_W_j = ref['N_W_j']
        M_W_j = ref['M_W_j']
        H_R_i = ref['H_R_i']
        K_i = exog['K_i']
        XE_ij = exog['df_XE'].to_numpy()
        
        Ups_j = np.sum(np.exp(-dlt*t_ij*60*24) * N_W_j / K_i.reshape(1, -1).T, axis=0)
        Omega_i = np.sum(np.exp(-rho*t_ij*60*24) * N_R_i.reshape(1, -1).T / K_i.reshape(1, -1).T, axis=1)
        W_i = np.sum(W_ij**gameps, axis=1)
        A_j = w_j/alp**alp * (Q_j/(1-alp))**(1-alp)
        B_i = (N_R_i/W_i)**(1/eps)
        al_j = A_j / Ups_j**lmd
        bl_i = B_i / Omega_i**eta
        XE_ij = XE_ij / (B_i.reshape(1, -1).T**eps)
        Pi_est_ij = XE_ij * W_ij**gameps * B_i.reshape(1, -1).T**eps * np.divide(1, np.sum(XE_ij * W_ij**gameps * B_i.reshape(1, -1).T**eps), out=np.zeros([n,n]), where=XE_ij!=0)

        #　就業地の商業地利用の面積H_W_j (式(18)を参照)
        H_W_j = ((1-alp)*A_j/Q_j)**(1/alp)*M_W_j
        # 床面積の合計
        H_i = H_R_i + H_W_j
        phi_i = H_i / K_i**(1-psi)
        # 居住地の平均価格q_ave_i, 居住地面積(H_i-H_W_j)と商業地面積のH_W_jの加重平均
        # q_ave_i = (q_i*H_R_i+Q_j*H_W_j) / H_i
        # 土地賦存量に対する床面積の割合φ_i
        # Omc_i = (((1-psi)*q_ave_i)**((1-psi)/psi)) * K_i
        # phi_i = H_i / Omc_i
        # 仮想的な床面積の最大量H_ave_i (式(30)を参照)
        # H_ave_i = Omc_i / (Omc_i/H_i-1)
        
        self.exog_next['al_j'] = al_j
        self.exog_next['bl_i'] = bl_i
        self.exog_next['XE_ij'] = XE_ij
        self.exog_next['phi_i'] = phi_i
        self.ref_next['Ups_j'] = Ups_j
        self.ref_next['Omega_i'] = Omega_i
        self.ref_next['W_ij'] = W_ij
        self.ref_next['A_j'] = A_j
        self.ref_next['B_i'] = B_i
        self.ref_next['Pi_est_ij'] = Pi_est_ij
        self.ref_next['H_W_j'] = H_W_j
        self.ref_next['H_i'] = H_i
        # self.ref_next['phi_i'] = phi_i
        # self.ref_next['Omc_i'] = Omc_i
        # self.exog_next['H_ave_i'] = H_ave_i

        #　推定結果の確認 (式(12)を参照)
        print('### Check the estimation result ###')
        print('A_j')
        display(pd.DataFrame(A_j).T)
        print('B_i')
        display(pd.DataFrame(B_i).T)
        print('XE_ij')
        display(pd.DataFrame(XE_ij))
        print('Pi_est_ij')
        display(pd.DataFrame(Pi_est_ij))
        print('ΔPi_est_ij (%)')
        display(pd.DataFrame((Pi_est_ij-Pi_ij)/Pi_ij*100))
        print('ΣPi_est_ij')
        print(np.sum(self.ref_next['Pi_est_ij']))
        print('###################################')

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
    prev_exog['K_i'] = df_K_i['K_i'].to_numpy()
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
    # prev_ref['phi_i'] = df_phi_i['phi_i'].to_numpy()
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
    next_exog['K_i'] = df_K_i['K_i'].to_numpy()
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
    # next_ref['phi_i'] = df_phi_i['phi_i'].to_numpy()
    next_ref['theta_i'] = df_theta_i['theta_i'].to_numpy()
    
    f_1 = Prepare_data([x for x in range(1,17)]) #16
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

# %%
    f_2 = Estimate_params(f_1)
    f_2.run_epsilon('OLS')
    f_2.run_lmd_dlt()
    f_2.run_eta_rho()
    f_2.recover_fundamentals()
# %%