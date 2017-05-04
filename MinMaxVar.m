% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

%% MINMAXVAR distortion function
function p_dist = MinMaxVar(u,varargin)
    p = inputParser;
    addRequired(p,'u',@isprobability);
    addRequired(p,'lambda',@ispositive)
    parse(p,u,varargin{:});
    
    p_dist = 1-(1-p.Results.u.^(1/(p.Results.lambda+1))).^(1+p.Results.lambda);
end 