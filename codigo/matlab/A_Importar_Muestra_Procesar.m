%if ~exist('subroutine','var')
clc
clear

%%%%%%%%%%%%%%%%
grafsOn = false;
%%%%%%%%%%%%%%%%

%% Parametros 
                                               
% Titulo = ''; ????????????????????????????????????????????????????????????% AÑADIR A FIGURAS para diferenciar por peliculas inmediatamente
% archivo = 'datos/parisisburning_248x180_23,98fps.dat';
% frameHeight = 180;
% frameWidth = 248;
% FPS = 23.98;
% FrameInicial = 1393;
% FrameFinal = 103864;
% PlanosReferencia = 539;

% archivo = 'datos/bulletsoverbroadway_304x160_23,98fps.dat';
% frameHeight = 160;
% frameWidth = 304;
% FPS = 23.98;
% FrameInicial = 2789;
% FrameFinal = 138971;
% PlanosReferencia = 113;

% archivo = 'datos/matrix_327x136_23,98fps.dat';
% frameHeight = 136;
% frameWidth = 327;
% FPS = 23.98;
% FrameInicial = 2121;
% FrameFinal = 186177;
% PlanosReferencia = 2341;

% archivo = 'datos/lostintranslation_256x136_25fps.dat';
% frameHeight = 136;
% frameWidth = 256;
% FPS = 25;
% FrameInicial = 1646;
% FrameFinal = 137963;
% PlanosReferencia = 869;

% archivo = 'datos/inception_320x134_23,98fps.dat';
% frameHeight = 134;
% frameWidth = 320;
% FPS = 23.98;
% FrameInicial = 957;
% FrameFinal = 202687;
% PlanosReferencia = 2654;

% archivo = 'datos/selma_320x134_23,98fps.dat';
% frameHeight = 134;
% frameWidth = 320;
% FPS = 23.98;
% FrameInicial = 1446;
% FrameFinal = 172397;
% PlanosReferencia = 1369;

archivo = 'datos/insideout_320x180_23,98fps.dat';
frameHeight = 180;
frameWidth = 320;
FPS = 23.98;
FrameInicial = 1500;
FrameFinal = 124050;
PlanosReferencia = 1255;

% archivo = 'datos/senna_320x180_23,98fps.dat';
% frameHeight = 180;
% frameWidth = 320;
% FPS = 23.98;
% FrameInicial = 4533;
% FrameFinal = 146800;
% PlanosReferencia = 30000; %50; 893;

% archivo = 'datos/birdman_320x174_23,98fps.dat';
% frameHeight = 174;
% frameWidth = 320;
% FPS = 23.98;
% FrameInicial = 2321;
% FrameFinal = 161524;
% PlanosReferencia = 1;

% archivo = 'datos/1917_360x152_29,97fps.dat';
% frameHeight = 152;
% frameWidth = 360;
% FPS = 29.97;
% FrameInicial = 1803;
% FrameFinal = 196820;
% PlanosReferencia = 1;

% archivo = 'datos/thecircle_384x160_23,98fps.dat';
% frameHeight = 160;
% frameWidth = 384;
% FPS = 23.98;
% FrameInicial = ;
% FrameFinal = ; 
% PlanosReferencia = 'no data'

%                                         t_s=(FrameFinal-FrameInicial+1)/FPS
%                                         m=t_s/60
%                                         h=m/60
%                                         s=t_s-floor(m)*60
%                                         FrameFinal-FrameInicial+1

% percE_1 = (20+19+43+20+21+17+14)/7
% percH_1 = (19+20+33+20+22+19+23)/7
% 
% percE_2 = (27+20+38+21+21+22+12)/7
% percH_2 = (24+20+27+23+22+24+19)/7
% perc_ = (percE_1+percH_1+percE_2+percH_2)/4
% 
% per1111 = (percE_1+percH_1)/2
% per2222 = (percE_2+percH_2)/2

(2.62+2.35+2.24+2.34+2.39+2.64+2.80)/7

(2.35+2.32+2.60+2.23+2.30+2.79+2.10)/7
%% Data Import

Fichero = importdata(archivo);

% Frames
[N_frames_full,~] = size(Fichero.textdata);
N_frames = FrameFinal-FrameInicial+1; % Frames de metraje sin creditos
Frames = Fichero.textdata;
frames_vector = linspace(1,N_frames_full,N_frames_full);

% Datos de BMPread
E     = Fichero.data(:,1);
sigma = Fichero.data(:,5);
H     = Fichero.data(:,6);

% Datos de color
E_R = Fichero.data(:,2);
E_G = Fichero.data(:,3);
E_B = Fichero.data(:,4);


%% Data Processing 

% Se retiran los fotogramas de los creditos del inicio y final del filme

% Deltas de las variables
Delta_E = zeros(1,N_frames);
%Delta_S = zeros(1,N_frames);
Delta_H = zeros(1,N_frames);

frames_vector_selected = frames_vector(FrameInicial:FrameFinal);

for i=1:N_frames
    j = i + (FrameInicial-1);
    Delta_E(i) = E(j) - E(j-1);
    % Delta_S(i) = sigma(i) - sigma(i-1);
    Delta_H(i) = H(j) - H(j-1);
end

% Declaramos las variaciones en valor absoluto
absDE = abs(Delta_E);
absDH = abs(Delta_H);

% Registramos los mínimos y los valores medios
MinDE = min(Delta_E);
DeltaE_medio = sum(Delta_E)/N_frames;
MaxDE = max(Delta_E);
minAbsDE = min(absDE);
absDE_medio = sum(absDE)/N_frames;
maxAbsDE = max(absDE);

MinDH = min(Delta_H);
DeltaH_medio = sum(Delta_H)/N_frames;
MaxDH = max(Delta_H);
minAbsDH = min(absDH);
absDH_medio = sum(absDH)/N_frames;
maxAbsDH = max(absDH);


% Valores maximos de las variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[E_max,i] = max(E(FrameInicial:FrameFinal))
[H_max,i] = max(H(FrameInicial:FrameFinal))
[DE_max,i] = max(absDE)
[DH_max,i] = max(absDH)

% convertir a segundos para buscar el momento en el video

stoppp = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%

if grafsOn

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

end

%%
clear i j Fichero 