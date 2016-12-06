function [C_VG,G_VG,M_VG] = VG_param(s,v,th)
    p = inputParser();
    addRequired(p,'s');
    addRequired(p,'v');
    addRequired(p,'th');
    parse(p,s,v,th);
    s = p.Results.s;
    v = p.Results.v;
    th = p.Results.th;
    C_VG = 1/v;
    G_VG = 1/(sqrt(th^2*v^2/4+s^2*v/2)-th*v/2);
    M_VG = 1/(sqrt(th^2*v^2/4+s^2*v/2)+th*v/2);
end

