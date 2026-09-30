"""Решение по ключевой ставке в игре «центробанк».
Запуск:  python -X utf8 rate_decision.py <data_XXXQY.csv>
Последняя строка файла = текущий квартал (ставка уже задана, часть колонок null).
Выдаёт: правило Тейлора игры, VAR-прогноз, подбор ставки на СЛЕДУЮЩИЙ квартал по RMSE инфляции г/г от 4 %.
"""
import sys
import numpy as np, pandas as pd
import statsmodels.api as sm
from statsmodels.tsa.api import VAR
import warnings; warnings.filterwarnings('ignore')
pd.set_option('display.width', 200)

CSV = sys.argv[1]
P = int(sys.argv[2]) if len(sys.argv) > 2 else 2          # лаг VAR
df = pd.read_csv(CSV, skiprows=1, na_values=['null']).set_index('period')
r, dP, dY, dFX = df['zzobs_r_G'], df['zzobs_dPC'], df['zzobs_dY'], df['zzobs_dNFX']
yoy = dP.rolling(4).sum(); yoy_pct = (np.exp(yoy) - 1) * 100
TARGET = np.log(1.04)
now = df.index[-1]

print("=== хвост данных ===")
print(pd.DataFrame({'r': r, 'dP_q%': dP*100, 'yoy%': yoy_pct, 'dY_q%': dY*100, 'dNFX': dFX}).tail(8).round(3))
print("средние: вся история r=%.2f инфл.ann=%.2f%% рост.ann=%.2f%% | последние 40 кв r=%.2f инфл.ann=%.2f%% рост.ann=%.2f%%" % (
    r.mean(), dP.mean()*400, dY.mean()*400, r[-40:].mean(), dP[-40:].mean()*400, dY[-40:].mean()*400))

# ---------- 1. правило Тейлора игры ----------
d = pd.DataFrame({'r': r, 'r1': r.shift(1), 'yoy': yoy, 'dY': dY}).dropna()
tr = sm.OLS(d['r'], sm.add_constant(d[['r1', 'yoy', 'dY']])).fit()
c, rho, a, b = tr.params['const'], tr.params['r1'], tr.params['yoy'], tr.params['dY']
print("\n=== правило Тейлора (OLS) === r=%.2f + %.2f r(-1) + %.1f yoy_log + %.1f dY   R2=%.3f" % (c, rho, a, b, tr.rsquared))
r_now = float(r.iloc[-1]); yoy_now = float(yoy.iloc[-1]); dY_guess = dY.dropna()[-4:].mean()
print("правило -> ставка после %s: %.2f  (yoy=%.2f%%, r_now=%.2f, dY≈%.2f%%)" % (
    now, c + rho*r_now + a*yoy_now + b*dY_guess, yoy_pct.iloc[-1], r_now, dY_guess*100))

# ---------- 2. VAR ----------
v = pd.DataFrame({'r': r, 'dP': dP, 'dY': dY, 'dFX': dFX}).dropna()
res = VAR(v).fit(P)
A = [res.coefs[i] for i in range(P)]; c0 = res.intercept
print("\n=== VAR(%d), уравнение dP ===" % P, dict(zip(res.params.index, res.params['dP'].round(4))))

def step(lags, r_fix=None):
    x = c0.copy()
    for i in range(P): x = x + A[i] @ lags[-1-i]
    if r_fix is not None: x[0] = r_fix
    return x

# текущий квартал: известны r, dP, dFX (и, возможно, dY); остальное — по VAR
last = v.values[-P:]
cur = step(last, r_fix=r_now)
row = df.iloc[-1]
for j, col in enumerate(['zzobs_r_G', 'zzobs_dPC', 'zzobs_dY', 'zzobs_dNFX']):
    if not np.isnan(row[col]): cur[j] = row[col]
print("текущий квартал %s: r=%.2f dP=%.2f%% dY=%.2f%%%s dFX=%.3f" % (
    now, cur[0], cur[1]*100, cur[2]*100, '' if not np.isnan(row['zzobs_dY']) else ' (VAR-оценка)', cur[3]))
state = np.vstack([last, cur])
past3 = list(dP.iloc[-3:])                       # три последних известных квартала инфляции

H = 8
def simulate(r_path):
    s = state.copy(); out = []
    for h in range(H):
        x = step(s[-P:], r_fix=(r_path[h] if h < len(r_path) else None))
        s = np.vstack([s, x]); out.append(x)
    return np.array(out)

def devs(sim):
    seq = past3 + list(sim[:, 1])
    return [(np.exp(sum(seq[i-3:i+1]))-1)*100 - 4 for i in range(3, len(seq))]

print("\n=== подбор ставки на следующий квартал (далее ставка эндогенна по VAR) ===")
rows = []
for rq in np.arange(2.0, 8.01, 0.25):
    sim = simulate([rq]); dv = devs(sim)
    rows.append((rq, *np.round(dv[:6], 2), round(np.sqrt(np.mean(np.square(dv[:4]))), 3),
                 round(np.sqrt(np.mean(np.square(dv))), 3), round(sim[0, 2]*100, 2), round(sim[1, 0], 2)))
tab = pd.DataFrame(rows, columns=['r_next', 'dev+1', 'dev+2', 'dev+3', 'dev+4', 'dev+5', 'dev+6', 'RMSE4', 'RMSE8', 'dY+1%', 'r+2'])
print(tab.to_string(index=False))
b4 = tab.loc[tab.RMSE4.idxmin()]; b8 = tab.loc[tab.RMSE8.idxmin()]
print("мин RMSE4: r=%.2f (%.3f)   мин RMSE8: r=%.2f (%.3f)" % (b4.r_next, b4.RMSE4, b8.r_next, b8.RMSE8))

print("\n=== ставка фиксируется на 4 квартала ===")
rows = []
for rq in np.arange(2.0, 8.01, 0.5):
    dv = devs(simulate([rq]*4))
    rows.append((rq, *np.round(dv[:6], 2), round(np.sqrt(np.mean(np.square(dv))), 3)))
print(pd.DataFrame(rows, columns=['r', '+1', '+2', '+3', '+4', '+5', '+6', 'RMSE8']).to_string(index=False))

irf = res.irf(8).irfs
print("\nIRF dP на +1 п.п. ставки (п.п. кв/кв):", np.round(irf[:, 1, 0]*100, 3))
print("IRF dP на +0.1 dNFX (п.п. кв/кв):      ", np.round(irf[:, 1, 3]*10, 3))
