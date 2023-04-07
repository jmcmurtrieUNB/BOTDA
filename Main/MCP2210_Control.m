function []= MCP2210_Control(GPIOSetVal)

if ~libisloaded('mcp2210_dll_um_x86')
    [notFound warnings]=loadlibrary('mcp2210_dll_um_x86','mcp2210_dll_um');
end
if ~libisloaded('mcp2210_dll_um_x86')
    %     disp('mcp2210_dll_um_x86 library is loaded')
    %     disp(' ')
% else
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


