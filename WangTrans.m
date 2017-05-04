% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

%% Wang transformation
function p_dist = WangTrans(u,varargin)
    p = inputParser;
    addRequired(p,'u',@isprobability);
    addRequired(p,'lambda',@ispositive)
    parse(p,u,varargin{:});
    
    p_dist = normcdf(norminv(p.Results.u)+ p.Results.lambda);
end 