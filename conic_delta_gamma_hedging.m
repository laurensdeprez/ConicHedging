% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

clear;
close all;

%% conic delta-gamma hedging in trinomial tree
S_0 = 100;                       % init. stock price
s = 0.2;                         % volatility
r = 0.01;                        % interest
T = 1;                           % maturity
K = S_0;                         % strike ATM
option_type = 'call';            % option type
delta_range = [-1.2,0.4];
delta_precision = 200;
gamma_range = [-0.1,0.1];
gamma_precision = 100;
lambda = 0.25;
%% risk neutral
[price,delta_rn,gamma_rn] = risk_neutral_tri(S_0,s,r,T,K,option_type);
disp(['risk neutral price ',num2str(price)])
disp(['risk neutral delta ',num2str(delta_rn)])
disp(['risk neutral gamma ',num2str(gamma_rn)])
%% bid
[bid,bids,delta_b,deltas,gamma_b,gammas] = bid_tri_tree(S_0,s,r,T,K,option_type,'hedging_type','Delta-Gamma','delta_range',delta_range,'delta_precision',delta_precision,'gamma_range',gamma_range,'gamma_precision',gamma_precision,'lambda',lambda);
disp(['bid (d-g) ',num2str(bid)])
disp(['bid delta (d-g) ',num2str(delta_b)])
disp(['bid gamma (d-g) ',num2str(gamma_b)])
figure()
colormap('jet')
contourf(gammas,flip(deltas),flipud(transpose(bids)),20);
xlabel('\Gamma','FontSize',15)
ylabel('\Delta','FontSize',15)
c = colorbar;
ylabel(c,'bid price','FontSize',15)
%% ask
[ask,asks,delta_a,deltas,gamma_a,gammas] = ask_tri_tree(S_0,s,r,T,K,option_type,'hedging_type','Delta-Gamma','delta_range',delta_range,'delta_precision',delta_precision,'gamma_range',gamma_range,'gamma_precision',gamma_precision,'lambda',lambda);
disp(['ask (d-g) ',num2str(ask)])
disp(['ask delta (d-g) ',num2str(delta_a)])
disp(['ask gamma (d-g) ',num2str(gamma_a)])
figure()
colormap('jet')
contourf(gammas,flip(deltas),flipud(transpose(asks)),20);
xlabel('\Gamma','FontSize',15)
ylabel('\Delta','FontSize',15)
c = colorbar;
ylabel(c,'ask price','FontSize',15)