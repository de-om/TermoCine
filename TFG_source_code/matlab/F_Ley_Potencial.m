% Es necesaria la ejecución de A, B, C, D y E para F
E_Distr_Acumulada;

%%%%%%%%%%%%%%%%
grafsOn = false;
%%%%%%%%%%%%%%%%
%% Parametros

% Rangos de duracion rectos en distr. acum. e histogramas
% Indices de los vectores contenidos en los rangos rectos
f_LP_parametros;


%% Calculo de ALFA

% Alfa con la formula para los las muestras Xi (E y H)
xi_E = 0;
xi_H = 0;
N_xi_E = 0; % Numero de muestras a la derecha del inicio del tramo recto
N_xi_H = 0;
sum_alfa_E = 0;
sum_alfa_H = 0;
for i=1:PlanosReferencia
    if segmE_sorted(i) >= x_rectoE_min %&& segmE_sorted(i) <= x_rectoE_max
        N_xi_E = N_xi_E + 1;
        xi_E(N_xi_E) = segmE_sorted(i);
        sum_alfa_E = sum_alfa_E + log(xi_E(N_xi_E)/x_rectoE_min);      
    end
    if segmH_sorted(i) >= x_rectoH_min %&& segmH_sorted(i) <= x_rectoH_max
        N_xi_H = N_xi_H + 1;
        xi_H(N_xi_H) = segmH_sorted(i);
        sum_alfa_H = sum_alfa_H + log(xi_H(N_xi_H)/x_rectoH_min);      
    end
end
alfa_xi_E = 1 + N_xi_E*(inv(sum_alfa_E));
error_a_E = (alfa_xi_E-1)/sqrt(N_xi_E);
alfa_xi_H = 1 + N_xi_H*(inv(sum_alfa_H));
error_a_H = (alfa_xi_H-1)/sqrt(N_xi_H);


% Alfa por min.-cuad. para intervalo recto de distr. acumuladas Xi (E y H)

% alfa Polyfit para X_dx acum. de segmentos E
% x_dx_acum_intE = log10(x_dx_acumedE(i_min_dx_acumE:i_max_dx_acumE));
% f_dx_acum_intE = log10(f_x_dx_acumE(i_min_dx_acumE:i_max_dx_acumE));
% polyfit_X_dxE = polyfit(x_dx_acum_intE,f_dx_acum_intE,1);
% alfa_fit_dxE = polyfit_X_dxE(1);

% alfa Polyfit para X_dx acum. de segmentos H
% x_dx_acum_intH = log10(x_dx_acumedH(i_min_dx_acumH:i_max_dx_acumH));
% f_dx_acum_intH = log10(f_x_dx_acumH(i_min_dx_acumH:i_max_dx_acumH));
% polyfit_X_dxH = polyfit(x_dx_acum_intH,f_dx_acum_intH,1);
% alfa_fit_dxH = polyfit_X_dxH(1);

% alfa Polyfit para acumulada en los puntos Xi de segmentos E
x_i_acum_intE = log10(x_segmE(i_min_dur_acumE:i_max_dur_acumE));
f_i_acum_intE = log10(F_acumE_i(i_min_dur_acumE:i_max_dur_acumE));
polyfit_acumE = polyfit(x_i_acum_intE,f_i_acum_intE,1);
alfa_fit_iE = polyfit_acumE(1);

% alfa Polyfit para acumulada en los puntos Xi de segmentos H
x_i_acum_intH = log10(x_segmH(i_min_dur_acumH:i_max_dur_acumH));
f_i_acum_intH = log10(F_acumH_i(i_min_dur_acumH:i_max_dur_acumH));
polyfit_acumH = polyfit(x_i_acum_intH,f_i_acum_intH,1);
alfa_fit_iH = polyfit_acumH(1);


% Alfa por min.-cuad. para intervalo de los histogramas duracion (E y H) %%%%%%%%%% PROBLEMAS CALCULANDO ALFA

% alfa histograma lineal de duraciones de segmentoE en el intervalo
x_lin_intE = log10(xDurLinM_E(i_min_X_linE:i_max_X_linE));
f_lin_intE = log10(fDurLin_E(i_min_X_linE:i_max_X_linE));
polyfit_X_linE = polyfit(x_lin_intE,f_lin_intE,1);
alfa_fit_linE = polyfit_X_linE(1);

% alfa histograma lineal de duraciones de segmentoH en el intervalo
x_lin_intH = log10(xDurLinM_H(i_min_X_linH:i_max_X_linH));
f_lin_intH = log10(fDurLin_H(i_min_X_linH:i_max_X_linH));
polyfit_X_linH = polyfit(x_lin_intH,f_lin_intH,1);
alfa_fit_linH = polyfit_X_linH(1);

% alfa histograma log de duraciones de segmentoE en el intervalo
x_log_intE = xDurLogM_E(i_min_X_logE:i_max_X_logE);
f_log_intE = log10(fDurLog_E(i_min_X_logE:i_max_X_logE));
polyfit_X_logE = polyfit(x_log_intE,f_log_intE,1);
alfa_fit_logE = polyfit_X_logE(1);

% alfa Polyfit histograma log. de duraciones de segmentoH en el intervalo
x_log_intH = xDurLogM_H(i_min_X_logH:i_max_X_logH);
f_log_intH = log10(fDurLog_H(i_min_X_logH:i_max_X_logH));
polyfit_X_logH = polyfit(x_log_intH,f_log_intH,1);
alfa_fit_logH = polyfit_X_logH(1);


if grafsOn

%%
    % Alfas obtenidas de los histogramas
    figure('Name','Comparacion de Alfas de histogramas (Figura 24)')
    alph = [ -alfa_fit_linE,-alfa_fit_linH,-alfa_fit_logE,-alfa_fit_logH ];
    tags = {'\alpha lin E','\alpha lin H','\alpha log E','\alpha log H'};
    barX = categorical(tags); barX = reordercats(barX,tags);
    bar(barX,alph)
    grid on

    % Alfa min.-cuad. con distribuciones acumuladas (Xi) de segmento
    figure('Name','Alfa min-cuad distr. acum. Xi (E y H) (Figura 25)')
        subplot(1,2,1)
    loglog(x_segmE,F_acumE_i,'.-'); hold on
        % recta alfa con min-cuad de acum. (Xi) para segmentos E
        yR_acumE = polyval(polyfit_acumE,x_i_acum_intE);
    loglog(10.^x_i_acum_intE,10.^yR_acumE,':','LineWidth',2); hold off
    grid on; axis tight
    xlabel('Duración en fotogramas')
    ylabel('P(x) - segmentos E')
        subplot(1,2,2)
    loglog(x_segmH,F_acumH_i,'.-'); hold on
        % recta alfa con min-cuad de acum. (Xi) para segmentos H
        yR_acumH = polyval(polyfit_acumH,x_i_acum_intH);
    loglog(10.^x_i_acum_intH,10.^yR_acumH,':','LineWidth',2); hold off
    grid on; axis tight
    xlabel('Duración en fotogramas')
    ylabel('P(x) - segmentos H')

    % Alfas obtenidas de las distribuciones acumuladas
    figure('Name','Comparacion de Alfas polyfit acumulada (Figura 26)')
    alph = [ -alfa_fit_iE+1,-alfa_fit_iH+1 ];
    tags = {'\alpha ajuste acum. E','\alpha ajuste acum. H'};
    barX = categorical(tags); barX = reordercats(barX,tags);
    bar(barX,alph)
    grid on

    % Alfa formula en las distribuciones acumuladas de segmento
    figure('Name','Alfa formula en distr. acum. segmento (Figura 27)')
        subplot(2,1,1)
    loglog(x_segmE,F_acumE_i,'.-'); hold on
    % recta alfa con la formula para las muestras Xi de E
        xR_formulaE = log10([xi_E(1),xi_E(N_xi_E)]);
        y1 = log10(F_acumE_i(i_min_dur_acumE));
        y2 = -(alfa_xi_E-1)*(xR_formulaE(2)-xR_formulaE(1)) + y1;
        yR_formulaE = [y1,y2];
    loglog(10.^xR_formulaE,10.^yR_formulaE,':','LineWidth',2); hold off
    grid on; axis tight
    xlabel('Duración en fotogramas seg(E)')
    ylabel('P(x)')
        subplot(2,1,2)
    loglog(x_segmH,F_acumH_i,'.-'); hold on
    % recta alfa con la formula para las muestras Xi de H
        xR_formulaH = log10([xi_H(1),xi_H(N_xi_H)]);
        y1 = log10(F_acumH_i(i_min_dur_acumH));
        y2 = -(alfa_xi_H-1)*(xR_formulaH(2)-xR_formulaH(1)) + y1;
        yR_formulaH = [y1,y2];
    loglog(10.^xR_formulaH,10.^yR_formulaH,':','LineWidth',2); hold off
    grid on; axis tight
    xlabel('Duración en fotogramas seg(H)')
    ylabel('P(x)')


    % Alfa formula en las distribuciones acumuladas de segmento
    figure('Name','Alfa formula en distr. acum. segmento (Figura 33 &bis)')
        subplot(2,1,1)
    loglog(x_segmE,F_acumE_i,'.-'); hold on
    % recta alfa con la formula para las muestras Xi de E
        xR_formulaE = log10([xi_E(1),xi_E(N_xi_E)]);
        y1 = log10(F_acumE_i(i_min_dur_acumE));
        y2 = -(alfa_xi_E-1)*(xR_formulaE(2)-xR_formulaE(1)) + y1;
        yR_formulaE = [y1,y2];
    loglog(10.^xR_formulaE,10.^yR_formulaE,':','LineWidth',2); hold off
    grid on; axis tight
    xlabel('Duración en fotogramas (TCE)')
    xline(x_rectoE_min,'-r',{'x_m_i_n'},'LineWidth',1)
    xline(x_rectoE_max,'-r',{'x_m_a_x'},'LineWidth',1)
    ylabel('P(x)')
        subplot(2,1,2)
    loglog(x_segmH,F_acumH_i,'.-'); hold on
    % recta alfa con la formula para las muestras Xi de H
        xR_formulaH = log10([xi_H(1),xi_H(N_xi_H)]);
        y1 = log10(F_acumH_i(i_min_dur_acumH));
        y2 = -(alfa_xi_H-1)*(xR_formulaH(2)-xR_formulaH(1)) + y1;
        yR_formulaH = [y1,y2];
    loglog(10.^xR_formulaH,10.^yR_formulaH,':','LineWidth',2); hold off
    grid on; axis tight
    xlabel('Duración en fotogramas (TCH)')
    ylabel('P(x)')
    xline(x_rectoH_min,'-r',{'x_m_i_n'},'LineWidth',1)
    xline(x_rectoH_max,'-r',{'x_m_a_x'},'LineWidth',1)


%%  Graficas no utilizadas en la memoria
   
    % Alfa min.-cuad. con histogramas lineales de segmento
    figure('Name','Alfa min-cuad hist. lineal de segmentos')
        subplot(2,1,1)
    loglog(xDurLinM_E,fDurLin_E,'.-'); hold on
        % recta alfa con min-cuad de acum. (Xi) para segmentos E
        yR_linE = polyval(polyfit_X_linE,x_lin_intE);
    loglog(10.^x_lin_intE,10.^yR_linE,':','LineWidth',2); hold off
    grid on; axis tight
    xlabel('Duración de segmentos (E) en fotogramas')
    ylabel('p(x)')
        subplot(2,1,2)
    loglog(xDurLinM_H,fDurLin_H,'.-'); hold on
        % recta alfa con min-cuad de acum. (Xi) para segmentos H
        yR_linH = polyval(polyfit_X_linH,x_lin_intH);
    loglog(10.^x_lin_intH,10.^yR_linH,':','LineWidth',2); hold off
    grid on; axis tight
    xlabel('Duración de segmentos (H) en fotogramas')
    ylabel('p(x)')

    
    % Alfa min.-cuad. con histogramas logaritmicos de segmento

    figure('Name','Alfa min-cuad hist. logaritmico de segmentos')
        subplot(2,1,1)
    loglog(10.^xDurLogM_E,fDurLog_E,'.-'); hold on
        % recta alfa con min-cuad de histo-log para segmentos E
        yR_logE = polyval(polyfit_X_logE,x_log_intE);
    loglog(10.^x_log_intE,10.^yR_logE,':','LineWidth',2); hold off
    grid on; axis tight
    xlabel('Duración de segmentos (E) en fotogramas')
    ylabel('p(x)')
        subplot(2,1,2)
    loglog(10.^xDurLogM_H,fDurLog_H,'.-'); hold on
        % recta alfa con min-cuad de histo-log para segmentos H
        yR_logH = polyval(polyfit_X_logH,x_log_intH);
    loglog(10.^x_log_intH,10.^yR_logH,':','LineWidth',2); hold off
    grid on; axis tight
    xlabel('Duración de segmentos (H) en fotogramas')
    ylabel('p(x)')

    %% Comparacion de los alfas obtenidos

    % Alfas obtenidos de segmentos E
    figure('Name','Comparacion de Alfas para segmentos E')
    alph = [ alfa_xi_E, ... %-alfa_fit_dxE+1,
            -alfa_fit_iE+1,-alfa_fit_linE,-alfa_fit_logE ];
    tags = {'\alpha formula', ... %'\alpha acum dx',
            '\alpha acum Xi','\alpha histLin','\alpha histLog'};
    barX = categorical(tags); barX = reordercats(barX,tags);
    bar(barX,alph)
    grid on; ylim([alfa_xi_E*0.8 alfa_xi_E*1.2])
    yline(alfa_xi_E,'-',{'\alpha_f_o_r_m_u_l_a'},'LineWidth',1)
    yline(alfa_xi_E+error_a_E,'-r',{'+\sigma'},'LineWidth',1)
    yline(alfa_xi_E-error_a_E,'-r',{'-\sigma'},'LineWidth',1)
    title('Valores de \alpha obtenidos de los segmentos (E)')
 
    % Alfas obtenidos de segmentos H
    figure('Name','Comparacion de Alfas para segmentos H')
    alph = [ alfa_xi_H, ... %-alfa_fit_dxH+1,
            -alfa_fit_iH+1,-alfa_fit_linH,-alfa_fit_logH ];
    tags = {'\alpha formula', ... '\alpha acum dx',
            '\alpha acum Xi','\alpha histLin','\alpha histLog'};
    barX = categorical(tags); barX = reordercats(barX,tags);
    bar(barX,alph)
    grid on; ylim([alfa_xi_H*0.8 alfa_xi_H*1.2])
    yline(alfa_xi_H,'-',{'\alpha_f_o_r_m_u_l_a'},'LineWidth',1)
    yline(alfa_xi_H+error_a_H,'-r',{'+\sigma'},'LineWidth',1)
    yline(alfa_xi_H-error_a_H,'-r',{'-\sigma'},'LineWidth',1)
    title('Valores de \alpha obtenidos de los segmentos (H)')

end

%%
% clear alph