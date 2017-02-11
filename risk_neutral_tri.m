function price = risk_neutral_tri(S_0,s,r,T,K,option)
p = inputParser;
addRequired(p,'S_0');
addRequired(p,'s',@ispositive);
addRequired(p,'r',@ispositive);
addRequired(p,'T',@ispositive);
addRequired(p,'K');
addRequired(p,'option');
parse(p,S_0,s,r,T,K,option);
S_0 = p.Results.S_0;
s = p.Results.s;
r = p.Results.r;
T = p.Results.T;
K = p.Results.K;
option = p.Results.option;
%states
[u,m,d] = states_tri_tree(r,s,T);
%payouts
f_u = payoff(u*S_0,K,option);
f_m = payoff(m*S_0,K,option);
f_d = payoff(d*S_0,K,option);
f = [f_u,f_m,f_d];
%jump probabilities
p_u = 1/6;                        % jump up 
p_m = 2/3;                        % jump middle
p_d = 1/6;                        % jump down
ps = [p_u,p_m,p_d];
%price
price = exp(-r*T)*sum(f.*ps);
end

