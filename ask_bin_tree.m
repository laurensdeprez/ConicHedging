function [ask,asks,delta,deltas] = ask_bin_tree(S_0,u,d,r,T,K,option,varargin)
p = inputParser;
addRequired(p,'S_0');
addRequired(p,'u',@ispositive);
addRequired(p,'d',@ispositive);
addRequired(p,'r',@ispositive);
addRequired(p,'T',@ispositive);
addRequired(p,'K');
addRequired(p,'option');
defaultDelta_range = [-2,2];
addOptional(p,'delta_range',defaultDelta_range,@(x)validateattributes(x,{'numeric'},{'numel',2,'increasing'}));
defaultDelta_precision = 0.01;
addOptional(p,'delta_precision',defaultDelta_precision,@ispositive);
parse(p,S_0,u,d,r,T,K,option,varargin{:});
S_0 = p.Results.S_0;
u = p.Results.u;
d = p.Results.d;
r = p.Results.r;
T = p.Results.T;
K = p.Results.K;
option = p.Results.option;
delta_range = p.Results.delta_range;
delta_precision = p.Results.delta_precision;
% risk neutral up probability
p = (exp(r*T)-d)/(u-d);  
if (~isprobability(p))
    error('choose up and down state differently w.r.t. the interest')
end
% payouts
f_u = payoff(u*S_0,K,option);         % option payout up
f_d = payoff(d*S_0,K,option);         % option payout down
% optimize
n = (delta_range(2)-delta_range(1))/delta_precision;
deltas = linspace(delta_range(1),delta_range(2),n); 
asks = zeros(1,n);
for i=1:n
    pi_u = f_u + deltas(i)*(u - exp(r*T))*S_0;
    pi_d = f_d + deltas(i)*(d - exp(r*T))*S_0;
    if (pi_u >= pi_d)
        asks(i) = exp(-r*T)*(distortion(p)*pi_u+(1-distortion(p))*pi_d);
    else
        asks(i) = exp(-r*T)*((1-distortion(1-p))*pi_u+distortion(1-p)*pi_d);
    end 
end
[ask,i] = min(asks);
delta = deltas(i);
end


