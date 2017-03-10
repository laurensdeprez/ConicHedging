close all;
%% conic Delta-Gamma hedging in trinomial tree
S_0 = 100;                       % init. stock price
s = 0.2;                         % volatility
r = 0.01;                        % interest
T = 1/12;                        % maturity
K = S_0;                         % strike ATM
option_type = 'call';            % option type
delta_range = [-1.2,0.4];
delta_precision = 200;
gamma_range = [-0.1,0.1];
gamma_precision = 100;
lambda = 0.25;
%% bid
[bid,bids,delta,deltas,gamma,gammas] = bid_tri_tree(S_0,s,r,T,K,option_type,'hedging_type','Delta-Gamma','delta_range',delta_range,'delta_precision',delta_precision,'gamma_range',gamma_range,'gamma_precision',gamma_precision,'lambda',lambda);

figure()
colormap('jet')
contourf(gammas,flip(deltas),flipud(transpose(bids)),20);
xlabel('\Gamma','FontSize',15)
ylabel('\Delta','FontSize',15)
c = colorbar;
ylabel(c,'bid price','FontSize',15)
%% ask
[ask,asks,delta,deltas,gamma,gammas] = ask_tri_tree(S_0,s,r,T,K,option_type,'hedging_type','Delta-Gamma','delta_range',delta_range,'delta_precision',delta_precision,'gamma_range',gamma_range,'gamma_precision',gamma_precision,'lambda',lambda);

figure()
colormap('jet')
contourf(gammas,flip(deltas),flipud(transpose(asks)),20);
xlabel('\Gamma','FontSize',15)
ylabel('\Delta','FontSize',15)
c = colorbar;
ylabel(c,'ask price','FontSize',15)