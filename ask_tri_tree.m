function [ask,asks,delta,deltas,gamma,gammas] = ask_tri_tree(S_0,s,r,T,K,option,varargin)
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
defaultGamma_precision = 400;
addOptional(p,'gamma_precision',defaultGamma_precision,@ispositive);
defaultDist = 'MinMaxVar';
addOptional(p,'dist',defaultDist);
defaultLambda = 0.25;
addOptional(p,'lambda',defaultLambda);
defaultOld_ask = [0,0,0];
addOptional(p,'old_ask',defaultOld_ask,@(x)validateattributes(x,{'numeric'},{'numel',3}))
defaultHedged = true;
addOptional(p, 'hedged',defaultHedged, @(x)validateattributes(x,{'logical'},{'numel',1}))
parse(p,S_0,s,r,T,K,option,varargin{:});
S_0 = p.Results.S_0;
s = p.Results.s;
r = p.Results.r;
T = p.Results.T;
K = p.Results.K;
option = p.Results.option;
hedging_type = p.Results.hedging_type;
gamma_range = p.Results.gamma_range;
gamma_precision = p.Results.gamma_precision;
delta_range = p.Results.delta_range;
delta_precision = p.Results.delta_precision;
dist = p.Results.dist;
lambda = p.Results.lambda;
old_ask = p.Results.old_ask;
hedged = p.Results.hedged;
%states
[u,m,d] = states_tri_tree(r,s,T);
%payouts
if (sum(old_ask)==0)
    f_u = payoff(u*S_0,K,option);   % option payout up
    f_m = payoff(m*S_0,K,option);   % option payout middle
    f_d = payoff(d*S_0,K,option);   % option payout down
else
    f_u = old_ask(1);
    f_m = old_ask(2);
    f_d = old_ask(3);
end
%jump probabilities
p_u = 1/6;                        % jump up 
p_m = 2/3;                        % jump middle
p_d = 1/6;                        % jump down
ps = [p_u,p_m,p_d];
%optimize    
if hedged
    n = delta_precision;
    deltas = linspace(delta_range(1),delta_range(2),n); 
    n_g = gamma_precision;
    gammas = linspace(gamma_range(1),gamma_range(2),n_g);
else
    n = 1;
    deltas = 0;
    n_g = 1;
    gammas = 0;
end 
switch hedging_type
    case 'Delta'
        asks = zeros(1,n);
        for i=1:n
            pi_u = f_u + deltas(i)*(u - exp(r*T))*S_0;
            pi_m = f_m + deltas(i)*(m - exp(r*T))*S_0;
            pi_d = f_d + deltas(i)*(d - exp(r*T))*S_0;
            [sorted_pi,I]=sort([pi_u,pi_m,pi_d],'descend');
            dist_cdf = distortion(cumsum(ps(I)),dist,lambda);
            dist_sorted_ps = [dist_cdf(1),diff(dist_cdf)];
            asks(i) = exp(-r*T)*sum((sorted_pi).*(dist_sorted_ps));
        end
        [ask,i] = min(asks);
        delta = deltas(i);
        gamma = false;
    case 'Delta-Gamma'
        asks = zeros(n_g,n);
        exp_value = sum(ps.*([((u - exp(r*T))*S_0)^2,((m - exp(r*T))*S_0)^2,((d - exp(r*T))*S_0)^2]));
        for i=1:n
            for j=1:n_g
                pi_u = f_u + deltas(i)*(u - exp(r*T))*S_0 + gammas(j)*(((u - exp(r*T))*S_0)^2 - exp_value);
                pi_m = f_m + deltas(i)*(m - exp(r*T))*S_0 + gammas(j)*(((m - exp(r*T))*S_0)^2 - exp_value);
                pi_d = f_d + deltas(i)*(d - exp(r*T))*S_0 + gammas(j)*(((d - exp(r*T))*S_0)^2 - exp_value);
                [sorted_pi,I]=sort([pi_u,pi_m,pi_d],'descend');
                dist_cdf = distortion(cumsum(ps(I)),dist,lambda);
                dist_sorted_ps = [dist_cdf(1),diff(dist_cdf)];
                asks(j,i) = exp(-r*T)*sum((sorted_pi).*(dist_sorted_ps));
            end
        end
        ask = min(min(asks));
        [j,i] = find(asks==min(min(asks)));
        delta = deltas(i);
        gamma = gammas(j);
    otherwise
        error('only Delta or Delta-Gamma hedging')
end