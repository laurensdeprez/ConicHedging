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

% Bid hedging
% intermediate state (hedged)
[bid_u,~,delta_u,~] = bid_tri_tree(u*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda);
[bid_m,~,delta_m,~] = bid_tri_tree(m*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda);
[bid_d,~,delta_d,~] = bid_tri_tree(d*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda);
disp([bid_u,bid_m,bid_d])
disp([delta_u,delta_m,delta_d])
% final state (hedged)
old_bid = [bid_u,bid_m,bid_d];
[bid,~,delta,~] = bid_tri_tree(S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'old_bid',old_bid);
disp(bid)
disp(delta)
% intermediate state (unhedged)
[bid_u,~,~,~] = bid_tri_tree(u*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'hedged',false);
[bid_m,~,~,~] = bid_tri_tree(m*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'hedged',false);
[bid_d,~,~,~] = bid_tri_tree(d*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'hedged',false);
disp([bid_u,bid_m,bid_d])
% final stated (unhedged)
old_bid = [bid_u,bid_m,bid_d];
[bid,~,~,~] = bid_tri_tree(S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'old_bid',old_bid,'hedged',false);
disp(bid)

% Ask hedging
% intermediate state (hedged)
[ask_u,~,delta_u,~] = ask_tri_tree(u*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda);
[ask_m,~,delta_m,~] = ask_tri_tree(m*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda);
[ask_d,~,delta_d,~] = ask_tri_tree(d*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda);
disp([ask_u,ask_m,ask_d])
disp([delta_u,delta_m,delta_d])
% final state (hedged)
old_ask = [ask_u,ask_m,ask_d];
[ask,~,delta,~] = ask_tri_tree(S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'old_ask',old_ask);
disp(ask)
disp(delta)
% intermediate state (unhedged)
[ask_u,~,~,~] = ask_tri_tree(u*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'hedged',false);
[ask_m,~,~,~] = ask_tri_tree(m*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'hedged',false);
[ask_d,~,~,~] = ask_tri_tree(d*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'hedged',false);
disp([ask_u,ask_m,ask_d])
% final stated (unhedged)
old_ask = [ask_u,ask_m,ask_d];
[ask,~,~,~] = ask_tri_tree(S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'old_ask',old_ask,'hedged',false);
disp(['ask price ',num2str(ask)])