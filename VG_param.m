% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

%% change variance gamma parametrisation
function [C_VG,G_VG,M_VG] = VG_param(s,v,th)
    p = inputParser();
    addRequired(p,'s',@ispositive);
    addRequired(p,'v',@ispositive);
    addRequired(p,'th',@isnumeric);
    parse(p,s,v,th);
    s = p.Results.s;
    v = p.Results.v;
    th = p.Results.th;
    C_VG = 1/v;
    G_VG = 1/(sqrt(th^2*v^2/4+s^2*v/2)-th*v/2);
    M_VG = 1/(sqrt(th^2*v^2/4+s^2*v/2)+th*v/2);
end

