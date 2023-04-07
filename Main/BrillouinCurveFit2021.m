function [PFT fy] = BrillouinCurveFit2021(delf,resol,Freqat20,TempCoeff,FinalAVG)

% BrillouinCurveFit2018 cross correlates measured results with an ideal
% Brillouin Gain curve in order to locate the peak frequency and in turn the
% temperature of that point along the fiber

% Modified in 2021 by James McMurtrie  
% - No longer requires cableL. FinalAVG contains cable lenght in column 6. if
% length is missing(old data sets) length is calculated.
% - Modified from BrillouinCurveFit2018
% [PFT fy] = BrillouinCurveFit2021(35e6,0.1e6,10.9778e9,0.7581,FinalAVG);
%
% Modified in 2018 by BC as follows:
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
%[PFT fy] = BrillouinCurveFit2021(35e6,0.1e6,10.9778e9,0.7581,FinalAVG);
%plot(FvP(:,2),FvP(:,1)-fb)
%xlabel('Position in meters from pulse end')
%ylabel('Frequency offset from fb (typ 11 GHz)')
%plot(PFT(:,1),PFT(:,2))
%plot(PFT(:,1),PFT(:,3))


%% Get information from header

SFinalAVG=FinalAVG(:,(21:end)); % Remove the header information
jsize=size(SFinalAVG); % first element is the number of frequencies measured second is the number of time samples
StartFreq=FinalAVG(1,2); % Obtain measurement parameters from header information
EndFreq=FinalAVG(1,5);
StepSize=FinalAVG(1,3);
f=StartFreq:StepSize:EndFreq;% These are the measured frequency points reconstructed from the header data

% Check if cableL is in the header info
if FinalAVG(1,6)==0
    cableL=((jsize(2)-4116)/10)-1;% 2048 points at start and end + 20 columns of header info = 4116
else
    cableL=FinalAVG(1,6);
end

%% Shift all data to positive
% Translation in the +z direction
if min(min(SFinalAVG))<0
    SFinalAVG=SFinalAVG+abs(min(min(SFinalAVG)));
end
stretch=150; % Increase the number of data points used
%% Build ideal lorentzian
%resol=0.1e6 ;% Set the frequency resolution of the correlation fit
%fb=10.98e9; % Set the gain profile center frequency
%delf=35e6; % Set the gain profile width
fb=(StartFreq + EndFreq)/2;
fnew=StartFreq:resol:EndFreq;
size(fnew);
amp=max(max(SFinalAVG)); %Set the Brillouin peak amplitude to that of the measured data
% amp=max(amp);
 bg=amp*(1+4*((fnew-fb)./delf).^2).^-1; % Calculate the Brillouin gain over the resampled frequency range
% figure(3);
% plot(bg);
%Position vector is defined based on spacial resolution and length of cable
%(as a multiple of the space resolution).

cableL = round(cableL/0.102095);
position = 0:0.102095:(cableL+stretch)*0.102095; % Determines the length of valid measurements
%0.102095m is travelled per sample. v = c/1.4682=204.1905e6m/s gives
%d=0.102095
Clength=size(position);

%% Find the peak Frequencies
% At each time step resample the data at finer frequency steps and cross
% correlate to determine the peak position.
k=1;
%for r=1:jsize(2); % Do this for each time step
% for r=(2049+171):(2048+171)+Clength(2); % Do this for each time step omitting the noise at the ends
%    for r=2501:2500+Clength(2);
% fy=zeros(1,Clength(2));
for r=2048+20:2048+20+Clength(2)-1
    SFinalAVG1=spline(f,SFinalAVG(:,r),fnew); % Resample the measured data
    
    % Ideal Lorentzian of this position
    amp=max(SFinalAVG1); %Set the Brillouin peak amplitude to that of the measured data
    bg=amp*(1+4*((fnew-fb)./delf).^2).^-1; % Calculate the Brillouin gain over the resampled frequency range
    
    % Crosscorrelation to find peak frequency
    yfit=(crosscorr(SFinalAVG1,bg))'; % Cross correlate with the ideal Brillouin curve
    [a,b]=max(yfit); % Select the peak correlation point
    
    
        SD(k)=std(SFinalAVG(:,r));
        figure(2)
        clf
        plot(SFinalAVG1','b');
        hold on
        plot(bg,'g')
        title(['SD ',num2str(SD(k))]);
        hold on
        beginning = round(size(fnew,2)/2);
        completion = beginning + size(fnew,2);
%         figure(3)
        P=spline(1:2001,yfit,1:2:2001);
        [x,y]=meshgrid(P,SFinalAVG1);
        plot(x(1,:),'r')

%         hold off
% plot(SFinalAVG1,'r')
%         plot(P,'r')
        drawnow
    if SD(k)>5e-5
        fy(k)=b;
    else
        fy(k)=nan;
    end
    k=k+1;
end

temp=size(bg);
%PI= round((EndFreq - fb)/(EndFreq - StartFreq) *temp(2)); % Find the peak index in the bg vector, it gets flipped will always be centered now
%frequency=(fy-PI)*resol+StartFreq; % Convert the correlation peaks to frequency
for i=1:length(fy)
    frequency(i)=(fy(i)-temp(2)/2)*resol+StartFreq; % Convert the correlation peaks to frequency
end
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

% PFT=[position',frequency',(frequency'-Freqat20)/1e6 .* TempCoeff+20];
PFT=[position',frequency',20-((Freqat20-frequency')./(1e6*TempCoeff))];

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
