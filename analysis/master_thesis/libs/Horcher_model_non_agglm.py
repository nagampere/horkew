#%%
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
        
        # 外生的なパラメーター
        self.param = {}
        self.param_keys = ['alpha','beta','gamma','psi','L','T','N']
        for k in self.param_keys:
            self.param[k] = None

        # 基準均衡状態の内生変数
        self.ref = {}
        self.ref_key_i = ['q_i']
        self.ref_key_j = ['Q_j','w_j']
        self.ref_key_ij = ['lambda_ij']
        self.ref_keys = self.ref_key_i+self.ref_key_j+self.ref_key_ij
        for k in self.ref_keys:
            self.ref[k] = None
        pass
    
    '''
    1. 外生変数の入力
    '''
    def set_exog(self, exog:dict[str, np.ndarray]) -> None:
        # exog.keys()に過不足がないかを判定
        if set(self.exog_keys) != set(exog.keys()):
            raise ValueError('Not all keys are included or unnecessary keys are included.')
        
        # p_i, L_iの入力
        for k in self.exog_key_i:
            # 各行列のサイズが正しいかを判定
            if exog[k].shape == (self.count_i,):
                self.exog[k] = exog[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')

        # 特になし
        for k in self.exog_key_j:
            # 各行列のサイズが正しいかを判定
            if exog[k].shape == (self.count_j,):
                self.exog[k] = exog[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')

        # tau_ij, t_ijの入力
        for k in self.exog_key_ij:
            # 各行列のサイズが正しいかを判定
            if exog[k].shape == (self.count_i, self.count_j):
                self.exog[k] = exog[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')
    
    '''
    2. パラメーターの入力
    '''
    def set_param(self, param:dict[str, float]) -> None:
        # param.keys()に過不足がないかを判定
        if set(self.param_keys) != set(param.keys()):
            raise ValueError('Not all keys are included or unnecessary keys are included.')
        
        # alpha, beta, gamma, psi, L, T, Nの入力
        for k in self.param_keys:
            self.param[k] = param[k]
    
    '''
    3. 基準均衡時の内生変数の入力
    '''
    def set_ref(self, ref:dict[str, np.ndarray]) -> None:
        # ref.keys()に過不足がないかを判定
        if set(self.ref_keys) != set(ref.keys()):
            raise ValueError('Not all keys are included or unnecessary keys are included.')
        
        # q_iの入力
        for k in self.ref_key_i:
            # 各行列のサイズが正しいかを判定
            if ref[k].shape == (self.count_i,):
                self.ref[k] = ref[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')

        # Q_j, w_jの入力
        for k in self.ref_key_j:
            # 各行列のサイズが正しいかを判定
            if ref[k].shape == (self.count_j,):
                self.ref[k] = ref[k]
                print(k + ' array has been stored.')
            else:
                print('In the ' +k+ ' array, the dimension size is wrong')

        # lambda_ijの入力
        for k in self.ref_key_ij:
            # 各行列のサイズが正しいかを判定
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
        # 一人当たり基本財消費量C_ijの算出 (式(9)を参照)
        self.ref['C_ij'] = self.param['beta']*self.param['gamma']*self.param['L']*self.ref['v_ij']/self.exog['p_i'].reshape(1,-1).T
        # 一人当たり居住地面積H_R_ijの算出 (式(9)を参照)
        self.ref['H_R_ij'] = (1-self.param['beta'])*self.param['gamma']*self.param['L']*self.ref['v_ij']/self.ref['q_i'].reshape(1,-1).T
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
        print('C_ij: 一人当たり基本財消費量')
        print(self.ref['C_ij'])
        print('H_R_ij: 一人当たり居住地面積')
        print(self.ref['H_R_ij'])
        print('H_R_i: 居住地面積')
        print(self.ref['H_R_i'])
        print('################################################')

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

        # 推定結果の確認, 傾きが𝛾𝜖を表す
        print('### Check the regression result ###')
        print(model_sm.summary())
        self.param['gam*eps'] = model_sm.params[1]
        self.param['epsilon'] = model_sm.params[1]/self.param['gamma']
        print('Estimated epsilon is ', self.param['epsilon'])
        print('Standard error is ', model_sm.bse[1])
        print('T-value is ', model_sm.tvalues[1])
        print('R-squared is ', model_sm.rsquared)
        # モデルの可視化
        print('x:', x)
        print('y:', y)
        fig, ax = plt.subplots(figsize=(8,6))
        ax.plot(x, y, 'o', label="data")
        ax.plot(x, model_sm.fittedvalues, 'r--.', label="OLS")
        ax.legend(loc='best')
        plt.show()
        print('###################################')

    '''
    未知数X_i, E_jを解く方程式の定義
    ※(選択確率-選択実績)->0 となるような, 居住地アメニティX_iと就業地アメニティE_jを求めるための関数
    '''
    def probabilities(self, l):
        x = np.array(l[0:self.count_i])
        e = np.array(l[self.count_i:(self.count_i+self.count_j)])

        utility = (self.ref['v_ij']/(self.exog['p_i']**self.param['beta']*self.ref['q_i']**(1-self.param['beta'])))**self.param['gam*eps']
        eq = x.reshape(1, -1).T* e * utility / np.sum(x.reshape(1, -1).T* e * utility) - self.ref['lambda_ij']
        return eq
    
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
        
        #　推定結果の確認 (式(12)を参照)
        print('### Check the estimation result ###')
        utility = (self.ref['v_ij']/(self.exog['p_i']**self.param['beta']*self.ref['q_i']**(1-self.param['beta'])))**self.param['gam*eps']
        print('utility')
        print(utility)
        print('X_i')
        print(self.exog['X_i'])
        print('E_j')
        print(self.exog['E_j'])
        print('XE')
        XE = self.exog['X_i'].reshape(1, -1).T * self.exog['E_j']
        print(XE)
        print('λ_ij')
        print(XE * utility / np.sum(XE * utility))
        print('Σλ_ij')
        print(np.sum(XE * utility / np.sum(XE * utility)))
        print('###################################')

        # 就業地の生産レベルA_jを推定, 標準化した生産レベルa_jも推定, (式(20)を参照)
        self.exog['A_j'] = (self.ref['w_j']/self.param['alpha'])**self.param['alpha']*((1-self.param['alpha'])/self.ref['Q_j'])**(self.param['alpha']-1)
        # 居住地の商業地利用の相対地価xi_i
        self.exog['xi_i'] = self.ref['Q_j']/self.ref['q_i']
        #　就業地の商業地利用の面積H_W_j (式(18)を参照)
        self.ref['H_W_j'] = ((1-self.param['alpha'])*self.exog['A_j']/self.ref['Q_j'])**(1/self.param['alpha'])*self.ref['M_W_j']
        # 床面積の合計
        self.ref['H_i'] = self.ref['H_R_i'] + self.ref['H_W_j']
        # 居住地の平均価格q_ave_i, 居住地面積(H_i-H_W_j)と商業地面積のH_W_jの加重平均
        self.ref['q_ave_i'] = (self.ref['q_i']*self.ref['H_R_i']+self.ref['Q_j']*self.ref['H_W_j'])/self.ref['H_i']
        # 土地賦存量に対する床面積の割合φ_i
        omega_i = (((1-self.param['psi'])*self.ref['q_ave_i'])**((1-self.param['psi'])/self.param['psi'])) * self.exog['L_i']
        self.ref['phi_i'] = self.ref['H_i'] / omega_i
        # 仮想的な床面積の最大量H_ave_i (式(30)を参照)
        self.exog['H_ave_i'] = omega_i / (omega_i/self.ref['H_i']-1)
        
        # 導出した変数の確認
        print('### Check the estimated variables ###')
        print('A_j: 就業地の生産レベル(外生変数)')
        print(self.exog['A_j'])
        print('xi_i: 地域iにおける商業地の相対地価(外生変数)')
        print(self.exog['xi_i'])
        print('H_W_j: 商業地面積')
        print(self.ref['H_W_j'])
        print('H_i: 床面積')
        print(self.ref['H_i'])
        print('q_ave_i:  居住地の平均価格')
        print(self.ref['q_ave_i'])
        print('φ_i: 土地賦存量に対する床面積の割合')
        print(self.ref['phi_i'])
        print('H_ave_i: 仮想的な床面積の最大量(外生変数)')
        print(self.exog['H_ave_i'])
        print('#####################################')
    
    '''
    未知数 w_jを解く方程式の定義
    '''
    def simultaneous_equations(self, l):
        # 未知数はw_j (j個)
        w_j = np.array(l)

        #　業務用地の地価Q_kの定義 (式(20)を参照)
        Q_j = ((1-self.param['alpha'])*self.given_exog['A_j']**(1/(1-self.param['alpha'])))*(self.param['alpha']/w_j)**(self.param['alpha']/(1-self.param['alpha']))
        # 居住用地の価格Q_jの定義
        q_i = Q_j / self.given_exog['xi_i']
        
        # 時間価値v_ij, 通勤確率lambda_ijの定義 (式(6), 式(12)を参照)
        v_ij = (w_j-self.given_exog['tau_ij'])/(self.param['T']+self.given_exog['t_ij'])
        utility = (v_ij/(self.given_exog['p_i']**self.param['beta']*q_i**(1-self.param['beta'])))**self.param['gam*eps']
        XE = self.given_exog['X_i'].reshape(1, -1).T * self.given_exog['E_j']
        lambda_ij = XE * utility / np.sum(XE * utility)
        # 労働量x_ijの定義 (式(8)を参照)
        x_ij = self.param['gamma']*self.param['L']/(self.param['T']+self.given_exog['t_ij'])
        # 労働需要M_W_jの定義 (式(15)を参照)
        M_W_j = self.param['N']*np.sum(lambda_ij*x_ij, axis=0)
        # 一人当たり居住地面積H_R_ij, 居住地面積H_R_iの定義(式(9)を参照)
        H_R_ij = (1-self.param['beta'])*self.param['gamma']*self.param['L']*v_ij/q_i.reshape(1,-1).T
        H_R_i = np.sum(H_R_ij*self.param['N']*lambda_ij, axis=1)
        
        # 業務用地H_W_jの定義 (式(18)を参照)
        H_W_j = ((1-self.param['alpha'])*self.given_exog['A_j']/Q_j)**(1/self.param['alpha']) * M_W_j
        # 床面積の需要量
        demand_H_i = H_R_i + H_W_j
        
        # 平均価格q_ave_i
        q_ave_i = (q_i*H_R_i + Q_j*H_W_j) / (H_R_i + H_W_j)
        # 床面積の供給量 (式(23)を参照)
        omega_i = (((1-self.param['psi'])*q_ave_i)**((1-self.param['psi'])/self.param['psi'])) * self.given_exog['L_i']
        supply_H_i = omega_i/(1+omega_i/self.given_exog['H_ave_i'])
        
        # 床面積H_iに関する需給均衡式 (i本)
        eq = demand_H_i - supply_H_i

        return eq

    '''
    上記の方程式の目的関数の定義 (最小化する残差の二乗和)
    '''
    # 目的関数の定義 (最小化する残差の二乗和)
    def objective_equations(self, vars):
        eqs = self.simultaneous_equations(vars)
        return sum(np.sum(eq**2) for eq in eqs)

    '''
    外生変数から一般均衡を解く関数の定義
    '''
    def solve_equilibrium(self, given_exog:dict, modeltype:str, method:str):
        # exogに不必要な数値が入っているかどうかを確認する
        if not(set(given_exog.keys()) <= set(self.exog.keys())): 
            raise ValueError('Unnecessary exogenous variables exist.') 
        
        # ベンチマークの外生変数の格納
        self.given_exog = given_exog
        
        # w_jの初期化
        w_j_init = [1.0 for x in range(self.count_j)]
        # 制約条件の設定 (非負制約)
        constraints = [{'type': 'ineq', 'fun': lambda vars: vars}]
        # 一般均衡の方程式を解く, functionが'minimize’の時は局所最適化, 'root'の時はベクトル
        if modeltype == 'minimize':
            result = optimize.minimize(fun=self.objective_equations, x0=w_j_init, method=method, constraints=constraints)
        elif modeltype == 'root':
            result = optimize.root(fun=self.simultaneous_equations, x0=w_j_init, method=method)
        else:
            raise ValueError('Enter the correct modeltype')

        # 方程式の解の格納
        eq = {}
        eq['w_j'] = np.array(result.x[0:self.count_j])

        #　業務用地の地価Q_kの算出 (式(20)を参照)
        eq['Q_j'] = ((1-self.param['alpha'])*self.given_exog['A_j']**(1/(1-self.param['alpha'])))*(self.param['alpha']/eq['w_j'])**(self.param['alpha']/(1-self.param['alpha']))
        # 居住用地の価格Q_jの算出
        eq['q_i'] = eq['Q_j'] / self.given_exog['xi_i']
        # 時間価値v_ij, 通勤確率lambda_ijの算出 (式(6), 式(12)を参照)
        eq['v_ij'] = (eq['w_j']-self.given_exog['tau_ij'])/(self.param['T']+self.given_exog['t_ij'])
        utility = (eq['v_ij']/(self.given_exog['p_i']**self.param['beta']*eq['q_i']**(1-self.param['beta'])))**self.param['gam*eps']
        eq['lambda_ij'] = self.given_exog['X_i'].reshape(1, -1).T * self.given_exog['E_j'] * utility / np.sum(self.given_exog['X_i'].reshape(1, -1).T * self.given_exog['E_j'] * utility)
        # 居住人口N_R_iと就業人口N_W_jの算出 (式(14)を参照)
        eq['N_R_i'] = self.param['N']*np.sum(eq['lambda_ij'], axis=1)
        eq['N_W_j'] = self.param['N']*np.sum(eq['lambda_ij'], axis=0)
        # 労働供給M_R_iと労働需要M_W_jの算出 (式(15)を参照)
        x_ij = self.param['gamma']*self.param['L']/(self.param['T']+self.given_exog['t_ij'])
        eq['M_R_i'] = self.param['N']*np.sum(eq['lambda_ij']*x_ij, axis=1)
        eq['M_W_j'] = self.param['N']*np.sum(eq['lambda_ij']*x_ij, axis=0)
        # 一人当たり居住地面積H_R_ij, 居住地面積H_R_iの算出 (式(9)を参照)
        eq['H_R_ij'] = (1-self.param['beta'])*self.param['gamma']*self.param['L']*eq['v_ij']/eq['q_i'].reshape(1,-1).T
        eq['H_R_i'] = np.sum(eq['H_R_ij']*self.param['N']*eq['lambda_ij'], axis=1)
        # 業務用地H_W_jの算出 (式(18)を参照)
        eq['H_W_j'] = ((1-self.param['alpha'])*self.given_exog['A_j']/eq['Q_j'])**(1/self.param['alpha']) * eq['M_W_j']
        # 土地供給H_iの算出
        eq['H_i'] = eq['H_R_i'] + eq['H_W_j']
        # 企業の生産量Y_jの算出 (式(17)を参照)
        eq['Y_j'] = self.given_exog['A_j']*eq['M_W_j']**self.param['alpha']*eq['H_W_j']**(1-self.param['alpha'])
        # 居住地の平均価格q_ave_i, 居住地面積(H_i-H_W_j)と商業地面積のH_W_jの加重平均
        eq['q_ave_i'] = (eq['q_i']*eq['H_R_i']+eq['Q_j']*eq['H_W_j'])/eq['H_i']
        # 土地賦存量に対する床面積の割合φ_i
        omega_i = (((1-self.param['psi'])*eq['q_ave_i'])**((1-self.param['psi'])/self.param['psi'])) * self.exog['L_i']
        eq['phi_i'] = eq['H_i'] / omega_i

        # 推定結果の可視化
        print('### Check the result of equilibrium ###')
        print(result)
        print('w_j: 賃金率')
        print(eq['w_j'])
        print('#######################################')
        print('### Calculate the endogenous variables ###')
        print('λ_ij: 通勤割合')
        print(eq['lambda_ij'])
        print('v_ij')
        print(eq['v_ij'])
        print('q_i: 居住用地価')
        print(eq['q_i'])
        print('Q_j: 業務用地価')
        print(eq['Q_j'])
        print('q_ave_i: 土地の平均価格')
        print(eq['q_ave_i'])
        print('N_R_i: 居住人口')
        print(eq['N_R_i'])
        print('N_W_j: 勤務人口')
        print(eq['N_W_j'])
        print('M_R_i: 労働供給量')
        print(eq['M_R_i'])
        print('M_W_j: 労働需要量')
        print(eq['M_W_j'])
        print('H_R_i: 居住地面積')
        print(eq['H_R_i'])
        print('H_W_j: 商業地面積')
        print(eq['H_W_j'])
        print('H_i: 床面積')
        print(eq['H_i'])
        print('Y_j: 企業の生産量')
        print(eq['Y_j'])
        print('#####################################')

        return eq

    '''
    6. 現況再現性の確認
    '''
    def check_replication(self, modeltype:str, method:str):
        # 現況再現性の確認
        self.rep = self.solve_equilibrium(self.exog, modeltype, method)

    '''
    7. 外生変数の再入力
    '''
    def change_exog(self, new_exog:dict[str,np.ndarray]):
        # new_exogに不必要な数値が入っているかどうかを確認する
        if not(set(new_exog.keys()) <= set(self.exog.keys())): 
            raise ValueError('Unnecessary exogenous variables exist.') 

        # new_exogの初期化
        self.new_exog = self.exog

        # new_exogの更新
        for k,v in new_exog.items():
            self.new_exog[k] = v
    
    '''
    8. 新しい外生変数による一般均衡分析と, 外生変数の再導出
    '''
    def simulate_project(self, modeltype:str, method:str):
        # self.new_exogに定義済みかどうかを判定
        if 'new_exog' not in vars(self).keys():
            raise ValueError('Necessary new exogenous variables are missing.')
        # self.paramに数値が入っているかどうかを判定
        if any([None is self.param[x] for x in self.param_keys]):
            raise ValueError('Necessary parameters are missing.') 
        
        self.res = self.solve_equilibrium(self.new_exog, modeltype, method)
    
    '''
    9. 一般均衡分析の結果の評価
    '''
    def evaluate_res(self):
        # 増加率の初期化
        change = {}

        # 増加率の算出
        for k in self.res.keys():
            rate = (self.res[k] - self.rep[k])/self.rep[k]*100
            #  i*jの配列に対して, i行ごとに加重平均を計算する
            if rate.ndim == 2:
                rate = np.sum(rate*self.rep['lambda_ij'], axis=1)/np.sum(self.rep['lambda_ij'], axis=1)
            
            change[k] = rate

        self.change = change



#%%
if __name__ == '__main__':
    # モデルの定義
    model = Horcher_model(2,2)
    # 外生変数の設定
    exog = {
        't_ij': np.array([
            [45, 75],
            [75, 30]
        ])/(60*24),
        'tau_ij': np.array([
            [0.006, 0.010],
            [0.010, 0.005]
        ]),
        'p_i': np.array([1.0, 1.0]), 
        'L_i': np.array([60, 60])
    }
    # パラメータの設定
    param = {    
        'alpha': 0.80,
        'beta':  0.75,
        'gamma': 9/24,
        'psi':   0.25,
        'L':     1,
        'T':     8/24,
        'N':     100
    }
    # 基準均衡時の内生変数の設定
    ref = {
        'lambda_ij': np.array([
            [0.30, 0.30],
            [0.05, 0.35]
        ]),
        'q_i':   np.array([0.95, 1.1]),
        'Q_j':   np.array([1.5, 1.5]),
        'w_j':   np.array([0.95, 1.05])
    }

    # 1.外生変数の入力
    model.set_exog(exog)
    # 2.パラメータの入力
    model.set_param(param)
    # 3.基準均衡時の内生変数の入力
    model.set_ref(ref)
    # 4.フレシェ分布のパラメータ-𝜖の推定
    model.estimate_epsilon('OLS')
    # 5.基準均衡時の内生変数をもとに、外生変数の推定
    model.recover_fundamentals()
    # 6.現況再現性の確認
    model.check_replication('root', 'hybr')
    # 7.外生変数の再入力
    model.change_exog(
        {
            't_ij': np.array([
                [45, 60],
                [60, 15]
            ])/(60*24),
            'tau_ij': np.array([
                [0.006, 0.009],
                [0.009, 0.004]
            ])
        }
    )
    # 8.新しい外生変数による一般均衡分析と, 内生変数の導出
    model.simulate_project('root', 'hybr')
    # 9.一般均衡分析の結果の評価
    model.evaluate_res()
#%%

