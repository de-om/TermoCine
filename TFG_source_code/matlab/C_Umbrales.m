% Es necesaria la ejecucion de A y B para C
B_Histogramas_Variables;


%% Umbral DE
% para obtener el mismo numero de segmentos que planos tiene el filme
absDE_sorted = sort(absDE);
Umbral_calcE = absDE_sorted(N_frames-PlanosReferencia+1);
if absDE(1) > Umbral_calcE
    Umbral_calcE = absDE_sorted(N_frames-PlanosReferencia);
end


%% Umbral DH

% para obtener el mismo numero de segmentos que planos tiene el filme
absDH_sorted = sort(absDH);
Umbral_calcH = absDH_sorted(N_frames-PlanosReferencia+1);
if absDH(1) > Umbral_calcH
    Umbral_calcH = absDH_sorted(N_frames-PlanosReferencia);
end

%% Figuras
if grafsOn

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

end

%%
clear absDE_sorted absDH_sorted