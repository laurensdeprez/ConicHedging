close all;
%% conic delta hedging under VG stock model

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
lambda = 0.10;                   % parameter for distortion               
delta_range = [-2,2];            % [delta_min, delta_max]
delta_precision = 0.01;          % step between deltas
option = 'call';                 % type of option considered

S_T = VG_stock(S_0,q,s,v,th,r,T,N);

%% bid
[bid,bids,delta_b,deltas] = bid_B_S(S_0,S_T,r,T,N,K,option,dist_type,lambda,delta_range,delta_precision);
[u_bid,~,~,~] = bid_B_S(S_0,S_T,r,T,N,K,option,dist_type,lambda,delta_range,delta_precision,'hedged',false);
display(delta_b)
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
[u_ask,~,~,~] = ask_B_S(S_0,S_T,r,T,N,K,option,dist_type,lambda,delta_range,delta_precision,'hedged',false);
display(delta_a)
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
plot(deltas,capital,'LineWidth',2)
hold on 
plot(deltas, u_cap*ones(1,length(deltas)) ,'b--','LineWidth',2)
xlabel('\Delta','FontSize',15)
ylabel('capital portfolio','FontSize',15)
leg = legend('\Delta hedged','unhedged');
set(gca,'fontsize',12)
set(leg,'fontsize',12)
