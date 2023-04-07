function [retosc] = oscmode(frequency,fiberlenght,averagenumber)
% This is the main Control function for the Brillouin Distributed sensing
% system 
%*************************
%those variables should be supplied by the user

StartFreq=frequency;
EndFreq=frequency+2e6;
StepSize=2e6;
FiberLenght=fiberlenght;
AVGNum=averagenumber;
SaveData=0;
BStart=1e-6;%in seconds
BEnd=10e-6;%in seconds
correctbaseline=0;

%******************************************
%setparameters

% FiberLenght = (BEnd-BStart);
% PllFreq =(StartFreq/64);%actual data passed to pll
 PolNum=2;%number of polarization states
% 
% %find sample numbers
% Snum=floor(FiberLenght*1e9+512);%Aquisition rate is 1G sample per sec
% %512 extra samples after the end point of the fiber
% Srem=rem(Snum,64);
% if Srem ==0 %if valid sample number
%     SampleNum=Snum;
% end
% 
% SampleNum=Snum+(64-Srem);

%******************************************
%setparameters
FiberLenght=FiberLenght*(.48e-8);
%******************************************
%setparameters


Snum=floor((fiberLenght*10)+1024);%Aquisition rate is 1G sample per sec
%4096 extra samples after the end point of the fiber
Srem=rem(Snum,64);
if Srem ==0 %if valid sample number
    SampleNum=2*Snum;
end
if Srem~= 0
SampleNum=2*Snum+(64-Srem);
end
PllFreq =(StartFreq/64);%actual data passed to pll


% if Srem >0 && Srem<=30% round the unvalid number
%     SampleNum = Snum + (64-Srem);
% end
% if Srem >0 && Srem>30% round the unvalid number
%     SampleNum = Snum - Srem;
% end
%****************************************************
%reserve memory for the data
RowData=zeros(AVGNum,SampleNum);% Holds the row data after each aquisition
AVGArray=zeros(((EndFreq-StartFreq)/StepSize)*PolNum,SampleNum);%before pol averaging
SFinalAVG=zeros(((EndFreq-StartFreq)/StepSize),SampleNum);% After pol averaging
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
 mex rawavg.c; % compiles row averaging c function
 mex polarizationavg.c % compiles polaraization averaging c function
 mex csend.c mmp.lib % initiate the lasers to be 11GHz apart
%this function might be moved out of the main algorithem


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

SampleNum
setuposcmode(handle,SampleNum,AVGNum); % pass parameters to setup gage parameters

CsMl_ResetTimeStamp(handle); % clear any initial counter numbers

 ret = CsMl_Commit(handle); % apply the parameters made by setup1 function
 CsMl_ErrorHandler(ret, 1, handle)

[ret, acqInfo] = CsMl_QueryAcquisition(handle);% get acquisition parameters
%set data transfer parameters
transfer.Channel = 1;
transfer.Mode = CsMl_Translate('TimeStamp', 'TxMode');
transfer.Length = acqInfo.SegmentCount;
transfer.Segment = AVGNum;
[ret, tsdata, tickfr] = CsMl_Transfer(handle, transfer);

transfer.Mode = CsMl_Translate('Default', 'TxMode');
transfer.Start = -acqInfo.TriggerHoldoff;
transfer.Length = acqInfo.SegmentSize

ret = CsMl_Commit(handle); % apply the parameters made by setup1 function
CsMl_ErrorHandler(ret, 0, handle);


%***************************************
%intialize the I/O bord
%***************************************
% the I/O board is used to control the polaraization controler
ao=analogoutput('mcc',0)
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
    freq %???????????????????????????????????????????????
   pllset(freq/64);
    if polo==1
    
        FinalAVG(((freq-StartFreq)/StepSize)+1,1)=freq; % write the frequency header
    end
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

AVGArray(((polo-1)*((EndFreq-StartFreq+StepSize)/StepSize))+((freq-StartFreq+StepSize)/StepSize),:)=rawavg(RowData);


%****************************************************
%saving the row data 
%****************************************************

if SaveData==1
mydata=sprintf('DataFreq%dPol%d',(freq-StartFreq+StepSize)/StepSize,polo);
save(mydata, 'RowData');
end
%****************************************************

end;
end;
ret = CsMl_FreeSystem(handle);%set the card free for next measurement
delete(ao); % clear the I/O board for next measurement

%*************************************************
%do the final averaging function for the polarization
%by sending AVGArray , and getting back FinaAVG
%*******************************************************
SFinalAVG=polarizationavg(AVGArray);
SFinalAVG=SFinalAVG';
%FinalAVG(:,(21:(fsize(2)+21)))=SFinalAVG; % add the header data
for i = 1:1:fsize(1)
    basecounter=0;
    for j = 1:1:fsize(2);
        FinalAVG(i,(j+20))=SFinalAVG(i,j);
        if basecounter<100
        FinalAVG(i,6)=FinalAVG(i,6)+SFinalAVG(i,j);
        basecounter=basecounter+1;
        end
    end
    basecounter=0;
    FinalAVG(i,6)=FinalAVG(i,6)/100;
   
end
if correctbaseline==1
    corrected=basefunc(FinalAVG);
end
%*****************************************************
%save the final averaged data
%****************************************************
% note: time can be added and modified in the GUI
% myfinaldata=sprintf('averaged_readings');
% mybasedata=sprintf('base_line');
% mysfinal=sprintf('sfinal');
% save(myfinaldata, 'FinalAVG');
% save(mybasedata, 'corrected');
% save(mysfinal, 'SFinalAVG');

ret = CsMl_FreeSystem(handle); %??????????????????????????????????
retosc=FinalAVG;

