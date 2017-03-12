function [ask,asks,delta,deltas,gamma,gammas] = ask_bin_tree(S_0,s,r,T,K,option,varargin)
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
defaultHedging_type = 'Delta';
addOptional(p,'hedging_type', defaultHedging_type)
defaultGamma_range = [-0.1,0.1];
addOptional(p,'gamma_range',defaultGamma_range,@(x)validateattributes(x,{'numeric'},{'numel',2,'increasing'}));
defaultGamma_precision = 100;
addOptional(p,'gamma_precision',defaultGamma_precision,@ispositive);
defaultDist = 'MinMaxVar';
addOptional(p,'dist',defaultDist);
defaultLambda = 0.25;
addOptional(p,'lambda',defaultLambda);
parse(p,S_0,s,r,T,K,option,varargin{:});
S_0 = p.Results.S_0;
s = p.Results.s;
r = p.Results.r;
T = p.Results.T;
K = p.Results.K;
option = p.Results.option;
delta_range = p.Results.delta_range;
delta_precision = p.Results.delta_precision;
hedging_type = p.Results.hedging_type;
gamma_range = p.Results.gamma_range;
gamma_precision = p.Results.gamma_precision;
dist = p.Results.dist;
lambda = p.Results.lambda;
% risk neutral up probability
[u,d] = states_bin_tree(s,T);
p = (exp(r*T)-d)/(u-d);  
if (~isprobability(p))
    error('choose up and down state differently w.r.t. the interest')
end
ps = [p,1-p];
% payouts
f_u = payoff(u*S_0,K,option);         % option payout up
f_d = payoff(d*S_0,K,option);         % option payout down
% optimize
n = delta_precision;
deltas = linspace(delta_range(1),delta_range(2),n); 
n_g = gamma_precision;
gammas = linspace(gamma_range(1),gamma_range(2),n_g); 
switch hedging_type
    case 'Delta'
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
    case 'Delta-Gamma'
        asks = zeros(n_g,n);
        exp_value = sum(ps.*([((u - exp(r*T))*S_0)^2,((d - exp(r*T))*S_0)^2]));
        for i=1:n
            for j=1:n_g
                pi_u = f_u + deltas(i)*(u - exp(r*T))*S_0 + gammas(j)*(((u - exp(r*T))*S_0)^2 - exp_value);
                pi_d = f_d + deltas(i)*(d - exp(r*T))*S_0 + gammas(j)*(((d - exp(r*T))*S_0)^2 - exp_value);
                if (pi_u >= pi_d)
                    asks(i) = exp(-r*T)*(distortion(p,dist,lambda)*pi_u+(1-distortion(p,dist,lambda))*pi_d);
                else
                    asks(i) = exp(-r*T)*((1-distortion(1-p,dist,lambda))*pi_u+distortion(1-p,dist,lambda)*pi_d);
                end 
            end
        end
        ask = min(min(asks));
        [j,i] = find(asks==min(min(asks)));
        delta = deltas(i);
        gamma = gammas(j);
    otherwise
        error('only Delta or Delta-Gamma hedging')
end
end
