# -*- coding: utf-8 -*-
"""model_T2_0 -> model_T2_1: налог tax из параметра становится переменной с правилом
в стиле строки 137 (лаг + разрыв выпуска + активы) и экзогенным процессом z_tax/er_tax.
Файлы читаются/пишутся в cp1251, чтобы не повредить русские комментарии."""
import io, os
os.chdir(r"D:\CCProjects\dsge")

def patch(text, pairs):
    for old, new in pairs:
        n = text.count(old)
        assert n == 1, f"ожидал 1 вхождение, нашёл {n}: {old[:60]!r}"
        text = text.replace(old, new)
    return text

# ---------------- .mod ----------------
m = io.open("model_T2_0.mod", encoding="cp1251", newline="").read()
m = patch(m, [
    # 1. переменные и шоки
    ("z_tr,z_trY,z_ztemp_growth,zzobs_dPC,zzobs_dY,zzobs_RH; \r\n\r\n\r\nvarexo er_R,er_YF,er_teta_F,er_tr,er_trY; ",
     "z_tr,z_trY,z_ztemp_growth,zzobs_dPC,zzobs_dY,zzobs_RH,tax,z_tax; \r\n\r\n\r\nvarexo er_R,er_YF,er_teta_F,er_tr,er_trY,er_tax; "),
    # 2. параметры: tax убираем, добавляем коэффициенты правила и процесса
    ("alfa_K,bbb,fi_PF,gama_r,gama_rp,gama_ry,gama_tr,gama_try,h,mu_L,mu_M,omega_C,omega_L,omega_M,tax,\r\nnu0_R,nu0_YF,nu0_teta_F,nu0_tr,nu0_trY,\r\nnu1_R,nu1_YF,nu1_teta_F,nu1_tr,nu1_trY\r\ngama_trA;",
     "alfa_K,bbb,fi_PF,gama_r,gama_rp,gama_ry,gama_tr,gama_try,h,mu_L,mu_M,omega_C,omega_L,omega_M,\r\nnu0_R,nu0_YF,nu0_teta_F,nu0_tr,nu0_trY,nu0_tax,\r\nnu1_R,nu1_YF,nu1_teta_F,nu1_tr,nu1_trY,nu1_tax,\r\ngama_trA,gama_tax,gama_taxy,gama_taxA;"),
    ("tax=0.1;\r\ngama_trA=-0.1*1;",
     "gama_trA=-0.1*1;\r\n\r\n//tax rule (same form as transfers): inertia + output gap + assets\r\ngama_tax=0.8;\r\ngama_taxy=0.1*0;\r\ngama_taxA=0.01*1;"),
    ("nu0_trY=0.005;\tnu1_trY=0;\r\n",
     "nu0_trY=0.005;\tnu1_trY=0;\r\nnu0_tax=0.1;\tnu1_tax=0;\r\n"),
    # 3. правило налога рядом с правилом трансфертов (строка 137)
    ("tr_H=gama_tr*tr_H(-1)+(1-gama_tr)*(gama_try*(y_D-y_D_SS)+gama_trA*(a_H-a_H_SS)+z_tr);\r\n",
     "tr_H=gama_tr*tr_H(-1)+(1-gama_tr)*(gama_try*(y_D-y_D_SS)+gama_trA*(a_H-a_H_SS)+z_tr);\r\n\r\n"
     "tax=gama_tax*tax(-1)+(1-gama_tax)*(gama_taxy*(y_D-y_D_SS)+gama_taxA*(a_H-a_H_SS)+z_tax);\r\n"),
    # 4. экзогенный процесс налога
    ("z_trY=nu1_trY*z_trY(-1)+(1-nu1_trY)*(nu0_trY)+er_trY;\r\n",
     "z_trY=nu1_trY*z_trY(-1)+(1-nu1_trY)*(nu0_trY)+er_trY;\r\nz_tax=nu1_tax*z_tax(-1)+(1-nu1_tax)*(nu0_tax)+er_tax;\r\n"),
    # 5. шоки
    ("var er_trY; stderr 0.01;\r\n", "var er_trY; stderr 0.01;\r\nvar er_tax; stderr 0.01;\r\n"),
    # 6. оцениваемые параметры
    ("stderr er_trY,0.0144390060777438,0.0003,10, inv_gamma_pdf,0.01,3;\r\n",
     "stderr er_trY,0.0144390060777438,0.0003,10, inv_gamma_pdf,0.01,3;\r\nstderr er_tax,0.0144390060777438,0.0003,10, inv_gamma_pdf,0.01,3;\r\n"),
    ("tax,0.4,0,0.8,normal_pdf,0.4,0.5e-1;\r\n",
     "nu0_tax,0.4,0,0.8,normal_pdf,0.4,0.5e-1;\r\nnu1_tax,0,-0.999,0.999,normal_pdf,0,0.5;\r\n"
     "gama_tax,0.9,0.6,0.999,normal_pdf,0.8,0.15;\r\ngama_taxy,0,-1,1,normal_pdf,0,0.15;\r\ngama_taxA,0.01,0,1,normal_pdf,0.01,0.15;\r\n"),
])
io.open("model_T2_1.mod", "w", encoding="cp1251", newline="").write(m)

# ---------------- steadystate ----------------
s = io.open("model_T2_0_steadystate.m", encoding="cp1251", newline="").read()
s = patch(s, [
    ("function [ys, params, info] = model_T2_0_steadystate(ys_, exo_,M_,options)\r\n%function [ys, params, info] = model_T2_0_steadystate(ys_, exo_,M_,options)",
     "function [ys, params, info] = model_T2_1_steadystate(ys_, exo_,M_,options)\r\n%function [ys, params, info] = model_T2_1_steadystate(ys_, exo_,M_,options)"),
    ("nu0_ztemp_growth=nu0_trY;\r\n",
     "nu0_ztemp_growth=nu0_trY;\r\ntax=nu0_tax;   % tax is now a variable: steady state = mean of its exogenous process\r\nz_tax=nu0_tax;\r\n"),
    ("z_ztemp_growth,zzobs_dPC,zzobs_dY,zzobs_RH].';",
     "z_ztemp_growth,zzobs_dPC,zzobs_dY,zzobs_RH,tax,z_tax].';"),
])
io.open("model_T2_1_steadystate.m", "w", encoding="cp1251", newline="").write(s)
print("ok: model_T2_1.mod, model_T2_1_steadystate.m")
