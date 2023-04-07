%% Re-name file names
% turns PFT file into a struct, adding a DateNumber vector
clear
clc
%% Do the thing

pathname='E:\OneDrive - University of New Brunswick\Measurements\testing\Processed'; %Where the data is saved
pathname='C:\Users\e5862\OneDrive - University of New Brunswick\Measurements\PFT_Data\SEPI-3'

PFTDestination='E:\OneDrive - University of New Brunswick\Measurements\testing\NewProcessed';% Where extracted temp info is stored
PFTDestination='C:\Users\e5862\OneDrive - University of New Brunswick\Measurements\PFT_Data\SEPI-3_structs'

addpath(pathname);

files=(dir(pathname));

files=files(~[files.isdir]);

% files=bubblesort(files); % Sort the files cronologically
[s,~]=size(files); %  number of files in directory

for i=1:s
    PFT=load(files(i).name);
    FileName=files(i).name;
    NumChar=length(FileName);
    j=0; %counter
    for k=1:NumChar
        if FileName(k:k+7)=='Averages'
           TempNumber=FileName(k+9:end-4);
           break
        end
    end
    
    for k=1:length(TempNumber)
        if TempNumber(k)~='_'
            DateNumber(k)=TempNumber(k);
        end
    end
    DateNumber=str2num(DateNumber);
    PFT(i).DateNumber=DateNumber;
    clear DateNumber
    save([files(i).name],'PFT');% Save the temperature data (PFT)
                [status_PFT,msg_PFT]=movefile(files(i).name,PFTDestination);% Move the saved data to correct folder
%                 [status_Raw,msg_RAW]=movefile([pathname '\' files(i).name],RawDestination);% Move to Raw data out of the folder containing unprocessed data
    
end