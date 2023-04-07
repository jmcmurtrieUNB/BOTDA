function varargout = oscwindow(varargin)
% OSCWINDOW MATLAB code for oscwindow.fig
%      OSCWINDOW, by itself, creates a new OSCWINDOW or raises the existing
%      singleton*.
%
%      H = OSCWINDOW returns the handle to a new OSCWINDOW or the handle to
%      the existing singleton*.
%
%      OSCWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OSCWINDOW.M with the given input arguments.
%
%      OSCWINDOW('Property','Value',...) creates a new OSCWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before oscwindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to oscwindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help oscwindow

% Last Modified by GUIDE v2.5 17-Jan-2013 10:46:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @oscwindow_OpeningFcn, ...
                   'gui_OutputFcn',  @oscwindow_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before oscwindow is made visible.
function oscwindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to oscwindow (see VARARGIN)
addpath 'C:\Program Files\Gage\CompuScope\CompuScope MATLAB SDK\CsMl';
% Choose default command line output for oscwindow
handles.output = hObject;

% Update handles structure
handles.loopflag = false;
guidata(hObject, handles);

% UIWAIT makes oscwindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = oscwindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function oscfrequency_Callback(hObject, eventdata, handles)
% hObject    handle to oscfrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of oscfrequency as text
%        str2double(get(hObject,'String')) returns contents of oscfrequency as a double


% --- Executes during object creation, after setting all properties.
function oscfrequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to oscfrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function oscfiber_Callback(hObject, eventdata, handles)
% hObject    handle to oscfiber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of oscfiber as text
%        str2double(get(hObject,'String')) returns contents of oscfiber as a double


% --- Executes during object creation, after setting all properties.
function oscfiber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to oscfiber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function oscaverage_Callback(hObject, eventdata, handles)
% hObject    handle to oscaverage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of oscaverage as text
%        str2double(get(hObject,'String')) returns contents of oscaverage as a double


% --- Executes during object creation, after setting all properties.
function oscaverage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to oscaverage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in trigger.
function trigger_Callback(hObject, eventdata, handles)
% hObject    handle to trigger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.loopflag
    return;
end




handles.loopflag = true;
guidata(hObject, handles);




frequencyosc = handles.frequencyosc;
averagesosc = handles.averagesosc;
fiberosc = handles.fiberosc

frequencyosc1 = str2num(frequencyosc);
averagesosc1 = str2num(averagesosc);
fiberosc1 = str2num(fiberosc);
%plotarray = oscmode(frequencyosc,fiberosc,averagesosc);
%plot(axesHandle, plotarray);
%*********************************************************************mmmmmmmmmmmmmmmmmmmmmmmm
CsMl_FreeAllSystems; % This seems to help if system will not start

StartFreq=frequencyosc1;
EndFreq=frequencyosc1+2e6;
StepSize=2e6;
FiberLenght=fiberosc1;
AVGNum=averagesosc1;
SaveData=0;
BStart=1e-6;%in seconds
BEnd=10e-6;%in seconds
correctbaseline=0;


%pllset(StartFreq/64);
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
%FiberLenght=FiberLenght*(.48e-8);
%******************************************
%setparameters


Snum=floor(FiberLenght*10+2048);%Aquisition rate is 1G sample per sec
%4096 extra samples after the end point of the fiber
Srem=rem(Snum,64);
if Srem ==0 %if valid sample number
    SampleNum=Snum;
end
if Srem~= 0
SampleNum=Snum+(64-Srem);
end
% PllFreq =(StartFreq/64);%actual data passed to pll


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
%  mex rawavg.c; % compiles row averaging c function
%  mex polarizationavg.c % compiles polaraization averaging c function
%  mex csend.c mmp.lib % initiate the lasers to be 11GHz apart
% %this function might be moved out of the main algorithem
% 

%******************************************************
%inetialize the Gage Card & set Aquizition parameters
%******************************************************


systems = CsMl_Initialize;
CsMl_ErrorHandler(systems);
[ret, handle] = CsMl_GetSystem;
handles.handle=handle;
guidata(hObject, handles);
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

addpath('C:\Users\Fiberlaser\Downloads\MCP2210_DLLv2\mcp2210_dll_v2.1.0\unmanaged\dll');

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

% Initializing pointers for mcp2210 dll functions
vid=uint16(hex2dec('4D8')); % Chip vendor ID
pid=uint16(hex2dec('DE'));  % Chip product ID
DevPath=libpointer('voidPtr'); % dummy void pointer that could contain the device path if desired(the actual path is not needed)
DevPathSize=libpointer('uint32Ptr',1001); % dummy pointer for memory allocation of device path string
Rx=uint8(0); % Rx data (there is none but the variable is required by the functions in the mcp2210_dll_um_x86 library
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

% Connect to the mcp2210 chip
handle_2=calllib('mcp2210_dll_um_x86','Mcp2210_OpenByIndex',vid,pid,uint32(0),DevPath,DevPathSize);
err=calllib('mcp2210_dll_um_x86','Mcp2210_GetLastError');
if err==0
    disp('Connected To MCP2210')
    disp(' ')
else
    try
        temp=calllib('mcp2210_dll_um_x86','Mcp2210_Close',handle_2);
        err=calllib('mcp2210_dll_um_x86','Mcp2210_GetLastError');
        if (err==0) && (temp==0)
            handle_2=calllib('mcp2210_dll_um_x86','Mcp2210_OpenByIndex',vid,pid,uint32(0),DevPath,DevPathSize);
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
temp=calllib('mcp2210_dll_um_x86','Mcp2210_SetSpiConfig',handle_2,MemoryMode,Baud,IdleCS,ActiveCS,CSToDataDelay,DataToCSDelay,DataToDataDelay,TxSize,SPIMode);
err=calllib('mcp2210_dll_um_x86','Mcp2210_GetLastError');
if err~=0
    disp('Error during SPI configuration. Check the "Mcp2210 DLL User Guide" for error code:')
    disp(err)
    calllib('mcp2210_dll_um_x86','Mcp2210_Close',handle_2);
    return
end

% Set GPIO Configuration
temp=calllib('mcp2210_dll_um_x86','Mcp2210_SetGpioConfig',handle_2,MemoryMode,PinDesignation,GPIODefaultOutput,GPIOPinDir,RemoteWakeup,InteruptCountMode,SPIBusRelease);
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


%************************************
%aquire data
%************************************
while handles.loopflag

for polo=1:PolNum%setup the polrization
  % Setting the polarization switch
 if polo ==1
     GPIOSetVal=uint32(2);
     temp=calllib('mcp2210_dll_um_x86','Mcp2210_SetGpioConfig',handle_2,MemoryMode,PinDesignation,GPIODefaultOutput,GPIOPinDir,RemoteWakeup,InteruptCountMode,SPIBusRelease);
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
     temp=calllib('mcp2210_dll_um_x86','Mcp2210_SetGpioPinVal',handle_2,GPIOSetVal,GPIOPinVal);
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
     temp=calllib('mcp2210_dll_um_x86','Mcp2210_SetGpioConfig',handle_2,MemoryMode,PinDesignation,GPIODefaultOutput,GPIOPinDir,RemoteWakeup,InteruptCountMode,SPIBusRelease);
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
     temp=calllib('mcp2210_dll_um_x86','Mcp2210_SetGpioPinVal',handle_2,GPIOSetVal,GPIOPinVal);
     err=calllib('mcp2210_dll_um_x86','Mcp2210_GetLastError');
     if err~=0 || temp<0
         disp('Error during setting GPIO pins. Check the "Mcp2210 DLL User Guide" for error code:')
         disp(err)
         calllib('mcp2210_dll_um_x86','Mcp2210_Close',handle);
         return
     end
     pause(0.1) % allow time for signal and pola switch to change
 end

for freq=StartFreq:StepSize:(EndFreq-StepSize)
    freq %???????????????????????????????????????????????
   
    Register = FreqCalcs(freq); % Calculate the register values for ADF4159 board
   
   % Convert binary vectors into decimal for transmission
   for k=1:11
       writeCmd(k,1) = bi2de(Register(k,1:8),'left-msb');
       writeCmd(k,2) = bi2de(Register(k,9:16),'left-msb');
       writeCmd(k,3) = bi2de(Register(k,17:24),'left-msb');
       writeCmd(k,4) = bi2de(Register(k,25:32),'left-msb');
   end
   
   for i=1:11
       err=calllib('mcp2210_dll_um_x86','Mcp2210_xferSpiData',handle_2,writeCmd(i,:),Rx,Baud,TxSize,CSMask);
       if err~=0
           disp('Error sending SPI data. Check the "Mcp2210 DLL User Guide" for error code:')
           disp(err)
           calllib('mcp2210_dll_um_x86','Mcp2210_Close',handle_2);
           return
       end
   end
    
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

AVGArray(((polo-1)*((EndFreq-StartFreq)/StepSize))+((freq-StartFreq+StepSize)/StepSize),:)=newavg(RowData);



%****************************************************
%saving the row data 
%****************************************************

%****************************************************

end;
end;
SFinalAVG=newpolavg(AVGArray);
x= str2num(handles.fiberosc)/SampleNum:str2num(handles.fiberosc)/SampleNum:str2num(handles.fiberosc);
plot(handles.axes11,SFinalAVG(1,:));
%xlabel('Position');
%ylabel('Intensity');
%plot(handles.axes11,SFinalAVG(1,(4000:5000)));
drawnow;

 if ~ishandle(hObject)
        return;
 end
     handles = guidata(hObject);
end;
ret = CsMl_FreeSystem(handle);%set the card free for next measurement
temp=calllib('mcp2210_dll_um_x86','Mcp2210_Close',handle_2)


% --- Executes on button press in stopbutton.
function stopbutton_Callback(hObject, eventdata, handles)
% hObject    handle to stopbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.loopflag = false;
guidata(hObject, handles);


% --- Executes on button press in change.
function change_Callback(hObject, eventdata, handles)
% hObject    handle to change (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.loopflag = false;
handles.frequencyosc = get(handles.oscfrequency,'string');
handles.averagesosc = get(handles.oscaverage,'string');
handles.fiberosc = get(handles.oscfiber,'string');
guidata(hObject, handles);
