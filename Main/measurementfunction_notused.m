function returnback = measurementfunction_notused(StartFreq,EndFreq,StepSize,AVGNum,FiberLenght,SaveData,Baseline,type)

%******************************************
% this is the main control function that performes BOTDA measurement
% invoked by measurementwindow gui function


%addpath 'C:\Program Files (x86)\Gage';%adc access functions

%******************************************
%setparameters
PolNum=2;
%FiberLenght=FiberLenght*(.48e-8);
Snum=floor(FiberLenght*10+4096);%Aquisition rate is 1G sample per sec
%4096 extra samples after the end point of the fiber
Srem=rem(Snum,64);
if Srem ==0 %if valid sample number
    SampleNum=Snum;
end
if Srem~= 0
SampleNum=Snum+(64-Srem);
end
PllFreq =(StartFreq/64);%actual data passed to pll


%****************************************************
%reserve memory for the data

RowData=zeros(AVGNum,SampleNum);% Holds the row data after each aquisition
AVGArray=zeros(((EndFreq-StartFreq)/StepSize)*PolNum,SampleNum);%before pol averaging
SFinalAVG=zeros(((EndFreq-StartFreq)/StepSize),SampleNum);% After pol averaging
correctionpar=zeros(((EndFreq-StartFreq)/StepSize),SampleNum);%base line correction parameter
fsize=size(SFinalAVG); %get the size of the final averaged data
FinalAVG=zeros(fsize(1),fsize(2)+21); % add 20 colomns for header data of each row
%write constant headers
FinalAVG(:,2)=StartFreq;
FinalAVG(:,5)=EndFreq;
FinalAVG(:,3)=StepSize;
FinalAVG(:,4)=AVGNum;
%*******************************************
%compile C functions and initialize the lasers
%*******************************************
 %mex csend.c mmp.lib % 

%******************************************************
%inetialize the Gage Card & set Aquizition parameters
%******************************************************


systems = CsMl_Initialize;
CsMl_ErrorHandler(systems);
[ret, handle] = CsMl_GetSystem;
CsMl_ErrorHandler(ret);
[ret, sysinfo] = CsMl_GetSystemInfo(handle); % get the board information

s = sprintf('-----Board name: %s\n', sysinfo.BoardName);
disp(s);

handle, SampleNum, AVGNum
addpath('C:\Brillouin_Measurement_Files\newcode');
Setup1(handle,SampleNum,AVGNum); % pass parameters to setup gage parameters

CsMl_ResetTimeStamp(handle); % clear any initial counter numbers

 ret = CsMl_Commit(handle); % apply the parameters made by setup1 function
 CsMl_ErrorHandler(ret, 1, handle);

[ret, acqInfo] = CsMl_QueryAcquisition(handle);% get acquisition parameters
%set data transfer parameters
transfer.Channel = 1;
transfer.Mode = CsMl_Translate('TimeStamp', 'TxMode');
transfer.Length = acqInfo.SegmentCount;
transfer.Segment = AVGNum;
[ret, tsdata, tickfr] = CsMl_Transfer(handle, transfer);

transfer.Mode = CsMl_Translate('Default', 'TxMode');
transfer.Start = -acqInfo.TriggerHoldoff;
transfer.Length = acqInfo.SegmentSize;

ret = CsMl_Commit(handle); % apply the parameters made by setup1 function
CsMl_ErrorHandler(ret, 0, handle);


%***************************************
%intialize the I/O bord
%***************************************
% the I/O board is used to control the polaraization controler
ao=analogoutput('mcc',0);
%ao=analogoutput('mcc',1);
chan=addchannel(ao,0:3); % use 4 output channels 
set(ao,'samplerate',500);
set(ao,'TriggerType','Manual');

%***************************************
%setup the pll
%***************************************
%pllset(PllFreq); % set up the PLL for the first aquisition

%************************************
%aquire data
%************************************
for polo=1:PolNum%setup the polrization
if polo ==1
    putsample(ao,[5,5,0,0]);% values should be tested with the polometer to obtain required states
end
if polo ==2
    putsample(ao,[0,5,1,3]);% values should be tested with the polometer controller to obtain required states
end


for freq=StartFreq:StepSize:EndFreq
    freq 
   pllset(freq/64);
    if polo==1
    
        FinalAVG(((freq-StartFreq)/StepSize)+1,1)=freq; % write the frequency header
    end
 %disp('you are here')
ret = CsMl_Capture(handle); % aquire data
%ret=CsMl_ForceCapture(handle);
CsMl_ErrorHandler(ret, 1, handle);

status = CsMl_QueryStatus(handle);
while status ~= 0
   status = CsMl_QueryStatus(handle);
  % status
end

MaskedMode = bitand(acqInfo.Mode, 15);
ChannelsPerBoard = sysinfo.ChannelCount / sysinfo.BoardCount;
ChannelSkip = ChannelsPerBoard / MaskedMode;

%transfer data aquired to rowdata one pulse each time
for channel = 1:ChannelSkip:sysinfo.ChannelCount
    transfer.Channel = channel;
    for i = 1:acqInfo.SegmentCount
        transfer.Segment = i;
        [ret, data, actual] = CsMl_Transfer(handle, transfer);
        CsMl_ErrorHandler(ret, 1, handle);

    	
        length = size(data, 2);
        if length > actual.ActualLength
            data(actual.ActualLength:end) = [];
            length = size(data, 2);
        end;                
        RowData(i,:)=data;
        % Get channel info for file header    
        [ret, chanInfo] = CsMl_QueryChannel(handle, channel);            
        CsMl_ErrorHandler(ret, 1, handle);
     
    end;
end;

% AVGArray(((polo-1)*((EndFreq-StartFreq+StepSize)/StepSize))+((freq-StartFreq+StepSize)/StepSize),:)=rawavg(RowData);

AVGArray(((polo-1)*((EndFreq-StartFreq+StepSize)/StepSize))+((freq-StartFreq+StepSize)/StepSize),:)=newavg(RowData);

%****************************************************
%saving the row data 
%****************************************************

if SaveData==1
mydata=sprintf('DataFreq%dPol%d',(freq-StartFreq+StepSize)/StepSize,polo);

save(['C:\botdasys\botdagui\newcode\rowdata\' mydata '.mat'], 'RowData');
end
%****************************************************

end;
disp('loop end')
end;
ret = CsMl_FreeSystem(handle);%set the card free for next measurement
delete(ao); % clear the I/O board for next measurement
%*************************************************
%do the final averaging function for the polarization
%by sending AVGArray , and getting back FinaAVG
%*******************************************************
% SFinalAVG=polarizationavg(AVGArray);

polarizationdata=sprintf('polarizationdata');
save(['C:\botdasys\botdagui\newcode\rowdata\' polarizationdata '.mat'], 'AVGArray');
SFinalAVG=newpolavg(AVGArray);
% SFinalAVG=SFinalAVG';
if type~=5
SFinalAVG=botdadenoise(SFinalAVG,type);
end

if Baseline==1
    [SFinalAVG,correctionpar]=basefunc(SFinalAVG);
end

FinalAVG(:,(21:(fsize(2)+20)))=SFinalAVG; % add the header data

%*****************************************************
%save the final averaged data
%****************************************************
% note: time can be added and modified in the GUI
myfinaldata=sprintf('averaged_readings');
%save(myfinaldata, 'FinalAVG');
save(['C:\botdasys\botdagui\newcode\rowdata\' myfinaldata '.mat'], 'FinalAVG');

puredata=sprintf('pure_data');
%save(finalpuredata,'SFinalAVG');
save(['C:\botdasys\botdagui\newcode\rowdata\' puredata '.mat'], 'SFinalAVG');

baselinecorrection=sprintf('baseline_correction_par');
%save(myfinaldata, 'FinalAVG');
save(['C:\botdasys\botdagui\newcode\rowdata\' baselinecorrection '.mat'], 'correctionpar');

ret = CsMl_FreeSystem(handle); 
returnback =1; % set finish flag to 1 if no errors


