% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

%% up, middle and down state for a trinomial tree
function [u,m,d] = states_tri_tree(r,s,T)
    p = inputParser;
    addRequired(p,'r',@ispositive);
    addRequired(p,'s',@ispositive);
    addRequired(p,'T',@ispositive);
    parse(p,r,s,T);
    
    r = p.Results.r;
    s = p.Results.s;
    T = p.Results.T;
    u = exp((r-s^2/2)*T+s*sqrt(3*T)); % up state
    m = exp((r-s^2/2)*T);             % middle state
    d = exp((r-s^2/2)*T-s*sqrt(3*T)); % down state
end

