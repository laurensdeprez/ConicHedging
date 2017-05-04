% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

clear;
close all;

%% conic dynamic delta-gamma hedging of trinom. tree
T = 1/12;            % maturity
dt = T/2;            % timestep
S_0 = 100;           % init. stock price
K = 105;             % strike
option = 'put';      % option type
s = 0.2;             % volatility
r = 0.01;            % risk free interest
dist = 'MinMaxVar';  % distortion function
lambda = 0.125;      % distortion parameter
delta_gamma = false; % delta-hedging
%% states
[u,m,d] = states_tri_tree(r,s,dt);
%% pay off
f_uu = payoff(u*u*S_0,K,option);
f_um = payoff(u*m*S_0,K,option);
f_mm = payoff(m*m*S_0,K,option);
f_dm = payoff(d*m*S_0,K,option);
f_dd = payoff(d*d*S_0,K,option);
disp(['pay-offs ',num2str([f_uu,f_um,f_mm,f_dm,f_dd])])
%% Risk free pricing
[bid_u,~,~,~] = bid_tri_tree(u*S_0,s,r,dt,K,option,'dist',dist,'lambda',0,'hedged',false);
[bid_m,~,~,~] = bid_tri_tree(m*S_0,s,r,dt,K,option,'dist',dist,'lambda',0,'hedged',false);
[bid_d,~,~,~] = bid_tri_tree(d*S_0,s,r,dt,K,option,'dist',dist,'lambda',0,'hedged',false);
disp(['intermediate prices ',num2str([bid_u,bid_m,bid_d])])
% final stated (unhedged)
old_bid = [bid_u,bid_m,bid_d];
[bid,~,~,~] = bid_tri_tree(S_0,s,r,dt,K,option,'dist',dist,'lambda',0,'old_bid',old_bid,'hedged',false);
disp(['final price ',num2str(bid)])
%% Bid hedging
if delta_gamma
% intermediate state (delta-gamma hedged)
[bid_u,~,delta_u,~,gamma_u,~] = bid_tri_tree(u*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'hedging_type','Delta-Gamma');
[bid_m,~,delta_m,~,gamma_m,~] = bid_tri_tree(m*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'hedging_type','Delta-Gamma');
[bid_d,~,delta_d,~,gamma_d,~] = bid_tri_tree(d*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'hedging_type','Delta-Gamma');
disp(['intermediate bids (d-g) ',num2str([bid_u,bid_m,bid_d])])
disp(['intermediate bid deltas (d-g) ',num2str([delta_u,delta_m,delta_d])])
disp(['intermediate bid gammas (d-g) ',num2str([gamma_u,gamma_m,gamma_d])])
% final state (delta-gamma hedged)
old_bid = [bid_u,bid_m,bid_d];
[bid,~,delta,~,gamma,~] = bid_tri_tree(S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'hedging_type','Delta-Gamma','old_bid',old_bid);
disp(['final bid (d-g) ',num2str(bid)])
disp(['final bid delta (d-g) ',num2str(delta)])
disp(['final bid gamma (d-g) ',num2str(gamma)])
end
% intermediate state (delta hedged)
[bid_u,~,delta_u,~] = bid_tri_tree(u*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda);
[bid_m,~,delta_m,~] = bid_tri_tree(m*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda);
[bid_d,~,delta_d,~] = bid_tri_tree(d*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda);
disp(['intermediate bids (d) ',num2str([bid_u,bid_m,bid_d])])
disp(['intermediate bid deltas (d) ',num2str([delta_u,delta_m,delta_d])])
% final state (delta hedged)
old_bid = [bid_u,bid_m,bid_d];
[bid,~,delta,~] = bid_tri_tree(S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'old_bid',old_bid);
disp(['final bid (d) ',num2str(bid)])
disp(['final bid delta (d) ',num2str(delta)])
% intermediate state (unhedged)
[bid_u,~,~,~] = bid_tri_tree(u*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'hedged',false);
[bid_m,~,~,~] = bid_tri_tree(m*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'hedged',false);
[bid_d,~,~,~] = bid_tri_tree(d*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'hedged',false);
disp(['intermediate bids ',num2str([bid_u,bid_m,bid_d])])
% final stated (unhedged)
old_bid = [bid_u,bid_m,bid_d];
[bid,~,~,~] = bid_tri_tree(S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'old_bid',old_bid,'hedged',false);
disp(['final bid ',num2str(bid)])
%% Ask hedging
if delta_gamma
% intermediate state (delta-gamma hedged)
[ask_u,~,delta_u,~,gamma_u,~] = ask_tri_tree(u*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'hedging_type','Delta-Gamma');
[ask_m,~,delta_m,~,gamma_m,~] = ask_tri_tree(m*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'hedging_type','Delta-Gamma');
[ask_d,~,delta_d,~,gamma_d,~] = ask_tri_tree(d*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'hedging_type','Delta-Gamma');
disp(['intermediate asks (d-g) ',num2str([ask_u,ask_m,ask_d])])
disp(['intermediate ask deltas (d-g) ',num2str([delta_u,delta_m,delta_d])])
disp(['intermediate ask gammas (d-g) ',num2str([gamma_u,gamma_m,gamma_d])])
% final state (delta-gamma hedged)
old_ask = [ask_u,ask_m,ask_d];
[ask,~,delta,~,gamma,~] = ask_tri_tree(S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'hedging_type','Delta-Gamma','old_ask',old_ask);
disp(['final ask (d-g) ',num2str(ask)])
disp(['final ask delta (d-g) ',num2str(delta)])
disp(['final ask gamma (d-g) ',num2str(gamma)])
end
% intermediate state (delta hedged)
[ask_u,~,delta_u,~] = ask_tri_tree(u*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda);
[ask_m,~,delta_m,~] = ask_tri_tree(m*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda);
[ask_d,~,delta_d,~] = ask_tri_tree(d*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda);
disp(['intermediate asks (d) ',num2str([ask_u,ask_m,ask_d])])
disp(['intermediate ask deltas (d) ',num2str([delta_u,delta_m,delta_d])])
% final state (delta hedged)
old_ask = [ask_u,ask_m,ask_d];
[ask,~,delta,~] = ask_tri_tree(S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'old_ask',old_ask);
disp(['final ask (d) ',num2str(ask)])
disp(['final ask delta (d) ',num2str(delta)])
% intermediate state (unhedged)
[ask_u,~,~,~] = ask_tri_tree(u*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'hedged',false);
[ask_m,~,~,~] = ask_tri_tree(m*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'hedged',false);
[ask_d,~,~,~] = ask_tri_tree(d*S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'hedged',false);
disp(['intermediate asks ',num2str([ask_u,ask_m,ask_d])])
% final stated (unhedged)
old_ask = [ask_u,ask_m,ask_d];
[ask,~,~,~] = ask_tri_tree(S_0,s,r,dt,K,option,'dist',dist,'lambda',lambda,'old_ask',old_ask,'hedged',false);
disp(['final ask ',num2str(ask)])