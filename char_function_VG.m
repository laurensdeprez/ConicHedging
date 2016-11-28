function phi_VG = char_function_VG(u,C_VG,G_VG,M_VG)
    phi_VG = zeros(length(u),1);
    for ii=1:length(u)
        phi_VG(ii) = (G_VG*M_VG./(G_VG*M_VG+(M_VG-G_VG)*1i*u(ii)+u(ii).^2)).^C_VG;
    end
end

