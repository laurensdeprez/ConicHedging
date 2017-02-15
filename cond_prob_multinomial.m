function ps = cond_prob_multinomial(M,delta,C_VG,G_VG,M_VG)
    B = zeros(1,M);
    fun = @(x) C_VG*exp(-M_VG*x)/x;
    for ii=1:M
        B(ii) = integral(fun, (ii-0.5)*delta,(ii+0.5)*delta,'ArrayValued',true);
    end
    A = zeros(1,M);
    fun = @(x) C_VG*exp(G_VG*x)/abs(x);
    for ii=1:M
        A(ii) = integral(fun, -(ii+0.5)*delta, -(ii-0.5)*delta,'ArrayValued',true);
    end 

    p_j = (A/sum(A+B));
    q_j = (B/sum(A+B));
    ps = [p_j; q_j];
end