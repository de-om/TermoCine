if contains(archivo,'parisisburning')
    x_rectoE_min = 230;
    x_rectoE_max = 536;
    x_rectoH_min = 180;
    x_rectoH_max = 700;
    x_recto_minHist = 60;
    x_recto_maxHist = 700;
elseif contains(archivo,'bulletsoverbroadway')
    x_rectoE_min = 1000;
    x_rectoE_max = 3100;
    x_rectoH_min = 960;
    x_rectoH_max = 5700;
    x_recto_minHist = 100;
    x_recto_maxHist = 2600;
elseif contains(archivo,'matrix')
    x_rectoE_min = 127;
    x_rectoE_max = 609;
    x_rectoH_min = 188;
    x_rectoH_max = 630;
    x_recto_minHist = 45;
    x_recto_maxHist = 1705;
elseif contains(archivo,'lostintranslation')
    x_rectoE_min = 155;
    x_rectoE_max = 935;
    x_rectoH_min = 142;
    x_rectoH_max = 1080;
    x_recto_minHist = 90;
    x_recto_maxHist = 1260;
elseif contains(archivo,'inception')
    x_rectoE_min = 75;
    x_rectoE_max = 293;
    x_rectoH_min = 63;
    x_rectoH_max = 330;
    x_recto_minHist = 27;
    x_recto_maxHist = 900;
elseif contains(archivo,'senna')
    x_rectoE_min = 590;
    x_rectoE_max = 1280;
    x_rectoH_min = 109;
    x_rectoH_max = 763;
    x_recto_minHist = 40;
    x_recto_maxHist = 1000;
elseif contains(archivo,'selma')
    x_rectoE_min = 163;
    x_rectoE_max = 2294;
    x_rectoH_min = 222;
    x_rectoH_max = 970;
    x_recto_minHist = 60;
    x_recto_maxHist = 747;
elseif contains(archivo,'insideout')
    x_rectoE_min = 150;
    x_rectoE_max = 642;
    x_rectoH_min = 94;
    x_rectoH_max = 753;
    x_recto_minHist = 90;
    x_recto_maxHist = 800;
end

% Indices de cada variable delimitandos por Xmin - Xmax

% En las distribuciones acumuladas de duracion
% for i=1:N_dx_acum
%     if x_dx_acumedE(i) < x_rectoE_min
%         i_min_dx_acumE = i+1;
%     elseif x_dx_acumedE(i) <= x_rectoE_max
%         i_max_dx_acumE = i;
%     end
%     if x_dx_acumedH(i) < x_rectoH_min
%         i_min_dx_acumH = i+1;
%     elseif x_dx_acumedH(i) <= x_rectoH_max
%         i_max_dx_acumH = i;
%     end
% end
for i=1:n_x_durE
    if x_segmE(i) < x_rectoE_min
        i_min_dur_acumE = i+1;
    elseif x_segmE(i) <= x_rectoE_max
        i_max_dur_acumE = i;
    end
end
for i=1:n_x_durH
    if x_segmH(i) < x_rectoH_min
        i_min_dur_acumH = i+1;
    elseif x_segmH(i) <= x_rectoH_max
        i_max_dur_acumH = i;
    end
end
% En los histogramas de duraciones
i_min_X_linE=1; i_min_X_logE=1; i_min_X_linH=1; i_min_X_logH=1;
for i=1:N_cl_dur
    if xDurLinM_E(i) < x_recto_minHist
        i_min_X_linE = i+1;
    elseif xDurLinM_E(i) <= x_recto_maxHist
        i_max_X_linE = i;
    end
    if xDurLogM_E(i) < log10(x_recto_minHist)
        i_min_X_logE = i+1;
    elseif xDurLogM_E(i) <= log10(x_recto_maxHist)
        i_max_X_logE = i;
    end
    if xDurLinM_H(i) < x_recto_minHist
        i_min_X_linH = i+1;
    elseif xDurLinM_H(i) <= x_recto_maxHist
        i_max_X_linH = i;
    end
    if xDurLogM_H(i) < log10(x_recto_minHist)
        i_min_X_logH = i+1;
    elseif xDurLogM_H(i) <= log10(x_recto_maxHist)
        i_max_X_logH = i;
    end
end

%% Figuras
if grafsOn

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

end