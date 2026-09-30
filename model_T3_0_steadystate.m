function [ys, params, info] = model_T3_steadystate(ys_, exo_,M_,options)
%function [ys, params, info] = model_T2_NR_d5_steadystate(ys_, exo_,M_,options)


%function [ys, params, info] = model_S1_steadystate(ys_, exo_,M_,options)


%function [ys,check,fval]=model_B2_d5_steadystate(junk,ys)
%keyboard;
info=0;
for i=1:M_.param_nbr
    eval([deblank(M_.param_names{i,1}),'=M_.params(',num2str(i),');']);   
end
params=M_.params;


%20	nu0_rw	'(-1+gama_rw)*(-r_W+nu0_rw)'
%25	y_GDP	'exp(y_GDP)-exp(c_H)-exp(ex)+exp(im)'
%27	p_ex	'p_ex-p_C'
%7	limda_BF	'1-limda_BF'
%11	d_F	'd_F+exp(w_H+l_H)-exp(p_F+y_F)-tr_W'
%6	a_H	'exp(p_C+c_H)-exp(m_H-r_H)+exp(m_H)+a_H*exp(-r_H)+b_WH*exp(fx-r_W)+(-1+tax)*exp(w_H+l_H)-a_H*exp(-p-nu0_trY)-b_WH*exp(fx-p_W-nu0_trY)-tr_H'
%4	m_H	'exp(mu_M)*exp(m_H)^(1-omega_M)+limda_BH*(exp(m_H-r_H)-exp(m_H))'
%15	tr_H	'(-1+gama_tr)*(-tr_H+nu0_tr)'
%1	r_H	'limda_BH*(exp(bbb-p-nu0_trY)-exp(-r_H))'
%2	r_W	'limda_BH*(exp(bbb+fx-p_W-nu0_trY)-exp(fx-r_W))'
%12	y_F	'y_F-y_D'
%13	y_D	'y_F-nu0_YF-l_H+l_H*alfa_K'
%14	p	'(-1+gama_r)*(-r_H+nu0_r)'
%9	limda_PF	'exp(p_F+y_F)*limda_BF-limda_DF-limda_PF'
%8	limda_DF	'exp(p_F+y_F)*limda_BF-nu0_teta_F*limda_DF'
%5	w_H	'-exp(mu_L)*exp(l_H)^(1+omega_L)+(1-tax)*limda_BH*exp(w_H+l_H)'
%3	limda_BH	'exp(c_H-h*c_H)^(1-omega_C)-limda_BH*exp(p_C+c_H)'
%26	p_F	'exp(p_C*(1-teta_D))-exp(p_F*(1-teta_D))*w_d+(w_d-1)*exp(p_im*(1-teta_D))'
%24	y	'exp(y)-exp(c_H)-exp(ex)'
%23	p_C	'y_D+teta_D*(p_F-p_C)-y-log(w_d)'
%10	l_H	'-exp(w_H+l_H)*limda_BF+(1-alfa_K)*limda_PF'
%16	fx	'exp(p_ex+ex)-b_WH*exp(fx-r_W)+tr_W-exp(p_im+im)+b_WH*exp(fx-p_W-nu0_trY)'
%17	p_IM	 'p_im-fx*0-nu0_pim'
%21	p_W	'p_W-nu0_pw'
%19	ex	'(-1+gama_ex)*(-ex+nu0_ex)'
%22	im	'im+teta_D*(p_im-p_C)-y-log(1-w_d)'
%18	tr_W	'tr_W-nu0_trw'


nu0_ztemp_growth=nu0_trY;

tax=nu0_tax;
c_H=c_H_SS;
b_WH=b_WH_SS;

tr_W=nu0_trw;
QQQ(3)=log((-1+tax)*(-1+alfa_K)*(nu0_teta_F-1)*exp(-c_H*(-1+h))^(1-omega_C)/nu0_teta_F);
QQQ(6)=log(w_d*(exp(c_H)+exp(nu0_ex)));
QQQ(7)=log((-1+w_d)/(w_d-exp((1-teta_D)/(alfa_K*teta_D+1-alfa_K+omega_L*teta_D)*(omega_L*nu0_YF-c_H+nu0_YF-mu_L+c_H*alfa_K+mu_L*alfa_K+(-log((-1+tax)*(-1+alfa_K)*(nu0_teta_F-1)*exp(-c_H*(-1+h))^(1-omega_C)/nu0_teta_F)-log(w_d*(exp(c_H)+exp(nu0_ex))))*alfa_K-log(w_d*(exp(c_H)+exp(nu0_ex)))*omega_L+log((-1+tax)*(-1+alfa_K)*(nu0_teta_F-1)*exp(-c_H*(-1+h))^(1-omega_C)/nu0_teta_F)))));
im=(-omega_L*teta_D^2*(QQQ(7)+log(w_d)-log(1-w_d))-alfa_K*teta_D^2*(QQQ(7)+log(w_d)-log(1-w_d)+QQQ(3))-nu0_YF*teta_D-log(1-w_d)+alfa_K*teta_D*(QQQ(3)+2*log(w_d)-QQQ(6)-2*log(1-w_d)+QQQ(7))+c_H*teta_D+(-log(w_d)+QQQ(6)+log(1-w_d))*alfa_K+omega_L*teta_D*(log(w_d)-log(1-w_d))-teta_D*(log(w_d)+QQQ(3)-QQQ(6)-log(1-w_d)+QQQ(7))+nu0_YF*teta_D^2-c_H*teta_D*alfa_K-c_H*teta_D^2-QQQ(6)+teta_D^2*QQQ(3)+nu0_YF*teta_D^2*omega_L+alfa_K*teta_D^2*mu_L+alfa_K*teta_D^2*c_H-omega_L*teta_D*nu0_YF-mu_L*teta_D^2+mu_L*teta_D-mu_L*teta_D*alfa_K+log(w_d))/(-2*alfa_K*teta_D+alfa_K*teta_D^2-1+teta_D+alfa_K-omega_L*teta_D+omega_L*teta_D^2);
ex=nu0_ex;
p_W=nu0_pw;
p_im=nu0_pim;
QQQ(1)=exp(c_H)+exp(ex);
QQQ(2)=alfa_K*teta_D+1-alfa_K+omega_L*teta_D;
QQQ(4)=log(w_d*(exp(c_H)+exp(ex)))*omega_L;
QQQ(5)=log((-1+w_d)/(w_d-exp((1-teta_D)/(alfa_K*teta_D+1-alfa_K+omega_L*teta_D)*(omega_L*nu0_YF-c_H+nu0_YF-mu_L+c_H*alfa_K+mu_L*alfa_K-alfa_K*(log((-1+tax)*(-1+alfa_K)*(nu0_teta_F-1)*exp(-c_H*(-1+h))^(1-omega_C)/nu0_teta_F)+log(w_d*(exp(c_H)+exp(ex))))-log(w_d*(exp(c_H)+exp(ex)))*omega_L+log((-1+tax)*(-1+alfa_K)*(nu0_teta_F-1)*exp(-c_H*(-1+h))^(1-omega_C)/nu0_teta_F)))));
fx=p_W+nu0_trY+log((exp((-teta_D*p_im*omega_L+p_im*alfa_K+teta_D*QQQ(3)-2*teta_D*p_im*alfa_K+teta_D^2*p_im*omega_L+teta_D^2*p_im*alfa_K+QQQ(4)+nu0_YF*teta_D-nu0_YF+mu_L+ex*omega_L*teta_D^2-ex*omega_L*teta_D+ex*alfa_K*teta_D^2-c_H*teta_D+c_H*teta_D*alfa_K+ex*teta_D+(-QQQ(5)-QQQ(3)-log(w_d*QQQ(1)))*teta_D*alfa_K+alfa_K*(QQQ(5)+QQQ(3)+log(w_d*QQQ(1)))-omega_L*teta_D*(QQQ(5)+log(w_d*QQQ(1)))-c_H*alfa_K+c_H+teta_D*p_im-QQQ(3)-p_im+ex*alfa_K-2*ex*alfa_K*teta_D-omega_L*nu0_YF-mu_L*alfa_K+omega_L*teta_D*nu0_YF-ex-mu_L*teta_D+mu_L*teta_D*alfa_K-QQQ(5))/QQQ(2)/(-1+teta_D))+tr_W-exp(p_im+im))/b_WH/(exp(bbb)-1));
l_H=(-c_H*teta_D+nu0_YF*teta_D-mu_L*teta_D+teta_D*log((-1+tax)*(-1+alfa_K)*(nu0_teta_F-1)*exp(c_H*(1-h))^(1-omega_C)/nu0_teta_F)-nu0_YF+log(w_d*QQQ(1)))/QQQ(2);
p_C=-(nu0_YF-nu0_YF*teta_D+l_H-l_H*teta_D-l_H*alfa_K+l_H*alfa_K*teta_D-log(w_d*QQQ(1))+teta_D*(log(w_d*QQQ(1))+log((-1+w_d)/(w_d-exp((-1+teta_D)*(-nu0_YF-l_H+l_H*alfa_K+log(w_d*QQQ(1)))/teta_D))))+teta_D*p_im-teta_D^2*p_im)/teta_D/(-1+teta_D);
y=log(QQQ(1));
p_F=1/(1-teta_D)*log((exp(p_C*(1-teta_D))-exp(p_im*(1-teta_D))+exp(p_im*(1-teta_D))*w_d)/w_d);
limda_BH=exp(c_H-h*c_H)^(1-omega_C)/exp(p_C+c_H);
w_H=log(1/limda_BH/(1-tax))+l_H*omega_L+mu_L;
limda_DF=exp(p_F+nu0_YF+l_H-l_H*alfa_K)/nu0_teta_F;
limda_PF=exp(p_F+nu0_YF+l_H-l_H*alfa_K)-limda_DF;
p=bbb-nu0_trY+nu0_r;
y_D=nu0_YF+l_H-l_H*alfa_K;
y_F=y_D;
r_W=-bbb+p_W+nu0_trY;
r_H=-bbb+p+nu0_trY;
tr_H=nu0_tr;
m_H=(-log(limda_BH*(-1+exp(r_H)))+r_H+mu_M)/omega_M;
a_H=(exp(p_C+c_H)-exp(m_H-r_H)+exp(m_H)+b_WH*exp(fx-r_W)-exp(w_H+l_H)+exp(w_H+l_H)*tax-b_WH*exp(fx-p_W-nu0_trY)-tr_H)/(exp(-p-nu0_trY)-exp(-r_H));
d_F=-exp(w_H+l_H)+exp(p_F+y_F)+tr_W;
limda_BF=1;
p_ex=p_C;
y_GDP=log(exp(c_H)+exp(ex)-exp(im));
nu0_rw=r_W;


z_ex=nu0_ex;
z_pim=nu0_pim;
z_pw=nu0_pw;
z_r=nu0_r;
z_rw=nu0_rw;
z_teta_F=nu0_teta_F;
z_tr=nu0_tr;
z_trw=nu0_trw;
z_trY=nu0_trY;
z_YF=nu0_YF;
z_tax=nu0_tax;
z_r1=0;
z_r4=0;


z_ztemp_growth=nu0_ztemp_growth;

%zzobs_dY=+z_ztemp_growth;
%zzobs_RH=exp(r_H*12)*100-100;
%zzobs_dPC=p;

zzobs_dL=l_H-l_H;
zzobs_dPC=p;
zzobs_R1=r_H*12;	
zzobs_dSN=fx-fx+p-p_W;
zzobs_dSR=fx-fx;
zzobs_dY=y_GDP-y_GDP+z_ztemp_growth;


ys=[a_H,b_WH,c_H,d_F,ex,fx,im,l_H,limda_BF,limda_BH,limda_DF,limda_PF,m_H,p,p_C,p_ex,p_F,p_im,p_W,r_H,r_W,tax,tr_H,tr_W,w_H,y,y_D,y_F,y_GDP,z_ex,z_pim,z_pw,z_r,z_r1,z_r4,z_rw,z_tax,z_teta_F,z_tr,z_trw,z_trY,z_YF,z_ztemp_growth,zzobs_dL,zzobs_dPC,zzobs_R1,zzobs_dSN,zzobs_dSR,zzobs_dY].';
%ys=real(ys);
%keyboard;
if max(abs(imag(ys)))<1.0e-6
	ys=real(ys);
end
if isfield(M_,'aux_vars')
    for i=1:size(M_.aux_vars,2)
        ttt=strrep(M_.aux_vars(1,i).orig_expr,'(-1)','');
        eval([M_.endo_names{i+M_.orig_endo_nbr,1},'=',ttt,';']);%for aux using aux(large lags or exp)
        ys(end+1,1)=eval(ttt);
    end
end
    
%ys_i=(imag(ys))==0;
%ys=ys.*ys_i;
return





