% NOT TESTED
function d2 = B_S_d2(S_0,q,s,r,T,K)
    d2 = (log(S_0./K)+(r-q-s^2/2)*T)/(s*sqrt(T));
end