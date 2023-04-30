% Es necesaria la ejecución de A, B y C para D 
C_Umbrales;

%%%%%%%%%%%%%%%%
grafsOn = false;
%%%%%%%%%%%%%%%%
%% Parametros

N_cl_dur = 15; % Numero de clases para los histogramas de duraciones


%% Determinacion de segmentos

% Con el umbral en DE
contador = 0;
duracionFrames = 0;
segmento_U_DE = zeros(contador,3);
for i=1:N_frames
    duracionFrames = duracionFrames+1;
    if absDE(i)>Umbral_calcE && i~=1
        contador = contador+1;
        segmento_U_DE(contador,:) = ...
                            [ contador duracionFrames (FrameInicial+i-1) ];
        duracionFrames = 0;
    elseif i==N_frames
        contador = contador+1;
        segmento_U_DE(contador,:) = ...
                            [ contador duracionFrames (FrameInicial+i-1) ];
    end
end
N_segmentos_E = contador;

% Con el umbral en DH
contador = 0;
duracionFrames = 0;
segmento_U_DH = zeros(contador,3);
for i=1:N_frames
    duracionFrames = duracionFrames+1;
    if absDH(i)>Umbral_calcH && i~=1
        contador = contador+1;
        segmento_U_DH(contador,:) = ...
                            [ contador duracionFrames (FrameInicial+i-1) ];
        duracionFrames = 0;
    elseif i==N_frames
        contador = contador+1;
        segmento_U_DH(contador,:) = ...
                            [ contador duracionFrames (FrameInicial+i-1) ];
    end
end
N_segmentos_H = contador;

if N_segmentos_E ~= PlanosReferencia || N_segmentos_H ~= PlanosReferencia
    disp('Hay una inexactitud en la determinacion del umbral.')
end


%% Histogramas de duracion de segmentos obtenidos con DE y DH

durMaxE = max(segmento_U_DE(:,2)); % Segmento mas largo obtenido con Umb.E
durMinE = min(segmento_U_DE(:,2)); % Segmento más corto
durMaxH = max(segmento_U_DH(:,2)); % Segmento mas largo obtenido con Umb.H
durMinH = min(segmento_U_DH(:,2)); % Segmento más corto

% Lineal (Duraciones E y Duraciones H)
xDurLin_E = linspace(durMinE,durMaxE,N_cl_dur+1);
xDurLin_H = linspace(durMinH,durMaxH,N_cl_dur+1);
xDurLinM_E = zeros(1,N_cl_dur);
xDurLinM_H = zeros(1,N_cl_dur);
for i=1:N_cl_dur
    xDurLinM_E(i) = (xDurLin_E(i)+xDurLin_E(i+1))/2;
    xDurLinM_H(i) = (xDurLin_H(i)+xDurLin_H(i+1))/2;
end

fDurLin_E = zeros(1,N_cl_dur);
fDurLin_H = zeros(1,N_cl_dur);
for i=1:PlanosReferencia
    for j=1:N_cl_dur
        if segmento_U_DE(i,2) <= xDurLin_E(j+1) && ...
           segmento_U_DE(i,2) >= xDurLin_E(j)
            fDurLin_E(j) = fDurLin_E(j)+1;
        end
        if segmento_U_DH(i,2)<=xDurLin_H(j+1) && ...
           segmento_U_DH(i,2)>=xDurLin_H(j)
            fDurLin_H(j) = fDurLin_H(j)+1;
        end
    end
end
fDurLin_E = fDurLin_E/((xDurLin_E(2)-xDurLin_E(1))*PlanosReferencia);
fDurLin_H = fDurLin_H/((xDurLin_H(2)-xDurLin_H(1))*PlanosReferencia);


% Logaritmico
xDurLog_E = linspace(log10(durMinE),log10(durMaxE),N_cl_dur+1);
xDurLog_H = linspace(log10(durMinH),log10(durMaxH),N_cl_dur+1);
xDurLogM_E = zeros(1,N_cl_dur);
xDurLogM_H = zeros(1,N_cl_dur);
dx_durlog_E = zeros(1,N_cl_dur);
dx_durlog_H = zeros(1,N_cl_dur);
for i=1:N_cl_dur
    xDurLogM_E(i) = (xDurLog_E(i)+xDurLog_E(i+1))/2;
    dx_durlog_E(i) = 10^xDurLog_E(i+1)-10^xDurLog_E(i);
    xDurLogM_H(i) = (xDurLog_H(i)+xDurLog_H(i+1))/2;
    dx_durlog_H(i) = 10^xDurLog_H(i+1)-10^xDurLog_H(i);
end

fDurLog_E = zeros(1,N_cl_dur);
fDurLog_H = zeros(1,N_cl_dur);
for j=1:N_cl_dur
    for i=1:PlanosReferencia
        if log10(segmento_U_DE(i,2))<=xDurLog_E(j+1) && ...
           log10(segmento_U_DE(i,2))>=xDurLog_E(j)
            fDurLog_E(j) = fDurLog_E(j)+1;
        end
        if log10(segmento_U_DH(i,2))<=xDurLog_H(j+1) && ...
           log10(segmento_U_DH(i,2))>=xDurLog_H(j)
            fDurLog_H(j) = fDurLog_H(j)+1;
        end
    end
    fDurLog_E(j) = fDurLog_E(j)/(dx_durlog_E(j)*PlanosReferencia);
    fDurLog_H(j) = fDurLog_H(j)/(dx_durlog_H(j)*PlanosReferencia);
end


%% Guardar un archivo con los datos de segmentos (para U_E y U_H)

segm_umbE = fopen('output/TC_segmentos_umbral_E.txt','w');
segm_umbH = fopen('output/TC_segmentos_umbral_H.txt','w');
for i=1:PlanosReferencia
    fprintf(segm_umbE,'%d,',FrameInicial+i-1);
    fprintf(segm_umbE,'%d,',segmento_U_DE(i,2));
    fprintf(segm_umbE,'%f,',segmento_U_DE(i,3)/(10*FPS));
    fprintf(segm_umbE,'%f\n',absDE(segmento_U_DE(i,3)-FrameInicial+1));

    fprintf(segm_umbH,'%d,',FrameInicial+i-1);
    fprintf(segm_umbH,'%d,',segmento_U_DH(i,2));
    fprintf(segm_umbH,'%f,',segmento_U_DH(i,3)/(10*FPS));
    fprintf(segm_umbH,'%f\n',absDH(segmento_U_DH(i,3)-FrameInicial+1));
end
fclose(segm_umbE);
fclose(segm_umbH);


% Figuras
if grafsOn
%%
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

end

%%
clear duracionFrames N_segmentos_E N_segmentos_H segm_umbE segm_umbH durMed