% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

clear;
close all;

%% Dynamic Hedging: Multinomial Tree approx. of VG stock process
optimize = false;
T = 1;                      % maturity (in years)
S_0 = 100;                  % init stock value
r = 0.02;                   % risk-free interest
K = S_0;%[110,120];              % call spread strikes
option = 'straddle';%'callspread';      % option type
s = 0.2;                    % VG process parameters
v = 0.75;
th = -0.3;
dist = 'MinMaxVar';         % distortion type
lambda = 0.015;             % distortion parameter
M = 10;                     % 2M+1-nomial approximation
N = 50;
delta = 0.0740;             % jump size 
p0 = 0.9407;                % jump zero probability 
if optimize
    x0 = [0.07,0.9];    
    x = fit_multinomial_VG(M,N,C_VG,G_VG,M_VG,x0);
    delta = x(1);
    p0 = x(2);
    disp(x)
end
if false
% bid
[S,f_bid,Delta_b,deltas_b] = bid_N_tree(S_0,r,delta,p0,M,N,s,v,th,T,K,option,'delta_precision',0.05,'delta_range',[-2,0]);
figure()
plot(S,f_bid(:,1,1),'k','LineWidth',2)
hold on
plot(S,f_bid(:,end,1),'b','LineWidth',2)
plot(S,f_bid(:,floor(end/2),1),'g','LineWidth',2)
plot(S,f_bid(:,floor(end/12),1),'r','LineWidth',2)
plot(S,f_bid(:,end,2),'b:','LineWidth',2)
plot(S,f_bid(:,floor(end/2),2),'g:','LineWidth',2)
plot(S,f_bid(:,floor(end/12),2),'r:','LineWidth',2)
axis([70 150 0 10.5])
xlabel('Stock price','FontSize',15)
ylabel('bid price','FontSize',15)
leg = legend('call spread payoff','unhedged bid (1y)','unhedged bid (6m)','unhedged bid (1m)','hedged bid (1y)','hedged bid (6m)','hedged bid (1m)');
set(gca,'fontsize',12)
set(leg,'fontsize',12)
end
% ask
if false
[S,f_ask, Delta_a,deltas_a] = ask_N_tree(S_0,r,delta,p0,M,N,s,v,th,T,K,option,'delta_precision',0.05,'delta_range',[-2,0]);
figure()
plot(S,f_ask(:,1,1),'k','LineWidth',2)
hold on
plot(S,f_ask(:,end,1),'b','LineWidth',2)
plot(S,f_ask(:,floor(end/2),1),'g','LineWidth',2)
plot(S,f_ask(:,floor(end/12),1),'r','LineWidth',2)
plot(S,f_ask(:,end,2),'b:','LineWidth',2)
plot(S,f_ask(:,floor(end/2),2),'g:','LineWidth',2)
plot(S,f_ask(:,floor(end/12),2),'r:','LineWidth',2)
axis([70 150 0 10.5])
xlabel('Stock price','FontSize',15)
ylabel('ask price','FontSize',15)
leg = legend('call spread payoff','unhedged ask (1y)','unhedged ask (6m)','unhedged ask (1m)','hedged ask (1y)','hedged ask (6m)','hedged ask (1m)');
set(gca,'fontsize',12)
set(leg,'fontsize',12)
end
if false
% bid-ask spread
figure()
plot(S,f_ask(:,end,1)-f_bid(:,end,1),'b','LineWidth',2)
hold on
plot(S,f_ask(:,floor(end/2),1)-f_bid(:,floor(end/2),1),'g','LineWidth',2)
plot(S,f_ask(:,floor(end/12),1)-f_bid(:,floor(end/12),1),'r','LineWidth',2)
plot(S,f_ask(:,end,2)-f_bid(:,end,2),'b:','LineWidth',2)
plot(S,f_ask(:,floor(end/2),2)-f_bid(:,floor(end/2),2),'g:','LineWidth',2)
plot(S,f_ask(:,floor(end/12),2)-f_bid(:,floor(end/12),2),'r:','LineWidth',2)
%axis([70 150 0 1])
xlabel('Stock price','FontSize',15)
ylabel('abs. bid-ask spread','FontSize',15)
leg = legend('unhedged ask (1y)','unhedged ask (6m)','unhedged ask (1m)','hedged ask (1y)','hedged ask (6m)','hedged ask (1m)');
set(gca,'fontsize',12)
set(leg,'fontsize',12)
end


if true
[S,f_cap, Delta_cap,deltas_cap] = capital_N_tree(S_0,r,delta,p0,M,N,s,v,th,T,K,option,'delta_precision',0.05,'delta_range',[-2,1]);
% bid figure
figure()
plot(S,f_cap(:,1,1),'k','LineWidth',2)
hold on
plot(S,f_cap(:,end,1),'b','LineWidth',2)
plot(S,f_cap(:,floor(end/2),1),'g','LineWidth',2)
plot(S,f_cap(:,floor(end/12),1),'r','LineWidth',2)
plot(S,f_cap(:,end,4),'b:','LineWidth',2)
plot(S,f_cap(:,floor(end/2),4),'g:','LineWidth',2)
plot(S,f_cap(:,floor(end/12),4),'r:','LineWidth',2)
%axis([70 150 0 10.5])
xlabel('Stock price','FontSize',15)
ylabel('bid price','FontSize',15)
leg = legend('call spread payoff','unhedged bid (1y)','unhedged bid (6m)','unhedged bid (1m)','hedged bid (1y)','hedged bid (6m)','hedged bid (1m)');
set(gca,'fontsize',12)
set(leg,'fontsize',12)
% ask figure
figure()
plot(S,f_cap(:,1,2),'k','LineWidth',2)
hold on
plot(S,f_cap(:,end,2),'b','LineWidth',2)
plot(S,f_cap(:,floor(end/2),2),'g','LineWidth',2)
plot(S,f_cap(:,floor(end/12),2),'r','LineWidth',2)
plot(S,f_cap(:,end,5),'b:','LineWidth',2)
plot(S,f_cap(:,floor(end/2),5),'g:','LineWidth',2)
plot(S,f_cap(:,floor(end/12),5),'r:','LineWidth',2)
%axis([70 150 0 10.5])
xlabel('Stock price','FontSize',15)
ylabel('ask price','FontSize',15)
leg = legend('call spread payoff','unhedged ask (1y)','unhedged ask (6m)','unhedged ask (1m)','hedged ask (1y)','hedged ask (6m)','hedged ask (1m)');
set(gca,'fontsize',12)
set(leg,'fontsize',12)
% capital figure
figure()
plot(S,f_cap(:,end,3),'b','LineWidth',2)
hold on
plot(S,f_cap(:,floor(end/2),3),'g','LineWidth',2)
plot(S,f_cap(:,floor(end/12),3),'r','LineWidth',2)
plot(S,f_cap(:,end,6),'b:','LineWidth',2)
plot(S,f_cap(:,floor(end/2),6),'g:','LineWidth',2)
plot(S,f_cap(:,floor(end/12),6),'r:','LineWidth',2)
plot(S,f_cap(:,end,7),'b--','LineWidth',2)
plot(S,f_cap(:,floor(end/2),7),'g--','LineWidth',2)
plot(S,f_cap(:,floor(end/12),7),'r--','LineWidth',2)
xlabel('Stock price','FontSize',15)
ylabel('spread','FontSize',15)
leg = legend('unhedged (1y)','unhedged (6m)','unhedged (1m)','hedged (1y)','hedged (6m)','hedged (1m)','cap. hedged (1y)','cap. hedged (6m)','cap. hedged (1m)');
set(gca,'fontsize',12)
set(leg,'fontsize',12)
end