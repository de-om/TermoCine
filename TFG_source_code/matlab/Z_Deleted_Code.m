%% Z_Cinemetrics

% Acumulada usando length_sorted en los x_dx
frec_x_sorted = zeros(1,N_dx_acum);
j=1;
for i=1:N_planos
    while x_dx_acumgr(j) < length_sorted(i) && j~=N_dx_acum
        j=j+1;
    end
    if x_dx_acumgr(j) >= length_sorted(i) || i==N_planos
        frec_x_sorted(j) = (N_planos+1-i)*dx_acum;
    end
end
for i=(N_dx_acum-1):-1:1
    if frec_x_sorted(i) == 0
        frec_x_sorted(i) = frec_x_sorted(i+1);
    end
end
frec_x_sorted = frec_x_sorted / (N_planos*dx_acum);

%%
