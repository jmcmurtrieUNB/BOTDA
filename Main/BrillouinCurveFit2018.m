function [PFT fy] = BrillouinCurveFit2018(delf,resol,Freqat20,TempCoeff,FinalAVG,cableL)
%BrillouinCurveFit2018 cross correlates measured results with an ideal
%Brillouin Gain curve in order to locate the peak frequency and in turn the
%temperature of that point along the fiber. Modified in 2018 by BC as
%follows:
%  Uses a single fiber instead of using two correction factors.
%  Centers the Brillouin Gain Profile within the acquisition window which
%  maintains symmetry and easies temperature calculations.
% Coefficients are peat at 20 degrees Celsius and degrees per MHz
% Blue fiber coefficients 10.9778e9 and 0.7581
% Red fiber coefficients 10.970586e9 and 0.8235294
% Uses the FinalAVG data file
% Resamples and fits to a Brillouin gain profile
% Produces an array of the peak frequency
% Gives temperature as a function of position
%Freqat20= 10.9778e9; % Brillouin peak for fiber at 20 degrees
%C for the forward and reverse fibres during experiments at the lab
%TempCoeff = 0.7581; % Temperature coefficient is degrees per MHz for
%the forward and reverse paths during experiments at the lab
% cableL is the length of the cable, which was measured to be approx 165.2m
% Produces an array of three columns position, frequency, temperature PFT.
% Also a plot of temperature vs. position is created.
%[PFT fy] = BrillouinCurveFit2018(35e6,0.1e6,10.9778e9,0.7581,FinalAVG,50);
%plot(FvP(:,2),FvP(:,1)-fb)
%xlabel('Position in meters from pulse end')
%ylabel('Frequency offset from fb (typ 11 GHz)')
%plot(PFT(:,1),PFT(:,2))
%plot(PFT(:,1),PFT(:,3))


% SFinalAVG=FinalAVG(:,(21:end)); % Remove the header information
SFinalAVG=FinalAVG(:,(21:end)); % Remove the header information
% figure(1)
%clf
%mesh(FinalAVG(:,(21:end)))
%pause
%view(2)
%pause
jsize=size(SFinalAVG); % first element is the number of frequencies measured second is the number of time samples
StartFreq=FinalAVG(1,2); % Obtain measurement parameters from header information
EndFreq=FinalAVG(1,5);
StepSize=FinalAVG(1,3);
f=StartFreq:StepSize:EndFreq;% These are the measured frequency points reconstructed from the header data
%resol=0.1e6 ;% Set the frequency resolution of the correlation fit
%fb=10.98e9; % Set the gain profile center frequency
%delf=35e6; % Set the gain profile width
fb=(StartFreq + EndFreq)/2;
fnew=StartFreq:resol:EndFreq;
size(fnew);
amp=max(abs(SFinalAVG)); %Set the Brillouin peak amplitude to that of the measured data
amp=max(amp);
 bg=amp*(1+4*((fnew-fb)./delf).^2).^-1; % Calculate the Brillouin gain over the resampled frequency range
%figure(3);
%plot(bg);
%Position vector is defined based on spacial resolution and length of cable
%(as a multiple of the space resolution).

cableL = round(cableL/0.102095);
position = 0:0.102095:cableL*0.102095; % Determines the length of valid measurements
%0.102095m is travelled per sample. v = c/1.4682=204.1905e6m/s gives
%d=0.102095
Clength=size(position);

% At each time step resample the data at finer frequency steps and cross
% correlate to determine the peak position.
k=1;
%for r=1:jsize(2); % Do this for each time step
    for r=(2049+171):(2048+171)+Clength(2); % Do this for each time step omitting the noise at the ends
    SFinalAVG1=spline(f,SFinalAVG(:,r),fnew); % Resample the measured data
    yfit=(crosscorr(SFinalAVG1,bg))'; % Cross correlate with the ideal Brillouin curve  
    [a b]=max(yfit); % Select the peak correlation point
%     if (r>3800 && r<3810)
%     figure(2)
%     plot(SFinalAVG1)
%     hold on
%     beginning = round(size(fnew,2)/2);
%     completion = beginning + size(fnew,2);
%     plot(yfit(beginning:completion)/2)
%     pause
%     clf
%     end
    fy(k)=b;
    k=k+1;
    end
temp=size(bg);
%PI= round((EndFreq - fb)/(EndFreq - StartFreq) *temp(2)); % Find the peak index in the bg vector, it gets flipped will always be centered now
%frequency=(fy-PI)*resol+StartFreq; % Convert the correlation peaks to frequency
frequency=(fy-temp(2)/2)*resol+StartFreq; % Convert the correlation peaks to frequency

%Assume 1 GSPS and 2e8 m/s propagation speed,
%therefore 10 cm per sample.

%FvP=[frequency(2049:2048+Clength(2))' position']; % Omits the noise at each end of the data set.
%PFT=[position',frequency(2049:2048+Clength(2))',(frequency(2049:2048+Clength(2))'-Freqat20)/1e6 * TempCoeff];

%midInd = round(cableL/2);
%dummy1 = zeros(1, Clength(2));
%dummy1(1:midInd) = 1;
%dummy2((midInd+1):Clength(2)) = 1;

%Freqat20vec = Freqat20(1)*dummy1+Freqat20(2)*dummy2;
%TempCoeffVec = TempCoeff(1)*dummy1+TempCoeff(2)*dummy2;

PFT=[position',frequency',(frequency'-Freqat20)/1e6 .* TempCoeff+20];

% Plot of temperature vs. position
%figure(1)
%plot(PFT(:,1),PFT(:,3))
%itle('Temperature of the Fibre vs. Position');
%xlabel('Position [m]');
%ylabel('Temperature [ ^\circC]');
%axis([min(position) max(position) min(PFT(:,3))-5 max(PFT(:,3))+5]);
%grid on

% Plot of frequency vs. position
% Uncomment if desired
% figure(2)
% plot(PFT(:,1),PFT(:,2))
% title('Frequency vs. Position');
% xlabel('Position [m]');
% ylabel('Frequency [Hz]');
% axis([min(position) max(position) min(PFT(:,2))-5 max(PFT(:,2))+5]);
% grid on

end