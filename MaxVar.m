
%% MAXVAR distortion function
function p_dist = MaxVar(u,varargin)
    p = inputParser;
    defaultLambda = 0.25;
    addRequired(p,'u',@isprobability);
    addOptional(p,'lambda',defaultLambda,@ispositive)
    parse(p,u,varargin{:});
    
    p_dist = p.Results.u .^(1/(1+p.Results.lambda));
end 