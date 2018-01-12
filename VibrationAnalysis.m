%% Vibration Analysis of Things
clear
clc

%Fixes a crash when reading large .avi files
%matlab.video.read.UseHardwareAcceleration('off');

%Set working directory
%cd

%Input video directory
dataDir = 'data/';

%Reading Video input
vidName = '4';
vidExtension = '.mp4';

filename = [vidName vidExtension];
vr = VideoReader(fullfile(dataDir, filename));

%Complex Steerable Pyramid Parameters 4,2 in visualmic | 4,1 in vibrometry
nScales = 4;
nOrientations = 2;
dSamplefactor = 1;

%% Extract Signal
S = ExtractVibration(vr, nScales, nOrientations, dSamplefactor);
'Done'

%% (Visual Vibrometry 2016 Aluminum Rods) 2500FPS

%Gaussian Filtering
S.averageNoAlignmentFiltered = imgaussfilt(S.averageNoAlignment, 10)

%[pxx,w] = periodogram(S.averageNoAlignmentFiltered,[],[],2500);
%[pxx,w] = pwelch(S.averageNoAlignmentFiltered,[],[],[],2500);

plot(w,log10(pxx))
title('Recovered Spectrum')
xlabel('Frequency (Hz)')
ylabel('Power (Log Normalized)')

%% Wine Glass Experiment 240FPS (4Sc, 2Or) 

%Gaussian Filtering
One.averageNoAlignmentFiltered = imgaussfilt(One.averageNoAlignment, 1.5)
Two.averageNoAlignmentFiltered = imgaussfilt(Two.averageNoAlignment, 1.5)
Three.averageNoAlignmentFiltered = imgaussfilt(Three.averageNoAlignment, 1.5)
Four.averageNoAlignmentFiltered = imgaussfilt(Four.averageNoAlignment, 1.5)
Noise.averageNoAlignmentFiltered = imgaussfilt(Noise.averageNoAlignment, 1.5)


[pxx1,w1] = pwelch(One.averageNoAlignmentFiltered,[],[],[],240);
     pxx2 = pwelch(Two.averageNoAlignmentFiltered,[],[],[],240);
     pxx3 = pwelch(Three.averageNoAlignmentFiltered,[],[],[],240);
     pxx4 = pwelch(Four.averageNoAlignmentFiltered,[],[],[],240);
     pxx5 = pwelch(Noise.averageNoAlignmentFiltered,[],[],[],240);

plot(w1,log10(pxx1))
hold on
plot(w,log10(pxx2))
plot(w,log10(pxx3))
plot(w,log10(pxx4))
plot(w,log10(pxx5))

title('Recovered Spectrum, Wine Glas')
xlabel('Frequency (Hz)')
ylabel('Power (Log Normalized)') 
legend('Glass One (Empty)','Glass Two (Empty)', 'Glass Three (Empty)', 'Glass Four (Water)', 'Noise')

%% Shirts Experiment 30 FPS (4Sc, 8Or)

%{
%Gaussian Filtering
Shirt1.averageNoAlignmentFiltered = imgaussfilt(Shirt1.averageNoAlignment, 0.25);
Shirt1_C.averageNoAlignmentFiltered = imgaussfilt(Shirt1_C.averageNoAlignment, 0.25);
%}

[pxx1,w1] = pwelch(Shirt1.averageNoAlignment,[],[],[],30);
[pxx2,w2] = pwelch(Shirt1_C.averageNoAlignment,[],[],[],30);

plot(w1,log10(pxx1))
hold on
plot(w2,log10(pxx2))

title('Recovered Spectrum, Shirt')
xlabel('Frequency (Hz)')
ylabel('Power (Log Normalized)')
legend('Shirt','Shirt-Coated')

%% Fabric Experiment 30FPS (4Sc, 8Or)

% Crop Training Set

Crop = 1707;

Cotton1_v1_C = Cotton1_v1.averageNoAlignment(1:Crop);
Peva1_v1_C = Peva1_v1.averageNoAlignment(1:Crop);
Polyster1_v1_C = Polyster1_v1.averageNoAlignment(1:Crop);

Cotton1_v2_C = Cotton1_v2.averageNoAlignment(1:Crop);
Peva1_v2_C = Peva1_v2.averageNoAlignment(1:Crop);
Polyster1_v2_C = Polyster1_v2.averageNoAlignment(1:Crop);

Cotton1_v3_C = Cotton1_v3.averageNoAlignment(1:Crop);
Peva1_v3_C = Peva1_v3.averageNoAlignment(1:Crop);
Polyster1_v3_C = Polyster1_v3.averageNoAlignment(1:Crop);

Cotton1_v4_C = Cotton1_v4.averageNoAlignment(1:Crop);
Peva1_v4_C = Peva1_v4.averageNoAlignment(1:Crop);
Polyster1_v4_C = Polyster1_v4.averageNoAlignment(1:Crop);

% Fabric Crop Testing Set

Crop = 1707;

Cotton2_v1_C = Cotton2_v1.averageNoAlignment(1:Crop);
Peva2_v1_C = Peva2_v1.averageNoAlignment(1:Crop);
Polyster2_v1_C = Polyster2_v1.averageNoAlignment(1:Crop);

Cotton2_v2_C = Cotton2_v2.averageNoAlignment(1:Crop);
Peva2_v2_C = Peva2_v2.averageNoAlignment(1:Crop);
Polyster2_v2_C = Polyster2_v2.averageNoAlignment(1:Crop);

Cotton2_v3_C = Cotton2_v3.averageNoAlignment(1:Crop);
Peva2_v3_C = Peva2_v3.averageNoAlignment(1:Crop);
Polyster2_v3_C = Polyster2_v3.averageNoAlignment(1:Crop);

Cotton2_v4_C = Cotton2_v4.averageNoAlignment(1:Crop);
Peva2_v4_C = Peva2_v4.averageNoAlignment(1:Crop);
Polyster2_v4_C = Polyster2_v4.averageNoAlignment(1:Crop);

%% Training Set (PSD, Log)

%Cotton1
    [Cotton1_v1_C_P,w] = pwelch(Cotton1_v1_C,[],[],[],30);
    Cotton1_v2_C_P = pwelch(Cotton1_v2_C,[],[],[],30);
    Cotton1_v3_C_P = pwelch(Cotton1_v3_C,[],[],[],30);
    Cotton1_v4_C_P = pwelch(Cotton1_v4_C,[],[],[],30);
    
    Cotton1_v1_C_P_log = log10(Cotton1_v1_C_P);
    Cotton1_v2_C_P_log = log10(Cotton1_v2_C_P);
    Cotton1_v3_C_P_log = log10(Cotton1_v3_C_P);
    Cotton1_v4_C_P_log = log10(Cotton1_v4_C_P);

%Peva
    [Peva1_v1_C_P,w] = pwelch(Peva_v1_C,[],[],[],30);
    Peva1_v2_C_P = pwelch(Peva1_v2_C,[],[],[],30);
    Peva1_v3_C_P = pwelch(Peva1_v3_C,[],[],[],30);
    Peva1_v4_C_P = pwelch(Peva1_v4_C,[],[],[],30);
    
    Peva1_v1_C_P_log = log10(Peva1_v1_C_P);
    Peva1_v2_C_P_log = log10(Peva1_v2_C_P);
    Peva1_v3_C_P_log = log10(Peva1_v3_C_P);
    Peva1_v4_C_P_log = log10(Peva1_v4_C_P);


%Polyster
    [Polyster1_v1_C_P,w] = pwelch(Polyster1_v1_C,[],[],[],30);
    Polyster1_v2_C_P = pwelch(Polyster1_v2_C,[],[],[],30);
    Polyster1_v3_C_P = pwelch(Polyster1_v3_C,[],[],[],30);
    Polyster1_v4_C_P = pwelch(Polyster1_v4_C,[],[],[],30);
    
    Polyster1_v1_C_P_log = log10(Polyster1_v1_C_P);
    Polyster1_v2_C_P_log = log10(Polyster1_v2_C_P);
    Polyster1_v3_C_P_log = log10(Polyster1_v3_C_P);
    Polyster1_v4_C_P_log = log10(Polyster1_v4_C_P);

%Plot
    %{
    plot(w, Cotton1_v4_C_P_log)
    hold on
    plot(w, Peva_v4_C_P_log)
    plot(w, Polyster_v4_C_P_log)
    
    legend('Cotton1-v4','Peva1-v4', 'Polyster1-v4')
    %}

%% Testing Set (PSD, Log)

%Cotton2
    [Cotton2_v1_C_P,w] = pwelch(Cotton2_v1_C,[],[],[],30);
    Cotton2_v2_C_P = pwelch(Cotton2_v2_C,[],[],[],30);
    Cotton2_v3_C_P = pwelch(Cotton2_v3_C,[],[],[],30);
    Cotton2_v4_C_P = pwelch(Cotton2_v4_C,[],[],[],30);
    
    Cotton2_v1_C_P_log = log10(Cotton2_v1_C_P);
    Cotton2_v2_C_P_log = log10(Cotton2_v2_C_P);
    Cotton2_v3_C_P_log = log10(Cotton2_v3_C_P);
    Cotton2_v4_C_P_log = log10(Cotton2_v4_C_P);
    
    %Peva
    [Peva2_v1_C_P,w] = pwelch(Peva2_v1_C,[],[],[],30);
    Peva2_v2_C_P = pwelch(Peva2_v2_C,[],[],[],30);
    Peva2_v3_C_P = pwelch(Peva2_v3_C,[],[],[],30);
    Peva2_v4_C_P = pwelch(Peva2_v4_C,[],[],[],30);
    
    Peva2_v1_C_P_log = log10(Peva2_v1_C_P);
    Peva2_v2_C_P_log = log10(Peva2_v2_C_P);
    Peva2_v3_C_P_log = log10(Peva2_v3_C_P);
    Peva2_v4_C_P_log = log10(Peva2_v4_C_P);


%Polyster
    [Polyster2_v1_C_P,w] = pwelch(Polyster2_v1_C,[],[],[],30);
    Polyster2_v2_C_P = pwelch(Polyster2_v2_C,[],[],[],30);
    Polyster2_v3_C_P = pwelch(Polyster2_v3_C,[],[],[],30);
    Polyster2_v4_C_P = pwelch(Polyster2_v4_C,[],[],[],30);
    
    Polyster2_v1_C_P_log = log10(Polyster2_v1_C_P);
    Polyster2_v2_C_P_log = log10(Polyster2_v2_C_P);
    Polyster2_v3_C_P_log = log10(Polyster2_v3_C_P);
    Polyster2_v4_C_P_log = log10(Polyster2_v4_C_P);

 %Plot
    %{
    plot(w, Cotton2_v4_C_P_log)
    hold on
    plot(w, Peva2_v4_C_P_log)
    plot(w, Polyster2_v4_C_P_log)
    
    legend('Cotton2-v1','Peva2-v1', 'Polyster2-v1')
    %}

%% All viewpoints, 4626 Observations (Training)
clear

load Cotton1_C_P_log.mat
load Peva1_C_P_log.mat
load Polyster1_C_P_log.mat


FabricData = zeros(4626,2);

FabricData(1:257)   = Cotton1_v1_C_P_log;
FabricData(258:514) = Peva1_v1_C_P_log;
FabricData(515:771) = Polyster1_v1_C_P_log;

FabricData(772:1028)  = Cotton1_v1_C_P_log;
FabricData(1029:1285) = Peva1_v1_C_P_log;
FabricData(1286:1542) = Polyster1_v1_C_P_log;

FabricData(1543:1799) = Cotton1_v1_C_P_log;
FabricData(1800:2056) = Peva1_v1_C_P_log;
FabricData(2057:2313) = Polyster1_v1_C_P_log;

FabricData(2314:2570) = Cotton1_v2_C_P_log;
FabricData(2571:2827) = Peva1_v2_C_P_log;
FabricData(2828:3084) = Polyster1_v2_C_P_log;

FabricData(3085:3341) = Cotton1_v2_C_P_log;
FabricData(3342:3598) = Peva1_v2_C_P_log;
FabricData(3599:3855) = Polyster1_v2_C_P_log;

FabricData(3856:4112) = Cotton1_v3_C_P_log;
FabricData(4113:4369) = Peva1_v3_C_P_log;
FabricData(4370:4626) = Polyster1_v3_C_P_log;


FabricData(4627:4883) = Cotton1_v2_C_P_log;
FabricData(4884:5140) = Peva1_v2_C_P_log;
FabricData(5141:5397) = Polyster1_v2_C_P_log;

FabricData(5398:5654) = Cotton1_v3_C_P_log;
FabricData(5655:5911) = Peva1_v3_C_P_log;
FabricData(5912:6168) = Polyster1_v3_C_P_log;

FabricData(6169:6425) = Cotton1_v4_C_P_log;
FabricData(6426:6682) = Peva1_v4_C_P_log;
FabricData(6683:6939) = Polyster1_v4_C_P_log;

FabricData(6940:7196) = Cotton1_v3_C_P_log;
FabricData(7197:7453) = Peva1_v3_C_P_log;
FabricData(7454:7710) = Polyster1_v3_C_P_log;

FabricData(7711:7967) = Cotton1_v4_C_P_log;
FabricData(7968:8224) = Peva1_v4_C_P_log;
FabricData(8225:8481) = Polyster1_v4_C_P_log;

FabricData(8482:8738) = Cotton1_v4_C_P_log;
FabricData(8739:8995) = Peva1_v4_C_P_log;
FabricData(8996:9252) = Polyster1_v4_C_P_log;

FabricType = cell(4626,1);

FabricType(1:257) = {'Cotton'};
FabricType(258:514) = {'Peva'};
FabricType(515:771) = {'Polyster'};

FabricType(772:1028) = {'Cotton'};
FabricType(1029:1285) = {'Peva'};
FabricType(1286:1542) = {'Polyster'};

FabricType(1543:1799) = {'Cotton'};
FabricType(1800:2056) = {'Peva'};
FabricType(2057:2313) = {'Polyster'};

FabricType(2314:2570) = {'Cotton'};
FabricType(2571:2827) = {'Peva'};
FabricType(2828:3084) = {'Polyster'};

FabricType(3085:3341) = {'Cotton'};
FabricType(3342:3598) = {'Peva'};
FabricType(3599:3855) = {'Polyster'};

FabricType(3856:4112) = {'Cotton'};
FabricType(4113:4369) = {'Peva'};
FabricType(4370:4626) = {'Polyster'};


FabricTable = table(FabricData, FabricType);

%% All viewpoints, 4626 Observations (Testing)
clear

load Cotton2_C_P_log.mat
load Peva2_C_P_log.mat
load Polyster2_C_P_log.mat


FabricData = zeros(4626,2);

FabricData(1:257)   = Cotton2_v1_C_P_log;
FabricData(258:514) = Peva2_v1_C_P_log;
FabricData(515:771) = Polyster2_v1_C_P_log;

FabricData(772:1028)  = Cotton2_v1_C_P_log;
FabricData(1029:1285) = Peva2_v1_C_P_log;
FabricData(1286:1542) = Polyster2_v1_C_P_log;

FabricData(1543:1799) = Cotton2_v1_C_P_log;
FabricData(1800:2056) = Peva2_v1_C_P_log;
FabricData(2057:2313) = Polyster2_v1_C_P_log;

FabricData(2314:2570) = Cotton2_v2_C_P_log;
FabricData(2571:2827) = Peva2_v2_C_P_log;
FabricData(2828:3084) = Polyster2_v2_C_P_log;

FabricData(3085:3341) = Cotton2_v2_C_P_log;
FabricData(3342:3598) = Peva2_v2_C_P_log;
FabricData(3599:3855) = Polyster2_v2_C_P_log;

FabricData(3856:4112) = Cotton2_v3_C_P_log;
FabricData(4113:4369) = Peva2_v3_C_P_log;
FabricData(4370:4626) = Polyster2_v3_C_P_log;


FabricData(4627:4883) = Cotton2_v2_C_P_log;
FabricData(4884:5140) = Peva2_v2_C_P_log;
FabricData(5141:5397) = Polyster2_v2_C_P_log;

FabricData(5398:5654) = Cotton2_v3_C_P_log;
FabricData(5655:5911) = Peva2_v3_C_P_log;
FabricData(5912:6168) = Polyster2_v3_C_P_log;

FabricData(6169:6425) = Cotton2_v4_C_P_log;
FabricData(6426:6682) = Peva2_v4_C_P_log;
FabricData(6683:6939) = Polyster2_v4_C_P_log;

FabricData(6940:7196) = Cotton2_v3_C_P_log;
FabricData(7197:7453) = Peva2_v3_C_P_log;
FabricData(7454:7710) = Polyster2_v3_C_P_log;

FabricData(7711:7967) = Cotton2_v4_C_P_log;
FabricData(7968:8224) = Peva2_v4_C_P_log;
FabricData(8225:8481) = Polyster2_v4_C_P_log;

FabricData(8482:8738) = Cotton2_v4_C_P_log;
FabricData(8739:8995) = Peva2_v4_C_P_log;
FabricData(8996:9252) = Polyster2_v4_C_P_log;

FabricType = cell(4626,1);

FabricType(1:257) = {'Cotton'};
FabricType(258:514) = {'Peva'};
FabricType(515:771) = {'Polyster'};

FabricType(772:1028) = {'Cotton'};
FabricType(1029:1285) = {'Peva'};
FabricType(1286:1542) = {'Polyster'};

FabricType(1543:1799) = {'Cotton'};
FabricType(1800:2056) = {'Peva'};
FabricType(2057:2313) = {'Polyster'};

FabricType(2314:2570) = {'Cotton'};
FabricType(2571:2827) = {'Peva'};
FabricType(2828:3084) = {'Polyster'};

FabricType(3085:3341) = {'Cotton'};
FabricType(3342:3598) = {'Peva'};
FabricType(3599:3855) = {'Polyster'};

FabricType(3856:4112) = {'Cotton'};
FabricType(4113:4369) = {'Peva'};
FabricType(4370:4626) = {'Polyster'};


FabricTable = table(FabricData, FabricType);

%% Predict on new data
yfit = trainedModel.predictFcn(FabricTable);
CP = classperf(FabricType, yfit)

CP.CorrectRate

%% V3 discarded, 2313 Observations (Training)

clear

load Cotton1_C_P_log.mat
load Peva1_C_P_log.mat
load Polyster1_C_P_log.mat


FabricData = zeros(2313,2);

FabricData(1:257)   = Cotton1_v1_C_P_log;
FabricData(258:514) = Peva1_v1_C_P_log;
FabricData(515:771) = Polyster1_v1_C_P_log;

FabricData(772:1028)  = Cotton1_v1_C_P_log;
FabricData(1029:1285) = Peva1_v1_C_P_log;
FabricData(1286:1542) = Polyster1_v1_C_P_log;

FabricData(1543:1799) = Cotton1_v2_C_P_log;
FabricData(1800:2056) = Peva1_v2_C_P_log;
FabricData(2057:2313) = Polyster1_v2_C_P_log;

FabricData(2314:2570) = Cotton1_v2_C_P_log;
FabricData(2571:2827) = Peva1_v2_C_P_log;
FabricData(2828:3084) = Polyster1_v2_C_P_log;

FabricData(3085:3341) = Cotton1_v4_C_P_log;
FabricData(3342:3598) = Peva1_v4_C_P_log;
FabricData(3599:3855) = Polyster1_v4_C_P_log;

FabricData(3856:4112) = Cotton1_v4_C_P_log;
FabricData(4113:4369) = Peva1_v4_C_P_log;
FabricData(4370:4626) = Polyster1_v4_C_P_log;

FabricType = cell(2313,1);

FabricType(1:257) = {'Cotton'};
FabricType(258:514) = {'Peva'};
FabricType(515:771) = {'Polyster'};

FabricType(772:1028) = {'Cotton'};
FabricType(1029:1285) = {'Peva'};
FabricType(1286:1542) = {'Polyster'};

FabricType(1543:1799) = {'Cotton'};
FabricType(1800:2056) = {'Peva'};
FabricType(2057:2313) = {'Polyster'};

FabricTable = table(FabricData, FabricType);

%% V3 discarded, 2313 Observations (Testing)

clear

load Cotton2_C_P_log.mat
load Peva2_C_P_log.mat
load Polyster2_C_P_log.mat


FabricData = zeros(2313,2);

FabricData(1:257)   = Cotton2_v1_C_P_log;
FabricData(258:514) = Peva2_v1_C_P_log;
FabricData(515:771) = Polyster2_v1_C_P_log;

FabricData(772:1028)  = Cotton2_v1_C_P_log;
FabricData(1029:1285) = Peva2_v1_C_P_log;
FabricData(1286:1542) = Polyster2_v1_C_P_log;

FabricData(1543:1799) = Cotton2_v2_C_P_log;
FabricData(1800:2056) = Peva2_v2_C_P_log;
FabricData(2057:2313) = Polyster2_v2_C_P_log;

FabricData(2314:2570) = Cotton2_v2_C_P_log;
FabricData(2571:2827) = Peva2_v2_C_P_log;
FabricData(2828:3084) = Polyster2_v2_C_P_log;

FabricData(3085:3341) = Cotton2_v4_C_P_log;
FabricData(3342:3598) = Peva2_v4_C_P_log;
FabricData(3599:3855) = Polyster2_v4_C_P_log;

FabricData(3856:4112) = Cotton2_v4_C_P_log;
FabricData(4113:4369) = Peva2_v4_C_P_log;
FabricData(4370:4626) = Polyster2_v4_C_P_log;

FabricType = cell(2313,1);

FabricType(1:257) = {'Cotton'};
FabricType(258:514) = {'Peva'};
FabricType(515:771) = {'Polyster'};

FabricType(772:1028) = {'Cotton'};
FabricType(1029:1285) = {'Peva'};
FabricType(1286:1542) = {'Polyster'};

FabricType(1543:1799) = {'Cotton'};
FabricType(1800:2056) = {'Peva'};
FabricType(2057:2313) = {'Polyster'};

FabricTable = table(FabricData, FabricType);

%% Predict on new data
yfit = trainedModel.predictFcn(FabricTable);
CP = classperf(FabricType, yfit)

CP.CorrectRate

%% V3 discarded, 771 observations (Training)

clear

load Cotton1_C_P_log.mat
load Peva1_C_P_log.mat
load Polyster1_C_P_log.mat


FabricData = zeros(771,3);

FabricData(1:257)   = Cotton1_v1_C_P_log;
FabricData(258:514) = Peva1_v1_C_P_log;
FabricData(515:771) = Polyster1_v1_C_P_log;

FabricData(772:1028)  = Cotton1_v2_C_P_log;
FabricData(1029:1285) = Peva1_v2_C_P_log;
FabricData(1286:1542) = Polyster1_v2_C_P_log;

FabricData(1543:1799) = Cotton1_v4_C_P_log;
FabricData(1800:2056) = Peva1_v4_C_P_log;
FabricData(2057:2313) = Polyster1_v4_C_P_log;

FabricType = cell(771,1);

FabricType(1:257) = {'Cotton'};
FabricType(258:514) = {'Peva'};
FabricType(515:771) = {'Polyster'};

FabricTable = table(FabricData, FabricType);

%% V3 discarded, 771 observations (Testing)

clear

load Cotton2_C_P_log.mat
load Peva2_C_P_log.mat
load Polyster2_C_P_log.mat


FabricData = zeros(771,3);

FabricData(1:257)   = Cotton2_v1_C_P_log;
FabricData(258:514) = Peva2_v1_C_P_log;
FabricData(515:771) = Polyster2_v1_C_P_log;

FabricData(772:1028)  = Cotton2_v2_C_P_log;
FabricData(1029:1285) = Peva2_v2_C_P_log;
FabricData(1286:1542) = Polyster2_v2_C_P_log;

FabricData(1543:1799) = Cotton2_v4_C_P_log;
FabricData(1800:2056) = Peva2_v4_C_P_log;
FabricData(2057:2313) = Polyster2_v4_C_P_log;

FabricType = cell(771,1);

FabricType(1:257) = {'Cotton'};
FabricType(258:514) = {'Peva'};
FabricType(515:771) = {'Polyster'};

FabricTable = table(FabricData, FabricType);

%% Predict on new data
yfit = trainedModel.predictFcn(FabricTable);
CP = classperf(FabricType, yfit)

CP.CorrectRate
