% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

%% calculates the Cox-Ross-Rubinstein up and down states of the binom. tree
function [u,d] = states_bin_tree(s,T)
    p = inputParser;
    addRequired(p,'s',@ispositive);
    addRequired(p,'T',@ispositive);
    parse(p,s,T);
    
    u = exp(p.Results.s*sqrt(p.Results.T)); % up state
    d = exp(-p.Results.s*sqrt(p.Results.T)); % down state
end

