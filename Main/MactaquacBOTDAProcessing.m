clear
clc
% pathname='C:\Users\e5862\OneDrive - University of New Brunswick\Measurements\Continuous\';
pathname='E:\OneDrive - University of New Brunswick\Mactaquac_BOTDA_Software\Test_Scripts';

addpath(pathname);

%% Setup some variables
mypool=gcp;
colormap 'jet'
dayTemp=[];
dayFreq=[];
avgPFT=0;
allAVG=0;
AVGDailyTemp=[];
AVGDailyFreq=[];
hold on
figure(1);
%% Process raw data
% month=11;% october
t=tic;
k=1;
for year =2021:2022
    for month=1:12
        for day=1:31
            names=['SEPI-3_1000Averages_' num2str(year) '_' num2str(month) '_' num2str(day) '_' '*.mat'];% file name
            files=bubblesort(dir([pathname names]));
            s=size(files);
            s=s(1,1);
            if s>0
                parfor i=1:s
                    try
                        b=load(files(i).name);
                        % allAVG=allAVG+b.FinalAVG(:,21:end);
                        [PFT,fy] = BrillouinCurveFit2018(35e6,0.1e6,10.9778e9,0.7581,b.FinalAVG,165);
                        dayTemp(:,i)=PFT(:,3);
                        dayFreq(:,i)=PFT(:,2);
                        %                 avgPFT=avgPFT+PFT;
                    catch ME
                        % Nothing to do, continue the loop
                    end
                end
                toc(t)
                dates(k)=day;
                if ~isempty(dayTemp) && k>1
                    AVGDailyTemp(:,k)=mean(dayTemp,2);
                    AVGDailyFreq(:,k)=mean(dayFreq,2);
                    Hsurf=surf(AVGDailyTemp,'EdgeColor','interp');
                    %             Hsurf=surf(dates,1:length(AVGDailyTemp),AVGDailyTemp,'EdgeColor','interp');
                end
                dayTemp=[];
                dayfreq=[];
                drawnow;
                k=k+1;
            end
        end
    end
end
% Hsurf=surf(AVGDailyTemp,'EdgeColor','interp');