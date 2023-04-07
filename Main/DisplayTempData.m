clear
clc

%% Load and Plot the PFT data
% pathname='E:\OneDrive - University of New Brunswick\Measurements\PFT_Data';%Where the data is saved on home computer
pathname="C:\Users\e5862\OneDrive - University of New Brunswick\Measurements\PFT_Data\SEPI-3" % UNB computer
addpath(pathname);
files=(dir(pathname));
files=files(~[files.isdir]);
x=bubblesort(files); % Sort the files cronologically
[s,~]=size(files); %  number of files in directory
figure




for i=1:s
    PFT=load(files(i).name);
    plot(PFT.PFT(:,3));
    ylim([0 25]);
    title(files(i).name)
    Temp(:,i)=PFT.PFT(:,3);
    drawnow
end
figure
surf(Temp,'EdgeColor','Interp');