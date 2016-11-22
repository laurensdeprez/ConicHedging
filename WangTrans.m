%% Wang transformation
function p_dist = WangTrans(u,varargin)
    p = inputParser;
    defaultLambda = 0.25;
    addRequired(p,'u',@isprobability);
    addOptional(p,'lambda',defaultLambda,@ispositive)
    parse(p,u,varargin{:});
    
    p_dist = normcdf(norminv(p.Results.u)+ p.Results.lambda);
end 