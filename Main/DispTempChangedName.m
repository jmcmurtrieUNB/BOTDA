%% Load and Plot the PFT data
pathname='E:\OneDrive - University of New Brunswick\Measurements\PFT_Data\SEPI-3';%Where the data is saved
pathname2='E:\OneDrive - University of New Brunswick\Measurements\Archived_Measurements\SEPI-3';
% name='Mactaquac_BOTDA_Software';
% % pathname=dir(['**\' name '']);
% % addpath([pathname '\' name])
% colormap jet
% addpath(pathname);
% addpath(pathname2);
% files=(dir(pathname));
% files2=(dir(pathname2));
% files=files(~[files.isdir]);
% files2=files2(~[files2.isdir]);
% files=bubblesort(files); % Sort the files cronologically
% files2=bubblesort(files2); % Sort the files cronologically
% [s,~]=size(files); %  number of files in directory
% [s2,~]=size(files2); %  number of files in directory
% % h1=figure(1);
% % h2=figure(2);
for i=7455:s
    FileName=files(i).name;
    NumChar=length(FileName);
    for k=1:NumChar
        if FileName(k)=='_'
            FileName(k)=' ';
        end
    end
        PFT=load(files(i).name);
        Raw=load(files2(i).name);
        figure(1)
    plot(PFT.PFT(:,1),PFT.PFT(:,3));
        ylim([-30 40]);
    title(FileName)
    ylabel(['Temperature (^o' 'C)'])
    xlabel('Position (m)')
    Temp(:,i)=PFT.PFT(:,3);
    figure(2)
    tempo=Raw.FinalAVG;
    surf(tempo(:,2048:end-1500),'EdgeColor','Interp');
    view(2)
    title(files(i).name)
    %surf(FinalAVG(:,2048+20:end),'EdgeColor','Interp')

    drawnow
end
        