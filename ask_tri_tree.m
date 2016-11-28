function [ask,asks,delta,deltas] = ask_tri_tree(S_0,s,r,T,K,option,varargin)
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
%optimize    
if hedged
    n = (delta_range(2)-delta_range(1))/delta_precision;
    deltas = linspace(delta_range(1),delta_range(2),n); 
    asks = zeros(1,n);
else
    n = 1;
    deltas = 0;
end 
for i=1:n
    pi_u = f_u + deltas(i)*(u - exp(r*T))*S_0;
    pi_m = f_m + deltas(i)*(m - exp(r*T))*S_0;
    pi_d = f_d + deltas(i)*(d - exp(r*T))*S_0;
    check = [(pi_u>=pi_m),(pi_u>=pi_d),(pi_m>=pi_d)];
    % can this be programmed cleaner?
    check = string(double(check));
    check = strcat(check(1),check(2),check(3));
    switch check
        case '111'
            p_ud = distortion(p_u,dist,lambda);
            p_md = distortion(p_u+p_m,dist,lambda)-distortion(p_u,dist,lambda);
            p_dd = 1-distortion(p_u+p_m,dist,lambda);
        case '110'
            p_ud = distortion(p_u,dist,lambda);
            p_dd = distortion(p_u+p_d,dist,lambda)-distortion(p_u,dist,lambda);
            p_md = 1-distortion(p_u+p_d,dist,lambda);
        case '101'
            error('impossible due to transitivity in bid_tri_tree')
        case '011'
            p_md = distortion(p_m,dist,lambda);
            p_ud = distortion(p_u+p_m,dist,lambda)-distortion(p_m,dist,lambda);
            p_dd = 1-distortion(p_u+p_m,dist,lambda);
        case '100'
            p_dd = distortion(p_d,dist,lambda);
            p_ud = distortion(p_u+p_d,dist,lambda)-distortion(p_d,dist,lambda);
            p_md = 1-distortion(p_u+p_d,dist,lambda);
        case '010'
            error('impossible due to transitivity in bid_tri_tree')
        case '001'
            p_md = distortion(p_m,dist,lambda);
            p_dd = distortion(p_m+p_d,dist,lambda)-distortion(p_m,dist,lambda);
            p_ud = 1-distortion(p_m+p_d,dist,lambda);
        case '000'
            p_dd = distortion(p_d,dist,lambda);
            p_md = distortion(p_m+p_d,dist,lambda)-distortion(p_d,dist,lambda);
            p_ud = 1-distortion(p_m+p_d,dist,lambda);
        otherwise
            error('something went wrong in bid_tri_tree')
    end 
    asks(i) = exp(-r*T)*(p_ud*pi_u+p_md*pi_m+p_dd*pi_d);
end
[ask,i] = min(asks);
delta = deltas(i);
end