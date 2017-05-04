% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

%% MAXVAR distortion function
function p_dist = MaxVar(u,varargin)
    p = inputParser;
    addRequired(p,'u',@isprobability);
    addRequired(p,'lambda',@ispositive)
    parse(p,u,varargin{:});
    
    p_dist = p.Results.u .^(1/(1+p.Results.lambda));
end 