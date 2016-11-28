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

[p_j,q_j] = cond_prob_multinomial(M,delta,C_VG,G_VG,M_VG);

U = linspace(-20,20,1000);
phis = char_function_multinomial(M,U,delta,p,p_j,q_j,N);
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
fun = @(u,x)(abs(char_function_VG(u,C_VG,G_VG,M_VG)-char_function_multinomial(M,u,x(1),x(2),p_j,q_j,N)));
fun2 = @(x)(integral(@(u)fun(u,x), -20, 20,'ArrayValued',true));
x0 = [0.0740,0.9407];
x = fminunc(fun2,x0);
delta = x(1);
p = x(2);

phis = char_function_multinomial(M,U,delta,p,p_j,q_j,N);

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