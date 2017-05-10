% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

%% dynamic capital calculation for non homogeneous grid with local multinomial VG approximation
function [S,f,Delta,deltas] = capital_N_tree(S_0,r,delta,p0,M,N,s,v,th,T,K,option,varargin)
p = inputParser;
addRequired(p,'S_0');
addRequired(p,'r',@ispositive);
addRequired(p,'delta',@ispositive);
addRequired(p,'p0',@isprobability);
addRequired(p,'M',@ispositive);
addRequired(p,'N',@ispositive);
addRequired(p,'s',@isnumeric);
addRequired(p,'v',@isnumeric);
addRequired(p,'th',@isnumeric);
addRequired(p,'T',@ispositive);
addRequired(p,'K');
addRequired(p,'option');
defaultDelta_range = [-2,2];
addOptional(p,'delta_range',defaultDelta_range,@(x)validateattributes(x,{'numeric'},{'numel',2,'increasing'}));
defaultDelta_precision = 0.01;
addOptional(p,'delta_precision',defaultDelta_precision,@ispositive);
defaultDist = 'MinMaxVar';
addOptional(p,'dist',defaultDist);
defaultLambda = 0.01;
addOptional(p,'lambda',defaultLambda);
parse(p,S_0,r,delta,p0,M,N,s,v,th,T,K,option,varargin{:});
S_0 = p.Results.S_0;
r = p.Results.r;
delta = p.Results.delta;
p0 = p.Results.p0;
M = p.Results.M;
N = p.Results.N;
s = p.Results.s;
v = p.Results.v;
th = p.Results.th;
T = p.Results.T;
K = p.Results.K;
option = p.Results.option;
delta_range = p.Results.delta_range;
delta_precision = p.Results.delta_precision;
dist = p.Results.dist;
lambda = p.Results.lambda;

[C_VG,G_VG,M_VG] = VG_param(s,v,th);
dt = T/N;
ps = cond_prob_multinomial(M,delta,C_VG,G_VG,M_VG);
p_j = ps(1,:);
q_j = ps(2,:);
ps = [(1-p0)*p_j,p0,(1-p0)*q_j];
ps = floor(ps*10^11)/10^11;
x = -(1:M)*delta;
y = (1:M)*delta;
% states
num_prices = 50;
[logS,S] = NUG(S_0,150,50,0.075,num_prices);

% payouts
f = zeros(num_prices,N+1,7);
f(:,1,1) = payoff(S,K,option);
f(:,1,2) = payoff(S,K,option);
f(:,1,4) = payoff(S,K,option);
f(:,1,5) = payoff(S,K,option);

Delta = zeros(num_prices,N+1,3);
omega = 1/v*log(1-s^2/2*v-th*v);

% hedging vector
n = (delta_range(2)-delta_range(1))/delta_precision;
deltas = linspace(delta_range(1),delta_range(2),n); 
hedge_asks = zeros(1,n);
hedge_bids = zeros(1,n);
hedge_caps = zeros(1,n);

% optim section
for ii=2:(N+1) %time loop 
    for jj=1:num_prices %stock prices loop
        local_tree = exp(logS(jj)+(r+omega)*dt+[x,0,y]);
        local_tree_f_bid = interp1(S,f(:,ii-1,1),local_tree,'PCHIP','extrap');
		local_tree_f_ask = interp1(S,f(:,ii-1,2),local_tree,'PCHIP','extrap');
		[sorted_tree_f_bid,I_bid]=sort(local_tree_f_bid);
        [sorted_tree_f_ask,I_ask]=sort(local_tree_f_ask,'descend');
        dist_cdf_bid = distortion(cumsum(ps(I_bid)),dist,lambda);
		dist_cdf_ask = distortion(cumsum(ps(I_ask)),dist,lambda);
        dist_sorted_ps_bid = [dist_cdf_bid(1),diff(dist_cdf_bid)];
		dist_sorted_ps_ask = [dist_cdf_ask(1),diff(dist_cdf_ask)];
        f(jj,ii,1) = exp(-r*dt)*sum((dist_sorted_ps_bid).*(sorted_tree_f_bid));
		f(jj,ii,2) = exp(-r*dt)*sum((dist_sorted_ps_ask).*(sorted_tree_f_ask));
		f(jj,ii,3) = f(jj,ii,2) - f(jj,ii,1);
        for kk=1:n%delta hedge loop
            local_tree_f_bid = interp1(S,f(:,ii-1,4),local_tree,'PCHIP','extrap');
            local_tree_f_ask = interp1(S,f(:,ii-1,5),local_tree,'PCHIP','extrap');
            local_tree_f_bid = local_tree_f_bid + deltas(kk)*(local_tree - exp(r*dt)*S(jj));
			local_tree_f_ask = local_tree_f_ask + deltas(kk)*(local_tree - exp(r*dt)*S(jj));
			[sorted_tree_f_bid,I_bid]=sort(local_tree_f_bid);
            [sorted_tree_f_ask,I_ask]=sort(local_tree_f_ask,'descend');
            dist_cdf_bid = distortion(cumsum(ps(I_bid)),dist,lambda);
			dist_cdf_ask = distortion(cumsum(ps(I_ask)),dist,lambda);
            dist_sorted_ps_bid = [dist_cdf_bid(1),diff(dist_cdf_bid)];
			dist_sorted_ps_ask = [dist_cdf_ask(1),diff(dist_cdf_ask)];
			hedge_bids(kk) = exp(-r*dt)*sum((sorted_tree_f_bid).*(dist_sorted_ps_bid));
            hedge_asks(kk) = exp(-r*dt)*sum((sorted_tree_f_ask).*(dist_sorted_ps_ask));
			hedge_caps(kk) = hedge_asks(kk)-hedge_bids(kk);
        end
		[f(jj,ii,4),I_bid] = max(hedge_bids);
        [f(jj,ii,5),I_ask] = min(hedge_asks);
		f(jj,ii,6) = f(jj,ii,5) - f(jj,ii,4);
		[f(jj,ii,7),I_cap] = min(hedge_caps);
        Delta(jj,ii,1) = deltas(I_bid);
		Delta(jj,ii,2) = deltas(I_ask);
		Delta(jj,ii,3) = deltas(I_cap);
    end
end 
end