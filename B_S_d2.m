% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

%% calculate the d2 of Black-Scholes call option
function d2 = B_S_d2(S_0,q,s,r,T,K)
    p = inputParser;
    addRequired(p,'S_0',@ispositive);
    addRequired(p,'q',@ispositive);
    addRequired(p,'s',@ispositive);
    addRequired(p,'r',@ispositive);
    addRequired(p,'T',@ispositive);
    addRequired(p,'K',@ispositive);
    parse(p,S_0,q,s,r,T,K);
    
    S_0 = p.Results.S_0;
    q = p.Results.q;
    s = p.Results.s;
    r = p.Results.r;
    T = p.Results.T;
    K = p.Results.K;
    d2 = (log(S_0./K)+(r-q-s^2/2)*T)/(s*sqrt(T));
end