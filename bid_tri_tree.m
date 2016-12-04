function [bid,bids,delta,deltas] = bid_tri_tree(S_0,s,r,T,K,option,varargin)
p = inputParser;
addRequired(p,'S_0');
addRequired(p,'s',@ispositive);
addRequired(p,'r',@ispositive);
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
defaultOld_bid = [0,0,0];
addOptional(p,'old_bid',defaultOld_bid,@(x)validateattributes(x,{'numeric'},{'numel',3}))
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
old_bid = p.Results.old_bid;
hedged = p.Results.hedged;
%states
[u,m,d] = states_tri_tree(r,s,T);
%payouts
if (sum(old_bid)==0)
    f_u = payoff(u*S_0,K,option);   % option payout up
    f_m = payoff(m*S_0,K,option);   % option payout middle
    f_d = payoff(d*S_0,K,option);   % option payout down
else
    f_u = old_bid(1);
    f_m = old_bid(2);
    f_d = old_bid(3);
end
%jump probabilities
p_u = 1/6;                        % jump up 
p_m = 2/3;                        % jump middle
p_d = 1/6;                        % jump down
ps = [p_u,p_m,p_d];
%optimize  
if hedged
    n = (delta_range(2)-delta_range(1))/delta_precision;
    deltas = linspace(delta_range(1),delta_range(2),n); 
    bids = zeros(1,n);
else
    n = 1;
    deltas = 0;
end 
for i=1:n
    pi_u = f_u + deltas(i)*(u - exp(r*T))*S_0;
    pi_m = f_m + deltas(i)*(m - exp(r*T))*S_0;
    pi_d = f_d + deltas(i)*(d - exp(r*T))*S_0;
    [sorted_pi,I]=sort([pi_u,pi_m,pi_d]);
    dist_cdf = distortion(cumsum(ps(I)),dist,lambda);
    dist_sorted_ps = [dist_cdf(1),diff(dist_cdf)];
    bids(i) = exp(-r*T)*sum((sorted_pi).*(dist_sorted_ps));
end
[bid,i] = max(bids);
delta = deltas(i);
end