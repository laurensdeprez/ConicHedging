function p_dist = distortion(u,varargin)
    p = inputParser;
    defaultLabel = 'MinMaxVar';
    validLabel = {'MinVar','MaxVar','MinMaxVar','MaxMinVar','Wang'};
    checkLabel = @(x) any(validatestring(x,validLabel));
    defaultLambda = 0.25;
    addRequired(p,'u');
    addOptional(p,'label',defaultLabel,checkLabel);
    addOptional(p,'lambda',defaultLambda);
    parse(p,u,varargin{:});
    
    u = p.Results.u;
    label = p.Results.label;
    lambda = p.Results.lambda;
    % call a distortion function
    switch label 
        case 'MinVar'
            p_dist = MinVar(u,lambda);
        case 'MaxVar'
            p_dist = MaxVar(u,lambda);
        case 'MinMaxVar'
            p_dist = MinMaxVar(u,lambda);
        case 'MaxMinVar'
            p_dist = MaxVar(u,lambda);
        case 'Wang'
            p_dist = WangTrans(u,lambda);
    end 
end

