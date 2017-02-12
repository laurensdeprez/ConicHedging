function [S,f] = ask_N_tree(S_0,r,delta,p0,M,N,C_VG,G_VG,M_VG,T,K,option,varargin)
p = inputParser;
addRequired(p,'S_0');
addRequired(p,'r',@ispositive);
addRequired(p,'delta',@ispositive);
addRequired(p,'p0',@isprobability);
addRequired(p,'M',@ispositive);%integer
addRequired(p,'N',@ispositive);%integer
addRequired(p,'C_VG');
addRequired(p,'G_VG');
addRequired(p,'M_VG');
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
parse(p,S_0,r,delta,p0,M,N,C_VG,G_VG,M_VG,T,K,option,varargin{:});
S_0 = p.Results.S_0;
r = p.Results.r;
delta = p.Results.delta;
p0 = p.Results.p0;
M = p.Results.M;
N = p.Results.N;
G_VG = p.Results.G_VG;
C_VG = p.Results.C_VG;
M_VG = p.Results.M_VG;
T = p.Results.T;
K = p.Results.K;
option = p.Results.option;
delta_range = p.Results.delta_range;
delta_precision = p.Results.delta_precision;
dist = p.Results.dist;
lambda = p.Results.lambda;

dt = T/N;
ps = cond_prob_multinomial(M,delta,C_VG,G_VG,M_VG);
p_j = ps(1,:);
q_j = ps(2,:);
ps = [(1-p0)*p_j,p0,(1-p0)*q_j];
ps = floor(ps*10^5)/10^5;
x = -(1:M)*delta;
y = (1:M)*delta;
% states
% kill the hardcoding later
num_prices = 100;
[logS,S] = NUG(S_0,150,50,0.075,num_prices);

% payouts
f = zeros(num_prices,N+1,2);
f(:,1,1) = payoff(S,K,option);
f(:,1,2) = payoff(S,K,option);

% hedging vector
n = (delta_range(2)-delta_range(1))/delta_precision;
deltas = linspace(delta_range(1),delta_range(2),n); 
hedge_asks = zeros(1,n);

% optim section
for ii=2:(N+1) %time loop 
    for jj=1:num_prices %stock prices loop
        local_tree = exp([logS(jj)+x,logS(jj),logS(jj)+y]);
        local_tree_f = interp1(S,f(:,ii-1,1),local_tree,'PCHIP','extrap');
        [sorted_tree_f,I]=sort(local_tree_f,'descend');
        dist_cdf = distortion(cumsum(ps(I)),dist,lambda);
        dist_sorted_ps = [dist_cdf(1),diff(dist_cdf)];
        f(jj,ii,1) = exp(-r*dt)*sum((dist_sorted_ps).*(sorted_tree_f));
        for kk=1:n%delta hedge loop
            local_tree_f = interp1(S,f(:,ii-1,2),local_tree,'PCHIP','extrap');
            hedge = local_tree_f + deltas(kk)*(local_tree - exp(r*dt)*S(jj));
            [sorted_hedge,I]=sort(hedge,'descend');
            dist_cdf = distortion(cumsum(ps(I)),dist,lambda);
            dist_sorted_ps = [dist_cdf(1),diff(dist_cdf)];
            hedge_asks(kk) = exp(-r*dt)*sum((dist_sorted_ps).*(sorted_hedge));
        end
        f(jj,ii,2) = max(hedge_asks);
    end
end 
end