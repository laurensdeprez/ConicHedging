%% conic delta hedging in trinomial tree

S_0 = 100;                       % init. stock price
s = 0.2;                         % volatility
r = 0.01;                        % interest
T = 1;                           % maturity
K = S_0;                         % strike ATM
delta_range = [-2,2];            % [delta_min, delta_max]
delta_precision = 0.001;         % step between deltas
option_type = 'call';            % option type
%% bid

[bid,bids,delta,deltas] = bid_tri_tree(S_0,s,r,T,K,option_type,delta_range,delta_precision);

figure()
plot(deltas, bids)
hold on
scatter(delta,bid,'b')
xlabel('delta')
ylabel('bid portfolio')

%% ask

[ask,asks,delta,deltas] = ask_tri_tree(S_0,s,r,T,K,option_type,delta_range,delta_precision);

figure()
plot(deltas, asks)
hold on
scatter(delta,ask,'b')
xlabel('delta')
ylabel('ask portfolio')
