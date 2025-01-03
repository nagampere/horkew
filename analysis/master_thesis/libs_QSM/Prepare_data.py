#%%
import numpy as np
import pandas as pd
from linearmodels.iv import IV2SLS
import matplotlib.pyplot as plt
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
        self.param_keys_input = ['alpha','gamma','psi','beta_cns','beta_flr','beta_chd']
        self.param_keys_dep = []
        self.param_keys = self.param_keys_input + self.param_keys_dep

        # Exogenous variables
        self.exog_keys_sca = ['T','N','L']
        self.exog_keys_i = ['p_i','K_i','theta_i']
        self.exog_keys_j = []
        self.exog_keys_ij = ['tau_ij','t_ij']
        self.exog_keys_dep = ['mu_cost','mu_time','mu_room','mu_resids_ij','xi_i','G_ij']
        self.exog_keys_input = self.exog_keys_sca + self.exog_keys_i + self.exog_keys_j + self.exog_keys_ij
        self.exog_keys = self.exog_keys_input + self.exog_keys_dep

        # Reference endogenous variables
        self.ref_keys_i = ['q_i']
        self.ref_keys_j = ['w_j','Q_j']
        self.ref_keys_ij = ['Pi_ij', 'n_ij']
        self.ref_keys_dep = ['N_R_i','N_W_j','M_R_i','M_W_j','v_ij','mu_ij','n_i','C_ij','H_R_ij','H_R_i','W_ij']
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
    def calc_dep(self, exog, ref, dir_name):
        n = self.count
        param = self.param
        # Initalize
        exog_dep = {}
        ref_dep = {}
        
        # G_ijの算出
        exog_dep['G_ij'] = np.ones([111,111]) * (ref['Pi_ij'] != 0)
        # 居住人口N_R_iと就業人口N_W_jの算出 (式(14)を参照)
        ref_dep['N_R_i'] = exog['N']*np.sum(ref['Pi_ij'], axis=1)
        ref_dep['N_W_j'] = exog['N']*np.sum(ref['Pi_ij'], axis=0)
        # 労働供給M_R_iと労働需要M_W_jの算出 (式(15)を参照)
        x_ij = param['gamma']*exog['L']/(exog['T']+exog['t_ij'])
        ref_dep['M_R_i'] = exog['N']*np.sum(ref['Pi_ij']*x_ij, axis=1)
        ref_dep['M_W_j'] = exog['N']*np.sum(ref['Pi_ij']*x_ij, axis=0)
        # 時間価値v_ijの算出 (式(12)を参照)
        ref_dep['v_ij'] = (ref['w_j']*(1-exog['tau_ij']))/(exog['T']+exog['t_ij'])

        # 育児費用係数と支出パラメータの算出
        df = pd.DataFrame()
        df['n_ij'] = np.ravel(ref['n_ij'])
        df['y'] = np.ravel(param['beta_chd']*param['gamma']*exog['L']*np.divide(ref_dep['v_ij'], ref['n_ij'], out=np.zeros_like(exog_dep['G_ij']), where=(exog_dep['G_ij']!=0))-ref['q_i'].reshape(1,-1).T*np.ones(n)*0.02-0.05)
        df['weight'] = np.ravel(ref['Pi_ij'])
        df['const'] = np.ones(n**2)
        df['x_1'] = np.ravel(ref_dep['v_ij'])
        df['x_2'] = np.ravel(ref['q_i'].reshape(1,-1).T*np.ones(n))
        df_model = df.query('n_ij != 0')
        model_sm = IV2SLS(df_model['y'], df_model[['x_1']], None, None).fit()
        print(model_sm)

        self.model = model_sm
        df['mu_resids_ij'] = np.zeros(len(df))
        df.loc[df_model.index, 'mu_resids_ij'] = model_sm.resids
        exog_dep['mu_cost'] = 0.05
        exog_dep['mu_time'] = model_sm.params['x_1']
        exog_dep['mu_room'] = 0.02
        exog_dep['mu_resids_ij'] = df['mu_resids_ij'].to_numpy().reshape(n,n)

        # 子供の実質費用μの算出
        ref_dep['mu_ij'] = param['beta_chd']*param['gamma']*exog['L']*np.divide(ref_dep['v_ij'], ref['n_ij'], out=np.zeros_like(exog_dep['G_ij']), where=(exog_dep['G_ij']!=0))
        # 地域の子供の数n_iの算出
        ref_dep['n_i'] = exog['N']*np.sum(ref['Pi_ij']*ref['n_ij'], axis=1)
        # 一世帯当たり基本財消費量C_ijの算出 (式(9)を参照)
        ref_dep['C_ij'] = param['beta_cns']*param['gamma']*exog['L']*ref_dep['v_ij']/exog['p_i'].reshape(1,-1).T
        # 一世帯当たり居住地面積H_R_ijの算出 (式(9)を参照)
        ref_dep['H_R_ij'] = param['beta_flr']*param['gamma']*exog['L']*ref_dep['v_ij']/ref['q_i'].reshape(1,-1).T + exog_dep['mu_room']*ref['n_ij']
        # 居住地面積H_R_iの算出
        ref_dep['H_R_i'] = np.sum(ref_dep['H_R_ij']*exog['N']*ref['Pi_ij'], axis=1)
        # ref_dep['H_W_j'] = ref_dep['H_R_i'] / (1-exog['theta_i']) * exog['theta_i']
        # ref_dep['H_W_j'] = ((1-param['alp'])*A_j/Q_j)**(1/param['alp'])*M_W_j
        # exog_dep['phi_i'] = (ref_dep['H_R_i']/(1 - exog['theta_i'])) / exog['K_i']**(1-param['psi'])
        # 居住地の商業地利用の相対地価xi_i
        exog_dep['xi_i'] = ref['Q_j']/ref['q_i']
        # 実質賃金W_ijの算出
        cost = (exog['p_i']**param['beta_cns']).reshape(1, -1).T * (ref['q_i']**param['beta_flr']).reshape(1, -1).T * ref_dep['mu_ij']**param['beta_chd']
        ref_dep['W_ij'] = np.divide(ref_dep['v_ij'], cost, out=np.zeros_like(exog_dep['G_ij']), where=(exog_dep['G_ij']!=0))

        # 基準均衡時の内生変数の確認
        n_ij = ref['n_ij']
        def save_hist(arr, name, dim):
            if dim==1: pd.DataFrame({name:arr[name]}).hist()
            if dim==2: pd.DataFrame({name:np.ravel(arr[name][n_ij!=0])}).hist()
            plt.savefig(f'images/{dir_name}/hist_{name}.png')
            plt.close('all')
        print('### Check the setting of reference variables ###')
        save_hist(ref_dep, 'N_R_i', 1)
        save_hist(ref_dep, 'N_W_j', 1)
        save_hist(ref_dep, 'M_R_i', 1)
        save_hist(ref_dep, 'M_W_j', 1)
        save_hist(ref_dep, 'v_ij', 2)
        save_hist(ref_dep, 'mu_ij', 2)
        save_hist(ref_dep, 'n_i', 1)
        save_hist(ref_dep, 'C_ij', 2)
        save_hist(ref_dep, 'H_R_ij', 2)
        # save_hist(ref_dep, 'H_R_i', 1)
        # save_hist(exog_dep, 'beta_cns_ij', 2)
        # save_hist(exog_dep, 'beta_flr_ij', 2)
        # save_hist(exog_dep, 'beta_chd_ij', 2)

        print('################################################')

        return exog_dep, ref_dep

    # Calculate dependent variables in the previous priod
    def calc_dep_prev(self) -> None:
        (exog_dep, ref_dep) = self.calc_dep(self.exog_prev, self.ref_prev, 'prev')
        for k in self.exog_keys_dep : self.exog_prev[k] = exog_dep[k]
        for k in self.ref_keys_dep  : self.ref_prev[k] = ref_dep[k]
        pass

    # Calculate dependent variables in the next priod
    def calc_dep_next(self) -> None:
        (exog_dep, ref_dep) = self.calc_dep(self.exog_next, self.ref_next, 'next')
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
    param['beta_cns'] = df_param['beta_cns'].to_list()[0]
    param['beta_flr'] = df_param['beta_flr'].to_list()[0]
    param['beta_chd'] = df_param['beta_chd'].to_list()[0]
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
    prev_ref['w_j'] = df_w_j['w_j'].to_numpy()
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
    next_ref['w_j'] = df_w_j['w_j'].to_numpy()
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
