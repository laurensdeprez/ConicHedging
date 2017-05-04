% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

%% ask prices in Black-Scholes
function [ask,asks,delta,deltas] = ask_B_S(S_0,S_T,r,T,N,K,option,dist_type,lambda,varargin)
p = inputParser;
addRequired(p,'S_0',@ispositive);
addRequired(p,'S_T',@ispositive);
addRequired(p,'r',@ispositive);
addRequired(p,'T',@ispositive);
addRequired(p,'N',@ispositive);
addRequired(p,'K',@ispositive);
addRequired(p,'option');
addRequired(p,'dist_type')
addRequired(p,'lambda')
defaultDelta_range = [-2,2];
addOptional(p,'delta_range',defaultDelta_range,@(x)validateattributes(x,{'numeric'},{'numel',2,'increasing'}));
defaultDelta_precision = 0.01;
addOptional(p,'delta_precision',defaultDelta_precision,@ispositive);
defaultHedged = true;
addOptional(p, 'hedged',defaultHedged, @(x)validateattributes(x,{'logical'},{'numel',1}))
parse(p,S_0,S_T,r,T,N,K,option,dist_type,lambda,varargin{:});
S_0 = p.Results.S_0;
S_T = p.Results.S_T;
r = p.Results.r;
T = p.Results.T;
N = p.Results.N;
K = p.Results.K;
option = p.Results.option;
dist_type = p.Results.dist_type;
lambda = p.Results.lambda;
delta_range = p.Results.delta_range;
delta_precision = p.Results.delta_precision;
hedged = p.Results.hedged;
% payoff
f = payoff(S_T,K,option);
% distorted probabilities
prob_dist = zeros(1,N);
for i=1:N
    prob_dist(i) = distortion((N-i+1)/N,dist_type,lambda)- distortion((N-i)/N,dist_type,lambda);
end
% optimize
if hedged
    n = (delta_range(2)-delta_range(1))/delta_precision;
    deltas = linspace(delta_range(1),delta_range(2),n); 
else
    n = 1;
    deltas = 0;
end 
asks = zeros(1,n);
for i=1:n
    pi = sort(f + deltas(i)*(S_T - exp(r*T)*S_0));
    asks(i) = exp(-r*T)*prob_dist*pi;
end
[ask,I] = min(asks);
delta = deltas(I);
end
