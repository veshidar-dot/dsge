function [S,SF,XF,L,VAR_S]=var_unobserved_forecast2(F,Q,HH,Q_er,EX,X,vpered,Ess_1,Es_1)
%модель:
%S(t)=F*S(t-1)+Q*Er(t); 
%X(t)=EX(t)+HH*S(t)+Q_er*er(t)
%время вправо
%S(:,i)=E(S(i)|I(i)) - ожидание S в периоде, учитывая наблюдения данного и прошлого периодов
%SF -прогнозы с этих точек
%XF -прогнозы с этих же точек, но наблюдаемых переменных, с учетом константы 

%HHH=zeros(size(bayestopt_.mf,2),size(T,1));
%HHH(1:size(bayestopt_.mf,2),bayestopt_.mf)=1;
%[S,SF,XF]=var_unobserved_forecast2(T,R*(chol(Q).'),HHH,chol(H).',trend(:,1),data,4,Pstar);
%LIK = var_unobserved_likelihood_Integrated(T,R,Q,H,HHH,data,trend,start);

a=size(X,2);
%m=size(X,1);
n=size(F,1);
if nargin<9
    Es_1(1:n,1)=0;
end

%H=HH;
L=zeros(a,1);
S(1:n,1:a)=0;
VAR_S=zeros(n*n,a);
if nargin<8
    [Ess_1,D_inf]=ono_glucke(F,Q*(Q'));
else
    D_inf=0;
end
if D_inf==1
    S=-inf;
    SF=NaN;
    XF=NaN;
    XFVAR=NaN;    
    return
else
    VVV=Q*(Q');
    VVV_er_f=Q_er*(Q_er');
    %VVV_er=VVV_er_f;
    for i=1:a
        X_obs=X(:,i)-EX;            
        H_1=(isfinite(X_obs));
        H_2=diag(H_1);
        H_3=H_2(find(H_1==1),:);
        H=H_3*HH;
        VVV_er=H_3*VVV_er_f*(H_3.');
        X_obs=X_obs(find(H_1==1),1);
        m=sum(H_1);
        AAA=H*Ess_1*(H')+VVV_er;
        [cAAA,rAAA]=chol(AAA);%AAA=cAAA.'*cAAA;
        if rAAA==0%rank(AAA)==m
            
            %L(i,1)=-0.5*(X_obs-H*Es_1).'*AAA*(X_obs-H*Es_1);
            %L(i,1)=L(i,1)+0.5*log(det(AAA))-0.5*m*log(2*pi);
            icAAA=inv(cAAA);%AAA=inv(AAA);%iAAA=icAAA*icAAA.';
            icAx=icAAA.'*(X_obs-H*Es_1);
            L(i,1)=-0.5*(icAx.'*icAx);%L(i,1)=-0.5*(X_obs-H*Es_1).'*AAA*(X_obs-H*Es_1);
            L(i,1)=L(i,1)-0.5*sum(log(diag(cAAA)))*2-0.5*m*log(2*pi);%L(i,1)=L(i,1)+0.5*log(det(AAA))-0.5*m*log(2*pi);
            
            %начинаем пересчет ожидания и дисперсии
            %E(S-Es_1)*(X-Ex_1)'=E(S-Es_1)*(S-Es_1)'*H'+E(S-Es_1)*(Q_er*er)'=Ess_1*H'+0
            %Es_1(+1)=F*Es_0=F*Es_1+F*Ess_1*(H')*inv(Var(X-Ex_1))*(X-Ex_1)
            AA=Ess_1*((H')*(icAAA*icAAA.'));%Ess_1*((H')*AAA);
            S(:,i)=Es_1+AA*(X_obs-H*Es_1);            
            Es_1=F*(Es_1+AA*(X_obs-H*Es_1));
            %Es_0=Es_1+AA*(X-Ex_1)
            %(X-Ex_1)=(H*S-H*Es_1)+Q_er*er
            %s-Es_0=(I-AA*H)*(s-Es_1)-AA*Q_er*er
            [V,D]=svd(Ess_1);
            %VV=V*(eye(n)-AA*H);
            %Ess_0=VV*D*(VV.')+AA*VVV_er*(AA.');
            Ess_0=(eye(n)-AA*H)*Ess_1*((eye(n)-AA*H).')+AA*VVV_er*(AA.');
            %Ess_1=F*Ess_0*(F')+VVV;
            VV1=F*(eye(n)-AA*H)*V;
            VV2=F*AA;
            Ess_1=VV1*D*(VV1.')+VV2*VVV_er*VV2.'+VVV;
            VAR_S(:,i)=reshape(Ess_0,n*n,1);
    
        else
            SF=-inf;
            SF=NaN;
            XF=NaN;
            XFVAR=NaN;
            L(i:a,1)=-1.0e+8;
            return
        end
    end
end

DD=0;

%расчет прогноза
SF{1,1}=F*S;
%VAR(S(+1))=F*VAR(S)*F.'+VVV;
%vec(VAR(S(+1)))=kron(F,F)*vec(var(S))+vec(VVV);
if DD==1
    AA=kron(F,F);
    SF{1,2}=AA*VAR_S+reshape(VVV,n*n,1)*ones(1,a);
end

for i=2:vpered
    SF{i,1}=F*SF{i-1,1};
    if DD==1
        SF{i,2}=AA*SF{i-1,2}+reshape(VVV,n*n,1)*ones(1,a);
    end
end

%VAR(X)=HH*VAR(S)*HH.'+VVV_er_f
AA=kron(HH,HH);
for i=1:vpered
    XF{i,1}=EX*ones(1,a)+HH*SF{i,1};
    if DD==1
    
        XF{i,2}=AA*SF{i,2}+reshape(VVV_er_f,size(X,1)^2,1)*ones(1,a);    
    end
end


return




function [D,D_inf]=ono_glucke(F,Q)
%D=F*D*(F')+Q
n=size(Q,1);
FF=eye(n*n)-kron(F,F);
QQ=reshape(Q,n*n,1);

[U,S,V] = svd(FF);%FF = U*S*V'
%FF*X=QQ
%S*V'*X=U'*QQ
%V'*X=inv(S)*U'*QQ
QQQ=U.'*QQ;

I=find(diag(S)<10^-15);
II=find(diag(S)>10^-15);
D_inf=0;

DD(II,1)=QQQ(II,1)./diag(S(II,II));
DD(I,1)=0;
DD=V*DD;
%DD=V*(QQQ./diag(S));
D=reshape(DD,n,n);
[U,S,V] = svd(D);
U=(U+V)*0.5;
V=U;
D=U*S*V';
return








