function S_T = VG_stock(S_0,q,s,v,th,r,T,N)
    p = inputParser;
    addRequired(p,'S_0',@ispositive);
    addRequired(p,'q',@isnumeric);
    addRequired(p,'s',@ispositive);
    addRequired(p,'v',@ispositive);
    addRequired(p,'th',@isnumeric);
    addRequired(p,'r',@ispositive);
    addRequired(p,'T',@ispositive);
    addRequired(p,'N',@ispositive);
    parse(p,S_0,q,s,v,th,r,T,N);
    S_0 = p.Results.S_0;
    q = p.Results.q;
    s = p.Results.s;
    v = p.Results.v;
    th = p.Results.th;
    r = p.Results.r;
    T = p.Results.T;
    N = p.Results.N;
    % Monte Carlo 
    [C_VG,G_VG,M_VG] = VG_param(s,v,th);
    X = gamrnd(T*C_VG,1/M_VG,[N,1]);
    Y = gamrnd(T*C_VG,1/G_VG,[N,1]);
    V = X-Y;
    omega= 1/v*log(1-s^2*v/2-th*v);
    S_T = S_0*exp((r-q+omega)*T+V);
end

