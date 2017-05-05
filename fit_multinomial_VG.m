% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

%% fit multinomial tree to VG process by matching characteristic functions
function x = fit_multinomial_VG(M,N,C_VG,G_VG,M_VG,x0)
    p = inputParser();
    addRequired(p,'M',@ispositive);
    addRequired(p,'N',@ispositive);
    addRequired(p,'C_VG',@ispositive);
    addRequired(p,'G_VG',@ispositive);
    addRequired(p,'M_VG',@ispositive);
    addRequired(p,'x0',@(x)validateattributes(x,{'numeric'},{'numel',2,'positive'}));
    parse(p,M,N,C_VG,G_VG,M_VG,x0);
    
    M = p.Results.M;
    N = p.Results.N;
    C_VG = p.Results.C_VG;
    G_VG = p.Results.G_VG;
    M_VG = p.Results.M_VG;
    x0 = p.Results.x0;
    fun1 = @(u,x)(abs(char_function_VG(u,C_VG,G_VG,M_VG)-char_function_multinomial(M,u,x(1),x(2),N,C_VG,G_VG,M_VG)));
    fun2 = @(x)(integral(@(u)fun1(u,x), -20, 20,'ArrayValued',true));
    x = fminunc(fun2,x0);
end

