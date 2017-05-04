% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

%% general payoff function
function f = payoff(S_T,K,type)
    p = inputParser();
    validType = {'call','put','callspread','straddle'};
    checkType = @(x) any(validatestring(x,validType));
    addRequired(p,'S_T');
    addRequired(p,'K');
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
        case 'callspread'
            f = payoff_callspread(S_T,K);
        case 'straddle'
            f = payoff_straddle(S_T,K);
    end
end