clear

archivoCM = 'cinemetrics/CM_inception.txt';

%% Datos de BMPread
dataCM = importdata(archivoCM);

shot_i       = dataCM(:,1); % numero de plano
length       = dataCM(:,2); % duracion de plano
shotend_time = dataCM(:,3); % instante final del plano en decisegundos

N_planos     = max(shot_i); % cantidad de planos
duracionMin  = min(length);
duracionMax  = max(length);


%% Histogramas de la muestra

N_clases = 20; % numero de clases en los histogramas lineal y logaritmico

% Lineal
X_lineal = linspace(duracionMin,duracionMax,N_clases+1); % limites de clase
X_linmed = zeros(1,N_clases); % punto medio de cada clase
for i=1:N_clases
    X_linmed(i) = (X_lineal(i)+X_lineal(i+1))/2;
end
dx_lin = X_lineal(2)-X_lineal(1); % ancho de clase

f_x_lin = zeros(1,N_clases); % numero de muestras en cada clase
for j=1:N_clases
    for i=1:N_planos
        if length(i)<=X_lineal(j+1) && length(i)>=X_lineal(j)
            f_x_lin(j) = f_x_lin(j)+1/N_planos;
        end
    end
end
f_x_lin = f_x_lin/dx_lin;

% Logaritmico 
X_logari = linspace(log10(duracionMin),log10(duracionMax),N_clases+1);
X_logmed = zeros(1,N_clases);
dx_log = zeros(1,N_clases);
for i=1:N_clases
    X_logmed(i) = (X_logari(i)+X_logari(i+1))/2;
    dx_log(i) = 10^X_logari(i+1)-10^X_logari(i);
end

f_x_log = zeros(1,N_clases);
for j=1:N_clases
    for i=1:N_planos
        if log10(length(i))<=X_logari(j+1) && log10(length(i))>=X_logari(j)
            f_x_log(j) = f_x_log(j)+1/N_planos;
        end
    end
    f_x_log(j) = f_x_log(j)/dx_log(j);
end


%% Calculo de la distribucion acumulada

% Recuento de valores discretos de las duraciones
length_sorted = sort(length);
lastdur = length_sorted(1);
n_dur_i = 1;
F_dur_i(1) = 0;
for i=1:N_planos
    if lastdur == length_sorted(i)
        x_dur_i(n_dur_i) = lastdur;
        F_dur_i(n_dur_i) = F_dur_i(n_dur_i) + 1;
    else
        n_dur_i = n_dur_i+1;
        F_dur_i(n_dur_i) = 1;
        lastdur = length_sorted(i);
        x_dur_i(n_dur_i) = lastdur;
    end
end

% Acumulada usando los puntos Xi
F_acum_i = zeros(1,n_dur_i);
F_acum_i(1) = N_planos;
for i=2:n_dur_i
    F_acum_i(i) = F_acum_i(i-1) - F_dur_i(i-1);
end
frec_acum_i = F_acum_i/N_planos;


%% X_max y X_min para el tramo recto de la ley potencial (en acumulado)

% Seleccionados manualmente
if contains(archivoCM,'CM_parisisburning.txt')
    x_min_manual = 83;
    x_max_manual = 330;
elseif contains(archivoCM,'CM_bulletsoverbroadway.txt')
    x_min_manual = 400;
    x_max_manual = 1206;
elseif contains(archivoCM,'CM_matrix.txt')
    x_min_manual = 63;
    x_max_manual = 340;
elseif contains(archivoCM,'CM_lostintranslation.txt')
    x_min_manual = 41;%63;
    x_max_manual = 238;
elseif contains(archivoCM,'CM_inception.txt')
    x_min_manual = 33;
    x_max_manual = 121;
elseif contains(archivoCM,'CM_senna.txt')
    x_min_manual = 55;
    x_max_manual = 527;
elseif contains(archivoCM,'CM_selma.txt')
    x_min_manual = 100;
    x_max_manual = 240;
elseif contains(archivoCM,'CM_insideout.txt')
    x_min_manual = 39;
    x_max_manual = 184;
end

% Obtenemos los indices de las muestras contenidas entre los Xmin - Xmax
for i = 1:N_clases
    if X_linmed(i) < x_min_manual
        i_min_X_lin = i+1;
    end
    if X_linmed(i) <= x_max_manual
        i_max_X_lin = i;
    end
    if X_logmed(i) < log10(x_min_manual)
        i_min_X_log = i+1;
    end
    if X_logmed(i) <= log10(x_max_manual)
        i_max_X_log = i;
    end
end
for i=1:n_dur_i
    if x_dur_i(i) < x_min_manual
        i_min_dur_acum = i+1;
    elseif x_dur_i(i) <= x_max_manual
        i_max_dur_acum = i;
    end
end


%% Calculo de ALFA

% Alfa con la formula para los las muestras Xi
xi_int = 0;
N_int_xi = 0;
sum_alfa = 0;
for i=1:N_planos
    if length_sorted(i) >= x_min_manual %&& length_sorted(i)<=x_max_manual
        N_int_xi = N_int_xi + 1;
        xi_int(N_int_xi) = length_sorted(i);
        sum_alfa = sum_alfa + log(xi_int(N_int_xi)/x_min_manual);      
    end
end
alfa_xi = 1 + N_int_xi*(inv(sum_alfa));
error_a = (alfa_xi-1)/sqrt(N_int_xi);

% recta alfa con la formula para las muestras Xi
xRecta_formula = log10([xi_int(1),xi_int(N_int_xi)]);
y1 = log10(frec_acum_i(i_min_dur_acum));
y2 = -(alfa_xi-1)*(xRecta_formula(2)-xRecta_formula(1)) + y1;
yRecta_formula = [y1,y2];

% xxxx = xRecta_formula;
% yyyy = yRecta_formula;

% Alfa en la distribucion acumulada mediante ajuste lineal

% alfa Polyfit para acumulada en los puntos Xi
x_dur_int = x_dur_i(i_min_dur_acum:i_max_dur_acum);
dur_acum_int = frec_acum_i(i_min_dur_acum:i_max_dur_acum);
polyfit_acum = polyfit(log10(x_dur_int),log10(dur_acum_int),1);
alfa_polyfit_i = polyfit_acum(1);

xRecta_acum = log10([x_dur_int(1),x_dur_int(i_max_dur_acum-i_min_dur_acum+1)]);
yRecta_polyval_acum = polyval(polyfit_acum,xRecta_acum);

% Alfa a partir de los histogramas y los datos de muestra

% alfa Polyfit para X_lin
x_lin_int = X_linmed(i_min_X_lin:i_max_X_lin);
f_dxlin_int = f_x_lin(i_min_X_lin:i_max_X_lin);
polyfit_X_lin = polyfit(log10(x_lin_int),log10(f_dxlin_int),1);
alfa_polyfit_lin = polyfit_X_lin(1);

xRecta_Xlin = log10([x_lin_int(1),x_lin_int(i_max_X_lin-i_min_X_lin+1)]);
yRecta_polyval_lin = polyval(polyfit_X_lin,xRecta_Xlin);

% alfa Polyfit para X_log
x_log_int = X_logmed(i_min_X_log:i_max_X_log);
f_dxlog_int = f_x_log(i_min_X_log:i_max_X_log);
polyfit_X_log = polyfit(x_log_int,log10(f_dxlog_int),1);
alfa_polyfit_log = polyfit_X_log(1);

xRecta_Xlog = log10([x_log_int(1),x_log_int(i_max_X_log-i_min_X_log+1)]);
yRecta_polyval_log = polyval(polyfit_X_log,xRecta_Xlog);


%% Figuras
if true %grafsOn

    % Comparacion de histogramas con el recuento de muestras discretas
    figure('Name','Comparacion de histogramas con la muestra (Figura 28)')
    loglog(X_linmed,f_x_lin*N_planos,'.-'); hold on
    loglog(10.^X_logmed,f_x_log*N_planos,'.-')
    loglog(x_dur_i,F_dur_i,'+'); hold off
    grid on; axis tight
    xlabel('Duración de planos (decisegundos)') 
    ylabel('Número de muestras') 
    legend('Clases unif. linealmente / ancho de clase', ...
           'Clases unif. en log10 / ancho de clase', ...
           'Recuento de puntos de la muestra')
    
    % Distribucion acumulada y delimitacion de tramo recto 
    figure('Name','Distribucion acumulada Cinemetrics (Figura 29 y 30)')
    loglog(x_dur_i,frec_acum_i,'.-')
    grid on; axis tight
    xlabel('Duración de planos (decisegundos)')
    ylabel('P(x)')
    xline(x_min_manual,'-',{'x_m_i_n'},'LineWidth',1)
    xline(x_max_manual,'-',{'x_m_a_x'},'LineWidth',1)

    %% Grafica de la recta de alfa a partir de la formula
    figure('Name','Recta potential sobre distr. acum. (Figura 29)')
    loglog(x_dur_i,frec_acum_i,'.-'); hold on
%    loglog(10.^xxxx,10.^yyyy)
    loglog(10.^xRecta_formula,10.^yRecta_formula); hold off
    grid on; axis tight
    xlabel('Duración de planos (decisegundos)')
    ylabel('P(x)')
    xline(x_min_manual,'-',{'x_m_i_n'},'LineWidth',1)
    xline(x_max_manual,'-',{'x_m_a_x'},'LineWidth',1)
    legend('Distr. acum','\alpha _f_o_r_m_u_l_a - 1')
%    legend('Distr. acum','\alpha-1 excluyendo cola','\alpha-1 incluyendo cola')


    %% Graficas no utilizadas en la memoria

    % Grafica de la recta de alfa por polyfit a la acumulada en Xi
    figure('Name','Recta ley potencial CineMetrics (muestra acumulada en Xi)')
    loglog(x_dur_i,frec_acum_i,'.'); hold on
    loglog(10.^xRecta_acum,10.^yRecta_polyval_acum); hold off
    xlabel('Duración de planos en decisegundos')
    ylabel('P(x)')
    grid on; axis tight
    xline(x_min_manual,'-',{'x_m_i_n'},'LineWidth',1)
    xline(x_max_manual,'-',{'x_m_a_x'},'LineWidth',1)
    xlim([x_min_manual-5,x_max_manual+15])
    legend('Distr. acum en Xi','\alpha acum en Xi')

    % Comparar valores de alfa obtenidos
    figure('Name','Valores de alfa')
    alphas = [ alfa_xi, ...
              -alfa_polyfit_i+1, ...
              -alfa_polyfit_lin,-alfa_polyfit_log ];
    tags = {'\alpha formula', ...
            '\alpha polyfit Xi', ...
            '\alpha polyfit hist.lin','\alpha polyfit hist.log'};
    barX = categorical(tags); barX = reordercats(barX,tags);
    bar(barX,alphas)
    grid on; ylim([alfa_xi*0.8 alfa_xi*1.2])
    yline(alfa_xi,'-',{'\alpha_f_o_r_m_u_l_a'},'LineWidth',1)
    yline(alfa_xi+error_a,'-r',{'+\sigma'},'LineWidth',1)
    yline(alfa_xi-error_a,'-r',{'-\sigma'},'LineWidth',1)

    % Grafica de alfa para histograma lineal
    figure('Name','Recta ley potencial CineMetrics (histograma lineal)')
    loglog(X_linmed,f_x_lin,'x'); hold on
    loglog(10.^xRecta_Xlin,10.^yRecta_polyval_lin); hold off
    grid on; axis tight
    xlabel('Duración de planos (ds)')
    ylabel('p(x)')
    xline(x_min_manual,'-',{'x_m_i_n'},'LineWidth',1)
    xline(x_max_manual,'-',{'x_m_a_x'},'LineWidth',1)
    legend('Histograma clases lineales','\alpha hist. lineal')
    
    % Grafica de alfa para histograma logaritmico
    figure('Name','Recta ley potencial CineMetrics (histograma logarimico)')
    loglog(10.^X_logmed,f_x_log,'x'); hold on
    loglog(10.^xRecta_Xlog,10.^yRecta_polyval_log); hold off
    xlabel('Duración de planos (ds)')
    ylabel('p(x)')
    grid on; axis tight
    xline(x_min_manual,'-',{'x_m_i_n'},'LineWidth',1)
    xline(x_max_manual,'-',{'x_m_a_x'},'LineWidth',1)
    legend('Histograma clases logaritmicas','\alpha hist. log_1_0')

end

%% clear


%% Notas
% En caso de no obtener valores de alfa para el ajuste de los histogramas
% se debe a que hay clases en las que no hay muestras y se recomienda
% reducir su numero hasta asegurar que todas las clases contengan al menos
% una muestra.