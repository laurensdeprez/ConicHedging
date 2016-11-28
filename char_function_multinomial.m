function phi = char_function_multinomial(M,u,delta,p,p_j,q_j,N)
    x = -(1:M)*delta;
    y = (1:M)*delta;
    phi = (p + (1-p)*(p_j*exp(1i*transpose(x)*u)+q_j*exp(1i*transpose(y)*u))).^N;
end

