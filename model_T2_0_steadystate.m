function [ys, params, info] = model_T2_0_steadystate(ys_, exo_,M_,options)
%function [ys, params, info] = model_T2_0_steadystate(ys_, exo_,M_,options)


%function [ys,check,fval]=model_B2_d5_steadystate(junk,ys)
%keyboard;
info=0;
for i=1:M_.param_nbr
    eval([deblank(M_.param_names{i,1}),'=M_.params(',num2str(i),');']);   
end
params=M_.params;


nu0_ztemp_growth=nu0_trY;

%how it is solved:
%16	p_C	'p_C'
%17	p_F	'p_F'
%6	limda_BF	'1-limda_BF'
%10	d_F	'd_F+exp(w_H+l_H)-exp(p_F+y_F)'
%5	a_H	'exp(p_C+c_H)-exp(m_H-r_H)+exp(m_H)+a_H*exp(-r_H)+(-1+tax)*exp(w_H+l_H)-a_H*exp(-p-nu0_trY)-tr_H'
%3	m_H	'exp(mu_M)*exp(m_H)^(1-omega_M)+(exp(m_H-r_H)-exp(m_H))*limda_BH'
%14	tr_H	'(1-gama_tr)*(tr_H-nu0_tr)'
%1	r_H	'limda_BH*(exp(bbb-p-nu0_trY)-exp(-r_H))'
%11	y_F	'y_F-y_D'
%12	y_D	'y_F-nu0_YF-l_H+l_H*alfa_K'
%13	p	'(1-gama_r)*(r_H-nu0_R)'
%8	limda_PF	'exp(p_F+y_F)*limda_BF-limda_DF-limda_PF'
%7	limda_DF	'exp(p_F+y_F)*limda_BF-nu0_teta_F*limda_DF'
%4	w_H	'-exp(mu_L)*exp(l_H)^(1+omega_L)+(1-tax)*limda_BH*exp(w_H+l_H)'
%2	limda_BH	'exp(c_H-h*c_H)^(1-omega_C)-limda_BH*exp(p_C+c_H)'
%15	c_H	'exp(y_D)-exp(c_H)'
%9	l_H	'-exp(w_H+l_H)*limda_BF+(1-alfa_K)*limda_PF'



l_H=(nu0_YF-omega_C*nu0_YF-h*nu0_YF+h*omega_C*nu0_YF+log((-1+tax)*(-1+alfa_K)*(nu0_teta_F-1)/nu0_teta_F)-mu_L)/(alfa_K+omega_C-omega_C*alfa_K+h-h*alfa_K-h*omega_C+h*omega_C*alfa_K+omega_L);
QQQ(2)=nu0_YF+l_H-l_H*alfa_K;
c_H=QQQ(2);
limda_BH=exp(c_H-h*c_H)^(1-omega_C)/exp(c_H);
w_H=log(1/limda_BH/(1-tax))+mu_L+l_H*omega_L;
limda_DF=exp(QQQ(2))/nu0_teta_F;
limda_PF=exp(QQQ(2))-limda_DF;
p=bbb-nu0_trY+nu0_R;
y_D=QQQ(2);
y_F=y_D;
r_H=-bbb+p+nu0_trY;
tr_H=nu0_tr;
m_H=(-log(limda_BH*(-1+exp(r_H)))+r_H+mu_M)/omega_M;
a_H=-(exp(c_H)-exp(m_H-r_H)+exp(m_H)-exp(w_H+l_H)+exp(w_H+l_H)*tax-tr_H)/(exp(-r_H)-exp(-p-nu0_trY));
d_F=-exp(w_H+l_H)+exp(y_F);
limda_BF=1;
p_F=0;
%QQQ(1)=nu0_YF+l_H-l_H*alfa_K;
p_C=0;


z_R=nu0_R;
z_YF=nu0_YF;
z_teta_F=nu0_teta_F;
z_tr=nu0_tr;
z_trY=nu0_trY;

z_ztemp_growth=nu0_ztemp_growth;

zzobs_dY=+z_ztemp_growth;
zzobs_RH=exp(r_H*12)*100-100;
zzobs_dPC=p;


ys=[a_H,c_H,d_F,l_H,limda_BF,limda_BH,limda_DF,limda_PF,m_H,p,p_C,p_F,r_H,tr_H,w_H,y_D,y_F,z_R,z_YF,z_teta_F,z_tr,z_trY,z_ztemp_growth,zzobs_dPC,zzobs_dY,zzobs_RH].';
%ys=real(ys);
%keyboard;
if max(abs(imag(ys)))<1.0e-6
	ys=real(ys);
end
if isfield(M_,'aux_vars')
    for i=1:size(M_.aux_vars,2)
        ttt=strrep(M_.aux_vars(1,i).orig_expr,'(-1)','');
        ys(end+1,1)=eval(ttt);
    end
end
    
%ys_i=(imag(ys))==0;
%ys=ys.*ys_i;
return





