pathname='E:\OneDrive - University of New Brunswick\Measurements\Continuous'; % Where raw BOTDA data is saved
RawDestination='E:\OneDrive - University of New Brunswick\Measurements\Archived_Measurements'; % Where the raw data will be moved once processed
PFTDestination='E:\OneDrive - University of New Brunswick\Measurements\PFT_Data';% Where extracted temp info is stored
addpath(pathname);

files=(dir(pathname));
files=files(~[files.isdir]);
% files=bubblesort(files);
[s,~]=size(files); %  number of files in directory


if s>=1
    for i=1:s
        try
            data=load(files(i).name); % load the data files
            [PFT,fy] = BrillouinCurveFit2021(35e6,0.1e6,10.9778e9,0.7581,data.FinalAVG); % Process the data/Extract the Temp data
            if exist('PFT','var')
                save(['PFT_' files(i).name],'PFT');% Save the temperature data (PFT)
                [status_PFT,msg_PFT]=movefile(['PFT_' files(i).name],PFTDestination);% Move the saved data to correct folder
                [status_Raw,msg_RAW]=movefile([pathname '\' files(i).name],RawDestination);% Move to Raw data out of the folder containing unprocessed data
            end
%             clear PFT 
%             clear status_PFT
%             clear status_Raw
        catch ME
            % Nothing to do, continue the loop
        end
    end
end