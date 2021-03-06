% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

close all;
clear;

%% conic delta hedging under Variance-Gamma stock model
S_0 = 100;                       % init. stock price
q = 0;                           % dividend 
s = 0.2;                         % volatility
v = 0.75;                        % param 2 of VG
th = -0.3;                       % param 3 of VG
r = 0.01;                        % interest
T = 1/12;                        % maturity
K = S_0;                         % strike ATM
N = 10000;                       % # monte carlo simulations (WARNING: bigger=slower)
dist_type = 'MinMaxVar';         % distortion function
lambda = 0.25;                   % parameter for distortion               
delta_range = [-2,0];            % [delta_min, delta_max]
delta_precision = 0.05;          % step between deltas
option = 'call';                 % type of option considered
different_strikes = 1;           % hedging for different strikes (0 = False, 1 = True)

%% stock process
S_T = VG_stock(S_0,q,s,v,th,r,T,N);

%% risk free
% call option
price = exp(-r*T)*sum(payoff(S_T,K,option))/N;
disp(['risk neutral price (MC)',num2str(price)])
[price,k,C] = risk_neutral_EC_VG(S_0,s,v,th,r,T,K);
disp(['risk neutral price ',num2str(price)])
delta_VG = risk_neutral_EC_VG_delta(S_0,s,v,th,r,T,K);
disp(['risk neutral delta ',num2str(delta_VG)])
%% bid
[bid,bids,delta_b,deltas] = bid_B_S(S_0,S_T,r,T,N,K,option,dist_type,lambda,delta_range,delta_precision);
disp(['bid (d) ',num2str(bid)])
disp(['bid delta (d) ',num2str(delta_b)])
[u_bid,~,~,~] = bid_B_S(S_0,S_T,r,T,N,K,option,dist_type,lambda,delta_range,delta_precision,'hedged',false);
disp(['bid ',num2str(u_bid)])
figure()
plot(deltas, bids,'LineWidth',2)
hold on 
plot(deltas, u_bid*ones(1,length(deltas)) ,'b--','LineWidth',2)
xlabel('\Delta','FontSize',15)
ylabel('bid portfolio','FontSize',15)
leg = legend('\Delta hedged','unhedged');
set(gca,'fontsize',12)
set(leg,'fontsize',12)

%% ask 
[ask,asks,delta_a,deltas] = ask_B_S(S_0,S_T,r,T,N,K,option,dist_type,lambda,delta_range,delta_precision);
disp(['ask (d) ',num2str(ask)])
disp(['ask delta (d) ',num2str(delta_a)])
[u_ask,~,~,~] = ask_B_S(S_0,S_T,r,T,N,K,option,dist_type,lambda,delta_range,delta_precision,'hedged',false);
disp(['ask ',num2str(u_ask)])
figure()
plot(deltas, asks,'LineWidth',2)
hold on 
plot(deltas, u_ask*ones(1,length(deltas)) ,'b--','LineWidth',2)
xlabel('\Delta','FontSize',15)
ylabel('ask portfolio','FontSize',15)
leg = legend('\Delta hedged','unhedged');
set(gca,'fontsize',12)
set(leg,'fontsize',12)

%% capital 
figure();
capital = asks-bids;
u_cap = u_ask-u_bid;
[M,I] = min(capital);
disp(['capital (d) ',num2str(M)])
disp(['capital delta (d) ',num2str(deltas(I))])
plot(deltas,capital,'LineWidth',2)
hold on 
plot(deltas, (ask-bid)*ones(1,length(deltas)) ,'r--','LineWidth',2)
plot(deltas, u_cap*ones(1,length(deltas)) ,'b--','LineWidth',2)
xlabel('\Delta','FontSize',15)
ylabel('capital portfolio','FontSize',15)
leg = legend('\Delta hedged','ask-bid','unhedged');
set(gca,'fontsize',12)
set(leg,'fontsize',12)

if different_strikes
%% different strikes
K = linspace(85,115,120);           % strikes
delta_bid = zeros(length(K),1);     % delta bid
delta_ask = zeros(length(K),1);     % delta ask
delta_capital = zeros(length(K),1); % delta capital
for j=1:length(K)
    [bid,bids,delta_bid(j),~] = bid_B_S(S_0,S_T,r,T,N,K(j),option,dist_type,lambda,delta_range,delta_precision);
    [ask,asks,delta_ask(j),deltas] = ask_B_S(S_0,S_T,r,T,N,K(j),option,dist_type,lambda,delta_range,delta_precision);
    [M,I]= min(asks-bids);
    delta_capital(j) = deltas(I);
end
K1 = linspace(85,115,30);           
delta_VG = risk_neutral_EC_VG_delta(S_0,s,v,th,r,T,K1);
figure()
plot(K,delta_bid,'LineWidth',2)
hold on
plot(K,delta_ask,'LineWidth',2)
plot(K,delta_capital,'LineWidth',2)
plot(K1,-delta_VG,'LineWidth',2)
xlabel('K','FontSize',15)
ylabel('\Delta','FontSize',15)
leg = legend('\Delta_{bid}','\Delta_{ask}','\Delta_{capital}','-\Delta_{VG}');
set(gca,'fontsize',12)
set(leg,'fontsize',12)
end

if false
%% stock process
% exact
[C_VG,G_VG,M_VG] = VG_param(s,v,th);
dt = 0.02;
steps = 50;
N_samples = 100;
t = linspace(0,steps*dt,steps+1);
X_t = zeros([steps+1,N_samples]);
figure()
for i=1:(N_samples)
    Xs = gamrnd(dt*C_VG,1/M_VG,[steps,1]);
    Ys = gamrnd(dt*C_VG,1/G_VG,[steps,1]);
    X_t(:,i) = [0; cumsum(Xs-Ys)];
    if (i<=20)
        plot(t,X_t(:,i));
    end
    hold on
end
S = mean(X_t,2);
plot(t,S,'LineWidth',2,'Color','r')
xlabel('t','FontSize',15)
ylabel('X_t','FontSize',15)
set(gca,'fontsize',12)
figure()
omega = 1/v*log(1-s^2/2*v-th*v);
S_t = zeros(steps+1,N_samples);
for i=1:N_samples
    S_t(:,i) = S_0*exp(X_t(:,i)+(r+omega)*transpose(t));
    if (i<=20)
        plot(t,S_t(:,i))
    end
    hold on
end
S = mean(S_t,2);
plot(t,S,'LineWidth',2,'Color','r')
xlabel('t','FontSize',15)
ylabel('S_t','FontSize',15)
set(gca,'fontsize',12)
display(S(steps)-S(1))

% 2M+1 tree approx
M = 10;
delta = 0.0763;
p0 = 0.9492;
ps = cond_prob_multinomial(M,delta,C_VG,G_VG,M_VG);
p_j = ps(1,:);
q_j = ps(2,:);
ps = [(1-p0)*p_j,p0,(1-p0)*q_j];
cdf = cumsum(ps);
x = -(1:M)*delta;
y = (1:M)*delta;
jumps = [x 0 y];
path = zeros(N);
X_t = zeros(steps+1,N_samples);
jump = zeros(steps,1);
indices = 1:(2*M+1);
figure()
for i=1:N_samples
    p = rand(1,steps);
    for j=1:steps
        index = min(indices(cdf >= p(j)));
        jump(j) = jumps(index);
    end
    path = cumsum(jump);
    X_t(:,i) = [0 ; path];
    if (i < 20)
        plot(t, X_t(:,i))
    end
    hold on
end
S = mean(X_t,2);
plot(t,S,'LineWidth',2,'Color','r')
xlabel('t','FontSize',15)
ylabel('X_t','FontSize',15)
set(gca,'fontsize',12)
figure()
S_t = zeros(steps+1,N_samples);
for i=1:N_samples
    S_t(:,i) = S_0*exp(X_t(:,i)+(r+omega)*transpose(t));
    if (i<=20)
        plot(t,S_t(:,i))
    end
    hold on
end
S = mean(S_t,2);
plot(t,S,'LineWidth',2,'Color','r')
xlabel('t','FontSize',15)
ylabel('S_t','FontSize',15)
set(gca,'fontsize',12)
display(S(steps)-S(1))
end