%% Dynamic Hedging
close all;
%% Multinomial Tree 
optimize = false;
T = 1;                      % maturity (in years)
S_0 = 100;                  % init stock value
r = 0.02;                   % risk-free interest
K = [110,120];              % call spread strikes
option = 'callspread';      % option type
s = 0.2;                    % VG process parameters
v = 0.75;
th = -0.3;
[C_VG,G_VG,M_VG] = VG_param(s,v,th);
dist = 'MinMaxVar';         % distortion type
lambda = 0.15;             % distortion parameter
M = 10;                     % 2M+1-nomial approximation
N = 50;
delta = 0.0763;             % jump size 
p0 = 0.9492;                % jump zero probability 
if optimize
    x0 = [0.07,0.9];    
    x = fit_multinomial_VG(M,N,C_VG,G_VG,M_VG,x0);
    delta = x(1);
    p0 = x(2);
    disp(x)
end

[S,f] = bid_N_tree(S_0,r,delta,p0,M,N,C_VG,G_VG,M_VG,T,K,option,'delta_precision',0.1);
% plot
% figure()
% plot(S,1:length(S))
figure()
plot(S,f(:,1,1))
hold on
plot(S,f(:,end,1),'k')
plot(S,f(:,floor(end/2),1),'r')
plot(S,f(:,floor(end/12),1),'g')
% plot(S,f(:,end,2),'k--')
% plot(S,f(:,floor(end/2),2),'r--')
% plot(S,f(:,floor(end/12),2),'g--')
% legend('call spread payoff','unhedged bid (1y)','unhedged bid (6m)','unhedged bid (1m)','hedged bid (1y)','hedged bid (6m)','hedged bid (1m)')