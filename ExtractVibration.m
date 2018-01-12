%%
function [S] = ExtractVibration(vHandle, nScalesin, nOrientationsin, dSamplefactorin)

%Setup parameters
tic;
startTime = toc;

nF = vHandle.NumberOfFrames;

framein = vHandle.read(1);

%%  Crop image for glass experiment

%imcrop(framein)
%[framein] = imcrop(framein,[0.5 0.5 1280 669]);

%%
if(dSamplefactorin == 1)
        refFrame = im2single(squeeze(mean(framein,3))); %Full size
    else
        refFrame = im2single(squeeze(mean(imresize(framein,dSamplefactorin),3))); %Downsampled
end
    
    
[h,w] = size(refFrame); %height, width

%%

%Pyramid for reference frame
[pyrRef, pind] = buildSCFpyr(refFrame, nScalesin, nOrientationsin-1);


signalffs = zeros(nScalesin,nOrientationsin,nF);
ampsigs = zeros(nScalesin,nOrientationsin,nF);


%Process
for q = 1:nF
    
    %Progress bar
    if(mod(q,floor(nF/100))==1)
        progress = q/nF;
        currentTime = toc;
        ['Progress:' num2str(progress*100) '% done after ' num2str(currentTime-startTime) ' seconds.']
    end

    %Read current frame, build pyramid, extract subband signal.
    framein = vHandle.read(q);
    
    %%  Crop image for glass experiment
    
    %imcrop(framein)
    %[framein] = imcrop(framein,[0.5 0.5 1280 669]);
    
    %%
    
    if(dSamplefactorin == 1)
        ProcessFrame = im2single(squeeze(mean(framein,3)));
    else
        ProcessFrame = im2single(squeeze(mean(imresize(framein,dSamplefactorin),3)));
    end
    
    pyr = buildSCFpyr(ProcessFrame, nScalesin, nOrientationsin-1);
    pyrAmp = abs(pyr);  %real values / magnitudes of complex subbands
    pyrDeltaPhase = mod(pi+angle(pyr)-angle(pyrRef), 2*pi) - pi; %Compute phase difference

    for j = 1:nScalesin      
        for k = 1:nOrientationsin
            bandIdx = 1 + (j-1)*nOrientationsin + k;   %Compute subband number based on current scale and orientation
            amp = pyrBand(pyrAmp, pind, bandIdx);   %Access real pyramid subband and set it to amp
            phase = pyrBand(pyrDeltaPhase, pind, bandIdx);  %Acess phase difference pyramid subband and set to phase
            
            %Weigh each phase signal by its squared amplitude (Increase SNR)
            phasew = phase.*(abs(amp).^2);
            
            sumamp = sum(abs(amp(:)));
            
            ampsigs(j,k,q)= sumamp;
            
            signalffs(j,k,q)=mean(phasew(:))/sumamp;    %mean of every subband divded by sum of amplitude subband.
        end
    end    
end

%Average
S.averageNoAlignment = mean(reshape(double(signalffs),nScalesin*nOrientationsin,nF)).';  %overall mean of phase


end
