function d1 = B_S_d1(S_0,q,s,r,T,K)
    d1 = (log(S_0./K)+(r-q+s^2/2)*T)/(s*sqrt(T));
end

