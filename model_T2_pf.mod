@#define i_Time=0


var a_H,c_H,d_F,l_H,limda_BF,limda_BH,limda_DF,limda_PF,m_H,p,p_C,p_F,r_H,tr_H,w_H,y_D,y_F,z_R,z_YF,z_teta_F,z_tr,z_trY,z_ztemp_growth,zzobs_dPC,zzobs_dY,zzobs_RH; 


varexo er_R,er_YF,er_teta_F,er_tr,er_trY; 




parameters
    
alfa_K,bbb,fi_PF,gama_r,gama_rp,gama_ry,gama_tr,gama_try,h,mu_L,mu_M,omega_C,omega_L,omega_M,tax,
nu0_R,nu0_YF,nu0_teta_F,nu0_tr,nu0_trY,
nu1_R,nu1_YF,nu1_teta_F,nu1_tr,nu1_trY
gama_trA;

alfa_K=0.6;
bbb=-0.01;
fi_PF=1;
gama_r=0.8;
gama_rp=1.5*1;
gama_ry=0.1;
gama_tr=0.8;
gama_try=0.1*0;
h=0.5;
mu_L=1;
mu_M=1;
omega_C=1.5;
omega_L=1.5;
omega_M=1.5;
tax=0.1;
gama_trA=-0.1*1;

nu0_R=0.015;	nu1_R=0.0;
nu0_YF=0;	nu1_YF=1.0;   // unit root in productivity
nu0_teta_F=8;	nu1_teta_F=0;
nu0_tr=0.1;	nu1_tr=0;
nu0_trY=0.005;	nu1_trY=0;



model; 


#l_H_SS=steady_state(l_H);
#c_H_SS=steady_state(c_H);
#limda_BH_SS=steady_state(limda_BH);
#w_H_SS=steady_state(w_H);
#limda_DF_SS=steady_state(limda_DF);
#limda_PF_SS=steady_state(limda_PF);
#p_SS=steady_state(p);
#y_D_SS=steady_state(y_D);
#y_F_SS=steady_state(y_F);
#r_H_SS=steady_state(r_H);
#tr_H_SS=steady_state(tr_H);
#m_H_SS=steady_state(m_H);
#a_H_SS=steady_state(a_H);
#d_F_SS=steady_state(d_F);
#limda_BF_SS=steady_state(limda_BF);
#p_F_SS=steady_state(p_F);
#p_C_SS=steady_state(p_C);


z_ztemp_growth=(0+z_trY);

//%householders №1
//target_F='(exp(c_H-h*c_H_OOO(-1)))^(1-omega_C)/(1-omega_C)+exp(mu_M)*(exp(m_H))^(1-omega_M)/(1-omega_M)-exp(mu_L)*(exp(l_H))^(1+omega_L)/(1+omega_L)';
//discount_var='exp(bbb+0)';
//restriction_f={
//'exp(p_C+c_H)+(-exp(m_H)*exp(-r_H)+exp(m_H))+a_H*exp(-r_H)-(exp(w_H+l_H)*(1-tax)+a_H(-1)*exp(-p-z_ztemp_growth)+tr_H)';
//};
//restriction_var={'limda_BH';};
//peremen={'c_H_OOO';'a_H';'c_H';'d_F';'l_H';'limda_BF';'limda_BH';'limda_DF';'limda_PF';'m_H';'p';'p_C';'p_F';'r_H';'tr_H';'w_H';'y_D';'y_F';'z_R';'z_YF';'z_teta_F';'z_tr';'z_ztemp_growth';};
//uprav_perem={'a_H';'c_H';'m_H';'l_H';};
//LL=1;

@#if 1==12
'exp(bbb)*limda_BH(+1)*exp(-p(+1)-z_ztemp_growth(+1))-limda_BH*exp(-r_H)=0;'
'exp(c_H-h*c_H_OOO(-1))^(1-omega_C)-limda_BH*exp(p_C+c_H)=0;'
'exp(mu_M)*exp(m_H)^(1-omega_M)-limda_BH*(-exp(m_H-r_H)+exp(m_H))=0;'
'-exp(mu_L)*exp(l_H)^(1+omega_L)-limda_BH*(-1+tax)*exp(w_H+l_H)=0;'
'exp(p_C+c_H)-exp(m_H-r_H)+exp(m_H)+a_H*exp(-r_H)+(-1+tax)*exp(w_H+l_H)-a_H(-1)*exp(-p-z_ztemp_growth)-tr_H=0;'

@#else
exp(bbb)*limda_BH(+1)*exp(-p(+1)-z_ztemp_growth(+1))-limda_BH*exp(-r_H)=0;
exp(c_H-h*c_H(-1))^(1-omega_C)-limda_BH*exp(p_C+c_H)=0;
exp(mu_M)*exp(m_H)^(1-omega_M)-limda_BH*(-exp(m_H-r_H)+exp(m_H))=0;
-exp(mu_L)*exp(l_H)^(1+omega_L)-limda_BH*(-1+tax)*exp(w_H+l_H)=0;
exp(p_C+c_H)-exp(m_H-r_H)+exp(m_H)+a_H*exp(-r_H)+(-1+tax)*exp(w_H+l_H)-a_H(-1)*exp(-p-z_ztemp_growth)-tr_H=0;
@#endif


//%firm №1
//%firm simple №1
//target_F='d_F-exp(p_F_OOO+y_F_OOO+fi_PF)*(exp(p_F-p_F(-1)+p)-exp(p_SS))^2';
//discount_var='exp(p+z_ztemp_growth-r_H(-1))';
//restriction_f={
//'d_F+exp(w_H+l_H)-exp(p_F+y_F)';
//'y_F-(-z_teta_F*(p_F-p_F_OOO)+y_D)';
//'y_F-(z_YF+(1-alfa_K)*l_H)';
//};
//restriction_var={'limda_BF';'limda_DF';'limda_PF'};
//peremen={'p_F_OOO';'y_F_OOO';'a_H';'c_H';'d_F';'l_H';'limda_BF';'limda_BH';'limda_DF';'limda_PF';'m_H';'p';'p_C';'p_F';'r_H';'tr_H';'w_H';'y_D';'y_F';'z_R';'z_YF';'z_teta_F';'z_tr';'z_ztemp_growth';};
//uprav_perem={'d_F';'p_F';'y_F';'l_H'};
//LL=1;

@#if 1==12
'1-limda_BF=0;'
'2*exp(p(+1)+z_ztemp_growth(+1)-r_H)*(exp(p_F(+1)-p_F+p(+1))-exp(p_SS))*exp(p_F_OOO(+1)+y_F_OOO(+1)+fi_PF+p_F(+1)-p_F+p(+1))+2*(-exp(p_F-p_F(-1)+p)+exp(p_SS))*exp(p_F_OOO+y_F_OOO+fi_PF+p_F-p_F(-1)+p)+exp(p_F+y_F)*limda_BF-z_teta_F*limda_DF=0;'
'exp(p_F+y_F)*limda_BF-limda_DF-limda_PF=0;'
'-exp(w_H+l_H)*limda_BF-(-1+alfa_K)*limda_PF=0;'
'd_F+exp(w_H+l_H)-exp(p_F+y_F)=0;'
'y_F+z_teta_F*(p_F-p_F_OOO)-y_D=0;'
'y_F-z_YF-l_H+l_H*alfa_K=0;'

@#else
1-limda_BF=0;
2*exp(p(+1)+z_ztemp_growth(+1)-r_H)*(exp(p_F(+1)-p_F+p(+1))-exp(p_SS))*exp(p_F(+1)+y_F(+1)+fi_PF+p_F(+1)-p_F+p(+1))+2*(-exp(p_F-p_F(-1)+p)+exp(p_SS))*exp(p_F+y_F+fi_PF+p_F-p_F(-1)+p)+exp(p_F+y_F)*limda_BF-z_teta_F*limda_DF=0;
exp(p_F+y_F)*limda_BF-limda_DF-limda_PF=0;
-exp(w_H+l_H)*limda_BF-(-1+alfa_K)*limda_PF=0;
d_F+exp(w_H+l_H)-exp(p_F+y_F)=0;
y_F+z_teta_F*(p_F-p_F)-y_D=0;
y_F-z_YF-l_H+l_H*alfa_K=0;

@#endif

//Government

@#if 1==1
    r_H=(gama_r)*r_H(-1)+(1-gama_r)*((gama_rp)*(p(+1)-p_SS)+(gama_ry)*(y_D-y_D_SS)+z_R);
@#else
    r_H=(gama_r)*r_H(-1)+(1-gama_r)*((gama_rp)*(p-p_SS)+(gama_ry)*(y_D-y_D_SS)+z_R);
@#endif

tr_H=gama_tr*tr_H(-1)+(1-gama_tr)*(gama_try*(y_D-y_D_SS)+gama_trA*(a_H-a_H_SS)+z_tr);


//balance
exp(y_D)=exp(c_H);
p_C=0;
p_F=0;

//экзогенные процессы
z_R=nu1_R*z_R(-1)+(1-nu1_R)*(nu0_R)+er_R;
z_YF=nu1_YF*z_YF(-1)+(1-nu1_YF)*(nu0_YF)+er_YF;
z_teta_F=nu1_teta_F*z_teta_F(-1)+(1-nu1_teta_F)*(nu0_teta_F)+er_teta_F;
z_tr=nu1_tr*z_tr(-1)+(1-nu1_tr)*(nu0_tr)+er_tr;
z_trY=nu1_trY*z_trY(-1)+(1-nu1_trY)*(nu0_trY)+er_trY;


@#if 1==1

zzobs_dY=y_D-y_D(-1)+z_ztemp_growth;
zzobs_RH=exp(r_H*12)*100-100;
zzobs_dPC=p;

@#endif




end;




varobs zzobs_dPC,zzobs_dY,zzobs_RH;

shocks;

var er_R; stderr 0.01;
var er_YF; stderr 0.01;
var er_teta_F; stderr 0.01;
var er_tr; stderr 0.01;
var er_trY; stderr 0.01;

end;



// ---- deterministic (nonlinear) simulation of a permanent +1% productivity shift ----
steady;
nu0_YF=0.01;      // terminal steady state: productivity level +1%
endval;
z_YF=0.01;
end;
steady;
shocks;
var er_YF; periods 1; values 0.01;
end;
perfect_foresight_setup(periods=400);
perfect_foresight_solver;
