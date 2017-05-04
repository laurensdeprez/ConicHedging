% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

%% risk neutral price of European call under Black-Scholes
function price = risk_neutral_EC_B_S(S_0,s,q,r,T,K)
p = inputParser;
addRequired(p,'S_0');
addRequired(p,'s',@ispositive);
addRequired(p,'q',@ispositive);
addRequired(p,'r',@ispositive);
addRequired(p,'T',@ispositive);
addRequired(p,'K');
parse(p,S_0,s,q,r,T,K);
S_0 = p.Results.S_0;
s = p.Results.s;
q = p.Results.q;
r = p.Results.r;
T = p.Results.T;
K = p.Results.K;

d1 = (log(S_0/K)+(r-q+s^2/2)*T)/(s*sqrt(T));
d2 = d1 - s*sqrt(T);

%price
price = exp(-q*T)*S_0*normcdf(d1) - exp(-r*T)*K*normcdf(d2);
end

