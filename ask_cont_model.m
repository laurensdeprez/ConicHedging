function [ask,asks,delta,deltas] = ask_cont_model(S_0,S_T,r,T,N,K,option,dist_type,lambda,delta_range,delta_precision,hedged)
p = inputParser;
addRequired(p,'S_0');
addRequired(p,'S_T');
addRequired(p,'r');
addRequired(p,'T');
addRequired(p,'N');
addRequired(p,'K');
addRequired(p,'option');
addRequired(p,'dist_type')
addRequired(p,'lambda')
addRequired(p,'delta_range');
addRequired(p,'delta_precision');
addRequired(p, 'hedged')
parse(p,S_0,S_T,r,T,N,K,option,dist_type,lambda,delta_range,delta_precision,hedged);
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

