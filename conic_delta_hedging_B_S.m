close all;
%% conic delta hedging under B-S

S_0 = 100;                       % init. stock price
q = 0;                           % trend 
s = 0.2;                         % volatility
r = 0.01;                        % interest
T = 1/12;                        % maturity
K = 100;                         % strike ATM
N = 10000;                       % # monte carlo simulations (WARNING: bigger=slower)
dist_type = 'MinMaxVar';         % distortion function
lambda = 0.25;                   % parameter for distortion               
delta_range = [-2,2];            % [delta_min, delta_max]
delta_precision = 0.01;          % step between deltas
option_type = 'call';            % type of option considered
different_strikes = 1;
%% bid

[bid,bids,delta,deltas] = bid_B_S(S_0,q,s,r,T,N,K,option_type,delta_range,delta_precision,dist_type,lambda);

figure()
plot(deltas, bids)
hold on
scatter(delta,bid,'b')
xlabel('delta')
ylabel('bid portfolio')

%% ask 
[ask,asks,delta,deltas] = ask_B_S(S_0,q,s,r,T,N,K,option_type,delta_range,delta_precision,dist_type,lambda);

figure()
plot(deltas, asks)
hold on
scatter(delta,ask,'b')
xlabel('delta')
ylabel('ask portfolio')

if different_strikes
%% different strikes
K = linspace(85,115,60);       % strikes
delta_bid = zeros(length(K),1); % delta bid
delta_ask = zeros(length(K),1); % delta ask
for j=1:length(K)
    [bid,bids,delta_bid(j),deltas] = bid_B_S(S_0,q,s,r,T,N,K(j),option_type,delta_range,delta_precision,dist_type,lambda);
    [ask,asks,delta_ask(j),deltas] = ask_B_S(S_0,q,s,r,T,N,K(j),option_type,delta_range,delta_precision,dist_type,lambda);
end
d1 = B_S_d1(S_0,q,s,r,T,K);
figure()
plot(K,delta_bid)
hold on
plot(K,delta_ask)
plot(K,-normcdf(d1))
xlabel('strike K')
ylabel('\Delta')
legend('\Delta_{bid}','\Delta_{ask}','-\Delta_{B-S}')
end