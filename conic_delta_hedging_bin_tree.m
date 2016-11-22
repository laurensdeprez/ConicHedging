%% conic delta hedging in binomial tree
S_0 = 100;                      % init. stock price
u = 1.2;                        % up state
d = 0.8;                        % down state
r = 0.01;                       % interest
T = 1;                          % maturity
K = S_0;                        % strike ATM
delta_range = [-2,2];           % [delta_min, delta_max]
delta_precision = 0.001;        % step between deltas
type = 'call';                  % option type

%% risk neutral
f_u = payoff(u*S_0,K,type);         % option payout up
f_d = payoff(d*S_0,K,type);         % option payout down

delta_tree = (f_u-f_d)/(S_0*(u-d));

%% bid
[bid,bids,delta,deltas] = bid_bin_tree(S_0,u,d,r,T,K,type,delta_range,delta_precision);

figure()
plot(deltas, bids)
hold on
scatter(delta,bid,'b')
scatter(-delta_tree,bid,100,'r')
xlabel('delta')
ylabel('bid portfolio')
legend('\Delta line','\Delta_{opt}','-\Delta_{tree}')

%% ask
[ask,asks,delta,deltas] = ask_bin_tree(S_0,u,d,r,T,K,type,delta_range,delta_precision);

figure()
plot(deltas, asks)
hold on
scatter(delta,ask,'b')
scatter(-delta_tree,ask,100,'r')
xlabel('delta')
ylabel('ask portfolio')
legend('\Delta line','\Delta_{opt}','-\Delta_{tree}')

%% capital
