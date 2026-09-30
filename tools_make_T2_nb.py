# -*- coding: utf-8 -*-
"""model_T2_0 -> model_T2_nb ("no bonds"): убираем актив/долг a_H вместе с бюджетным
ограничением домохозяйств и членом gama_trA*(a_H-a_H_SS) в правиле трансфертов.
Уравнение Эйлера по облигациям оставлено (облигации в нулевом чистом предложении, как в
стандартной NK-модели без денег в бюджете). Файлы читаются/пишутся в cp1251."""
import io, os
os.chdir(r"D:\CCProjects\dsge")

def patch(text, pairs):
    for old, new in pairs:
        n = text.count(old)
        assert n == 1, f"ожидал 1 вхождение, нашёл {n}: {old[:70]!r}"
        text = text.replace(old, new)
    return text

m = io.open("model_T2_0.mod", encoding="cp1251", newline="").read()
m = patch(m, [
    ("var a_H,c_H,", "var c_H,"),
    ("#a_H_SS=steady_state(a_H);\r\n", ""),
    ("\r\nexp(p_C+c_H)-exp(m_H-r_H)+exp(m_H)+a_H*exp(-r_H)+(-1+tax)*exp(w_H+l_H)-a_H(-1)*exp(-p-z_ztemp_growth)-tr_H=0;",
     "\r\n// [nb] household budget constraint dropped together with a_H (bonds in zero net supply)"),
    ("tr_H=gama_tr*tr_H(-1)+(1-gama_tr)*(gama_try*(y_D-y_D_SS)+gama_trA*(a_H-a_H_SS)+z_tr);",
     "tr_H=gama_tr*tr_H(-1)+(1-gama_tr)*(gama_try*(y_D-y_D_SS)+z_tr);   // [nb] no assets to react to"),
])
io.open("model_T2_nb.mod", "w", encoding="cp1251", newline="").write(m)

s = io.open("model_T2_0_steadystate.m", encoding="cp1251", newline="").read()
s = patch(s, [
    ("function [ys, params, info] = model_T2_0_steadystate(ys_, exo_,M_,options)\r\n%function [ys, params, info] = model_T2_0_steadystate(ys_, exo_,M_,options)",
     "function [ys, params, info] = model_T2_nb_steadystate(ys_, exo_,M_,options)\r\n%function [ys, params, info] = model_T2_nb_steadystate(ys_, exo_,M_,options)"),
    ("a_H=-(exp(c_H)-exp(m_H-r_H)+exp(m_H)-exp(w_H+l_H)+exp(w_H+l_H)*tax-tr_H)/(exp(-r_H)-exp(-p-nu0_trY));\r\n", ""),
    ("ys=[a_H,c_H,", "ys=[c_H,"),
])
io.open("model_T2_nb_steadystate.m", "w", encoding="cp1251", newline="").write(s)
print("ok: model_T2_nb.mod, model_T2_nb_steadystate.m")
