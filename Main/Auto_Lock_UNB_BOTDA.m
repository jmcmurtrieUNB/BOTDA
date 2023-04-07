 function [CWFreq,PulseFreq] =Auto_Lock_UNB_BOTDA(CWPort,PulsePort,varargin)
% Controls the fine frequency adjustment on the CW and Pulse lasers in the
% UNB BOTDA system to maintain a continuous lock.

% INPUTS
% 
% CWPort:       Com Port that CW laser in connected to ei 'COM8'
% PulsePort:    Com Port that Pulse laser in connected to ei 'COM3'
% CWFreq:       Current fine frequency setting CW laser
% PulseFreq:    Current fine frequency setting Pulse Laser
%
% OUTPUTS
%
% CWFreq:       The final setting of the CW Frequency
% PulseFreq:    The final setting of the Pulse Frequency

OpenComs=instrfindall;
if ~isempty(OpenComs)
    delete(OpenComs)
end


if nargin==2
    CWFreq=0;
    PulseFreq=0;
elseif nargin==3
    CWFreq=cell2mat(varargin(1));
    PulseFreq=0;
elseif nargin==4
    CWFreq=cell2mat(varargin(1));
    PulseFreq=cell2mat(varargin(2));
elseif nargin>4
    error('Too many input parameters')
end

% Max voltage supply
Vmax=2.25; %Volts\
FineFreqMax=2000; % try not to change the fine tune adjustment more than 2000 MHz


%% Setup the MCP2210 Chip for communication

% load the API library for MCP2210
% addpath('C:\Users\e5862\Downloads\MCP2210_DLLv2\mcp2210_dll_v2.1.0\unmanaged\dll');
if ~libisloaded('mcp2210_dll_um_x64')
    [notFound,warnings]=loadlibrary('mcp2210_dll_um_x64','mcp2210_dll_um');
end
if libisloaded('mcp2210_dll_um_x64')
    disp('mcp2210_dll_um_x64 library is loaded')
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
RxADC=libpointer('uint8Ptr',[0 0]); % Rx data (there is none but the variable is required by the functions in the mcp2210_dll_um_x64 library
Baud=uint32(40000); % Baud Rate in Hz
IdleCS=uint32(1);
ActiveCS=uint32(0);
CSToDataDelay=uint32(0); % Delay between Chip Select Active and Beginning of Data Transfer
DataToCSDelay=uint32(0); % Delay between end of Data Transfer and Chip Select Return to Idle
DataToDataDelay=uint32(0); % Delay between data bytes
TxSizePLL=uint32(4); % Bytes to transfer per SPI transaction for PLL
TxSizeADC=uint32(2);
TxSizeNULL=uint32(0);
SPIMode=uint8(0); % SPI mode: 0
RemoteWakeup=uint8(0); % 0=Disabled 1=enabled
ChipConfigMode=uint8(0); % 0=Volatile(Default) 1=NVRAM
InteruptCountMode=uint8(0); % 0=NoCount 1=FallingEdge 2=RisingEdge 3=LowPulse 4=HighPulse
SPIBusRelease=uint8(0); % 0=Enabled 1=Disabled
CSMaskPLL=uint32(1); % Chip select mask
CSMaskADC=uint32(32);
CSMaskNULL=uint32(128); % dummy chip select mask
PinDesignation=libpointer('uint8Ptr',[1 0 0 0 0 1 0 1 0]); % There are 9 pin 0=GPIO 1=ChipSelect 2=SpecialFunction
GPIODefaultOutput=uint32(bi2de([1 1 1 1 1 1 1 1 1])); % Default GPIO Output
GPIOPinDir=uint32(0); % Default GPIO Pin Direction(Input/Output)
GPIOSetVal=uint32(bi2de([0 0 0 0 0 0 0 0])); % GPIO set Pin Values
GPIOPinVal=libpointer('uint32Ptr',[0 0 0 0 0 0 0 0 0]); % GPIO read back pin values

% Connect to the mcp2210 chip
handle_MCP2210=calllib('mcp2210_dll_um_x64','Mcp2210_OpenByIndex',vid,pid,uint32(0),DevPath,DevPathSize);
err=calllib('mcp2210_dll_um_x64','Mcp2210_GetLastError');
if err==0
    disp('Connected To MCP2210')
    disp(' ')
else
    try
        temp=calllib('mcp2210_dll_um_x64','Mcp2210_Close',handle_MCP2210);
        err=calllib('mcp2210_dll_um_x64','Mcp2210_GetLastError');
        if (err==0) && (temp==0)
            handle_MCP2210=calllib('mcp2210_dll_um_x64','Mcp2210_OpenByIndex',vid,pid,uint32(0),DevPath,DevPathSize);
            err=calllib('mcp2210_dll_um_x64','Mcp2210_GetLastError');
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

% Set GPIO Configuration
temp=calllib('mcp2210_dll_um_x64','Mcp2210_SetGpioConfig',handle_MCP2210,ChipConfigMode,PinDesignation,GPIODefaultOutput,GPIOPinDir,RemoteWakeup,InteruptCountMode,SPIBusRelease);
err=calllib('mcp2210_dll_um_x64','Mcp2210_GetLastError');
if err~=0
    disp('Error during GPIO configuration1. Check the "Mcp2210 DLL User Guide" for error code:')
    disp(err)
    calllib('mcp2210_dll_um_x64','Mcp2210_Close',handle);
    return
end
if temp<0
    disp('Error during GPIO configuration2. Check the "Mcp2210 DLL User Guide" for error code:')
    disp(temp)
    calllib('mcp2210_dll_um_x64','Mcp2210_Close',handle);
    return
end

% Set SPI Configuration
temp=calllib('mcp2210_dll_um_x64','Mcp2210_SetSpiConfig',handle_MCP2210,ChipConfigMode,Baud,IdleCS,ActiveCS,CSToDataDelay,DataToCSDelay,DataToDataDelay,TxSizePLL,SPIMode);
err=calllib('mcp2210_dll_um_x64','Mcp2210_GetLastError');
if err~=0
    disp('Error during SPI configuration. Check the "Mcp2210 DLL User Guide" for error code:')
    disp(err)
    calllib('mcp2210_dll_um_x64','Mcp2210_Close',handle_MCP2210);
    return
end
err=calllib('mcp2210_dll_um_x64','Mcp2210_xferSpiDataEx',handle_MCP2210,0,RxADC,Baud,TxSizeNULL,CSMaskNULL,IdleCS,ActiveCS,CSToDataDelay,DataToCSDelay,DataToDataDelay,SPIMode);
if err~=0
    disp('Error sending SPI data. Check the "Mcp2210 DLL User Guide" for error code:')
    disp(err)
    calllib('mcp2210_dll_um_x64','Mcp2210_Close',handle_MCP2210);
    return
end
%--------------------------------------------------------------------------

%% Fine Tune the Frequencies Until Lock is Acheived

% Variables setup
ADC_WORD(1,1)=bi2de([0 1 1 0 1 0 0 0],'left-msb');
ADC_WORD(1,2)=uint8(0);
locked=false;
count=0;
iteration=0;
FineFrequency(CWFreq,CWPort,1);
FineFrequency(PulseFreq,PulsePort,1);

% H=msgbox('Locking Lasers');
%try

while ~locked
    % CWFreq
    % PulseFreq
    % disp(' ')
    
    % Read the error signal with 10 bit ADC (MCP3002)
    err=calllib('mcp2210_dll_um_x64','Mcp2210_xferSpiDataEx',handle_MCP2210,ADC_WORD(1,:),RxADC,Baud,TxSizeADC,CSMaskADC,IdleCS,ActiveCS,CSToDataDelay,DataToCSDelay,DataToDataDelay,SPIMode);
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

    if ErrorVoltage<=0.4
        if CWFreq>0
            CWFreq=CWFreq-5;
            FineFrequency(CWFreq,CWPort,1);
        elseif PulseFreq<FineFreqMax
            PulseFreq=PulseFreq+5;
            FineFrequency(PulseFreq,PulsePort,1);
        end
        count=0;
        iteration=0;
        pause(0.05)
    elseif ErrorVoltage>=1.5
        if CWFreq<FineFreqMax
            CWFreq=CWFreq+5;
            FineFrequency(CWFreq,CWPort,1);
        elseif PulseFreq>0
            PulseFreq=PulseFreq-5;
            FineFrequency(PulseFreq,PulsePort,1);
        end
        count=0;
        iteration=0;
        pause(0.05);
    else
        count=count+1;
        pause(0.05)
    end

    % If 25 consecutive cycles without adjusting frequency increment
    % iteration and wait for 1 second for lsers to settle
    if count>=25
        iteration=iteration+1;
        count=0;
        pause(1)
    end
    
    % if iteration = 3 lasers are considered locked
    if iteration>=3
        locked=true;
%       close(H);
%       clear H
%       H=msgbox('Lasers Locked');
%       pause(2);
%       close(H);
%       clear H
    end
end
%catch me
   % 1;
%end
calllib('mcp2210_dll_um_x64','Mcp2210_Close',handle_MCP2210); % close the connection to mcp2210 chip
