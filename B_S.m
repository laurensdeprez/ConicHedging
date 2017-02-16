function S_T = B_S(S_0,q,s,r,T,N)
    p = inputParser;
    addRequired(p,'S_0',@ispositive);
    addRequired(p,'q',@isnumeric);
    addRequired(p,'s',@ispositive);
    addRequired(p,'r',@ispositive);
    addRequired(p,'T',@ispositive);
    addRequired(p,'N',@ispositive);
    parse(p,S_0,q,s,r,T,N);
    S_0 = p.Results.S_0;
    q = p.Results.q;
    s = p.Results.s;
    r = p.Results.r;
    T = p.Results.T;
    N = p.Results.N;
    % Monte Carlo 
    W = normrnd(0,sqrt(T),[N,1]);
    S_T = S_0*exp((r-q-s^2/2)*T+s*W);
end

