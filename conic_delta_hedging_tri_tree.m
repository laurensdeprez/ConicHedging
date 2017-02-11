%% conic delta hedging in trinomial tree
S_0 = 100;                       % init. stock price
s = 0.2;                         % volatility
r = 0.01;                        % interest
T = 1;                           % maturity
K = S_0;                         % strike ATM
delta_range = [-2,2];            % [delta_min, delta_max]
delta_precision = 0.001;         % step between deltas
option_type = 'call';            % option type

%% risk neutral
price = risk_neutral_tri(S_0,s,r,T,K,option_type);

%% bid
[~,bids,delta_bid,deltas] = bid_tri_tree(S_0,s,r,T,K,option_type,delta_range,delta_precision);

figure()
plot(deltas, bids,'LineWidth',2)
xlabel('\Delta','FontSize',15)
ylabel('bid portfolio','FontSize',15)
set(gca,'fontsize',12)

%% ask
[~,asks,delta_ask,deltas] = ask_tri_tree(S_0,s,r,T,K,option_type,delta_range,delta_precision);

figure()
plot(deltas, asks,'LineWidth',2)
xlabel('\Delta','FontSize',15)
ylabel('ask portfolio','FontSize',15)
set(gca,'fontsize',12)

%% unhedged bid and ask
[bid,~,~,~] = bid_tri_tree(S_0,s,r,T,K,option_type,delta_range,delta_precision,'hedged',false);

[ask,~,~,~] = ask_tri_tree(S_0,s,r,T,K,option_type,delta_range,delta_precision,'hedged',false);
