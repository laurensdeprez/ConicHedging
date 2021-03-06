% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

%% ask prices in binomial tree model
function [ask,asks,delta,deltas] = ask_bin_tree(S_0,s,r,T,K,option,varargin)
p = inputParser;
addRequired(p,'S_0');
addRequired(p,'s',@ispositive);
addRequired(p,'r',@ispositive);
addRequired(p,'T',@ispositive);
addRequired(p,'K');
addRequired(p,'option');
defaultDelta_range = [-2,2];
addOptional(p,'delta_range',defaultDelta_range,@(x)validateattributes(x,{'numeric'},{'numel',2,'increasing'}));
defaultDelta_precision = 400;
addOptional(p,'delta_precision',defaultDelta_precision,@ispositive);
defaultDist = 'MinMaxVar';
addOptional(p,'dist',defaultDist);
defaultLambda = 0.25;
addOptional(p,'lambda',defaultLambda);
defaultHedged = true;
addOptional(p, 'hedged',defaultHedged, @(x)validateattributes(x,{'logical'},{'numel',1}))
parse(p,S_0,s,r,T,K,option,varargin{:});

S_0 = p.Results.S_0;
s = p.Results.s;
r = p.Results.r;
T = p.Results.T;
K = p.Results.K;
option = p.Results.option;
delta_range = p.Results.delta_range;
delta_precision = p.Results.delta_precision;
dist = p.Results.dist;
lambda = p.Results.lambda;
hedged = p.Results.hedged;
% risk neutral up probability
[u,d] = states_bin_tree(s,T);
p = (exp(r*T)-d)/(u-d);  
if (~isprobability(p))
    error('choose up and down state differently w.r.t. the interest')
end
% payouts
f_u = payoff(u*S_0,K,option);         % option payout up
f_d = payoff(d*S_0,K,option);         % option payout down
% optimize
if hedged
    n = delta_precision;
    deltas = linspace(delta_range(1),delta_range(2),n); 
else
    n = 1;
    deltas = 0;
end
asks = zeros(1,n);
for i=1:n
    pi_u = f_u + deltas(i)*(u - exp(r*T))*S_0;
    pi_d = f_d + deltas(i)*(d - exp(r*T))*S_0;
    if (pi_u >= pi_d)
        asks(i) = exp(-r*T)*(distortion(p,dist,lambda)*pi_u+(1-distortion(p,dist,lambda))*pi_d);
    else
        asks(i) = exp(-r*T)*((1-distortion(1-p,dist,lambda))*pi_u+distortion(1-p,dist,lambda)*pi_d);
    end 
end
[ask,i] = min(asks);
delta = deltas(i);
end
