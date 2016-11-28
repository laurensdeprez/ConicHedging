close all;
%% Dynamic Hedging
%% Trinomial Tree
% bid delta hedging
T = 1/12;           % maturity
dt = T/2;           % timestep
S_0 = 100;          % init. stock price
K = 105;            % strike
option = 'put';     % option type
s = 0.2;            % volatility
r = 0.01;           % risk free interest
dist = 'MinMaxVar'; % distortion function
lambda = 0.125;     % distortion parameter
% states
[u,m,d] = states_tri_tree(r,s,dt);
% intermediate state (hedged)
[bid_u,~,~,~] = bid_tri_tree(u*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda);
[bid_m,~,~,~] = bid_tri_tree(m*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda);
[bid_d,~,~,~] = bid_tri_tree(d*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda);
disp([bid_u,bid_m,bid_d])
% final state (hedged)
old_bid = [bid_u,bid_m,bid_d];
[bid,~,~,~] = bid_tri_tree(S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'old_bid',old_bid);
disp(bid)
% intermediate state (unhedged)
[bid_u,~,~,~] = bid_tri_tree(u*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'hedged',false);
[bid_m,~,~,~] = bid_tri_tree(m*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'hedged',false);
[bid_d,~,~,~] = bid_tri_tree(d*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'hedged',false);
disp([bid_u,bid_m,bid_d])
% final stated (unhedged)
old_bid = [bid_u,bid_m,bid_d];
[bid,~,~,~] = bid_tri_tree(S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'old_bid',old_bid,'hedged',false);
disp(bid)
%% Multinomial Tree 

