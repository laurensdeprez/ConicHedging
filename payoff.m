function f = payoff(S_T,K,type)
    p = inputParser();
    validType = {'call','put'};
    checkType = @(x) any(validatestring(x,validType));
    addRequired(p,'S_T',@ispositive);
    addRequired(p,'K',@ispositive);
    addRequired(p,'type',checkType);
    parse(p,S_T,K,type);
    S_T = p.Results.S_T;
    K = p.Results.K;
    type = p.Results.type;
    switch type
        case 'call'
            f = payoff_call(S_T,K);        
        case 'put'
            f = payoff_put(S_T,K);         
    end
end