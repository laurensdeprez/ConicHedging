% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

%% characteristic function of multinomial tree
function phi = char_function_multinomial(M,u,delta,p,N,C_VG,G_VG,M_VG)
    p1 = inputParser();
    addRequired(p1,'M',@ispositive);
    addRequired(p1,'u',@isnumeric);
    addRequired(p1,'delta',@isnumeric);
    addRequired(p1,'p',@isnumeric);
    addRequired(p1,'N',@ispositive);
    addRequired(p1,'C_VG',@ispositive);
    addRequired(p1,'G_VG',@ispositive);
    addRequired(p1,'M_VG',@ispositive);
    parse(p1,M,u,delta,p,N,C_VG,G_VG,M_VG);
    
    M = p1.Results.M;
    u = p1.Results.u;
    delta = p1.Results.delta;
    p = p1.Results.p;
    N = p1.Results.N;
    C_VG = p1.Results.C_VG;
    G_VG = p1.Results.G_VG;
    M_VG = p1.Results.M_VG;
    ps = cond_prob_multinomial(M,delta,C_VG,G_VG,M_VG);
    p_j = ps(1,:);
    q_j = ps(2,:);
    x = -(1:M)*delta;
    y = (1:M)*delta;
    phi = (p + (1-p)*(p_j*exp(1i*transpose(x)*u)+q_j*exp(1i*transpose(y)*u))).^N;
end

