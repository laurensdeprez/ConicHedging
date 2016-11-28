function x = fit_multinomial_VG(M,N,C_VG,G_VG,M_VG,x0)
    fun1 = @(u,x)(abs(char_function_VG(u,C_VG,G_VG,M_VG)-char_function_multinomial(M,u,x(1),x(2),N,C_VG,G_VG,M_VG)));
    fun2 = @(x)(integral(@(u)fun1(u,x), -20, 20,'ArrayValued',true));
    x = fminunc(fun2,x0);
end

