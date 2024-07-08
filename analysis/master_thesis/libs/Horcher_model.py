#%%
from __future__ import division

import numpy as np
import matplotlib.pyplot as plt
import statsmodels.api as sm
from scipy import optimize

#%%
class Horcher_model():
    '''
    classの定義
    '''
    def __init__(self, count_i:int, count_j:int) -> None:
        self.count_i = count_i
        self.count_j = count_j

        # 外生変数
        self.exog = {}
        self.exog_key_i = ['p_i', 'L_i']
        self.exog_key_j = []
        self.exog_key_ij = ['tau_ij','t_ij']
        self.exog_keys = self.exog_key_i+self.exog_key_j+self.exog_key_ij
        for k in self.exog_keys:
            self.exog[k] = None
        
        # 基準均衡状態の内生変数
        self.ref = {}
        self.ref_key_i = ['q_i','N_R_i','M_R_i','H_i']
        self.ref_key_j = ['Q_j','N_W_j','M_W_j','w_j']
        self.ref_key_ij = ['lambda_ij']
        self.ref_keys = self.ref_key_i+self.ref_key_j+self.ref_key_ij
        for k in self.ref_keys:
            self.ref[k] = None

        # 外生的なパラメーター
        self.param = {}
        self.param_keys = ['alpha','beta','gamma','psi','L','T']
        for k in self.param_keys:
            self.param[k] = None
    pass
    
    '''
    1. 外生変数の入力
    '''
    def set_exog(self, exog:dict[str, np.ndarray]) -> None:
        # exog.keys()に過不足がないかを判定
        if set(self.exog_keys) != set(exog.keys()):
            raise ValueError('Not all keys are included or unnecessary keys are included.')
        
        for k in self.exog_key_i:
            # 各行列のサイズが正しいかを判定
            if exog[k].shape == (self.count_i,):
                self.exog[k] = exog[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')

        for k in self.exog_key_j:
            # 各行列のサイズが正しいかを判定
            if exog[k].shape == (self.count_j,):
                self.exog[k] = exog[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')

        for k in self.exog_key_ij:
            # 各行列のサイズが正しいかを判定
            if exog[k].shape == (self.count_i, self.count_j):
                self.exog[k] = exog[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')
    
    '''
    2. 基準均衡時の内生変数の入力
    '''
    def set_ref(self, ref:dict[str, np.ndarray]) -> None:
        # ref.keys()に過不足がないかを判定
        if set(self.ref_keys) != set(ref.keys()):
            raise ValueError('Not all keys are included or unnecessary keys are included.')
        
        for k in self.ref_key_i:
            # 各行列のサイズが正しいかを判定
            if ref[k].shape == (self.count_i,):
                self.ref[k] = ref[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')

        for k in self.ref_key_j:
            # 各行列のサイズが正しいかを判定
            if ref[k].shape == (self.count_j,):
                self.ref[k] = ref[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')

        for k in self.ref_key_ij:
            # 各行列のサイズが正しいかを判定
            if ref[k].shape == (self.count_i, self.count_j):
                self.ref[k] = ref[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')
    
    '''
    3. パラメーターの入力
    '''
    def set_param(self, param:dict[str, float]) -> None:
        # param.keys()に過不足がないかを判定
        if set(self.param_keys) != set(param.keys()):
            raise ValueError('Not all keys are included or unnecessary keys are included.')
        
        for k in self.param_keys:
            self.param[k] = param[k]

    '''
    4. フレシェ分布のパラメータ-𝜖の推定
    '''
    def estimate_epsilon(self, modeltype:'str'):
        # self.exogに数値が入っているかどうかを判定
        if any([None is self.exog[x] for x in self.exog_keys]):
            raise ValueError('Necessary exogenous variables are missing.')
        # self.refに数値が入っているかどうかを判定
        if any([None is self.ref[x] for x in self.ref_keys]):
            raise ValueError('Necessary reference equilibrium variables are missing.')
        # self.paramに数値が入っているかどうかを判定
        if any([None is self.param[x] for x in self.param_keys]):
            raise ValueError('Necessary parameters are missing.')
        
        self.ref['v_ij'] = (self.ref['w_j']-self.exog['tau_ij'])/(self.param['T']-self.exog['t_ij'])

        # x, y, 重みwの算出
        y = np.log(self.ref['lambda_ij'])
        x = np.log(self.ref['v_ij']/(self.exog['p_i'].reshape(1, -1).T**self.param['beta']*self.ref['q_i'].reshape(1, -1).T**(1-self.param['beta'])))
        w = self.ref['N_R_i'].reshape(1, -1).T * self.ref['lambda_ij']
        # x, y, wの平坦化
        y = y.ravel()
        x = x.ravel()
        w = w.ravel()
        # 定数項の追加
        x_add_const = sm.add_constant(x.ravel())
        # モデル推定, modeltypeが'OLS'なら最小二乗法, 'WLS'なら加重最小二乗法
        if modeltype == 'OLS':
            model_sm = sm.OLS(y.ravel(), x_add_const).fit()
        elif modeltype == 'WLS':
            model_sm = sm.WLS(y.ravel(), x_add_const, weights=w.ravel()).fit()
        else:
            raise ValueError('Enter the correct modeltype')
        print(model_sm.summary())
        # モデルの可視化
        print('x:', x)
        print('y:', y)
        fig, ax = plt.subplots(figsize=(8,6))
        ax.plot(x, y, 'o', label="data")
        ax.plot(x, model_sm.fittedvalues, 'r--.', label="OLS")
        ax.legend(loc='best')
        # 傾きが𝛾𝜖を表す
        self.param['gam*eps'] = model_sm.params[1]
        self.param['epsilon'] = model_sm.params[1]/self.param['gamma']
        print(f'Estimated epsilon is ', self.param['epsilon'])
        print(f'Standard error is ', model_sm.bse[1])
        print(f'T-value is ', model_sm.tvalues[1])
        print(f'R-squared is ', model_sm.rsquared)

    '''
    未知数X_i, E_jを解く方程式の定義
    ※(選択確率-選択実績)->0 となるような, 居住地アメニティX_iと就業地アメニティE_jを求めるための関数
    '''
    def probabilities(self, l):
        x = np.array(l[0:self.count_i])
        e = np.array(l[self.count_i:(self.count_i+self.count_j)])
        # sum_e_j = np.sum(e*self.ref['v_ij']**self.param['gam*eps'], axis=0)
        # sum_e_i = np.sum(self.ref['N_R_i'].reshape(1, -1).T*self.ref['v_ij']**self.param['gam*eps']/sum_e_j, axis=1)
        # eq1 = e - self.ref['N_W_j']/sum_e_i

        # x_bar = x/(self.ref['q_i']**(1-self.param['beta']))**self.param['gam*eps']
        # sum_x_i = np.sum(x_bar.reshape(1, -1).T*self.ref['v_ij']**self.param['gam*eps'], axis=1)
        # sum_x_j = np.sum(self.ref['N_W_j']*self.ref['v_ij']**self.param['gam*eps']/sum_x_i, axis=0)
        # eq2 = x_bar - self.ref['N_R_i']/sum_x_j

        net_value = self.ref['v_ij']/(self.exog['p_i']**self.param['beta']*self.ref['q_i']**(1-self.param['beta']))**self.param['gam*eps']
        eq3 = x.reshape(1, -1).T* e * net_value / np.sum(x.reshape(1, -1).T* e * net_value) - self.ref['lambda_ij']
        return eq3
    
    '''
    上記の方程式の目的関数の定義 (最小化する残差の二乗和)
    '''
    # 目的関数の定義 (最小化する残差の二乗和)
    def objective_probabilities(self, vars):
        eqs = self.probabilities(vars)
        return sum(np.sum(eq**2) for eq in eqs)
    
    '''
    5. 基準均衡時の内生変数をもとに、外生変数の推定
    '''
    def recover_fundamentals(self):
        # self.exogに数値が入っているかどうかを判定
        if any([None is self.exog[x] for x in self.exog_keys]):
            raise ValueError('Necessary exogenous variables are missing.')
        # self.paramに数値が入っているかどうかを判定
        if any([None is self.param[x] for x in self.param_keys]):
            raise ValueError('Necessary parameters are missing.') 
        
        # X_iとE_jの初期化
        X_init = [1.0 for x in range(self.count_i)]
        E_init = [1.0 for x in range(self.count_j)]
        # 制約条件の設定 (非負制約)
        constraints = [{'type': 'ineq', 'fun': lambda vars: vars}]
        # 選択確率の方程式を解いて, 居住地アメニティX_iと就業地アメニティE_jを推定
        result = optimize.minimize(self.objective_probabilities, (X_init+E_init), constraints=constraints)
        print(result)
        self.exog['X_i'] = result.x[0:self.count_i]
        self.exog['E_j'] = result.x[self.count_i:(self.count_i+self.count_j)]
        
        #　推定結果の可視化
        net_value = self.ref['v_ij']/(self.exog['p_i']**self.param['beta']*self.ref['q_i']**(1-self.param['beta']))**self.param['gam*eps']
        print('### Check the estimation result ###')
        print('net_value')
        print(net_value)
        print('XE')
        print(self.exog['X_i'].reshape(1, -1).T * self.exog['E_j'])
        print('λ_ij')
        print(self.exog['X_i'].reshape(1, -1).T * self.exog['E_j'] * net_value / np.sum(self.exog['X_i'].reshape(1, -1).T * self.exog['E_j'] * net_value))
        print('Σλ_ij')
        print(np.sum(self.exog['X_i'].reshape(1, -1).T * self.exog['E_j'] * net_value / np.sum(self.exog['X_i'].reshape(1, -1).T * self.exog['E_j'] * net_value)))
        print('###################################')

        # 就業地の生産レベルA_jを推定, 標準化した生産レベルa_jも推定
        self.exog['A_j'] = (self.ref['w_j']/self.param['alpha'])**self.param['alpha']*((1-self.param['alpha'])/self.ref['Q_j'])**(1-self.param['alpha'])

        # 居住地の商業地利用の相対地価xi_i
        self.exog['xi_i'] = self.ref['Q_j']/self.ref['q_i']

        #　就業地の商業地利用の面積H_W_j
        self.ref['H_W_j'] = ((1-self.param['alpha'])*self.exog['A_j']/self.ref['Q_j'])**(1-self.param['alpha'])
        
        # 居住地の平均価格q_ave_i, 居住地面積(H_i-H_W_j)と商業地面積のH_W_jの加重平均
        self.exog['q_ave_i'] = (self.ref['q_i']*(self.ref['H_i']-self.ref['H_W_j'])+self.ref['Q_j']+self.ref['H_W_j'])/self.ref['H_i']

        # 居住地の限界密度H_ave_i
        omega_i = (((1-self.param['psi'])*self.exog['q_ave_i'])**((1-self.param['psi'])/self.param['psi'])) * (1-self.param['gamma'])*self.exog['L_i']
        self.exog['H_ave_i'] = omega_i / (omega_i/self.ref['H_i']-1)

        # 総人口N
        self.exog['N'] = np.sum(self.ref['N_R_i'])
    
    '''
    6. 外生変数の再入力
    '''
    def change_exog(self, new_exog:dict[str,np.ndarray]):
        # new_exogに不必要な数値が入っているかどうかを確認する
        if not(set(new_exog.keys()) <= set(self.exog_keys)): 
            raise ValueError('Unnecessary exogenous variables exist.') 

        # 更新先のself.new_exogの初期化
        self.new_exog = self.exog
        # 追加したnew_exogの反映
        for k,v in new_exog.items():
            self.exog[k] = v
    
    '''
    未知数lambda_ij, q_i, Q_j, N_R_i, M_R_i, N_W_j, M_W_j, H_i, w_jを解く方程式の定義
    '''
    def simultaneous_equations(self, l):
        # 未知数はi*(i+8)
        ij = self.count_i*self.count_j
        i = self.count_i
        j = self.count_j
        lambda_ij = np.array(l[0 : ij]).reshape(i, j)
        q_i = np.array(l[ij : ij+i])
        Q_j = np.array(l[ij+i : ij+i+j])
        N_R_i = np.array(l[ij+i+j : ij+2*i+j])
        M_R_i = np.array(l[ij+2*i+j : ij+3*i+j])
        N_W_j = np.array(l[ij+3*i+j : ij+3*i+2*j])
        M_W_j = np.array(l[ij+3*i+2*j : ij+3*i+3*j])
        H_i = np.array(l[ij+3*i+3*j : ij+4*i+3*j])
        w_j = np.array(l[ij+4*i+3*j : ij+4*i+4*j])

        v_ij = (w_j-self.new_exog['tau_ij'])/(self.param['T']-self.new_exog['t_ij'])

        # 式(12)を参照, i*j本
        net_value = v_ij/((self.new_exog['p_i']**self.param['beta'])*(q_i**(1-self.param['beta'])))**self.param['gam*eps']
        amenity_XE = self.new_exog['X_i'].reshape(1, -1).T * self.new_exog['E_j']
        eq1 = lambda_ij - amenity_XE * net_value / np.sum(amenity_XE * net_value)

        # 式(14)を参照, 2i本
        eq2 = N_R_i - self.new_exog['N']*np.sum(lambda_ij, axis=1)
        eq3 = N_W_j - self.new_exog['N']*np.sum(lambda_ij, axis=0)

        # 式(15)を参照, 2i本
        x_ij = self.param['gamma']*self.param['L']/(self.param['T']+self.new_exog['t_ij'])
        eq4 = M_R_i - self.new_exog['N']*np.sum(lambda_ij*x_ij, axis=0)
        eq5 = M_W_j - self.new_exog['N']*np.sum(lambda_ij*x_ij, axis=1)

        # 式(20)を参照, i本
        eq6 = (1-self.param['alpha'])*self.new_exog['A_j']**(1/(1-self.param['alpha']))*(self.param['alpha']/w_j)**(self.param['alpha']/(1-self.param['alpha']))

        # xi_iの定義を参照, i本
        eq7 = self.new_exog['xi_i'] - Q_j/q_i
                
        # 土地利用の均衡式と式(9)と式(18)を参照, i本
        H_R_ij = (1-self.param['beta'])*self.param['gamma']*self.param['L']*v_ij/q_i.reshape(1,-1).T
        H_W_j = ((1-self.param['alpha'])*self.new_exog['A_j']/Q_j)**(1-self.param['alpha'])
        eq8 = H_i - (np.sum(H_R_ij, axis=0) + H_W_j)
        
        # 式(23)を参照, i本
        q_ave_i = (q_i*np.sum(H_R_ij, axis=0) + Q_j*H_W_j)/H_i
        chi_i = ((1-self.param['psi'])*q_ave_i)**((1-self.param['psi'])/self.param['psi'])
        eq9 = H_i - chi_i*self.new_exog['L_i']/(1+chi_i*self.new_exog['L_i']/self.new_exog['H_ave_i'])

        return [eq1, eq2, eq3, eq4, eq5, eq6, eq7, eq8, eq9]
    
    '''
    上記の方程式の目的関数の定義 (最小化する残差の二乗和)
    '''
    # 目的関数の定義 (最小化する残差の二乗和)
    def objective_equations(self, vars):
        eqs = self.simultaneous_equations(vars)
        return sum(np.sum(eq**2) for eq in eqs)

    '''
    7. 新しい外生変数による一般均衡分析と, 外生変数の再導出
    '''
    def solve_equilibrium(self):
        # self.new_exogに定義済みかどうかを判定
        if 'new_exog' not in vars(self).keys():
            raise ValueError('Necessary new exogenous variables are missing.')
        # self.paramに数値が入っているかどうかを判定
        if any([None is self.param[x] for x in self.param_keys]):
            raise ValueError('Necessary parameters are missing.') 
        
        # lambda_ij,q_i,Q_j,N_R_i,M_R_i,N_W_j,M_W_j,H_i,w_jの初期化
        lambda_ij_init = [1/(self.count_i+self.count_j) for x in range(self.count_i+self.count_j)]
        q_i_init = [1.0 for x in range(self.count_i)]
        Q_j_init = [1.0 for x in range(self.count_j)]
        N_R_i_init = [1.0 for x in range(self.count_i)]
        M_R_i_init = [1.0 for x in range(self.count_i)]
        N_W_j_init = [1.0 for x in range(self.count_j)]
        M_W_j_init = [1.0 for x in range(self.count_j)]
        H_i_init = [1.0 for x in range(self.count_i)]
        w_j_init = [1.0 for x in range(self.count_j)]
        vars_init = lambda_ij_init + q_i_init + Q_j_init + N_R_i_init + M_R_i_init + N_W_j_init + M_W_j_init + H_i_init + w_j_init

        # 制約条件の設定 (非負制約)
        constraints = [{'type': 'ineq', 'fun': lambda vars: vars}]
        # 一般均衡の方程式を解く
        result = optimize.minimize(self.objective_equations, vars_init, constraints=constraints)
        print(result)

        # 方程式の解の格納
        ij = self.count_i*self.count_j
        i = self.count_i
        j = self.count_j
        self.eq = {}
        self.eq['lambda_ij'] = np.array(result.x[0 : ij]).reshape(i, j)
        self.eq['q_i'] = np.array(result.x[ij : ij+i])
        self.eq['Q_j'] = np.array(result.x[ij+i : ij+i+j])
        self.eq['N_R_i'] = np.array(result.x[ij+i+j : ij+2*i+j])
        self.eq['M_R_i'] = np.array(result.x[ij+2*i+j : ij+3*i+j])
        self.eq['N_W_j'] = np.array(result.x[ij+3*i+j : ij+3*i+2*j])
        self.eq['M_W_j'] = np.array(result.x[ij+3*i+2*j : ij+3*i+3*j])
        self.eq['H_i'] = np.array(result.x[ij+3*i+3*j : ij+4*i+3*j])
        self.eq['w_j'] = np.array(result.x[ij+4*i+3*j : ij+4*i+4*j])
        
        # 推定結果の可視化
        print('λ_ij: 通勤割合')
        print(self.eq['lambda_ij'])
        print('q_i: 居住用地価')
        print(self.eq['q_i'])
        print('Q_j: 業務用地価')
        print(self.eq['Q_j'])
        print('N_R_i: 居住人口')
        print(self.eq['N_R_i'])
        print('M_R_i: 勤務人口')
        print(self.eq['M_R_i'])
        print('N_W_j: 労働供給量')
        print(self.eq['N_W_j'])
        print('M_W_j: 労働需要量')
        print(self.eq['M_W_j'])
        print('H_i: 床面積')
        print(self.eq['H_i'])
        print('w_j: 賃金率')
        print(self.eq['w_j'])



#%%
if __name__ == '__main__':
    model = Horcher_model(2,2)
    exog = {
        't_ij': np.array([
            [45, 75],
            [75, 30]
        ])/(60*24),
        'tau_ij': np.array([
            [0.015, 0.020],
            [0.020, 0.010]
        ]),
        'p_i': np.array([1.0, 1.1]), 
        'L_i': np.array([2.0, 1.8])
    }
    ref = {
        'lambda_ij': np.array([
            [0.25, 0.40],
            [0.17, 0.18]
        ]),
        'q_i':   np.array([0.95, 1.05]),
        'N_R_i': np.array([65, 35]),
        'M_R_i': np.array([60, 40]),
        'H_i':   np.array([1.5, 1.2]),
        'Q_j':   np.array([0.95, 1.20]),
        'N_W_j': np.array([42, 58]),
        'M_W_j': np.array([50, 50]),
        'w_j':   np.array([0.95, 1.05])
    }
    param = {    
        'alpha': 0.80,
        'beta':  0.75,
        'gamma': 9/24,
        'psi':   0.25,
        'L':     1,
        'T':     8/24
    }
    # 1.外生変数の入力
    model.set_exog(exog)
    # 2.基準均衡時の内生変数の入力
    model.set_ref(ref)
    # 3.パラメーターの入力
    model.set_param(param)
    # 4.フレシェ分布のパラメータ-𝜖の推定
    model.estimate_epsilon('WLS')
    # 5.基準均衡時の内生変数をもとに、外生変数の推定
    model.recover_fundamentals()
    # 6.外生変数の再入力
    new_exog = {
        't_ij': np.array([
            [45, 60],
            [60, 20]
        ])/(60*24),
        'tau_ij': np.array([
            [0.015, 0.018],
            [0.018, 0.008]
        ])
    }
    model.change_exog(new_exog)
    # 7.新しい外生変数による一般均衡分析と, 外生変数の再導出
    model.solve_equilibrium()
#%%

# %%
