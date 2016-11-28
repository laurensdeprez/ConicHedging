function phi_VG = char_function_VG(u,C_VG,G_VG,M_VG)
      phi_VG = (G_VG*M_VG./(G_VG*M_VG+(M_VG-G_VG)*1i*u+u.^2)).^C_VG;
end

