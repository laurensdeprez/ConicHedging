function [ask,asks,delta,deltas] = ask_B_S(S_0,q,s,r,T,N,K,option,dist_type,lambda,varargin)
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
% Monte Carlo 
W = normrnd(0,sqrt(T),[N,1]);
S_T = S_0*exp((q-s^2/2)*T+s*W);
% payoff
f = payoff(S_T,K,option);
% distorted probabilities
prob_dist = zeros(1,N);
for i=1:N
    prob_dist(i) = distortion((N-i+1)/N,dist_type,lambda)- distortion((N-i)/N,dist_type,lambda);
end
% optimize
n = (delta_range(2)-delta_range(1))/delta_precision;
deltas = linspace(delta_range(1),delta_range(2),n); 
asks = zeros(1,n);
for i=1:n
    pi = sort(f + deltas(i)*(S_T - exp(r*T)*S_0));
    asks(i) = exp(-r*T)*prob_dist*pi;
end
[ask,I] = min(asks);
delta = deltas(I);
end

