function [PFT fy] = BrillouinCurveFitChanged(fb,delf,resol,Freqat20,TempCoeff,FinalAVG,cableL)
%BrillouinCurveFit cross correlates measured results with an ideal
%Brillouin Gain curve in order to locate the peak frequency and in turn the
%temperature of that point along the fiber.
% Uses the FinalAVG data file
% Resamples and fits to a Brillouin gain profile
% Produces an array of the peak frequency
% Gives temperature as a function of position
%Freqat20=[10.970586e9 10.9778e9]; % Brillouin peak for fiber at 20 degrees
%C for the forward and reverse fibres during experiments at the lab
%TempCoeff = [0.8235294 0.7581]; % Temperature coefficient is degrees per MHz for
%the forward and reverse paths during experiments at the lab
% cableL is the length of the cable, which was measured to be approx 165.2m
% Produces an array of three columns position, frequency, temperature PFT.
% Also a plot of temperature vs. position is created.
%[PFT fy] = BrillouinCurveFit(10.98e9,35e6,0.1e6,[10.970586e9 10.9778e9],[0.8235294 0.7581],FinalAVG,171);
%plot(FvP(:,2),FvP(:,1)-fb)
%xlabel('Position in meters from pulse end')
%ylabel('Frequency offset from fb (typ 11 GHz)')
%plot(PFT(:,1),PFT(:,2))
%plot(PFT(:,1),PFT(:,3))

SFinalAVG=FinalAVG(:,(21:end)); % Remove the header information
jsize=size(SFinalAVG); % first element is the number of frequencies measured, second is the number of time samples
StartFreq=FinalAVG(1,2); % Obtain measurement parameters from header information
EndFreq=FinalAVG(1,5);
StepSize=FinalAVG(1,3);
f=StartFreq:StepSize:EndFreq;% These are the measured frequency points reconstructed from the header data
%resol=0.1e6 ;% Set the frequency resolution of the correlation fit
%fb=10.98e9; % Set the gain profile center frequency
%delf=35e6; % Set the gain profile width
fnew=StartFreq:resol:EndFreq;

amp=max(max(abs(SFinalAVG))); %Set the Brillouin peak amplitude to that of the measured data
bg=-amp*(1+4*((fnew-fb)./delf).^2).^-1; % Calculate the Brillouin gain over the resampled frequency range

%Position vector is defined based on spacial resolution and length of cable
%(as a multiple of the space resolution).
c=299792458; % Speed of light in vacuum
v=c/1.4682; % Speed of Light in Fiber, index of refraction = 1.4682 for Corning SMF-28
SPS=1e9; % samples per second;
TimeBetweenSamples=1/SPS;
distance=v*TimeBetweenSamples;


cableL = round(cableL/distance);
position = 0:distance:cableL*distance; % Determines the length of valid measurements
%0.102095m is travelled per sample. v = c/1.4682=204.1905e6m/s gives
%d=0.102095
length=size(position);

% At each time step resample the data at finer frequency steps and cross
% correlate to determine the peak position.
k=1;
%for r=1:jsize(2); % Do this for each time step
    for r=(2049+171):(2048+171)+length(2); % Do this for each time step omitting the noise at the ends
    SFinalAVG1=spline(f,SFinalAVG(:,r),fnew); % Resample the measured data
    yfit=(crosscorr(SFinalAVG1,bg))'; % Cross correlate with the ideal Brillouin curve
   % plot(SFinalAVG1)
   % pause
    [a b]=max(yfit); % Select the peak correlation point
    fy(k)=b;
    k=k+1;
    end
temp=size(bg);
PI= round((EndFreq - fb)/(EndFreq - StartFreq) *temp(2)); % Find the peak index in the bg vector, it gets flipped
frequency=(fy-PI)*resol+StartFreq; % Convert the correlation peaks to frequency

%Assume 1 GSPS and 2e8 m/s propagation speed,
%therefore 10 cm per sample.

%FvP=[frequency(2049:2048+length(2))' position']; % Omits the noise at each end of the data set.
%PFT=[position',frequency(2049:2048+length(2))',(frequency(2049:2048+length(2))'-Freqat20)/1e6 * TempCoeff];

midInd = round(cableL/2);
dummy1 = zeros(1, length(2));
dummy1(1:midInd) = 1;
dummy2((midInd+1):length(2)) = 1;

Freqat20vec = Freqat20(1)*dummy1+Freqat20(2)*dummy2;
TempCoeffVec = TempCoeff(1)*dummy1+TempCoeff(2)*dummy2;

PFT=[position',frequency',(frequency'-Freqat20vec')/1e6 .* TempCoeffVec'+20];

% Plot of temperature vs. position
figure(1)
plot(PFT(:,1),PFT(:,3))
title('Temperature of the Fibre vs. Position');
xlabel('Position [m]');
ylabel('Temperature [ ^\circC]');
axis([min(position) max(position) min(PFT(:,3))-5 max(PFT(:,3))+5]);
grid on

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
