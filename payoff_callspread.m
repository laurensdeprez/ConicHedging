% This file is part of ConicHedging
% Copyright (c) 2017 Laurens Deprez and Wim Schoutens
% License: BSD 3-clause (see file LICENSE)

%% payoff of callspread option
function f = payoff_callspread(S_T,K)
    p = inputParser();
    addRequired(p,'S_T',@ispositive);
    addRequired(p,'K',@(x)validateattributes(x,{'numeric'},{'numel',2,'increasing','positive'}));
    parse(p,S_T,K);
    
    S_T = p.Results.S_T;
    K = p.Results.K;
    f = max(0,S_T-K(1))-max(0,S_T-K(2));
end

