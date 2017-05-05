% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

%% conditional jump probabilities for multinomial tree approximation of VG process
function ps = cond_prob_multinomial(M,delta,C_VG,G_VG,M_VG)
    p = inputParser();
    addRequired(p,'M',@ispositive);
    addRequired(p,'delta',@isnumeric);
    addRequired(p,'C_VG',@ispositive);
    addRequired(p,'G_VG',@ispositive);
    addRequired(p,'M_VG',@ispositive);
    parse(p,M,delta,C_VG,G_VG,M_VG);
    
    M = p.Results.M;
    delta = p.Results.delta;
    C_VG = p.Results.C_VG;
    G_VG = p.Results.G_VG;
    M_VG = p.Results.M_VG;
    B = zeros(1,M);
    fun = @(x) C_VG*exp(-M_VG*x)/x;
    for ii=1:M
        B(ii) = integral(fun, (ii-0.5)*delta,(ii+0.5)*delta,'ArrayValued',true);
    end
    A = zeros(1,M);
    fun = @(x) C_VG*exp(G_VG*x)/abs(x);
    for ii=1:M
        A(ii) = integral(fun, -(ii+0.5)*delta, -(ii-0.5)*delta,'ArrayValued',true);
    end 

    p_j = (A/sum(A+B));
    q_j = (B/sum(A+B));
    ps = [p_j; q_j];
end