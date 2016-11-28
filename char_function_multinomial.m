function phi = char_function_multinomial(M,u,delta,p,N,C_VG,G_VG,M_VG)
    ps = cond_prob_multinomial(M,delta,C_VG,G_VG,M_VG);
    p_j = ps(1,:);
    q_j = ps(2,:);
    x = -(1:M)*delta;
    y = (1:M)*delta;
    phi = (p + (1-p)*(p_j*exp(1i*transpose(x)*u)+q_j*exp(1i*transpose(y)*u))).^N;
end

