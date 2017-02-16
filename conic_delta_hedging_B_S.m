close all;
%% conic delta hedging under B-S

S_0 = 100;                       % init. stock price
q = 0;                           % dividend 
s = 0.2;                         % volatility
r = 0.01;                        % interest
T = 1/12;                        % maturity
K = S_0;                         % strike ATM
N = 10000;                       % # monte carlo simulations (WARNING: bigger=slower)
dist_type = 'MinMaxVar';         % distortion function
lambda = 0.10;                   % parameter for distortion               
delta_range = [-2,2];            % [delta_min, delta_max]
delta_precision = 0.01;          % step between deltas
option = 'call';                 % type of option considered
different_strikes = 0;

S_T = B_S(S_0,q,s,r,T,N);

%% risk neutral
% call option
price = risk_neutral_EC_B_S(S_0,s,q,r,T,K);

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

if different_strikes
%% different strikes
K = linspace(85,115,60);            % strikes
delta_bid = zeros(length(K),1);     % delta bid
delta_ask = zeros(length(K),1);     % delta ask
delta_capital = zeros(length(K),1); % delta capital
for j=1:length(K)
    [bid,bids,delta_bid(j),~] = bid_B_S(S_0,S_T,r,T,N,K(j),option,dist_type,lambda,delta_range,delta_precision);
    [ask,asks,delta_ask(j),deltas] = ask_B_S(S_0,S_T,r,T,N,K(j),option,dist_type,lambda,delta_range,delta_precision);
    [M,I]= min(asks-bids);
    delta_capital(j) = deltas(I);
end
d1 = B_S_d1(S_0,q,s,r,T,K);
figure()
plot(K,delta_bid,'LineWidth',2)
hold on
plot(K,delta_ask,'LineWidth',2)
plot(K,delta_capital,'LineWidth',2)
plot(K,-normcdf(d1),'LineWidth',2)
xlabel('K','FontSize',15)
ylabel('\Delta','FontSize',15)
leg = legend('\Delta_{bid}','\Delta_{ask}','\Delta_{capital}','-\Delta_{B-S}');
set(gca,'fontsize',12)
set(leg,'fontsize',12)
end

