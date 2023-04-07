% Continuous BOTDA data acquisition
clear
clc
addpath('C:\Matlab_SDK\CsMl');
addpath('C:\Users\Fiberlaser\Downloads\MCP2210_DLLv2\mcp2210_dll_v2.1.0\unmanaged\dll');
CsMl_FreeAllSystems; % This seems to help if system will not start
CsMl_FreeSystem(131083);
temp=fix(clock);
date=temp(3);
stopdate = 32;
figure(1);

temp=fix(clock);
date=temp(3);
count = 1;


%warning('off', 'MSGID') % use lastwarn to identify message
warning('off')
hold on

while date<= stopdate
    temp=fix(clock);
    time=temp(5); % minutes as an integer
    while (time == 00) || (time == 15) || (time == 30) || (time == 45) % Measurement every 15 minutes
        if time==00
            disp('on the hour')
        elseif time==15
            disp('15 minutes after the hour')
        elseif time==30
            disp('Half past the hour')
        elseif time==45
            disp('45 minutes after the hour')
        else
            break;
        end
        
        % Set up Acquisition parameters
        FreqStart=10.9e9;
        FreqEnd=11.02e9;
        FreqStep=10e6;
        AVGpass=500;
        FiberLength=200;
        savepass=0;
        basepass=1;
        typepass=5;
        
        ret= measurementfunction(FreqStart,FreqEnd,FreqStep,AVGpass,FiberLength,savepass,basepass,typepass);
        load(['C:\Brillouin_Measurement_Files\SavedData\averaged_readings.mat'])
        %load averaged_readings
        % [PFT fy]=BrillouinCurveFit(10.98e9,35e6,0.1e6,10.98e9,1,FinalAVG);
        [PFT fy] = BrillouinCurveFit(10.98e9,35e6,FreqStep,[10.9778e9 10.9778e9],[0.7581 0.7581],FinalAVG,FiberLength);
        plot(PFT(:,1),PFT(:,3),'b')
        mydata=sprintf('PFT%d%d%d%d%d%d',fix(clock));
        save(['C:\BOTDA_DATA\' mydata '.mat'], 'PFT');
        
        pause(15)
        clear
        temp=fix(clock);
        date=temp(3);
        stopdate = 32;
        temp=fix(clock);
        time=temp(5); % minutes as an integer
    end
    pause(5)
end