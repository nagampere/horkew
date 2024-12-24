#%%
import numpy as np
import pandas as pd
from scipy import optimize as opt
from IPython.display import display

#%%
class Prepare_data():
    '''
    class definition
    '''
    def __init__(self, index: list[str]) -> None:
        self.index = index
        self.count = len(index)

        # Parameter
        self.param_keys_input = ['alpha','gamma','psi','mu_cost','mu_time','mu_room']
        self.param_keys_dep = []
        self.param_keys = self.param_keys_input + self.param_keys_dep

        # Exogenous variables
        self.exog_keys_sca = ['T','N','L']
        self.exog_keys_i = ['p_i','K_i','theta_i']
        self.exog_keys_j = []
        self.exog_keys_ij = ['tau_ij','t_ij']
        self.exog_keys_dep = ['beta_cns_ij','beta_flr_ij','beta_chd_ij','xi_i','phi_i']
        self.exog_keys_input = self.exog_keys_sca + self.exog_keys_i + self.exog_keys_j + self.exog_keys_ij
        self.exog_keys = self.exog_keys_input + self.exog_keys_dep

        # Reference endogenous variables
        self.ref_keys_i = ['q_i']
        self.ref_keys_j = ['Q_j']
        self.ref_keys_ij = ['Pi_ij', 'n_ij']
        self.ref_keys_dep = ['N_R_i','N_W_j','w_j','M_R_i','M_W_j','v_ij','mu_ij','n_i','C_ij','H_R_ij','H_R_i','H_W_j','W_ij']
        self.ref_keys_input = self.ref_keys_i+self.ref_keys_j+self.ref_keys_ij
        self.ref_keys = self.ref_keys_input + self.ref_keys_dep

        # Initialization of Parameters
        self.param = {}
        for k in self.param_keys: self.param[k] = None  
        
        # Initialization of Variables in the previous priod
        self.exog_prev = {}
        for k in self.exog_keys: self.exog_prev[k] = None  
        self.ref_prev = {}
        for k in self.ref_keys: self.ref_prev[k] = None

        # Initialization of Variables in the next priod
        self.exog_next = {}
        for k in self.exog_keys: self.exog_next[k] = None  
        self.ref_next = {} 
        for k in self.ref_keys: self.ref_next[k] = None

        pass
    
    '''
    1. Inputs for Parameters
    '''
    def set_param(self, param:dict[str, float]) -> None:
        # check the number of keys
        if set(self.param_keys_input) != set(param.keys()):
            raise ValueError('Not all keys are included or unnecessary keys are included.')
        
        for k in self.param_keys_input: # alpha,gamma,psi,mu_cost,mu_time,mu_room
            # judge the size of each scaler 
            if type(param[k]) is float:
                self.param[k] = param[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' parameter, the type is wrong')
        
        pass
    
    '''
    2. Inputs for Exogenous Variables
    '''
    # Input the dict of exogenous variables
    def input_exog(self, exog:dict[str, int:np.ndarray]) -> dict[str, int:np.ndarray]:
        if set(self.exog_keys_input) != set(exog.keys()): # check the number of keys
            raise ValueError('Not all keys are included or unnecessary keys are included.')

        exog_input = {}
        for k in self.exog_keys_sca: # T, N, L
            if type(exog[k]) is int or float: # judge the size of each scaler 
                exog_input[k] = exog[k]
                print(k + ' array has been correctly stored.')
            else: 
                print('The variable type of ' +k+ ' is wrong.')

        for k in self.exog_keys_i: # p_i, K_i
            if exog[k].shape == (self.count,): # judge the size of each matrix 
                exog_input[k] = exog[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')

        for k in self.exog_keys_j: # None
            if exog[k].shape == (self.count,): # judge the size of each matrix 
                exog_input[k] = exog[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')

        for k in self.exog_keys_ij: # tau_ij,t_ij
            if exog[k].shape == (self.count, self.count): # judge the size of each matrix 
                exog_input[k] = exog[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')
        
        return exog_input
        
    # Set the dict of exogenous variables in the previous priod
    def set_exog_prev(self, exog:dict[str, int:np.ndarray]) -> None:
        exog_input = self.input_exog(exog)
        for k in self.exog_keys_input: self.exog_prev[k] = exog_input[k]
        pass

    # Set the dict of exogenous variables in the next priod
    def set_exog_next(self, exog:dict[str, int:np.ndarray]) -> None:
        exog_input = self.input_exog(exog)
        for k in self.exog_keys_input: self.exog_next[k] = exog_input[k]
        pass


    '''
    3. Inputs for Reference Endogenous Variables
    '''
    def input_ref(self, ref:dict[str, np.ndarray]) -> dict[str, np.ndarray]:
        if set(self.ref_keys_input) != set(ref.keys()): # check the number of keys
            raise ValueError('Not all keys are included or unnecessary keys are included.')
        
        ref_input = {}
        for k in self.ref_keys_i: # q_i
            if ref[k].shape == (self.count,): # judge the size of each matrix 
                ref_input[k] = ref[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')

        for k in self.ref_keys_j: # Q_j, W_j
            if ref[k].shape == (self.count,): # judge the size of each matrix 
                ref_input[k] = ref[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')

        for k in self.ref_keys_ij: # Pi_ij,n_ij
            if ref[k].shape == (self.count, self.count): # judge the size of each matrix 
                ref_input[k] = ref[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')
        
        return ref_input
    
    # Set the dict of reference endogenous variables in the previous priod
    def set_ref_prev(self, ref:dict[str, int:np.ndarray]) -> None:
        ref_input = self.input_ref(ref)
        for k in self.ref_keys_input: self.ref_prev[k] = ref_input[k]
        pass

    # Set the dict of reference endogenous variables in the next priod
    def set_ref_next(self, ref:dict[str, int:np.ndarray]) -> None:
        ref_input = self.input_ref(ref)
        for k in self.ref_keys_input: self.ref_next[k] = ref_input[k]
        pass

    '''
    4. Calculation for Dependent Variables
    '''
    def equation_wage(self, l):
        n = self.count
        param = self.given_param
        exog = self.given_exog
        ref = self.given_ref
        H_R_ave_i = np.array(l)
        alp = param['alpha']
        gam = param['gamma']
        psi = param['psi']
        mu_cost = param['mu_cost']
        mu_time = param['mu_time']
        mu_room = param['mu_room']
        L = exog['L']
        T = exog['T']
        N = exog['N']
        # L = 24*60
        # T = 60*8
        # N = 16
        K_i = exog['K_i']
        t_ij = exog['t_ij']
        tau_ij = exog['tau_ij']
        Pi_ij = ref['Pi_ij']
        n_ij = ref['n_ij']
        Q_j = ref['Q_j']
        q_i = ref['q_i']
        the_i = exog['theta_i']

        H_R_i = np.sum(H_R_ave_i.reshape(1,-1).T*N*Pi_ij, axis=1)
        # 労働供給M_R_iと労働需要M_W_jの算出 (式(15)を参照)
        x_ij = gam*L/(T+t_ij)
        N_W_j = N*np.sum(Pi_ij, axis=0)
        M_W_j = N*np.sum(Pi_ij*x_ij, axis=0)
        H_W_j = H_R_i * the_i/(1-the_i)
        w_j = alp/(1-alp) * H_W_j/M_W_j * Q_j

        v_ij = (w_j*(1-tau_ij))/(T+t_ij) # 2.4ぐらい
        # 子供の実質費用μの算出
        mu_ij = mu_cost + v_ij*mu_time + q_i.reshape(1,-1).T*mu_room # 0.1 + 2.4*(2/24) + 0.5*0.4 = 0.1+0.2+0.2 = 0.5
        # 外生的なパラメータδ_ijの算出
        beta_chd_ij = (n_ij/gam*L*v_ij)*mu_ij
        beta_chd_ij = np.where(beta_chd_ij<0.5, beta_chd_ij, 0)
        beta_cns_ij = 3/4*(1-beta_chd_ij)
        beta_flr_ij = 1/4*(1-beta_chd_ij)
        # 一世帯当たり居住地面積H_R_ijの算出 (式(9)を参照)
        H_R_ij = beta_flr_ij*gam*L*v_ij/q_i.reshape(1,-1).T + mu_room*n_ij
        # H_R_i = np.sum(H_R_ij*N*Pi_ij, axis=1)

        # H_W_j = H_R_i / (1-the_i) * the_i
        # 生産関数から労働需要量M_W_jの算出
        # A_j = (w_j/alp)**alp * (Q_j/(1-alp))**(1-alp)
        # M_W_j_r = alp/(1-alp) * Q_j/w_j * H_W_j
        # M_W_j_r = 1/A_j * (Q_j/w_j * alp/(1-alp))**(1-alp)
        # H_W_j = (1-alp)/alp * w_j/Q_j * M_W_j_r
        eq = H_R_i - np.sum(H_R_ij*N*Pi_ij, axis=1)
        eq = np.sum(eq**2)
        if self.given_param['i']%10000==0: print('iteration: ',self.given_param['i'],'func=', eq)
        self.given_param['i'] += 1
        return eq

    def calibrate_wage(self, exog, ref):
        H_R_init = [0.15 for x in range(self.count)]
        x0_init = H_R_init
        self.given_param = self.param
        self.given_param['i'] = 0
        self.given_exog = exog
        self.given_ref = ref
        constraints = [{'type': 'ineq', 'fun': lambda vars: vars}]
        # b_w_j = [(0.5,5) for x in range(self.count)]
        b_H_i = [(0.1,1) for x in range(self.count)]
        bounds = tuple(b_H_i)
        options = {'maxiter':10**6, 'maxfun':10**4, 'maxls': 2000, 'ftol': 1e-14, 'gtol': 1e-14}
        result = opt.minimize(fun=self.equation_wage, x0=x0_init, method='Nelder-Mead', tol=1e-7, options=options, bounds=bounds)
        # result = opt.root(fun=self.equation_wage, x0=wage_init, method='lm')
        H_R_ave_i = np.array(result.x[0:self.count])
        alp = self.param['alpha']
        gam = self.param['gamma']
        L = exog['L']
        T = exog['T']
        N = exog['N']
        t_ij = exog['t_ij']
        Pi_ij = ref['Pi_ij']
        Q_j = ref['Q_j']
        the_i = exog['theta_i']
        H_R_i = np.sum(H_R_ave_i.reshape(1,-1).T*N*Pi_ij, axis=1)
        x_ij = gam*L/(T+t_ij)
        M_W_j = N*np.sum(Pi_ij*x_ij, axis=0)
        H_W_j = H_R_i * the_i/(1-the_i)
        w_j = alp/(1-alp) * H_W_j/M_W_j * Q_j
        print(result)
        return w_j



    def calc_dep(self, exog, ref):
        param = self.param
        # Initalize
        exog_dep = {}
        ref_dep = {}
        # 生産関数から賃金率w_jの算出
        if ref['w_j'] is not None:
            ref_dep['w_j'] = ref['w_j']
        else: 
            ref_dep['w_j'] = self.calibrate_wage(exog, ref)
            print(ref_dep['w_j'])
        # 居住人口N_R_iと就業人口N_W_jの算出 (式(14)を参照)
        ref_dep['N_R_i'] = exog['N']*np.sum(ref['Pi_ij'], axis=1)
        ref_dep['N_W_j'] = exog['N']*np.sum(ref['Pi_ij'], axis=0)
        # 労働供給M_R_iと労働需要M_W_jの算出 (式(15)を参照)
        x_ij = param['gamma']*exog['L']/(exog['T']+exog['t_ij'])
        ref_dep['M_R_i'] = exog['N']*np.sum(ref['Pi_ij']*x_ij, axis=1)
        ref_dep['M_W_j'] = exog['N']*np.sum(ref['Pi_ij']*x_ij, axis=0)
        # 時間価値v_ijの算出 (式(12)を参照)
        ref_dep['v_ij'] = (ref_dep['w_j']*(1-exog['tau_ij']))/(exog['T']+exog['t_ij'])
        # 子供の実質費用μの算出
        ref_dep['mu_ij'] = param['mu_cost']+ref_dep['v_ij']*param['mu_time']+ref['q_i'].reshape(1,-1).T*param['mu_room']
        # 地域の子供の数n_iの算出
        ref_dep['n_i'] = exog['N']*np.sum(ref['Pi_ij']*ref['n_ij'], axis=1)
        # 外生的なパラメータδ_ijの算出
        exog_dep['beta_chd_ij'] = ref['n_ij']/(param['gamma']*exog['L']*ref_dep['v_ij']/ref_dep['mu_ij'])
        exog_dep['beta_chd_ij'] = np.nan_to_num(exog_dep['beta_chd_ij'])
        exog_dep['beta_chd_ij'] = np.where(exog_dep['beta_chd_ij']<0.5, exog_dep['beta_chd_ij'], 0)
        exog_dep['beta_cns_ij'] = 3/4*(1-exog_dep['beta_chd_ij'])
        exog_dep['beta_flr_ij'] = 1/4*(1-exog_dep['beta_chd_ij'])
        # 一世帯当たり基本財消費量C_ijの算出 (式(9)を参照)
        ref_dep['C_ij'] = exog_dep['beta_cns_ij']*param['gamma']*exog['L']*ref_dep['v_ij']/exog['p_i'].reshape(1,-1).T
        # 一世帯当たり居住地面積H_R_ijの算出 (式(9)を参照)
        ref_dep['H_R_ij'] = exog_dep['beta_flr_ij']*param['gamma']*exog['L']*ref_dep['v_ij']/ref['q_i'].reshape(1,-1).T + self.param['mu_room']*ref['n_ij']
        # 居住地面積H_R_iの算出
        ref_dep['H_R_i'] = np.sum(ref_dep['H_R_ij']*exog['N']*ref['Pi_ij'], axis=1)
        ref_dep['H_W_j'] = ref_dep['H_R_i'] / (1-exog['theta_i']) * exog['theta_i']
        exog_dep['phi_i'] = (ref_dep['H_R_i']/(1 - exog['theta_i'])) / exog['K_i']**(1-param['psi'])
        # 居住地の商業地利用の相対地価xi_i
        exog_dep['xi_i'] = ref['Q_j']/ref['q_i']
        # 実質賃金
        ref_dep['W_ij'] = ref_dep['v_ij'] / (exog['p_i'].reshape(1, -1).T**exog_dep['beta_cns_ij'] * ref['q_i'].reshape(1, -1).T**exog_dep['beta_flr_ij'] * ref_dep['mu_ij']**exog_dep['beta_chd_ij'])

        # 基準均衡時の内生変数の確認
        print('### Check the setting of reference variables ###')
        print('N_R_i:  residential population')
        # display(pd.DataFrame(ref_dep['N_R_i']).T)
        print('N_W_j:  workplace population')
        # display(pd.DataFrame(ref_dep['N_W_j']).T)
        print('M_R_i:  labor supply')
        # display(pd.DataFrame(ref_dep['M_R_i']).T)
        print('M_W_j:  labor demand')
        display(pd.DataFrame(ref_dep['M_W_j']).T)
        display(pd.DataFrame(param['alpha']/(1-param['alpha']) * ref['Q_j']/ref_dep['w_j'] * ref_dep['H_W_j']).T)
        print('v_ij:   value of time')
        display(pd.DataFrame(ref_dep['v_ij']))
        print('mu_ij:  net price per child')
        # display(pd.DataFrame(ref_dep['mu_ij']))
        print('n_i:    the number of children')
        # display(pd.DataFrame(ref_dep['n_i']))
        print('C_ij:   goods consumption in a household ij')
        # display(pd.DataFrame(ref_dep['C_ij']))
        print('H_R_ij: floor space in a household ij')
        # display(pd.DataFrame(ref_dep['H_R_ij']))
        print('H_R_i:  floor space in a residential area i')
        # display(pd.DataFrame(ref_dep['H_R_i']))
        print('K_i:    land endowment in a residential area i')
        # display(pd.DataFrame(exog_dep['K_i']))
        print('beta_cns_ij: share parameters for goods consumption')
        display(pd.DataFrame(exog_dep['beta_cns_ij']))
        print('beta_flr_ij: share parameters for floor space')
        display(pd.DataFrame(exog_dep['beta_flr_ij']))
        print('beta_chd_ij: share parameters for children')
        display(pd.DataFrame(exog_dep['beta_chd_ij']))
        print('################################################')

        return exog_dep, ref_dep

    # Calculate dependent variables in the previous priod
    def calc_dep_prev(self) -> None:
        (exog_dep, ref_dep) = self.calc_dep(self.exog_prev, self.ref_prev)
        for k in self.exog_keys_dep : self.exog_prev[k] = exog_dep[k]
        for k in self.ref_keys_dep  : self.ref_prev[k] = ref_dep[k]
        pass

    # Calculate dependent variables in the next priod
    def calc_dep_next(self) -> None:
        (exog_dep, ref_dep) = self.calc_dep(self.exog_next, self.ref_next)
        for k in self.exog_keys_dep : self.exog_next[k] = exog_dep[k]
        for k in self.ref_keys_dep  : self.ref_next[k] = ref_dep[k]
        pass


# %%
import pandas as pd
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
    prev_exog['theta_i'] = df_theta_i['theta_i'].to_numpy()
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
    next_exog['theta_i'] = df_theta_i['theta_i'].to_numpy()
    
    f_1 = Prepare_data([x for x in range(1,17)]) #16
    f_1.set_param(param)
    f_1.set_exog_prev(prev_exog)
    f_1.set_exog_next(next_exog)
    f_1.set_ref_prev(prev_ref)
    f_1.set_ref_next(next_ref)
    f_1.calc_dep_prev()
    f_1.calc_dep_next()

# %%
