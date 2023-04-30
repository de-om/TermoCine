% Es necesaria la ejecución de A, B, C, D, E, F y G para H
F_Ley_Potencial;
G_Cinemetrics;

                            % Figura comparando los alfa de CineMetrics y los de F !??!?!?!?!?!?!?!!?!?!?!?

%% A - Datos iniciales

    % Evolucion de las variables primarias
    figure('Name','Energía, Varianza y Entropia (Figura 1)') 
        subplot(3,1,1)
    bar(frames_vector,E,1)
    xlabel('Fotograma')
    ylabel('Energía')
    grid on; axis tight
        subplot(3,1,2)
    bar(frames_vector,sigma,'FaceColor','#D95319','BarWidth',1)
    xlabel('Fotograma')
    ylabel('\sigma_E')
    grid on; axis tight
        subplot(3,1,3)
    bar(frames_vector,H,'FaceColor','#77AC30','BarWidth',1)
    xlabel('Fotograma')
    ylabel('Entropia')
    grid on; axis tight
    
    % Evolucion de la Energia en cada canal de color
    figure('Name','Evolucion de colores (Energia en cada canal)')
    plot(frames_vector,E_R,'Color','r'); hold on
    plot(frames_vector,E_G,'Color','g')
    plot(frames_vector,E_B,'Color','b'); hold off
    xlabel('Fotograma')
    ylabel('Energía')
    grid on; axis tight

    % Delta de Energia
    figure('Name','Delta Energía (Figura 2)')
        subplot(2,1,1)
    plot(frames_vector_selected,Delta_E)
    xlabel('Frames')
    ylabel('\DeltaE')
    grid on; axis tight
        subplot(2,1,2)
    plot(frames_vector_selected,absDE)
    xlabel('Frames')
    ylabel('|\DeltaE|')
    grid on; axis tight

    % Delta de Entropia
    figure('Name','Delta Entropia (Figura 3)')
        subplot(2,1,1)
    plot(frames_vector_selected,Delta_H,'Color','#77AC30')
    xlabel('Frames')
    ylabel('\DeltaH')
    grid on; axis tight
        subplot(2,1,2)
    plot(frames_vector_selected,absDH,'Color','#77AC30')
    xlabel('Frames')
    ylabel('|\DeltaH|')
    grid on; axis tight


%% B - Histogramas de variables

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


%% C - Umbrales

    % Umbrales en DE
    figure('Name','Umbrales en DE (Figura 13)')
    loglog(xHistoMedioDEabs,yHistoDEabs,'.')
    xlabel('\DeltaE')
    ylabel('Frecuencia')
    set(gca, 'XScale', 'log')
    grid on; axis tight
    xline(absDE_medio,'-',{'Umbral valor medio'},'LineWidth',1)
    xline(maxAbsDE*0.3,'-',{'Umbral 30% sobre \DeltaE_m_a_x'},'LineWidth',1)
    xline(Umbral_calcE,'-r',{'Umbral calculado'},'LineWidth',2)

    % Umbrales en DH
    figure('Name','--')
    loglog(xHistoMedioDHabs,yHistoDHabs,'.')
    xlabel('Delta de Entropia')
    ylabel('Frecuencia')
    set(gca, 'XScale', 'log')
    grid on; axis tight
    xline(absDH_medio,'-',{'Umbral valor medio'},'LineWidth',1)
    xline(maxAbsDH*0.3,'-',{'Umbral 30% sobre \DeltaH_m_a_x'},'LineWidth',1)
    xline(Umbral_calcH,'-r',{'Umbral calculado'},'LineWidth',2)


%% D - Determinacion de segmentos

    % Histograma de 100 clases equiespaciadas linealmente
    figure('Name','Histogramas lineal y logaritmico (Fig. 14 y Fig. 15)')
    loglog(xDurLinM_E,fDurLin_E,'.-'); hold on
    loglog(10.^xDurLogM_E,fDurLog_E,'.-'); hold off
    xlabel('Duración de segmento')
    ylabel('p(x)')
    grid on; axis tight
    legend('Clases uniformes lineal','Clases uniformes logaritmo')

    % Comparacion histogramas lineal y logaritmico para dur. de segmentos
    figure('Name','Histogramas combinados duracion de semento (Fig. 18)')
    loglog(xDurLinM_E,fDurLin_E,'.:','LineWidth',1); hold on
    plot(xDurLinM_H,fDurLin_H,'.:','LineWidth',1)
    plot(10.^xDurLogM_E,fDurLog_E,'.--')
    plot(10.^xDurLogM_H,fDurLog_H,'.--'); hold on
    grid on; axis tight
    ylabel('p(x)')
    xlabel('Frames de duracion')
    legend('lin E','lin H','log E','log H')


%% E - Distribucion acumulada

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


        % Identificar intervalo recto en las distribuciones acumuladas (E y H)
    figure('Name','Distr. acum. segE - tramo recto (Figura 21)')
    loglog(x_segmE,F_acumE_i,'.-')
    grid on; axis tight
    xlabel('Frames de duracion')
    ylabel('P(x)')
    xline(x_rectoE_min,'-r',{'x_m_i_n'},'LineWidth',1)
    xline(x_rectoE_max,'-r',{'x_m_a_x'},'LineWidth',1)

    figure('Name','Distr. acum. segE - tramo recto (Figura 22)')
    loglog(x_segmH,F_acumH_i,'.-')
    grid on; axis tight
    xlabel('Frames de duracion')
    ylabel('P(x)')
    xline(x_rectoH_min,'-r',{'x_m_i_n'},'LineWidth',1)
    xline(x_rectoH_max,'-r',{'x_m_a_x'},'LineWidth',1)

    % Tramo recto en los histogramas de duraciones
    figure('Name','Histogramas dur. tramo recto (Figura 23)')
    loglog(xDurLinM_E,fDurLin_E,'.:','LineWidth',1); hold on
    plot(xDurLinM_H,fDurLin_H,'.:','LineWidth',1)
    plot(10.^xDurLogM_E,fDurLog_E,'.--')
    plot(10.^xDurLogM_H,fDurLog_H,'.--'); hold on
    grid on; axis tight
    ylabel('p(x)')
    xlabel('Frames de duracion')
    xline(x_recto_minHist,'-r',{'x_m_i_n'},'LineWidth',1)
    xline(x_recto_maxHist,'-r',{'x_m_a_x'},'LineWidth',1)
    legend('lin E','lin H','log E','log H')


%% f - parametros Ley Potencial

    % Identificar intervalo recto en las distribuciones acumuladas (E y H)
    figure('Name','Distr. acum. segE - tramo recto (Figura 21)')
    loglog(x_segmE,F_acumE_i,'.-')
    grid on; axis tight
    xlabel('Frames de duracion')
    ylabel('P(x)')
    xline(x_rectoE_min,'-r',{'x_m_i_n'},'LineWidth',1)
    xline(x_rectoE_max,'-r',{'x_m_a_x'},'LineWidth',1)

    figure('Name','Distr. acum. segE - tramo recto (Figura 22)')
    loglog(x_segmH,F_acumH_i,'.-')
    grid on; axis tight
    xlabel('Frames de duracion')
    ylabel('P(x)')
    xline(x_rectoH_min,'-r',{'x_m_i_n'},'LineWidth',1)
    xline(x_rectoH_max,'-r',{'x_m_a_x'},'LineWidth',1)

    % Tramo recto en los histogramas de duraciones
    figure('Name','Histogramas dur. tramo recto (Figura 23)')
    loglog(xDurLinM_E,fDurLin_E,'.:','LineWidth',1); hold on
    plot(xDurLinM_H,fDurLin_H,'.:','LineWidth',1)
    plot(10.^xDurLogM_E,fDurLog_E,'.--')
    plot(10.^xDurLogM_H,fDurLog_H,'.--'); hold on
    grid on; axis tight
    ylabel('p(x)')
    xlabel('Frames de duracion')
    xline(x_recto_minHist,'-r',{'x_m_i_n'},'LineWidth',1)
    xline(x_recto_maxHist,'-r',{'x_m_a_x'},'LineWidth',1)
    legend('lin E','lin H','log E','log H')


%% F - Ley Potencial

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

    % Comparacion de los alfas obtenidos

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


%% H - Cinemetrics

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
    loglog(10.^xRecta_formula,10.^yRecta_formula); hold off
    grid on; axis tight
    xlabel('Duración de planos (decisegundos)')
    ylabel('P(x)')
    xline(x_min_manual,'-',{'x_m_i_n'},'LineWidth',1)
    xline(x_max_manual,'-',{'x_m_a_x'},'LineWidth',1)
    legend('Distr. acum','\alpha _f_o_r_m_u_l_a - 1')


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