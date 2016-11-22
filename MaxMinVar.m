%% MAXMINVAR distortion function
function p_dist = MaxMinVar(u,varargin)
    p = inputParser;
    defaultLambda = 0.25;
    addRequired(p,'u',@isprobability);
    addOptional(p,'lambda',defaultLambda,@ispositive)
    parse(p,u,varargin{:});
    
    p_dist = 1-(1-p.Results.u.^(p.Results.lambda+1)).^(1/(1+p.Results.lambda));
end 