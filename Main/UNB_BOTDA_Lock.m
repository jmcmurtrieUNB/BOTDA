function UNB_BOTDA_Lock(freq)
freq=freq*1e9;
addpath('C:\Users\e5862\OneDrive - University of New Brunswick\Mactaquac_BOTDA_Software\mcp2210_dll_v2.1.0\unmanaged\dll');
if ~libisloaded('mcp2210_dll_um_x64')
    [notFound,warnings]=loadlibrary('mcp2210_dll_um_x64','mcp2210_dll_um');
end
if libisloaded('mcp2210_dll_um_x64')
    % disp('mcp2210_dll_um_x64 library is loaded')
    % disp(' ')
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
GPIODefaultOutput=uint32(bi2de([0 0 0 0 0 0 0 0 0])); % Default GPIO Output
GPIOPinDir=uint32(0); % Default GPIO Pin Direction(Input/Output)
GPIOSetVal=uint32(bi2de([0 0 0 0 0 0 0 0])); % GPIO set Pin Values
GPIOPinVal=libpointer('uint32Ptr',[0 0 0 0 0 0 0 0 0]); % GPIO read back pin values

% Connect to the mcp2210 chip
handle_2=calllib('mcp2210_dll_um_x64','Mcp2210_OpenByIndex',vid,pid,uint32(0),DevPath,DevPathSize);
err=calllib('mcp2210_dll_um_x64','Mcp2210_GetLastError');
if err==0
   % disp('Connected To MCP2210')
   % disp(' ')
else
    try
        temp=calllib('mcp2210_dll_um_x64','Mcp2210_Close',handle_2);
        err=calllib('mcp2210_dll_um_x64','Mcp2210_GetLastError');
        if (err==0) && (temp==0)
            handle_2=calllib('mcp2210_dll_um_x64','Mcp2210_OpenByIndex',vid,pid,uint32(0),DevPath,DevPathSize);
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
temp=calllib('mcp2210_dll_um_x64','Mcp2210_SetGpioConfig',handle_2,ChipConfigMode,PinDesignation,GPIODefaultOutput,GPIOPinDir,RemoteWakeup,InteruptCountMode,SPIBusRelease);
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
temp=calllib('mcp2210_dll_um_x64','Mcp2210_SetGpioPinVal',handle_2,GPIOSetVal,GPIOPinVal);

% Set SPI Configuration
temp=calllib('mcp2210_dll_um_x64','Mcp2210_SetSpiConfig',handle_2,ChipConfigMode,Baud,IdleCS,ActiveCS,CSToDataDelay,DataToCSDelay,DataToDataDelay,TxSizePLL,SPIMode);
err=calllib('mcp2210_dll_um_x64','Mcp2210_GetLastError');
if err~=0
    disp('Error during SPI configuration. Check the "Mcp2210 DLL User Guide" for error code:')
    disp(err)
    calllib('mcp2210_dll_um_x64','Mcp2210_Close',handle_2);
    return
end
err=calllib('mcp2210_dll_um_x64','Mcp2210_xferSpiDataEx',handle_2,0,RxADC,Baud,TxSizeNULL,CSMaskNULL,IdleCS,ActiveCS,CSToDataDelay,DataToCSDelay,DataToDataDelay,SPIMode);
if err~=0
    disp('Error sending SPI data. Check the "Mcp2210 DLL User Guide" for error code:')
    disp(err)
    calllib('mcp2210_dll_um_x64','Mcp2210_Close',handle_2);
    return
end

Register = FreqCalcs(freq); % Calculate the register values for ADF4159 board
   
   % Convert binary vectors into decimal for transmission
for k=1:11
   writeCmd(k,1) = bi2de(Register(k,1:8),'left-msb');
   writeCmd(k,2) = bi2de(Register(k,9:16),'left-msb');
   writeCmd(k,3) = bi2de(Register(k,17:24),'left-msb');
   writeCmd(k,4) = bi2de(Register(k,25:32),'left-msb');
end
pause(0.01)
% Write data
   for i=1:11
       err=calllib('mcp2210_dll_um_x64','Mcp2210_xferSpiDataEx',handle_2,writeCmd(i,:),RxADC,Baud,TxSizePLL,CSMaskPLL,IdleCS,ActiveCS,CSToDataDelay,DataToCSDelay,DataToDataDelay,SPIMode);
       if err~=0
           disp('Error sending SPI data. Check the "Mcp2210 DLL User Guide" for error code:')
           disp(err)
           calllib('mcp2210_dll_um_x86','Mcp2210_Close',handle_2);
           return
       end
       
       % get the bus to release
       err=calllib('mcp2210_dll_um_x64','Mcp2210_xferSpiDataEx',handle_2,0,RxADC,Baud,TxSizeNULL,CSMaskNULL,IdleCS,ActiveCS,CSToDataDelay,DataToCSDelay,DataToDataDelay,SPIMode);
       if err~=0
           disp('Error sending SPI data. Check the "Mcp2210 DLL User Guide" for error code:')
           disp(err)
           calllib('mcp2210_dll_um_x64','Mcp2210_Close',handle_2);
           return
       end
   end
pause(0.01)
% Invert polaswitch pin
% GPIODefaultOutput=uint32(bi2de([1 0 1 0 1 0 0 0 0])); % Default GPIO Output
% GPIOSetVal=uint32(bi2de([1 0 1 0 1 0 0 1])); % GPIO set Pin Values
% % Set GPIO Configuration
% temp=calllib('mcp2210_dll_um_x64','Mcp2210_SetGpioConfig',handle_2,ChipConfigMode,PinDesignation,GPIODefaultOutput,GPIOPinDir,RemoteWakeup,InteruptCountMode,SPIBusRelease);
% err=calllib('mcp2210_dll_um_x64','Mcp2210_GetLastError');
% if err~=0
%     disp('Error during GPIO configuration1. Check the "Mcp2210 DLL User Guide" for error code:')
%     disp(err)
%     calllib('mcp2210_dll_um_x64','Mcp2210_Close',handle);
%     return
% end
% if temp<0
%     disp('Error during GPIO configuration2. Check the "Mcp2210 DLL User Guide" for error code:')
%     disp(temp)
%     calllib('mcp2210_dll_um_x64','Mcp2210_Close',handle);
%     return
% end
% temp=calllib('mcp2210_dll_um_x64','Mcp2210_SetGpioPinVal',handle_2,GPIOSetVal,GPIOPinVal);
% 
% % Get the bus to release
% err=calllib('mcp2210_dll_um_x64','Mcp2210_xferSpiDataEx',handle_2,0,RxADC,Baud,TxSizeNULL,CSMaskNULL,IdleCS,ActiveCS,CSToDataDelay,DataToCSDelay,DataToDataDelay,SPIMode);
% if err~=0
%     disp('Error sending SPI data. Check the "Mcp2210 DLL User Guide" for error code:')
%     disp(err)
%     calllib('mcp2210_dll_um_x64','Mcp2210_Close',handle_2);
%     return
% end   
calllib('mcp2210_dll_um_x64','Mcp2210_Close',handle_2); % close the connection to mcp2210 chip