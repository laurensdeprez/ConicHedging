% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

%% characteristic function of VG process
function phi_VG = char_function_VG(u,C_VG,G_VG,M_VG)
    p1 = inputParser();
    addRequired(p1,'u',@isnumeric);
    addRequired(p1,'C_VG',@ispositive);
    addRequired(p1,'G_VG',@ispositive);
    addRequired(p1,'M_VG',@ispositive);
    parse(p1,u,C_VG,G_VG,M_VG);
    
    u = p1.Results.u;
    C_VG = p1.Results.C_VG;
    G_VG = p1.Results.G_VG;
    M_VG = p1.Results.M_VG;
    phi_VG = (G_VG*M_VG./(G_VG*M_VG+(M_VG-G_VG)*1i*u+u.^2)).^C_VG;
end

