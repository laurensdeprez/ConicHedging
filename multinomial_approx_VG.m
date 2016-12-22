close all;
%% Multinomial approximation of VG process
M = 10;         % 2M+1 nomial tree
N = 50;         % time steps
delta = 0.01;   % jump size
p = 0.3;        % probability for level 0
s = 0.2;        
v = 0.75;
th = -0.3;
[C_VG,G_VG,M_VG] = VG_param(s,v,th);

U = linspace(-20,20,1000);
phis = char_function_multinomial(M,U,delta,p,N,C_VG,G_VG,M_VG);
phis_VG = char_function_VG(U,C_VG,G_VG,M_VG);

figure()
plot(U,real(phis))
hold on 
plot(U,real(phis_VG))
axis([-20,20,-0.2,1.2])
legend('multinomial','VG')
title(['p = ',num2str(p),' en delta = ',num2str(delta)])
figure()
plot(U,imag(phis))
hold on
plot(U,imag(phis_VG))
axis([-20,20,-0.8,0.8])
legend('multinomial','VG')
title(['p = ',num2str(p),' en delta = ',num2str(delta)])


%% optimize
if true
x0 = [0.07,0.9];
x = fit_multinomial_VG(M,N,C_VG,G_VG,M_VG,x0);
delta = x(1);
p = x(2);
disp(x)

phis = char_function_multinomial(M,U,delta,p,N,C_VG,G_VG,M_VG);

figure()
plot(U,real(phis),'LineWidth',2)
hold on 
plot(U,real(phis_VG),'LineWidth',2)
axis([-20,20,-0.2,1.2])
title(['p = ',num2str(p),' en delta = ',num2str(delta)])
leg = legend('multinomial','VG');
set(leg,'FontSize',12)
figure()
plot(U,imag(phis),'LineWidth',2)
hold on
plot(U,imag(phis_VG),'LineWidth',2)
axis([-20,20,-0.5,0.5])
leg = legend('multinomial','VG');
set(leg,'FontSize',12)
title(['p = ',num2str(p),' en delta = ',num2str(delta)])
end