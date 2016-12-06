function f = payoff_call(S_T,K)
    p = inputParser();
    addRequired(p,'S_T',@(x)validateattributes(x,{'numeric'},{'positive'}));
    addRequired(p,'K',@(x)validateattributes(x,{'numeric'},{'numel',1,'positive'}));
    parse(p,S_T,K);
    S_T = p.Results.S_T;
    K = p.Results.K;
    f = max(0,S_T-K);
end