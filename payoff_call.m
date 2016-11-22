function f = payoff_call(S_T,K)
    f = max(0,S_T-K);
end