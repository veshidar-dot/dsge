
@#define data_file="data_NWRUS0626_s"

var a_H,b_WH,c_H,d_F,ex,fx,im,l_H,limda_BF,limda_BH,limda_DF,limda_PF,m_H,p,p_C,p_ex,p_F,p_im,p_W,r_H,r_W,tax,tr_H,tr_W,w_H,y,y_D,y_F,y_GDP,z_ex,z_pim,z_pw,z_r,z_r1,z_r4,z_rw,z_tax,z_teta_F,z_tr,z_trw,z_trY,z_YF,z_ztemp_growth,zzobs_dL,zzobs_dPC,zzobs_R1,zzobs_dSN,zzobs_dSR,zzobs_dY; 




varexo er_ex,er_pim,er_pw,er_r,er_r1,er_r4,er_rw,er_tax,er_teta_F,er_tr,er_trw,er_trY,er_YF; 




parameters
    
alfa_K,bbb,fi_PF,gama_r,gama_rp,gama_ry,gama_tr,gama_try,h,mu_L,mu_M,omega_C,omega_L,omega_M,
nu0_ex,nu0_pim,nu0_pw,nu0_r,	   nu0_teta_F,nu0_tr,nu0_trw,nu0_trY,nu0_YF,
nu1_ex,nu1_pim,nu1_pw,nu1_r,nu1_rw,nu1_teta_F,nu1_tr,nu1_trw,nu1_trY,nu1_YF,
nu1_r1,nu1_r4
gama_ex,gama_exfx,gama_rw,gama_rwb,
teta_D,w_d
b_WH_SS,c_H_SS
nu0_tax,nu1_tax,gama_trA,gama_tax,gama_taxy,gama_taxA
;

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
%tax=0.1;
gama_trA=-0.1*1;

gama_ex=0.8;
gama_exfx=0.1;
gama_rw=0.8;
gama_rwb=-0.1;
teta_D=8;
w_d=0.6;
b_WH_SS=1;
c_H_SS=1;

nu0_tax=0.1;nu1_tax=0;
gama_trA=-0.1*1;
gama_tax=0.8;
gama_taxy=0.0;
gama_taxA=0.1*1;


nu1_r1=0;
nu1_r4=0;
nu0_ex=0;	nu1_ex=0;
nu0_pim=0;	nu1_pim=0;
nu0_pw=0.005;	nu1_pw=0;
nu0_r=0.015;	nu1_r=0;
nu1_rw=0;
nu0_teta_F=8;	nu1_teta_F=0;
nu0_tr=0.1;	nu1_tr=0;
nu0_trw=0;	nu1_trw=0;
nu0_trY=0.005;	nu1_trY=0;
nu0_YF=0;	nu1_YF=0;




model; 


#tr_W_SS=steady_state(tr_W);
#im_SS=steady_state(im);
#ex_SS=steady_state(ex);
#p_W_SS=steady_state(p_W);
#p_im_SS=steady_state(p_im);
#fx_SS=steady_state(fx);
#l_H_SS=steady_state(l_H);
#p_C_SS=steady_state(p_C);
#y_SS=steady_state(y);
#p_F_SS=steady_state(p_F);
#limda_BH_SS=steady_state(limda_BH);
#w_H_SS=steady_state(w_H);
#limda_DF_SS=steady_state(limda_DF);
#limda_PF_SS=steady_state(limda_PF);
#p_SS=steady_state(p);
#y_D_SS=steady_state(y_D);
#y_F_SS=steady_state(y_F);
#r_W_SS=steady_state(r_W);
#r_H_SS=steady_state(r_H);
#tr_H_SS=steady_state(tr_H);
#m_H_SS=steady_state(m_H);
#a_H_SS=steady_state(a_H);
#d_F_SS=steady_state(d_F);
#limda_BF_SS=steady_state(limda_BF);
#p_ex_SS=steady_state(p_ex);
#y_GDP_SS=steady_state(y_GDP);
    #nu0_rw=steady_state(z_rw);


%comment about labor trend. tr_L=tr_E;tr_HK=tr_E*alfa_e+(1-alfa_e)*tr_HK;   tr_HK=tr_E; tr_LF=2*tr_L;
//z_ztemp_growth=(alfa_K*z_trI+(1-alfa_K)*z_trL*2+z_trY)/(1-alfa_K);
//z_ztemp_growth=(0+(1-alfa_K)*z_trL+z_trY);
z_ztemp_growth=(0+z_trY);

//%householders №1
//target_F='(exp(c_H-h*c_H_OOO(-1)))^(1-omega_C)/(1-omega_C)+exp(mu_M)*(exp(m_H))^(1-omega_M)/(1-omega_M)-exp(mu_L)*(exp(l_H))^(1+omega_L)/(1+omega_L)';
//discount_var='exp(bbb+0)';
//restriction_f={
//'exp(p_C+c_H)+(-exp(m_H)*exp(-r_H)+exp(m_H))+a_H*exp(-r_H)+b_WH*exp(fx-r_W)-(exp(w_H+l_H)*(1-tax)+a_H(-1)*exp(-p-z_ztemp_growth)+b_WH(-1)*exp(fx-p_W-z_ztemp_growth)+tr_H)';
//};
//restriction_var={'limda_BH';};
//peremen={'c_H_OOO';'a_H';'b_WH';'c_H';'d_F';'ex';'fx';'im';'l_H';'limda_BF';'limda_BH';'limda_DF';'limda_PF';'m_H';'p';'p_C';'p_ex';'p_F';'p_im';'p_W';'r_H';'r_W';'tr_H';'tr_W';'w_H';'y_D';'y_F';'y_GDP';'z_ex';'z_pim';'z_pw';'z_R';'z_rw';'z_teta_F';'z_tr';'z_trw';'z_YF';'z_ztemp_growth';};
//uprav_perem={'a_H';'b_WH';'c_H';'m_H';'l_H';};
//LL=1;

@#if 1==12
'exp(bbb)*limda_BH(+1)*exp(-p(+1)-z_ztemp_growth(+1))-limda_BH*exp(-r_H)=0;'
'exp(bbb)*limda_BH(+1)*exp(fx(+1)-p_W(+1)-z_ztemp_growth(+1))-limda_BH*exp(fx-r_W)=0;'
'exp(c_H-h*c_H_OOO(-1))^(1-omega_C)-limda_BH*exp(p_C+c_H)=0;'
'exp(mu_M)*exp(m_H)^(1-omega_M)-limda_BH*(-exp(m_H-r_H)+exp(m_H))=0;'
'-exp(mu_L)*exp(l_H)^(1+omega_L)-limda_BH*(-1+tax)*exp(w_H+l_H)=0;'
'exp(p_C+c_H)-exp(m_H-r_H)+exp(m_H)+a_H*exp(-r_H)+b_WH*exp(fx-r_W)+(-1+tax)*exp(w_H+l_H)-a_H(-1)*exp(-p-z_ztemp_growth)-b_WH(-1)*exp(fx-p_W-z_ztemp_growth)-tr_H=0;'

@#else

exp(bbb)*limda_BH(+1)*exp(-p(+1)-z_ztemp_growth(+1))-limda_BH*exp(-r_H)=0;
exp(bbb)*limda_BH(+1)*exp(fx(+1)-p_W(+1)-z_ztemp_growth(+1))-limda_BH*exp(fx-r_W)=0;
exp(c_H-h*c_H(-1))^(1-omega_C)-limda_BH*exp(p_C+c_H)=0;
exp(mu_M)*exp(m_H)^(1-omega_M)-limda_BH*(-exp(m_H-r_H)+exp(m_H))=0;
-exp(mu_L)*exp(l_H)^(1+omega_L)-limda_BH*(-1+tax)*exp(w_H+l_H)=0;
exp(p_C+c_H)-exp(m_H-r_H)+exp(m_H)+a_H*exp(-r_H)+b_WH*exp(fx-r_W)+(-1+tax)*exp(w_H+l_H)-a_H(-1)*exp(-p-z_ztemp_growth)-b_WH(-1)*exp(fx-p_W-z_ztemp_growth)-tr_H=0;

@#endif


//%firm №1
//%firm simple №1
//target_F='d_F-exp(p_F_OOO+y_F_OOO+fi_PF)*(exp(p_F-p_F(-1)+p)-exp(p_SS))^2';
//discount_var='exp(p+z_ztemp_growth-r_H(-1))';
//restriction_f={
//'d_F+exp(w_H+l_H)-exp(p_F+y_F)-tr_W';
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
'd_F+exp(w_H+l_H)-exp(p_F+y_F)-tr_W=0;'
'y_F+z_teta_F*(p_F-p_F_OOO)-y_D=0;'
'y_F-z_YF-l_H+l_H*alfa_K=0;'

@#else
1-limda_BF=0;
2*exp(p(+1)+z_ztemp_growth(+1)-r_H)*(exp(p_F(+1)-p_F+p(+1))-exp(p_SS))*exp(p_F(+1)+y_F(+1)+fi_PF+p_F(+1)-p_F+p(+1))+2*(-exp(p_F-p_F(-1)+p)+exp(p_SS))*exp(p_F+y_F+fi_PF+p_F-p_F(-1)+p)+exp(p_F+y_F)*limda_BF-z_teta_F*limda_DF=0;
exp(p_F+y_F)*limda_BF-limda_DF-limda_PF=0;
-exp(w_H+l_H)*limda_BF-(-1+alfa_K)*limda_PF=0;
d_F+exp(w_H+l_H)-exp(p_F+y_F)-tr_W=0;
y_F+z_teta_F*(p_F-p_F)-y_D=0;
y_F-z_YF-l_H+l_H*alfa_K=0;

@#endif

//Government
@#if 1==1
//r_H=(gama_r)*r_H(-1)+(1-gama_r)*((gama_rp)*(p-p_SS)+(gama_ry)*(y_D-y_D_SS)+z_R);

r_H=(gama_r)*r_H(-1)+(1-gama_r)*((gama_rp)*(p(+1)-p_SS)+(gama_ry)*(y_D-y_D_SS)+z_r+z_r1(-1)+z_r4(-4));
tr_H=gama_tr*tr_H(-1)+(1-gama_tr)*(gama_try*(y_D-y_D_SS)+gama_trA*(a_H-a_H_SS)+z_tr);
tax=gama_tax*tax(-1)+(1-gama_tax)*(gama_taxy*(y_D-y_D_SS)+gama_taxA*(a_H-a_H_SS)+z_tax);

@#endif

//world
exp(p_ex+ex)-b_WH*exp(fx-r_W)+tr_W=exp(p_im+im)-b_WH(-1)*exp(fx-p_W-z_ztemp_growth);
p_im=(fx-fx_SS)+z_pim;
tr_W=z_trw;
ex=(gama_ex)*ex(-1)+(1-gama_ex)*(gama_exfx*(fx-fx_SS)+z_ex);
r_W=(gama_rw)*r_W(-1)+(1-gama_rw)*((gama_rwb)*(b_WH-b_WH_SS)+z_rw);
p_W=z_pw;

//balance
im=-teta_D*(p_im-p_C)+y+log(1-w_d);
y_D=-teta_D*(p_F-p_C)+y+log(w_d);
exp(y)=exp(c_H)+exp(ex);
exp(y_GDP)=exp(c_H)+exp(ex)-exp(im);
exp(p_C*(1-teta_D))=exp(p_F*(1-teta_D))*w_d+(1-w_d)*exp(p_im*(1-teta_D));
p_ex=p_C_SS;
p_C=p_C_SS;



//экзогенные процессы
z_ex=nu1_ex*z_ex(-1)+(1-nu1_ex)*(nu0_ex)+er_ex;
z_pim=nu1_pim*z_pim(-1)+(1-nu1_pim)*(nu0_pim)+er_pim;
z_pw=nu1_pw*z_pw(-1)+(1-nu1_pw)*(nu0_pw)+er_pw;
z_r=nu1_r*z_r(-1)+(1-nu1_r)*(nu0_r)+er_r;
z_rw=nu1_rw*z_rw(-1)+(1-nu1_rw)*(nu0_rw)+er_rw;
z_tax=nu1_tax*z_tax(-1)+(1-nu1_tax)*(nu0_tax)+er_tax;
z_teta_F=nu1_teta_F*z_teta_F(-1)+(1-nu1_teta_F)*(nu0_teta_F)+er_teta_F;
z_tr=nu1_tr*z_tr(-1)+(1-nu1_tr)*(nu0_tr)+er_tr;
z_trw=nu1_trw*z_trw(-1)+(1-nu1_trw)*(nu0_trw)+er_trw;
z_trY=nu1_trY*z_trY(-1)+(1-nu1_trY)*(nu0_trY)+er_trY;
z_YF=nu1_YF*z_YF(-1)+(1-nu1_YF)*(nu0_YF)+er_YF;

z_r1=nu1_r1*z_r1(-1)+er_r1;
z_r4=nu1_r4*z_r4(-1)+er_r4;

@#if 1==1

zzobs_dL=l_H-l_H(-1);
zzobs_dPC=p;
zzobs_R1=r_H*12;	
zzobs_dSN=fx-fx(-1)+p-p_W;
zzobs_dSR=fx-fx(-1);
zzobs_dY=y_GDP-y_GDP(-1)+z_ztemp_growth;


@#else
zzobs_dY=y_GDP-y_GDP(-1)+z_ztemp_growth;
zzobs_RH=exp(r_H*12)*100-100;
zzobs_dPC=p;


@#endif




end;




varobs zzobs_dL,zzobs_dPC,zzobs_R1,zzobs_dSN,zzobs_dSR,zzobs_dY;
%varobs zzobs_dPC,zzobs_R1,zzobs_dSN,zzobs_dSR,zzobs_dY;
//varobs zzobs_RH;

shocks;

var er_ex; stderr 0.01;
var er_pim; stderr 0.01;
var er_pw; stderr 0.01;
var er_r; stderr 0.01;
var er_rw; stderr 0.01;
var er_teta_F; stderr 0.01;
var er_tr; stderr 0.01;
var er_trw; stderr 0.01;
var er_trY; stderr 0.01;
var er_YF; stderr 0.01;

var er_r1; stderr 0.01e-4;
var er_r4; stderr 0.01e-4;

end;


%options_.balance_jacobia=1;
%options_.balance_qz=1;

//model_info;
//simul(periods=100);
%steady(nocheck);
%options_.steadystate.nocheck = 1;
steady;
check;
%options_.qz_criterium=1-1.e-6;
%check;

%keyboard;


estimated_params;

@#if 1==12
stderr er_r,0.00397586474154794,0.00000001,10, gamma_pdf,0.001,3;
stderr zzobs_dY,1.00259491322835E-06,0.000001,0.1,gamma_pdf,0.0001, 3e-3;
bbb,0.468912448334904,-0.999,0.999,normal_pdf,0.3,0.6;

@#endif

@#if 1==1

stderr er_ex,0.0144390060777438,0.0003,10, inv_gamma_pdf,0.01,3;
stderr er_pim,0.0144390060777438,0.0003,10, inv_gamma_pdf,0.01,3;
stderr er_pw,0.0144390060777438,0.0003,10, inv_gamma_pdf,0.01,3;
stderr er_r,0.0144390060777438,0.0003,10, inv_gamma_pdf,0.01,3;
stderr er_r1,0.0144390060777438,0.0003,10, inv_gamma_pdf,0.01e-1,0.03e-1;
stderr er_r4,0.0144390060777438,0.0003,10, inv_gamma_pdf,0.01e-1,0.03e-1;
stderr er_rw,0.0144390060777438,0.0003,10, inv_gamma_pdf,0.01,3;
stderr er_tax,0.0144390060777438,0.0003,10, inv_gamma_pdf,0.01,3;
stderr er_teta_F,0.0144390060777438,0.0003,10, inv_gamma_pdf,0.01,3;
stderr er_tr,0.0144390060777438,0.0003,10, inv_gamma_pdf,0.01,3;
stderr er_trw,0.0144390060777438,0.0003,10, inv_gamma_pdf,0.01,3;
stderr er_trY,0.0144390060777438,0.0003,10, inv_gamma_pdf,0.01e-1,0.03e-1;
stderr er_YF,0.0144390060777438,0.0003,10, inv_gamma_pdf,0.01,3;
stderr zzobs_dL,1.00259491322835E-06,0.000001,0.001,gamma_pdf,0.0001, 3e-3;
stderr zzobs_dPC,1.00259491322835E-06,0.000001,0.001,gamma_pdf,0.0001, 3e-3;
stderr zzobs_R1,1.00259491322835E-06,0.000001,0.001,gamma_pdf,0.0001, 3e-3;
stderr zzobs_dSN,1.00259491322835E-06,0.000001,0.001,gamma_pdf,0.0001, 3e-3;
stderr zzobs_dSR,1.00259491322835E-06,0.000001,0.001,gamma_pdf,0.0001, 3e-3;
stderr zzobs_dY,1.00259491322835E-06,0.000001,0.001,gamma_pdf,0.0001, 3e-3;
alfa_K,0.6,0.3,0.8,normal_pdf,0.6,0.05;
bbb,-0.005,-0.01,-0.00001,normal_pdf,-0.005,0.005e-2;
fi_PF,0,-5,5,normal_pdf,0,10;
gama_ex,0.9,0.6,0.999,normal_pdf,0.8,0.15;
gama_exfx,0.1,0,5,normal_pdf,0.1,0.15;
gama_r,0.9,0.6,0.999,normal_pdf,0.8,0.15;
gama_rp,1.5,1,5,normal_pdf,1.5,0.5;
gama_rw,0.9,0.6,0.999,normal_pdf,0.8,0.15;
gama_rwb,-0.1,-5,0,normal_pdf,-0.1,0.15;
gama_ry,0,-1,1,normal_pdf,0,0.15;
gama_tax,0.9,0.6,0.999,normal_pdf,0.8,0.15;
gama_taxA,0.1,0,1,normal_pdf,0,0.15;
gama_taxy,0,-1,1,normal_pdf,0,0.15;
gama_tr,0.9,0.6,0.999,normal_pdf,0.8,0.15;
gama_trA,-0.1,-1,0,normal_pdf,-0.1,0.15;
gama_try,0,-1,1,normal_pdf,0,0.15;
h,0.7,0,0.999,normal_pdf,0.7,0.15;
mu_L,0,-5,5,normal_pdf,0,10;
mu_M,0,-5,5,normal_pdf,0,10;
nu0_ex,0,-5,5,normal_pdf,0,0.1;
nu0_pim,0,-5,5,normal_pdf,0,0.1;
nu0_pw,0.00166666666666667,0,0.003,normal_pdf,0.00166,0.001;
nu0_r,0.005,0.0033,0.00833,normal_pdf,0.005,0.005;
nu0_tax,0.4,0,0.8,normal_pdf,0.4,0.5e-1;
nu0_teta_F,8,4,12,normal_pdf,8,2;
nu0_tr,0,-5,5,normal_pdf,0,10;
nu0_trw,0.1,0,5,normal_pdf,0.1,0.1;
nu0_trY,0.00432277762665952,-0.01,0.02,normal_pdf,0.01,0.01;
nu0_YF,2.49000612495961,-10,10,normal_pdf,0,10;
nu1_ex,0,-0.999,0.999,normal_pdf,0,0.5;
nu1_pim,0,-0.999,0.999,normal_pdf,0,0.5;
nu1_pw,0,-0.999,0.999,normal_pdf,0,0.5;
nu1_r,0,-0.999,0.999,normal_pdf,0,0.5;
nu1_r1,0,-0.999,0.999,normal_pdf,0,0.5;
nu1_r4,0,-0.999,0.999,normal_pdf,0,0.5;
nu1_rw,0,-0.999,0.999,normal_pdf,0,0.5;
nu1_tax,0,-0.999,0.999,normal_pdf,0,0.5;
nu1_teta_F,0,-0.999,0.999,normal_pdf,0,0.5;
nu1_tr,0,-0.999,0.999,normal_pdf,0,0.5;
nu1_trw,0,-0.999,0.999,normal_pdf,0,0.5;
nu1_trY,0,-0.999,0.999,normal_pdf,0,0.5;
nu1_YF,0,-0.999,0.999,normal_pdf,0,0.5;
omega_C,1.5,1,5,normal_pdf,1.5,1.5e-1;
omega_L,1.5,1,5,normal_pdf,1.5,1.5e-1;
omega_M,1.5,1,5,normal_pdf,1.5,1.5e-1;
teta_D,8,4,12,normal_pdf,8,2;
w_d,0.6,0.4,0.8,normal_pdf,0.6,0.1;
b_WH_SS,0,-5,5,normal_pdf,0,0.1;
c_H_SS,0,-5,5,normal_pdf,0,0.1;

@#endif



end;


@#if 1==12

    estimation(nograph,datafile=@{data_file},mode_compute=DSGE_optimization_vrezka,presample=4,lik_init=1,optim=('Display','iter','MaxFunEvals',35,'MaxIter',20000),plot_priors =0, prior_trunc =0.0e-99,cova_compute=0,mh_replic=0,kalman_algo=1,use_univariate_filters_if_singularity_is_detected =0,filter_step_ahead =[1:12],consider_all_endogenous);

@#else
    i_mode=5;load model_T3_temp_full;xparam1=area_S{i_mode,2}([1:13,15:68],1);save mode_temp xparam1;%1,5
    i_mode=5;load model_T3_temp_full;xparam1=area_S{i_mode,2}(:,1);save mode_temp xparam1;%1,5
 
    estimation(nograph,datafile=@{data_file},mode_file='mode_temp.mat',mode_compute=0,presample=4,lik_init=1,optim=('Display','iter','MaxFunEvals',35,'MaxIter',20000),plot_priors =0, prior_trunc =0.0e-99,cova_compute=0,mh_replic=0,kalman_algo=1,use_univariate_filters_if_singularity_is_detected =0,filter_step_ahead =[1:12],consider_all_endogenous);

@#endif

@#if 1==12
        shock_groups(name=test_group); 
        MP = er_r,er_r1,er_r4;
        FP = er_tax,er_tr;
        W =er_ex,er_pim,er_pw,er_rw,er_trw;
        D=er_teta_F,er_trY,er_YF;
        end;
        %er_ex,er_pim,er_pw,er_r,er_r1,er_r4,er_rw,er_tax,er_teta_F,er_tr,er_trw,er_trY,er_YF
        shock_decomposition(use_shock_groups=test_group)zzobs_dPC zzobs_dY zzobs_R1;
@#endif

@#if 1==12
stoch_simul(nograph, order=1, drop=25, periods=100, replic=0) a_H,b_WH,c_H,d_F,ex,fx,im,l_H,limda_BF,limda_BH,limda_DF,limda_PF,m_H,p,p_C,p_ex,p_F,p_im,p_W,r_H,r_W,tax,tr_H,tr_W,w_H,y,y_D,y_F,y_GDP,z_ex,z_pim,z_pw,z_r,z_r1,z_r4,z_rw,z_tax,z_teta_F,z_tr,z_trw,z_trY,z_YF,z_ztemp_growth,zzobs_dL,zzobs_dPC,zzobs_R1,zzobs_dSN,zzobs_dSR,zzobs_dY;%
oo_.irfs_est=oo_.irfs;

nu1_r4=0.0;
nu1_r1=0.0;
nu1_r=0.0;
stoch_simul(nograph, order=1, drop=25, periods=100, replic=0) a_H,b_WH,c_H,d_F,ex,fx,im,l_H,limda_BF,limda_BH,limda_DF,limda_PF,m_H,p,p_C,p_ex,p_F,p_im,p_W,r_H,r_W,tax,tr_H,tr_W,w_H,y,y_D,y_F,y_GDP,z_ex,z_pim,z_pw,z_r,z_r1,z_r4,z_rw,z_tax,z_teta_F,z_tr,z_trw,z_trY,z_YF,z_ztemp_growth,zzobs_dL,zzobs_dPC,zzobs_R1,zzobs_dSN,zzobs_dSR,zzobs_dY;%
oo_.irfs_iid=oo_.irfs;


disp('plot IRF');figure;T_irf=40;
SH={'er_r','z_r';'er_r1','z_r1';'er_r4','z_r4';};
VVV={'zzobs_dPC','infl';'zzobs_dY','GDP growth';'zzobs_R1','interest rate';'zzobs_dSN','n.exch.growth';'w_H','wage';'l_H','labor';'a_H','assets';'fx','real exch';'y_GDP','output-GAP'};
for i=1:9;subplot(3,3,i);eval(['plot(1:T_irf,oo_.irfs.',VVV{i,1},'_',SH{1,1},',''r'',1:T_irf,oo_.irfs.',VVV{i,1},'_',SH{2,1},',''b'',1:T_irf,oo_.irfs.',VVV{i,1},'_',SH{3,1},','':k'');']);title(VVV{i,2});end;legend(SH{1,1},SH{2,1},SH{3,1});
figure('name','normilizer');
for i=1:9;subplot(3,3,i);eval(['plot(1:T_irf,oo_.irfs.',VVV{i,1},'_',SH{1,1},'/oo_.irfs.',SH{1,2},'_',SH{1,1},'(1,1),''r'',1:T_irf,oo_.irfs.',VVV{i,1},'_',SH{2,1},'/oo_.irfs.',SH{2,2},'_',SH{2,1},'(1,1),''b'',1:T_irf,oo_.irfs.',VVV{i,1},'_',SH{3,1},'/oo_.irfs.',SH{3,2},'_',SH{3,1},'(1,1),'':k'');']);title(VVV{i,2});end;legend(SH{1,1},SH{2,1},SH{3,1});


//randn('state',round(mod(now()*1.0e+12,1.0e+7)));//для инициализации randn


@#endif





@#if 1==12
    disp('AR-RMSE-in-Na(outside)');load @{data_file};TT_h=12;presampl=4;OBS=options_.varobs.';TT=eval(['size(',OBS{1,1},',1);']);TT_per=TT-presampl;for i=1:size(OBS,2);for j=1:size(M_.endo_names,1);if strcmp(deblank(OBS{1,i}),deblank(M_.endo_names(j,:)));I_OBS(i,1)=j;end;end;end;      clear er_ARin;for i=1:size(I_OBS,1); for dt=1:TT_per;    y=eval(['',OBS{1,i},'(presampl+1:TT,1)']);x=eval(['',OBS{1,i},'(presampl:TT-1,1)']);x=[x,ones(size(x,1),1)];I_fin=isfinite(y+x(:,1));b=inv(x(I_fin,:).'*x(I_fin,:))*x(I_fin,:).'*y(I_fin,1);for j=1:TT_h;if j<=dt;er_ARin{j,1}(TT_per+1-dt,i)=y(TT_per+1-dt,1)-x(TT_per+1-dt,:)*b;x(:,1)=x*b;else;er_ARin{j,1}(TT_per+1-dt,i)=NaN;end;end;end;end;for i=1:size(I_OBS);for j=1:TT_h;RMSE_ARin(i,j)=mean(er_ARin{j,1}(isfinite(er_ARin{j,1}(:,i)),i).^2,1).^0.5.';end;end;
    disp('DSGE-RMSE(outside-dynare)');T_max=TT;for i_v=1:size(OBS,2);eval(['y=',OBS{1,i_v},';']);for i_h=1:TT_h;DSGE_forecast(i_v,i_h,1:T_max-1)=oo_.FilteredVariablesKStepAhead(i_h,I_OBS(i_v,1),1+i_h:T_max-1+i_h);DSGE_er(i_v,i_h,1:T_max-1)=reshape([NaN(presampl,1);y(presampl+1+i_h:T_max,1);NaN(i_h-1,1)],[1,1,T_max-1])-DSGE_forecast(i_v,i_h,1:T_max-1);end;end;disp('RMSE');for i_v=1:size(I_OBS,1);for i_h=1:TT_h;I_fin=(1:T_max-1);I_fin=I_fin(isfinite(DSGE_er(i_v,i_h,:)));er=DSGE_er(i_v,i_h,I_fin);er=er(:);RMSE_DSGE(i_v,i_h)=mean(er.^2).^0.5;end;end;
    %disp('DSGE-RMSE-in-Na(outside-my)');clear ZZZZ_data;for i=1:size(OBS,2);eval(['ZZZZ_data(:,i)=',OBS{1,i},';']);end;    options_.qz_criterium=1-1.e-6;Ax=zeros(M_.endo_nbr);Ax(:,oo_.dr.state_var)=oo_.dr.ghx(oo_.dr.inv_order_var,:); Aer=oo_.dr.ghu(oo_.dr.inv_order_var,:);HHH=sparse(1:size(I_OBS,1),I_OBS,1,size(I_OBS,1),size(Ax,1));SS=oo_.dr.ys(I_OBS,1);Pstar=lyapunov_solver(Ax,Aer,M_.Sigma_e,options_);disp('creation of matrixes is done');[ZZZZ_S,ZZZZ_SF,ZZZZ_XF,ZZZZ_L,ZZZZ_VAR_S]=var_unobserved_forecast2(Ax,Aer*(M_.Sigma_e.^0.5),HHH,(M_.H+zeros(size(HHH,1))).^0.5,SS,ZZZZ_data.',TT_h,Pstar);clear er_DSGEin;for j=1:TT_h;er_DSGEin{j,1}=ZZZZ_data(presampl+j:end,:).'-ZZZZ_XF{j,1}(:,presampl:end-j);end;for i=1:size(ZZZZ_data,2);for j=1:TT_h;RMSE_DSGEin(i,j)=mean(er_DSGEin{j,1}(i,isfinite(er_DSGEin{j,1}(i,:))).^2,2).^0.5.';MAE_DSGEin(i,j)=median(er_DSGEin{j,1}(i,isfinite(er_DSGEin{j,1}(i,:))).^2,2).^0.5.';end;end;
    %disp('DSGE-RMSE-in-Na(outside-my-static)');clear ZZZZ_data;for i=1:size(OBS,2);eval(['ZZZZ_data(:,i)=',OBS{1,i},';']);end;    I_save=false(M_.endo_nbr);I_save(I_OBS)=true;I_save(oo_.dr.state_var)=true; options_.qz_criterium=1-1.e-6;Ax=zeros(M_.endo_nbr);Ax(:,oo_.dr.state_var)=oo_.dr.ghx(oo_.dr.inv_order_var,:); Aer=oo_.dr.ghu(oo_.dr.inv_order_var,:);HHH=sparse(1:size(I_OBS,1),I_OBS,1,size(I_OBS,1),size(Ax,1));SS=oo_.dr.ys(I_OBS,1);Axs=Ax(I_save,I_save);Aers=Aer(I_save,:);HHHs=HHH(:,I_save);Pstar=lyapunov_solver(Axs,Aers,M_.Sigma_e,options_);disp('creation of matrixes is done');[ZZZZ_S,ZZZZ_SF,ZZZZ_XF,ZZZZ_L,ZZZZ_VAR_S]=var_unobserved_forecast2(Axs,Aers*(M_.Sigma_e.^0.5),HHHs,(M_.H+zeros(size(HHHs,1))).^0.5,SS,ZZZZ_data.',TT_h,Pstar);clear er_DSGEins;for j=1:TT_h;er_DSGEins{j,1}=ZZZZ_data(presampl+j:end,:).'-ZZZZ_XF{j,1}(:,presampl:end-j);end;for i=1:size(ZZZZ_data,2);for j=1:TT_h;RMSE_DSGEins(i,j)=mean(er_DSGEins{j,1}(i,isfinite(er_DSGEins{j,1}(i,:))).^2,2).^0.5.';MAE_DSGEins(i,j)=median(er_DSGEins{j,1}(i,isfinite(er_DSGEins{j,1}(i,:))).^2,2).^0.5.';end;end;
    disp([min(RMSE_DSGE./RMSE_ARin,[],1);median(RMSE_DSGE./RMSE_ARin,1);mean(RMSE_DSGE./RMSE_ARin,1);max(RMSE_DSGE./RMSE_ARin,[],1)]);
@#endif



