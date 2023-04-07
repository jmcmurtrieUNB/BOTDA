function [returnback CWFineFreq PulseFineFreq] = MeasurementFunctionContinuous(StartFreq,EndFreq,StepSize,NumberOfAverages,FiberLength,SaveData,Baseline,type,CWFineFreq,PulseFineFreq)

%******************************************
% this is the main control function that performes BOTDA measurement
% invoked by measurementwindow gui function
%******************************************

% Every 5 loops, checks for lock
count=0;

%% Set Parameters
PolNum=2;

%******************************************
% Calculate number of samples
Snum=floor(FiberLength*10+4096);

%Aquisition rate is 1G sample per sec
%4096 extra samples after the end point of the fiber
Srem=rem(Snum,64);
if Srem ==0 %if valid sample number
    SampleNum=Snum;
elseif Srem~=0
    SampleNum=Snum+(64-Srem);
end
%****************************************************
%reserve memory for the data

RowData=zeros(NumberOfAverages,SampleNum);% Holds the row data after each aquisition
AVGArray=zeros(((EndFreq-StartFreq)/StepSize)*PolNum,SampleNum);%before pol averaging
SFinalAVG=zeros(((EndFreq-StartFreq)/StepSize),SampleNum);% After pol averaging
correctionpar=zeros(((EndFreq-StartFreq)/StepSize),SampleNum);%base line correction parameter
fsize=size(SFinalAVG); %get the size of the final averaged data
FinalAVG=zeros(fsize(1),fsize(2)+21); % add 20 colomns for header data of each row
%write constant headers
FinalAVG(:,2)=StartFreq;
FinalAVG(:,5)=EndFreq;
FinalAVG(:,3)=StepSize;
FinalAVG(:,4)=NumberOfAverages;
FinalAVG(:,6)=FiberLength;
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

handle, SampleNum, NumberOfAverages
%addpath('C:\Brillouin_Measurement_Files\newcode');
Setup1(handle,SampleNum,NumberOfAverages); % pass parameters to setup gage parameters

CsMl_ResetTimeStamp(handle); % clear any initial counter numbers

 ret = CsMl_Commit(handle); % apply the parameters made by setup1 function
 CsMl_ErrorHandler(ret, 1, handle);

[ret, acqInfo] = CsMl_QueryAcquisition(handle);% get acquisition parameters
%set data transfer parameters
transfer.Channel = 1;
transfer.Mode = CsMl_Translate('TimeStamp', 'TxMode');
transfer.Length = acqInfo.SegmentCount;
transfer.Segment = NumberOfAverages;
[ret, tsdata, tickfr] = CsMl_Transfer(handle, transfer);

transfer.Mode = CsMl_Translate('Default', 'TxMode');
transfer.Start = -acqInfo.TriggerHoldoff;
transfer.Length = acqInfo.SegmentSize;

ret = CsMl_Commit(handle); % apply the parameters made by setup1 function
CsMl_ErrorHandler(ret, 0, handle);


%***************************************************************************************************************************************
% Setup the SPI communication and PLL board
%***************************************************************************************************************************************
if ~libisloaded('mcp2210_dll_um_x86')
    [notFound warnings]=loadlibrary('mcp2210_dll_um_x86','mcp2210_dll_um');
end
if libisloaded('mcp2210_dll_um_x86')
    disp('mcp2210_dll_um_x86 library is loaded')
    disp(' ')
else 
    disp('Library failed to load')
    disp(' ')
    return
end

% Initializing variables/pointers for mcp2210 dll functions
vid=uint16(hex2dec('4D8')); % Chip vendor ID
pid=uint16(hex2dec('DE'));  % Chip product ID
DevPath=libpointer('voidPtr'); % dummy void pointer that could contain the device path if desired(the actual path is not needed)
DevPathSize=libpointer('uint32Ptr',1001); % dummy pointer for memory allocation of device path string
Rx=uint8(0); % Rx data (there is none but the variable is required by the functions in the mcp2210_dll_um_x86 library
RxADC=libpointer('uint8Ptr',[0 0]); % Rx data (there is none but the variable is required by the functions in the mcp2210_dll_um_x64 library
Baud=uint32(40000); % Baud Rate in Hz
IdleCS=uint32(1); % Idle Chip Select Pin Status
ActiveCS=uint32(0); % Active Chip Select Pin Status
CSToDataDelay=uint32(0); % Delay between Chip Select Active and Beginning of Data Transfer
DataToCSDelay=uint32(0); % Delay between end of Data Transfer and Chip Select Return to Idle
DataToDataDelay=uint32(0); % Delay between data bytes
TxSize=uint32(4); % Bytes to transfer per SPI transaction
SPIMode=uint8(0); % SPI mode: 0
RemoteWakeup=uint8(1); % 0=Disabled 1=enabled
MemoryMode=uint8(0); % 0=Volatile(Default) 1=NVRAM
InteruptCountMode=uint8(0); % 0=NoCount 1=FallingEdge 2=RisingEdge 3=LowPulse 4=HighPulse
SPIBusRelease=uint8(0); % 0=Enabled 1=Disabled
CSMask=uint32(1); % Chip Select Mask
PinDesignation=libpointer('uint8Ptr',[1 0 0 0 0 0 0 0 0]); % There are 9 pin 0=GPIO 1=ChipSelect 2=SpecialFunction
GPIODefaultOutput=uint32(255); % Default GPIO Output
GPIOPinDir=uint32(0); % Default GPIO Pin Direction(Input/Output)
GPIOSetVal=uint32(2); % GPIO set Pin Values
GPIOPinVal=libpointer('uint32Ptr',[0 0 0 0 0 0 0 0 0]); % GPIO read back pin values
ADC_WORD(1,1)=bi2de([0 1 1 0 1 0 0 0],'left-msb');
ADC_WORD(1,2)=uint8(0);

% Connect to the mcp2210 chip
handle_MCP2210=calllib('mcp2210_dll_um_x86','Mcp2210_OpenByIndex',vid,pid,uint32(0),DevPath,DevPathSize);
err=calllib('mcp2210_dll_um_x86','Mcp2210_GetLastError');
if err==0
    disp('Connected To MCP2210')
    disp(' ')
else
    try
        temp=calllib('mcp2210_dll_um_x86','Mcp2210_Close',handle_MCP2210);
        err=calllib('mcp2210_dll_um_x86','Mcp2210_GetLastError');
        if (err==0) && (temp==0)
            handle_MCP2210=calllib('mcp2210_dll_um_x86','Mcp2210_OpenByIndex',vid,pid,uint32(0),DevPath,DevPathSize);
            err=calllib('mcp2210_dll_um_x86','Mcp2210_GetLastError');
            if err==0
                disp('Device Connected')
            else
                disp('Error connecting device. Check the "Mcp2210 DLL User Guide" for error code:')
                disp(err)    
                return
            end
        else
            disp('Error connecting device. Check the "Mcp2210 DLL User Guide" for error code:')
            disp(err)    
            return
        end
    catch me
        disp('Error connecting device. Check the "Mcp2210 DLL User Guide" for error code:')
        disp(err)
        return
    end
end

% Set SPI Configuration
temp=calllib('mcp2210_dll_um_x86','Mcp2210_SetSpiConfig',handle_MCP2210,MemoryMode,Baud,IdleCS,ActiveCS,CSToDataDelay,DataToCSDelay,DataToDataDelay,TxSize,SPIMode);
err=calllib('mcp2210_dll_um_x86','Mcp2210_GetLastError');
if err~=0
    disp('Error during SPI configuration. Check the "Mcp2210 DLL User Guide" for error code:')
    disp(err)
    calllib('mcp2210_dll_um_x86','Mcp2210_Close',handle_MCP2210);
    return
end

% Set GPIO Configuration
temp=calllib('mcp2210_dll_um_x86','Mcp2210_SetGpioConfig',handle_MCP2210,MemoryMode,PinDesignation,GPIODefaultOutput,GPIOPinDir,RemoteWakeup,InteruptCountMode,SPIBusRelease);
err=calllib('mcp2210_dll_um_x86','Mcp2210_GetLastError');
if err~=0
    disp('Error during GPIO configuration1. Check the "Mcp2210 DLL User Guide" for error code:')
    disp(err)
    calllib('mcp2210_dll_um_x86','Mcp2210_Close',handle);
    return
end
if temp<0
    disp('Error during GPIO configuration2. Check the "Mcp2210 DLL User Guide" for error code:')
    disp(temp)
    calllib('mcp2210_dll_um_x86','Mcp2210_Close',handle);
    return
end


%****************************************************************************************************************************************************************************
for polo=1:PolNum%setup the polarization
    % Setting the polarization switch
 if polo ==1
     GPIOSetVal=uint32(2);
     temp=calllib('mcp2210_dll_um_x86','Mcp2210_SetGpioConfig',handle_MCP2210,MemoryMode,PinDesignation,GPIODefaultOutput,GPIOPinDir,RemoteWakeup,InteruptCountMode,SPIBusRelease);
     err=calllib('mcp2210_dll_um_x86','Mcp2210_GetLastError');
     if err~=0
         disp('Error during GPIO configuration1. Check the "Mcp2210 DLL User Guide" for error code:')
         disp(err)
         calllib('mcp2210_dll_um_x86','Mcp2210_Close',handle);
         return
     end
     if temp<0
         disp('Error during GPIO configuration2. Check the "Mcp2210 DLL User Guide" for error code:')
         disp(temp)
         calllib('mcp2210_dll_um_x86','Mcp2210_Close',handle);
         return
     end
     temp=calllib('mcp2210_dll_um_x86','Mcp2210_SetGpioPinVal',handle_MCP2210,GPIOSetVal,GPIOPinVal);
     err=calllib('mcp2210_dll_um_x86','Mcp2210_GetLastError');
     if err~=0 || temp<0
         disp('Error during setting GPIO pins. Check the "Mcp2210 DLL User Guide" for error code:')
         disp(err)
         calllib('mcp2210_dll_um_x86','Mcp2210_Close',handle);
         return
     end
     pause(0.1) % allow time for signal and pola switch to change
 end
 
 if polo ==2
     GPIODefaultOutput=uint32(0);
     GPIOSetVal=uint32(0);
     temp=calllib('mcp2210_dll_um_x86','Mcp2210_SetGpioConfig',handle_MCP2210,MemoryMode,PinDesignation,GPIODefaultOutput,GPIOPinDir,RemoteWakeup,InteruptCountMode,SPIBusRelease);
     err=calllib('mcp2210_dll_um_x86','Mcp2210_GetLastError');
     if err~=0
        disp('Error during GPIO configuration1. Check the "Mcp2210 DLL User Guide" for error code:')
        disp(err)
        calllib('mcp2210_dll_um_x86','Mcp2210_Close',handle);
        return
     end
     if temp<0
        disp('Error during GPIO configuration2. Check the "Mcp2210 DLL User Guide" for error code:')
        disp(temp)
        calllib('mcp2210_dll_um_x86','Mcp2210_Close',handle);
        return
     end
     temp=calllib('mcp2210_dll_um_x86','Mcp2210_SetGpioPinVal',handle_MCP2210,GPIOSetVal,GPIOPinVal);
     err=calllib('mcp2210_dll_um_x86','Mcp2210_GetLastError');
     if err~=0 || temp<0
         disp('Error during setting GPIO pins. Check the "Mcp2210 DLL User Guide" for error code:')
         disp(err)
         calllib('mcp2210_dll_um_x86','Mcp2210_Close',handle);
         return
     end
     pause(0.1) % allow time for signal and pola switch to change
 end

% Start the frequency sweep
for freq=StartFreq:StepSize:EndFreq
    freq 

   Register = FreqCalcs(freq); % Calculate the register values for ADF4159 board
   
   % Convert binary vectors into decimal for transmission
   for k=1:11
       writeCmd(k,1) = bi2de(Register(k,1:8),'left-msb');
       writeCmd(k,2) = bi2de(Register(k,9:16),'left-msb');
       writeCmd(k,3) = bi2de(Register(k,17:24),'left-msb');
       writeCmd(k,4) = bi2de(Register(k,25:32),'left-msb');
   end
   
   for i=1:11
       err=calllib('mcp2210_dll_um_x86','Mcp2210_xferSpiData',handle_MCP2210,writeCmd(i,:),Rx,Baud,TxSize,CSMask);
       if err~=0
           disp('Error sending SPI data. Check the "Mcp2210 DLL User Guide" for error code:')
           disp(err)
           calllib('mcp2210_dll_um_x86','Mcp2210_Close',handle_MCP2210);
           return
       end
   end
   
   
   
   
   
  
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   if count>=5   
   % Check for lock
   % Read the error signal with 10 bit ADC (MCP3002)
   err=calllib('mcp2210_dll_um_x64','Mcp2210_xferSpiDataEx',Handle_2,ADC_WORD(1,:),RxADC,Baud,TxSizeADC,CSMaskADC,IdleCS,ActiveCS,CSToDataDelay,DataToCSDelay,DataToDataDelay,SPIMode);
   if err~=0
       disp('Error sending SPI data. Check the "Mcp2210 DLL User Guide" for error code:')
       disp(err)
       calllib('mcp2210_dll_um_x86','Mcp2210_Close',handle_MCP2210);
       return
   end
   
   % The bus does not like to release, this forces it to release
   err=calllib('mcp2210_dll_um_x64','Mcp2210_xferSpiDataEx',handle_MCP2210,0,RxADC,Baud,TxSizeNULL,CSMaskNULL,IdleCS,ActiveCS,CSToDataDelay,DataToCSDelay,DataToDataDelay,SPIMode);
   if err~=0
       disp('Error sending SPI data. Check the "Mcp2210 DLL User Guide" for error code:')
       disp(err)
       calllib('mcp2210_dll_um_x64','Mcp2210_Close',handle_MCP2210);
       return
   end
    % Bus should now be released

    % Convert measured error signal to voltage level
   rx=RxADC.value; % retrieve the value from pointer
   binaryVoltage(1,1:8)=de2bi(rx(1,1),8,'left-msb'); %  most significant bits
   binaryVoltage(1,9:16)=de2bi(rx(1,2),8,'left-msb'); % 8 least significant bits
   binaryVoltage(1,1:6)=[0 0 0 0 0 0];
   binaryVoltage=double(binaryVoltage); % convert to type double
   VoltFraq=bi2de(binaryVoltage,'left-msb'); % convert binary to decimal number 
   ErrorVoltage=Vmax*VoltFraq/1023; % convert to voltage level


   % If error voltage is between 0.5 and 2 lasers are still locked
   if ErrorVoltage<=0.5 || ErrorVoltage>=2
       calllib('mcp2210_dll_um_x64','Mcp2210_Close',handle_MCP2210); % close the connection to mcp2210 chip
       [CWFineFreq,PulseFineFreq]=Auto_Lock_UNB_BOTDA('COM8','COM3',CWFineFreq,PulseFineFreq);
       % Reconnect to the mcp2210 chip
       handle_MCP2210=calllib('mcp2210_dll_um_x86','Mcp2210_OpenByIndex',vid,pid,uint32(0),DevPath,DevPathSize);
       err=calllib('mcp2210_dll_um_x86','Mcp2210_GetLastError');
       if err==0
           disp('Connected To MCP2210')
           disp(' ')
       else
           try
               temp=calllib('mcp2210_dll_um_x86','Mcp2210_Close',handle_MCP2210);
               err=calllib('mcp2210_dll_um_x86','Mcp2210_GetLastError');
               if (err==0) && (temp==0)
                   handle_MCP2210=calllib('mcp2210_dll_um_x86','Mcp2210_OpenByIndex',vid,pid,uint32(0),DevPath,DevPathSize);
                   err=calllib('mcp2210_dll_um_x86','Mcp2210_GetLastError');
                   if err==0
                       disp('Device Connected')
                   else
                       disp('Error connecting device. Check the "Mcp2210 DLL User Guide" for error code:')
                       disp(err)    
                       return
                   end
               else
                   disp('Error connecting device. Check the "Mcp2210 DLL User Guide" for error code:')
                   disp(err)    
                   return
               end
           catch me
               disp('Error connecting device. Check the "Mcp2210 DLL User Guide" for error code:')
               disp(err)
               return
           end
       end
   end
   count=0;
   end
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------












    
   if polo==1
        FinalAVG(((freq-StartFreq)/StepSize)+1,1)=freq; % write the frequency header
   end
ret = CsMl_Capture(handle); % aquire data
CsMl_ErrorHandler(ret, 1, handle);
status = CsMl_QueryStatus(handle);
while status ~= 0
   status = CsMl_QueryStatus(handle); % wait for trigger
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

save(['C:\Brillouin_Measurement_Files\SavedData\' mydata '.mat'], 'RowData');
end
%****************************************************
count=count+1;
end;
if polo ==1
    disp('Changing polarization and restarting frequency sweep.')
end
end
disp('Aquisition Complete')
calllib('mcp2210_dll_um_x86','Mcp2210_Close',handle_MCP2210); % close the connection to mcp2210 chip
ret = CsMl_FreeSystem(handle);%set the card free for next measurement
%*************************************************
%do the final averaging function for the polarization
%by sending AVGArray , and getting back FinaAVG
%*******************************************************
% SFinalAVG=polarizationavg(AVGArray);

polarizationdata=sprintf('polarizationdata');
save(['C:\Brillouin_Measurement_Files\SavedData\' polarizationdata '.mat'], 'AVGArray');
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
myfinaldata=sprintf('SEPI-3B_%dAverages_%d_%d_%d_%d_%d_%d',NumberOfAverages,fix(clock));
%save(myfinaldata, 'FinalAVG');
save(['C:\Users\Fiberlaser\Desktop\Measurements\Continuous\' myfinaldata '.mat'], 'FinalAVG');

puredata=sprintf('pure_data');
%save(finalpuredata,'SFinalAVG');
save(['C:\Brillouin_Measurement_Files\SavedData\' puredata '.mat'], 'SFinalAVG');

baselinecorrection=sprintf('baseline_correction_par');
%save(myfinaldata, 'FinalAVG');
save(['C:\Brillouin_Measurement_Files\SavedData\' baselinecorrection '.mat'], 'correctionpar');
calllib('mcp2210_dll_um_x86','Mcp2210_Close',handle_MCP2210);
ret = CsMl_FreeSystem(handle); 
returnback =1; % set finish flag to 1 if no errors