% Es necesaria la ejecución de A, B, C y D para E 
D_Det_Segmentos;

%%%%%%%%%%%%%%%%
grafsOn = false;
%%%%%%%%%%%%%%%%
%% Parametros

% Numero de diferenciales para integrar la distr. acumulada (clases dx)
N_dx_acum = 100;


%% Distribucion acumulada


% Acumulada integrando con dx

% Incremento para barrer el eje x_min -> x_max (en E y H)
dx_acumE = (durMaxE-durMinE)/N_dx_acum; 
dx_acumH = (durMaxH-durMinH)/N_dx_acum;
% Vectores contenedor y pto- medio de clase (para segmentos E y H)
x_dx_acumgrE = zeros(1,N_dx_acum+1);
x_dx_acumgrE(1) = durMinE;
x_dx_acumedE = zeros(1,N_dx_acum);
x_dx_acumgrH = zeros(1,N_dx_acum+1);
x_dx_acumgrH(1) = durMinH;
x_dx_acumedH = zeros(1,N_dx_acum);
% Variable P(X) para la distribucion de segmentos obtenidos con E y H
f_x_dx_acumE = zeros(1,N_dx_acum);
f_x_dx_acumH = zeros(1,N_dx_acum);
for i=1:N_dx_acum
    x_dx_acumgrE(i+1) = x_dx_acumgrE(i) + dx_acumE;
    x_dx_acumedE(i) = (x_dx_acumgrE(i+1) + x_dx_acumgrE(i))/2;
    x_dx_acumgrH(i+1) = x_dx_acumgrH(i) + dx_acumH;
    x_dx_acumedH(i) = (x_dx_acumgrH(i+1) + x_dx_acumgrH(i))/2;
    for j=1:PlanosReferencia
        if segmento_U_DE(j,2)>=x_dx_acumgrE(i)
            f_x_dx_acumE(i) = f_x_dx_acumE(i) + 1;
        end
        if segmento_U_DH(j,2)>=x_dx_acumgrH(i)
            f_x_dx_acumH(i) = f_x_dx_acumH(i) + 1;
        end
    end
end
f_x_dx_acumE = f_x_dx_acumE/PlanosReferencia;
f_x_dx_acumH = f_x_dx_acumH/PlanosReferencia;


% Acumulada usando los puntos Xi

% Ordenamos los puntos para simplificar el algoritmo de integración en los 
% puntos Xi (con muestras) usando el vector ordenado
segmE_sorted = sort(segmento_U_DE(:,2));
segmH_sorted = sort(segmento_U_DH(:,2));
lastdurE = segmE_sorted(1);
lastdurH = segmH_sorted(1);
% Cantidad de valores de duracion de los segmentos
n_x_durE = 1; 
n_x_durH = 1;
% Frecuencia de cada valor de duracion Xi
f_segmE_i(1) = 0;
f_segmH_i(1) = 0;
for i=1:PlanosReferencia
    if lastdurE == segmE_sorted(i)
        x_segmE(n_x_durE) = lastdurE;
        f_segmE_i(n_x_durE) = f_segmE_i(n_x_durE) + 1;
    else
        n_x_durE = n_x_durE+1;
        f_segmE_i(n_x_durE) = 1;
        lastdurE = segmE_sorted(i);
        x_segmE(n_x_durE) = lastdurE;
    end
    if lastdurH == segmH_sorted(i)
        x_segmH(n_x_durH) = lastdurH;
        f_segmH_i(n_x_durH) = f_segmH_i(n_x_durH) + 1;
    else
        n_x_durH = n_x_durH+1;
        f_segmH_i(n_x_durH) = 1;
        lastdurH = segmH_sorted(i);
        x_segmH(n_x_durH) = lastdurH;
    end
end

% Hacemos la acumulada a la derecha para segmentos E
F_acumE_i = zeros(1,n_x_durE);
F_acumE_i(1) = PlanosReferencia;
for i=2:n_x_durE
    F_acumE_i(i) = F_acumE_i(i-1) - f_segmE_i(i-1);
end
F_acumE_i = F_acumE_i/PlanosReferencia;

% Hacemos la acumulada a la derecha para segmentos H
F_acumH_i = zeros(1,n_x_durH);
F_acumH_i(1) = PlanosReferencia;
for i=2:n_x_durH
    F_acumH_i(i) = F_acumH_i(i-1) - f_segmH_i(i-1);
end
F_acumH_i = F_acumH_i/PlanosReferencia;


%% Figuras
if grafsOn

    % Comparacion entre acumulado dx y Xi (zoom en b y c)
    figure('Name','Distr. acumuladas dx y Xi (E) (Figura 19)')
        subplot(3,1,1)
    loglog(x_dx_acumgrE(1:N_dx_acum),f_x_dx_acumE,'.-'); hold on
    loglog(x_segmE,F_acumE_i,'.-'); hold off
    grid on; axis tight
    xlabel('Frames de duracion')
    ylabel('P(x)')
    legend('Distr. acum. dx duraciones (segm. E)', ...
           'Distr. acum. Xi duraciones (segm. E)')
        subplot(3,1,2)
    loglog(x_dx_acumgrE(1:N_dx_acum),f_x_dx_acumE,'.-'); hold on
    loglog(x_segmE,F_acumE_i,'.-'); hold off
    grid on; axis tight
    xlabel('Frames de duracion')
    ylabel('P(x)')
        subplot(3,1,3)
    loglog(x_dx_acumgrE(1:N_dx_acum),f_x_dx_acumE,'.-'); hold on
    loglog(x_segmE,F_acumE_i,'.-'); hold off
    grid on; axis tight
    xlabel('Frames de duracion')
    ylabel('P(x)')

    % Comparacion entre distribucion de segE y segH
    figure('Name','Comparar dist. segE-segH (dx) (Figura 20)')
    loglog(x_segmE,F_acumE_i,'.-'); hold on
    loglog(x_segmH,F_acumH_i,'.-'); hold off
    grid on; axis tight
    xlabel('Frames de duracion')
    ylabel('P(x)')
    legend('Distribucion acumulada de segmentos con E', ...
           'Distribucion acumulada de segmentos con H')

end

%%
clear x_dx_acumedE x_dx_acumgrE f_x_dx_acumE dx_acumE
clear x_dx_acumedH x_dx_acumgrH f_x_dx_acumH dx_acumH