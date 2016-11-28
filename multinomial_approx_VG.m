close all;
%% Multinomial approximation of VG process
M = 10;         % 2M+1 nomial tree
N = 50;         % time steps
delta = 0.01;   % jump size
p = 0.3;        % probability for level 0
s = 0.2;        
v = 0.75;
th = -0.3;
C_VG = 1/v;
G_VG = 1/(sqrt(th^2*v^2/4+s^2*v/2)-th*v/2);
M_VG = 1/(sqrt(th^2*v^2/4+s^2*v/2)+th*v/2);

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
x0 = [0.0740,0.9407];%[delta,p];%
x = fit_multinomial_VG(M,N,C_VG,G_VG,M_VG,x0);
delta = x(1);
p = x(2);
disp(x)


phis = char_function_multinomial(M,u,delta,p,N,C_VG,G_VG,M_VG);

figure()
plot(U,real(phis))
hold on 
plot(U,real(phis_VG))
axis([-20,20,-0.2,1.2])
title(['p = ',num2str(p),' en delta = ',num2str(delta)])
legend('multinomial','VG')
figure()
plot(U,imag(phis))
hold on
plot(U,imag(phis_VG))
axis([-20,20,-0.5,0.5])
legend('multinomial','VG')
title(['p = ',num2str(p),' en delta = ',num2str(delta)])