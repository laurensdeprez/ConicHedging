%% Dynamic Hedging
close all;
tri = false;
multi = true;

%% Trinomial Tree
if tri 
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
end
%% Multinomial Tree 
T = 1;                      % maturity (in years)
dt = 1/50;                  % timestep (in years)

S_0 = 100;                  % init stock value
r = 0.02;                   % risk-free interest
K = [100,120];              % call spread strikes
option = 'callspread';      % option type

sigma = 0.2;                % VG process parameters
nu = 0.75;
theta = -0.3;
C_VG = 1/v;
G_VG = 1/(sqrt(th^2*v^2/4+s^2*v/2)-th*v/2);
M_VG = 1/(sqrt(th^2*v^2/4+s^2*v/2)+th*v/2);

dist = 'MinMaxVar';         % distortion type
lambda = 0.015;             % distortion parameter

M = 10;                     % 2M+1-nomial approximation
p = 0.9407;                 % jump zero probability (after optim)
delta = 0.0740;             % jump size (after optim)

ps = cond_prob_multinomial(M,delta,C_VG,G_VG,M_VG);
p_j = ps(1,:);              % conditional prob 
q_j = ps(2,:);

