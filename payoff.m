function f = payoff(S_T,K,type)
    switch type
        case 'call'
            f = payoff_call(S_T,K);        
        case 'put'
            f = payoff_put(S_T,K);         
        otherwise
            error('option_type should be "put" or "call"')
    end
end