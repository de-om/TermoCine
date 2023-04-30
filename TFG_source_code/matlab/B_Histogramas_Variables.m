% Es necesaria la ejecución de A para B
A_Importar_Muestra_Procesar;

%% Parametros

% Clases lineales en DE y DH
N_HistoDE = 1000; % Numero de clases en Histograma Deltas E
N_HistoDH = 1000; % Numero de clases en Histograma Deltas H

% Razon de la progresion geometrica y el numero de clases
r = 1.8;
N_cl_Geom = 27;

% Clases logaritmicas en DE y DH
N_cl_logDE = 100;
N_cl_logDH = 100;


%% Histograma Clases Uniformes Linealmente

% Definimos los vectores de las clases (intervalo y punto medio)
xHistoDE = linspace(MinDE,MaxDE,N_HistoDE+1);
xHistoMedioDE = zeros(1,N_HistoDE);
xHistoDEabs = linspace(minAbsDE,maxAbsDE,N_HistoDE+1);
xHistoMedioDEabs = zeros(1,N_HistoDE);
for i=1:N_HistoDE
    xHistoMedioDE(i) = (xHistoDE(i)+xHistoDE(i+1))/2;
    xHistoMedioDEabs(i) = (xHistoDEabs(i)+xHistoDEabs(i+1))/2;
end
% Vectores de frecuencia de muestras en cada clase i
yHistoDE = zeros(1,N_HistoDE);
yHistoDEabs = zeros(1,N_HistoDE);

for i=1:N_frames
    for j=1:N_HistoDE
        if Delta_E(i)<=xHistoDE(j+1) && Delta_E(i)>=xHistoDE(j)
            yHistoDE(j) = yHistoDE(j)+1;
        end
        if absDE(i)<=xHistoDEabs(j+1) && absDE(i)>=xHistoDEabs(j)
            yHistoDEabs(j) = yHistoDEabs(j)+1;
        end
    end
end


% Histograma Clases Unif. Linealmente en DH

xHistoDH = linspace(MinDH,MaxDH,N_HistoDH+1);
xHistoDHabs = linspace(minAbsDH,maxAbsDH,N_HistoDH+1);
xHistoMedioDH = zeros(1,N_HistoDH);
xHistoMedioDHabs = zeros(1,N_HistoDH);
for i=1:N_HistoDH
    xHistoMedioDH(i) = (xHistoDH(i)+xHistoDH(i+1))/2;
    xHistoMedioDHabs(i) = (xHistoDHabs(i)+xHistoDHabs(i+1))/2;
end
yHistoDH = zeros(1,N_HistoDH);
yHistoDHabs = zeros(1,N_HistoDH);

for i=1:N_frames
    for j=1:N_HistoDH
        if Delta_H(i)<=xHistoDH(j+1) && Delta_H(i)>=xHistoDH(j)
            yHistoDH(j) = yHistoDH(j)+1;
        end
        if absDH(i)<=xHistoDHabs(j+1) && absDH(i)>=xHistoDHabs(j)
            yHistoDHabs(j) = yHistoDHabs(j)+1;
        end
    end
end


%% Histograma Clases Progresion Geometrica

% Clases Prog. Geometrica en DE
N = N_cl_Geom;
a1 = (maxAbsDE-minAbsDE)/((r^(N+1)-1)/(r-1));

xGeomDE = zeros(1,N+1);
xGeomDEmed = zeros(1,N);
dx_geomDE = zeros(1,N);
for i=1:N
    xGeomDE(i+1)=xGeomDE(i)+a1*r^(i);
    xGeomDEmed(i) = (xGeomDE(i)+xGeomDE(i+1))/2;
    dx_geomDE(i) = xGeomDE(i+1)-xGeomDE(i);
end

yHistoGeomDE = zeros(1,N);
for j=1:N
    for i=1:N_frames
        if absDE(i)<=xGeomDE(j+1) && absDE(i)>=xGeomDE(j)
            yHistoGeomDE(j) = yHistoGeomDE(j)+1;
        end
    end
    yHistoGeomDE(j) = yHistoGeomDE(j)/dx_geomDE(j);
end

% Clases Prog. Geometrica en DH
N = N_cl_Geom;
a1 = (maxAbsDH-minAbsDH)/((r^(N+1)-1)/(r-1));

xGeomDH = zeros(1,N+1);
xGeomDHmed = zeros(1,N);
dx_geomDH = zeros(1,N);
for i=1:N
    xGeomDH(i+1)=xGeomDH(i)+a1*r^(i);
    xGeomDHmed(i) = (xGeomDH(i)+xGeomDH(i+1))/2;
    dx_geomDH(i) = xGeomDH(i+1)-xGeomDH(i);
end

yHistoGeomDH = zeros(1,N);
for j=1:N
    for i=1:N_frames
        if absDH(i)<=xGeomDH(j+1) && absDH(i)>=xGeomDH(j)
            yHistoGeomDH(j) = yHistoGeomDH(j)+1;
        end
    end
    yHistoGeomDH(j) = yHistoGeomDH(j)/dx_geomDH(j);
end


%% Histogramas de clases uniformes en escala logaritmica 

% Histograma Clases Unif. Logaritmicamente en DE
minAbsDE_0 = 1;
for i=1:N_frames
    if absDE(i) ~= 0 && minAbsDE_0 > absDE(i)
        minAbsDE_0 = absDE(i);
    end
end

x_logDE_gr = linspace(log10(minAbsDE_0),log10(maxAbsDE),N_cl_logDE+1);
x_logDE_m = zeros(1,N_cl_logDE);
dx_log_E = zeros(1,N_cl_logDE);
for i=1:N_cl_logDE
    x_logDE_m(i) = (x_logDE_gr(i)+x_logDE_gr(i+1))/2;
    dx_log_E(i) = 10^x_logDE_gr(i+1)-10^x_logDE_gr(i);
end

frames_0_E = 0;
frecLogDE = zeros(1,N_cl_logDE);
f_sin_div = zeros(1,N_cl_logDE); % f sin dividir por el tamaño de clase
for j=1:N_cl_logDE
    for i=1:N_frames
        if absDE(i) < minAbsDE_0
            frames_0_E = frames_0_E+1;
        else
            if log10(absDE(i))>=x_logDE_gr(j) && ...
                    log10(absDE(i))<=x_logDE_gr(j+1)
                frecLogDE(j) = frecLogDE(j)+1;
            end
        end
    end
    f_sin_div(j) = frecLogDE(j); % solo para comparar resultados
    frecLogDE(j) = frecLogDE(j)/dx_log_E(j);
end


% Histograma Clases Unif. Logaritmicamente en DH
minAbsDH_0 = 1;
for i=1:N_frames
    if absDH(i) ~= 0 && minAbsDH_0 > absDH(i)
        minAbsDH_0 = absDH(i);
    end
end

x_logDH_gr = linspace(log10(minAbsDH_0),log10(maxAbsDH),N_cl_logDH+1);
x_logDH_m = zeros(1,N_cl_logDH);
dx_log_H = zeros(1,N_cl_logDH);
for i=1:N_cl_logDH
    x_logDH_m(i) = (x_logDH_gr(i)+x_logDH_gr(i+1))/2;
    dx_log_H(i) = 10^x_logDH_gr(i+1)-10^x_logDH_gr(i);
end

frames_0_H = 0;
frecLogDH = zeros(1,N_cl_logDH);
for j=1:N_cl_logDH
    for i=1:N_frames
        if absDH(i) < minAbsDH_0
            frames_0_H = frames_0_H+1;
        else
            if log10(absDH(i))>=x_logDH_gr(j) && ...
                    log10(absDH(i))<=x_logDH_gr(j+1)
                frecLogDH(j) = frecLogDH(j)+1;
            end
        end
    end
    frecLogDH(j) = frecLogDH(j)/dx_log_H(j);
end


%% Figuras de histogramas (lineales, geometricos y logaritmicos)
if grafsOn

    % Histograma de Delta_E (Figura 4)
    figure('Name','Histograma de Energias')
        subplot(2,1,1)
    bar(xHistoMedioDE,yHistoDE,1)
    xlabel('\DeltaE')
    ylabel('Frecuencia \DeltaE')
    grid on; xlim([-5 5])
        subplot(2,1,2)
    bar(xHistoMedioDE,yHistoDE,1)
    xlabel('\DeltaE')
    ylabel('Frecuencia \DeltaE')
    set(gca, 'YScale', 'log')
    grid on; xlim([-100 100])

    % Histograma de Delta_H (Figura 5)
    figure('Name','Histograma de Entropia')
    bar(xHistoMedioDH,yHistoDH,1)
    xlabel('\DeltaH')
    ylabel('Ocurrencias \DeltaH')
    grid on; set(gca, 'YScale', 'log')
    xlim([-2 2])
    
    % Histograma de Energias en valor absoluto (Figura 6 - N=100)
    figure('Name','Histograma de Energias')
        subplot(3,1,1)
    bar(xHistoMedioDEabs,yHistoDEabs,1)
    xlabel('\DeltaE')
    ylabel('Frecuencia')
    grid on; axis tight
    xlim([0 100])
        subplot(3,1,2)
    bar(xHistoMedioDEabs,yHistoDEabs,1)
    xlabel('\DeltaE')
    ylabel('Frecuencia')
    set(gca, 'YScale', 'log')
    grid on; axis tight
    xlim([0 100])
        subplot(3,1,3)
    loglog(xHistoMedioDEabs,yHistoDEabs,'.')
    xlabel('\DeltaE')
    ylabel('Frecuencia')
    grid on; axis tight
    xlim([0 100])
    
    % Histograma loglog (Figura 7 N=1000 y Figura 8 N=10000)
    
    figure('Name','Histograma de Energias - loglog')
    loglog(xHistoMedioDEabs,yHistoDEabs,'.')
    xlabel('\DeltaE')
    ylabel('Frecuencia')
    grid on; axis tight

    % Visualizacion de las clases geometricas
    figure('Name','Histogramas clases geom. (Fig. 9 r=1.8 y Fig. 10 r=1.1')
        subplot(2,1,1)
    loglog(xGeomDEmed,yHistoGeomDE,'o')
    xlabel('\DeltaE')
    ylabel('Frecuencia / ancho-clase')
    grid on; axis tight
        subplot(2,1,2)
    loglog(xGeomDHmed,yHistoGeomDH,'o')
    xlabel('\DeltaH')
    ylabel('Frecuencia / ancho-clase')
    grid on; axis tight

    % Histograma sin tener en cuenta el ancho de clase
    figure('Name','Hist. log sin ancho clase (Figura 11 N=1000)')
        subplot(2,1,1)
    plot(10.^(x_logDE_m),f_sin_div,'.')
    xlabel('\DeltaE')
    ylabel('Frecuencia')
    grid on; axis tight
    set(gca, 'XScale', 'log')
        subplot(2,1,2)
    loglog(10.^x_logDE_m,f_sin_div,'.')
    xlabel('\DeltaE')
    ylabel('Frecuencia')
    grid on; axis tight

    % Histograma considerando el ancho de clase
    figure('Name','Hist. log sin ancho clase (Figura 12 N=1000)')
        subplot(2,1,1)
    plot(10.^(x_logDE_m),frecLogDE,'.')
    xlabel('\DeltaE')
    ylabel('Frecuencia')
    grid on; axis tight
    set(gca, 'XScale', 'log')
        subplot(2,1,2)
    loglog(10.^x_logDE_m,frecLogDE,'.')
    xlabel('\DeltaE')
    ylabel('Frecuencia')
    grid on; axis tight

end

%%
clear a1 eqn x1 x2 y1 y2 S N 