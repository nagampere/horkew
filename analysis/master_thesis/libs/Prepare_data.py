#%%
import numpy as np

#%%
class Prepare_data():
    '''
    classの定義
    '''
    def __init__(self, count: int) -> None:
        self.count = count

        # Exogenous parameter
        self.param_keys = ['alpha','gamma','psi','mu_cost','mu_time','mu_room']
        self.param_keys = self.param_keys
        self.param = {} #Initialize
        for k in self.param_keys: self.param[k] = None  

        # Exogenous variables; scaler and vector
        self.exog_keys_sca = ['T','N','L']
        self.exog_keys_i = ['p_i', 'K_i']
        self.exog_keys_j = []
        self.exog_keys_ij = ['tau_ij','t_ij']
        self.exog_keys = self.exog_keys_sca + self.exog_keys_i + self.exog_keys_j + self.exog_keys_ij
        self.exog = {}  #Initialize
        for k in self.exog_keys: self.exog[k] = None  
        
        # Reference endogenous variables
        self.ref_keys_i = ['q_i']
        self.ref_keys_j = ['Q_j','w_j']
        self.ref_keys_ij = ['lambda_ij', 'n_ij']
        self.ref_keys = self.ref_keys_i+self.ref_keys_j+self.ref_keys_ij
        self.ref = {} #Initialize
        for k in self.ref_keys: self.ref[k] = None
        pass
    
    '''
    1. Exogenous variables inputs
    '''
    def set_exog(self, exog:dict[str, int:np.ndarray]) -> None:
        # check the number of keys
        if set(self.exog_keys) != set(exog.keys()):
            raise ValueError('Not all keys are included or unnecessary keys are included.')

        for k in self.exog_keys_sca: # T, N
            # judge the size of each scaler 
            if type(exog[k]) is int:
                self.exog[k] = exog[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')

        for k in self.exog_keys_i: # p_i, L_i
            # judge the size of each matrix 
            if exog[k].shape == (self.count,):
                self.exog[k] = exog[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')

        for k in self.exog_keys_j: # None
            # judge the size of each matrix 
            if exog[k].shape == (self.count,):
                self.exog[k] = exog[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')

        for k in self.exog_keys_ij: # tau_ij,t_ij
            # judge the size of each matrix 
            if exog[k].shape == (self.count_i, self.count_j):
                self.exog[k] = exog[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')
    
    '''
    2. Parameter inputs
    '''
    def set_param(self, param:dict[str, float]) -> None:
        # check the number of keys
        if set(self.param_keys) != set(param.keys()):
            raise ValueError('Not all keys are included or unnecessary keys are included.')
        
        for k in self.param_keys: # alpha,gamma,psi,mu_cost,mu_time,mu_room
            # judge the size of each scaler 
            if type(param[k]) is int:
                self.param[k] = param[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')
    
    '''
    3. Reference endogenous variables inputs
    '''
    def set_ref(self, ref:dict[str, np.ndarray]) -> None:
        # check the number of keys
        if set(self.ref_keys) != set(ref.keys()):
            raise ValueError('Not all keys are included or unnecessary keys are included.')
        
        for k in self.ref_keys_i: # q_i
            # judge the size of each scaler 
            if ref[k].shape == (self.count_i,):
                self.ref[k] = ref[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')

        for k in self.ref_keys_j: # Q_j, w_j
            # judge the size of each scaler 
            if ref[k].shape == (self.count_j,):
                self.ref[k] = ref[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')

        for k in self.ref_keys_ij: # lambda_ij, n_ij
            # judge the size of each scaler 
            if ref[k].shape == (self.count_i, self.count_j):
                self.ref[k] = ref[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')

        # 居住人口N_R_iと就業人口N_W_jの算出 (式(14)を参照)
        self.ref['N_R_i'] = self.param['N']*np.sum(self.ref['lambda_ij'], axis=1)
        self.ref['N_W_j'] = self.param['N']*np.sum(self.ref['lambda_ij'], axis=0)
        # 労働供給M_R_iと労働需要M_W_jの算出 (式(15)を参照)
        x_ij = self.param['gamma']*self.param['L']/(self.param['T']+self.exog['t_ij'])
        self.ref['M_R_i'] = self.param['N']*np.sum(self.ref['lambda_ij']*x_ij, axis=1)
        self.ref['M_W_j'] = self.param['N']*np.sum(self.ref['lambda_ij']*x_ij, axis=0)
        # 時間価値v_ijの算出 (式(12)を参照)
        self.ref['v_ij'] = (self.ref['w_j']-self.exog['tau_ij'])/(self.param['T']+self.exog['t_ij'])
        # 子供の実質費用μの算出
        self.ref['mu_ij'] = self.param['mu_cost']+self.ref['v_ij']*self.param['mu_time']+self.ref['q_i'].reshape(1,-1).T*self.param['mu_room']
        # 地域の子供の数n_iの算出
        self.ref['n_i'] = self.param['N']*np.sum(self.ref['lambda_ij']*self.ref['n_ij'], axis=1)
        # 外生的なパラメータδ_ijの算出
        self.param['delta_ij'] = self.ref['n_ij']/(self.param['gamma']*self.param['L']*self.ref['v_ij']/self.ref['mu_ij'])
        self.param['beta_ij'] = 4/5*(1-self.param['delta_ij'])
        self.param['theta_ij'] = 1/5*(1-self.param['delta_ij'])
        # 一世帯当たり基本財消費量C_ijの算出 (式(9)を参照)
        self.ref['C_ij'] = self.exog['beta_ij']*self.param['gamma']*self.param['L']*self.ref['v_ij']/self.exog['p_i'].reshape(1,-1).T
        # 一世帯当たり居住地面積H_R_ijの算出 (式(9)を参照)
        self.ref['H_R_ij'] = self.exog['theta_ij']*self.param['gamma']*self.param['L']*self.ref['v_ij']/self.ref['q_i'].reshape(1,-1).T + self.param['mu_room']*self.ref['n_ij']
        # 居住地面積H_R_iの算出
        self.ref['H_R_i'] = np.sum(self.ref['H_R_ij']*self.param['N']*self.ref['lambda_ij'], axis=1)

        # 基準均衡時の内生変数の確認
        print('### Check the setting of reference variables ###')
        print('N_R_i: 居住人口')
        print(self.ref['N_R_i'])
        print('N_W_j: 就業人口')
        print(self.ref['N_W_j'])
        print('M_R_i: 労働供給')
        print(self.ref['M_R_i'])
        print('M_W_j: 労働需要')
        print(self.ref['M_W_j'])
        print('v_ij: 時間価値')
        print(self.ref['v_ij'])
        print('mu_ij: 子供の実質費用')
        print(self.ref['mu_ij'])
        print('n_i: 地域の子供の数')
        print(self.ref['n_i'])
        print('delta_ij: 子供の消費性向')
        print(self.param['delta_ij'])
        print('beta_ij: 基本財の消費性向')
        print(self.param['beta_ij'])
        print('theta_ij: 土地の消費性向')
        print(self.param['theta_ij'])
        print('C_ij: 一世帯当たり基本財消費量')
        print(self.ref['C_ij'])
        print('H_R_ij: 一世帯当たり居住地面積')
        print(self.ref['H_R_ij'])
        print('H_R_i: 居住地面積')
        print(self.ref['H_R_i'])
        print('################################################')
