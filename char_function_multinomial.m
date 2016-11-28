function phi = char_function_multinomial(M,u,delta,p,p_j,q_j,N)
    x = -(1:M)*delta;
    y = (1:M)*delta;
    phi = zeros(length(u),1);
    for ii=1:length(u)
        phi(ii) = (p + (1-p)*sum(p_j.*exp(1i*u(ii)*x)+q_j.*exp(1i*u(ii)*y)))^N;
    end
end

