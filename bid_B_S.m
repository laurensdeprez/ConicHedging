function [bid,bids,delta,deltas] = bid_B_S(S_0,q,s,r,T,N,K,option,dist_type,lambda,varargin)
p = inputParser;
addRequired(p,'S_0');
addRequired(p,'q',@isnumeric);
addRequired(p,'s',@ispositive);
addRequired(p,'r',@ispositive);
addRequired(p,'T',@ispositive);
addRequired(p,'N',@ispositive);
addRequired(p,'K');
addRequired(p,'option');
addRequired(p,'dist_type')
addRequired(p,'lambda')
defaultDelta_range = [-2,2];
addOptional(p,'delta_range',defaultDelta_range,@(x)validateattributes(x,{'numeric'},{'numel',2,'increasing'}));
defaultDelta_precision = 0.01;
addOptional(p,'delta_precision',defaultDelta_precision,@ispositive);
defaultHedged = true;
addOptional(p, 'hedged',defaultHedged, @(x)validateattributes(x,{'logical'},{'numel',1}))
parse(p,S_0,q,s,r,T,N,K,option,dist_type,lambda,varargin{:});
S_0 = p.Results.S_0;
s = p.Results.s;
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
% Monte Carlo 
W = normrnd(0,sqrt(T),[N,1]);
S_T = S_0*exp((q-s^2/2)*T+s*W);
% payoff
f = payoff(S_T,K,option);
% distorted probabilities
prob_dist = zeros(1,N);
for i=1:N
    prob_dist(i) = distortion(i/N,dist_type,lambda)- distortion((i-1)/N,dist_type,lambda);
end
% optimize
if hedged
    n = (delta_range(2)-delta_range(1))/delta_precision;
    deltas = linspace(delta_range(1),delta_range(2),n); 
else
    n = 1;
    deltas = 0;
end 
bids = zeros(1,n);
for i=1:n
    pi = sort(f + deltas(i)*(S_T - exp(r*T)*S_0));
    bids(i) = exp(-r*T)*prob_dist*pi;
end
[bid,I] = max(bids);
delta = deltas(I);
end

