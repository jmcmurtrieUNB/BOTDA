function varargout = ContinuousMeasurementsWindow2(varargin)
% CONTINUOUSMEASUREMENTSWINDOW2 MATLAB code for ContinuousMeasurementsWindow2.fig
%      CONTINUOUSMEASUREMENTSWINDOW2, by itself, creates a new CONTINUOUSMEASUREMENTSWINDOW2 or raises the existing
%      singleton*.
%
%      H = CONTINUOUSMEASUREMENTSWINDOW2 returns the handle to a new CONTINUOUSMEASUREMENTSWINDOW2 or the handle to
%      the existing singleton*.
%
%      CONTINUOUSMEASUREMENTSWINDOW2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONTINUOUSMEASUREMENTSWINDOW2.M with the given input arguments.
%
%      CONTINUOUSMEASUREMENTSWINDOW2('Property','Value',...) creates a new CONTINUOUSMEASUREMENTSWINDOW2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ContinuousMeasurementsWindow2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ContinuousMeasurementsWindow2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ContinuousMeasurementsWindow2

% Last Modified by GUIDE v2.5 23-May-2018 10:48:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ContinuousMeasurementsWindow2_OpeningFcn, ...
                   'gui_OutputFcn',  @ContinuousMeasurementsWindow2_OutputFcn, ...
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


% --- Executes just before ContinuousMeasurementsWindow2 is made visible.
function ContinuousMeasurementsWindow2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ContinuousMeasurementsWindow2 (see VARARGIN)
handles.loopflag=false;
% Choose default command line output for ContinuousMeasurementsWindow2
handles.output = hObject;
handles.firstloop=true;
handles.CWFineFreq=0;
handles.PulseFineFreq=0;
%  handles.t = timer('BusyMode', 'queue', 'ExecutionMode','fixedRate', 'Period', 4.0);
%  set(handles.t, 'TimerFcn', {@StartButton_Callback, hObject});
%  start(handles.t);

%t = timer('TimerFcn',{@(hObject,eventdata)ContinuousMeasurementsWindow2('StartButton_Callback',hObject,eventdata,guidata(hObject))},'StartDelay',2);
%start(t)
% @(hObject,eventdata)ContinuousMeasurementsWindow2('StartButton_Callback',hObject,eventdata,guidata(hObject))
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ContinuousMeasurementsWindow2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ContinuousMeasurementsWindow2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

StartButton_Callback(hObject,[],handles)
varargout{1} = handles.output;


function measurefiber_Callback(hObject, eventdata, handles)
% hObject    handle to measurefiber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of measurefiber as text
%        str2double(get(hObject,'String')) returns contents of measurefiber as a double


% --- Executes during object creation, after setting all properties.
function measurefiber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to measurefiber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
handles.save=0;
handles.base=0;
handles.type=5;
guidata(hObject,handles);

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function measurestart_Callback(hObject, eventdata, handles)
% hObject    handle to measurestart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of measurestart as text
%        str2double(get(hObject,'String')) returns contents of measurestart as a double


% --- Executes during object creation, after setting all properties.
function measurestart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to measurestart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function measureend_Callback(hObject, eventdata, handles)
% hObject    handle to measureend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of measureend as text
%        str2double(get(hObject,'String')) returns contents of measureend as a double


% --- Executes during object creation, after setting all properties.
function measureend_CreateFcn(hObject, eventdata, handles)
% hObject    handle to measureend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function measureavg_Callback(hObject, eventdata, handles)
% hObject    handle to measureavg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of measureavg as text
%        str2double(get(hObject,'String')) returns contents of measureavg as a double


% --- Executes during object creation, after setting all properties.
function measureavg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to measureavg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function measurestep_Callback(hObject, eventdata, handles)
% hObject    handle to measurestep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of measurestep as text
%        str2double(get(hObject,'String')) returns contents of measurestep as a double


% --- Executes during object creation, after setting all properties.
function measurestep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to measurestep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in measurementsave.
function measurementsave_Callback(hObject, eventdata, handles)
% hObject    handle to measurementsave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.save=1;
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of measurementsave


% --- Executes on button press in measurebase.
function measurebase_Callback(hObject, eventdata, handles)
% hObject    handle to measurebase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.base=1;
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of measurebase


% --- Executes on button press in StartButton.
function StartButton_Callback(hObject ,eventdata, handles)
% hObject    handle to StartButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles=guidata(hObject,handles);

count=0;

if handles.loopflag
    return;
end

% Get values from UI
handles.loopflag=true;
startpass =get(handles.measurestart,'string');
endpass =get(handles.measureend,'string');
AVGpass =get(handles.measureavg,'string');
steppass =get(handles.measurestep,'string');
lenghtpass =get(handles.measurefiber,'string');
savepass =handles.save;
basepass =handles.base;
typepass=handles.type;
startpass = str2num(startpass);
endpass = str2num(endpass);
AVGpass = str2num(AVGpass);
steppass = str2num(steppass);
lenghtpass = str2num(lenghtpass);

% If any values are missing from the UI, do not perform measurements and
% return to waiting for user input.
if isempty(lenghtpass) || isempty(steppass) || isempty(AVGpass) || isempty(endpass) || isempty(startpass)
    msgbox({'Must fill in all required fields:'; ' ';'Fiber Length'; 'Start Frequency'; 'End Frequency'; 'Frequency Step'; 'Number of AVG'},'Error','error');
    return;
end

guidata(hObject,handles);

% Upon first run of this script setup the lasers
if handles.firstloop
    UNB_BOTDA_Lock(4);
    autoLaserSetup();
    UNB_BOTDA_Lock(10.9);
    [handles.CWFineFreq,handles.PulseFineFreq]=Auto_Lock_UNB_BOTDA('COM8','COM3',handles.CWFineFreq,handles.PulseFineFreq);
    UNB_BOTDA_Lock(4);
    handles.firstloop=false;
end

guidata(hObject,handles);

% loop to perform repeated measurements
while handles.loopflag
    time=fix(clock);
    %time=temp(5); % minutes as an integer
%     if (time(5)==15) || (time(5)==30) % Measurement every 30 minutes
        if 1
        % Switch the lasers into dither mode to re-establish internal laser
        % freqeuncy control, then switch back to whisper mode for
        % measurement
        
        ret=LaserMode('COM8',0);% 0=dither 1=no dither 2=whisper
        ret=LaserMode('COM3',0);
        pause(0.25)
        ret=LaserMode('COM8',2);
        ret=LaserMode('COM3',2);
        
        % Lock the lasers
        UNB_BOTDA_Lock(10.9);
        [handles.CWFineFreq,handles.PulseFineFreq]=Auto_Lock_UNB_BOTDA('COM8','COM3',handles.CWFineFreq,handles.PulseFineFreq);
        
        % Perform measurement
        [ret handles.CWFineFreq handles.PulseFineFreq]= MeasurementFunctionContinuous(startpass,endpass,steppass,AVGpass,lenghtpass,savepass,basepass,typepass,handles.CWFineFreq,handles.PulseFineFreq);
        
        % Restart timer for next measurement
        temp=fix(clock);
        time=temp(5); % minutes as an integer
    end
    
    % Restart the system once per month. MATLAB slowly uses more RAM and
    % will crash eventually without a restart.
    if (time(3)==7 && time(4)==13 && time(5)==23)
        % disable the lasers before MATLAB restart
        LaserDisable('COM8');
        LaserDisable('COM3');
        % System command to restart MATLAB and run autoSetupTest script
        !"C:\Program Files\MATLAB\R2017a\bin\matlab.exe" -r "autoSetupTest"
        exit
    end
    
    % Check if any buttons have been pressed
    drawnow;
    if ~ishandle(hObject)
        return;
    end
    
    
%    if count>=5
%        addpath('C:\Users\e5862\Downloads\MCP2210_DLLv2\mcp2210_dll_v2.1.0\unmanaged\dll');
% if ~libisloaded('mcp2210_dll_um_x64')
%     [notFound,warnings]=loadlibrary('mcp2210_dll_um_x64','mcp2210_dll_um');
% end
% if libisloaded('mcp2210_dll_um_x64')
%     disp('mcp2210_dll_um_x64 library is loaded')
%     disp(' ')
% else 
%     disp('Library failed to load')
%     disp(' ')
%     return
% end
%        % Initializing variables/pointers for mcp2210 dll functions
% vid=uint16(hex2dec('4D8')); % Chip vendor ID
% pid=uint16(hex2dec('DE'));  % Chip product ID
% DevPath=libpointer('voidPtr'); % dummy void pointer that could contain the device path if desired(the actual path is not needed)
% DevPathSize=libpointer('uint32Ptr',1001); % dummy pointer for memory allocation of device path string
% RxADC=libpointer('uint8Ptr',[0 0]); % Rx data (there is none but the variable is required by the functions in the mcp2210_dll_um_x64 library
% Baud=uint32(40000); % Baud Rate in Hz
% IdleCS=uint32(1);
% ActiveCS=uint32(0);
% CSToDataDelay=uint32(0); % Delay between Chip Select Active and Beginning of Data Transfer
% DataToCSDelay=uint32(0); % Delay between end of Data Transfer and Chip Select Return to Idle
% DataToDataDelay=uint32(0); % Delay between data bytes
% TxSizePLL=uint32(4); % Bytes to transfer per SPI transaction for PLL
% TxSizeADC=uint32(2);
% TxSizeNULL=uint32(0);
% SPIMode=uint8(0); % SPI mode: 0
% RemoteWakeup=uint8(0); % 0=Disabled 1=enabled
% ChipConfigMode=uint8(0); % 0=Volatile(Default) 1=NVRAM
% InteruptCountMode=uint8(0); % 0=NoCount 1=FallingEdge 2=RisingEdge 3=LowPulse 4=HighPulse
% SPIBusRelease=uint8(0); % 0=Enabled 1=Disabled
% CSMaskPLL=uint32(1); % Chip select mask
% CSMaskADC=uint32(32);
% CSMaskNULL=uint32(128); % dummy chip select mask
% PinDesignation=libpointer('uint8Ptr',[1 0 0 0 0 1 0 1 0]); % There are 9 pin 0=GPIO 1=ChipSelect 2=SpecialFunction
% GPIODefaultOutput=uint32(bi2de([1 1 1 1 1 1 1 1 1])); % Default GPIO Output
% GPIOPinDir=uint32(0); % Default GPIO Pin Direction(Input/Output)
% GPIOSetVal=uint32(bi2de([0 0 0 0 0 0 0 0])); % GPIO set Pin Values
% GPIOPinVal=libpointer('uint32Ptr',[0 0 0 0 0 0 0 0 0]); % GPIO read back pin values
% ADC_WORD(1,1)=bi2de([0 1 1 0 1 0 0 0],'left-msb');
% ADC_WORD(1,2)=uint8(0);
% 
% % Connect to the mcp2210 chip
% hand_MCP2210=calllib('mcp2210_dll_um_x64','Mcp2210_OpenByIndex',vid,pid,uint32(0),DevPath,DevPathSize);
% err=calllib('mcp2210_dll_um_x64','Mcp2210_GetLastError');
% if err==0
%     disp('Connected To MCP2210')
%     disp(' ')
% else
%     try
%         temp=calllib('mcp2210_dll_um_x64','Mcp2210_Close',hand_MCP2210);
%         err=calllib('mcp2210_dll_um_x64','Mcp2210_GetLastError');
%         if (err==0) && (temp==0)
%             hand_MCP2210=calllib('mcp2210_dll_um_x64','Mcp2210_OpenByIndex',vid,pid,uint32(0),DevPath,DevPathSize);
%             err=calllib('mcp2210_dll_um_x64','Mcp2210_GetLastError');
%             if err==0
%                 disp('Device Connected')
%             else
%                 disp('Error connecting device. Check the "Mcp2210 DLL User Guide" for error code:')
%                 disp(err)    
%                 return
%             end
%         else
%             disp('Error connecting device. Check the "Mcp2210 DLL User Guide" for error code:')
%             disp(err)    
%             return
%         end
%     catch me
%         disp('Error connecting device. Check the "Mcp2210 DLL User Guide" for error code:')
%         disp(err)
%         return
%     end
% end
% 
% % Set GPIO Configuration
% temp=calllib('mcp2210_dll_um_x64','Mcp2210_SetGpioConfig',hand_MCP2210,ChipConfigMode,PinDesignation,GPIODefaultOutput,GPIOPinDir,RemoteWakeup,InteruptCountMode,SPIBusRelease);
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
% 
% % Set SPI Configuration
% temp=calllib('mcp2210_dll_um_x64','Mcp2210_SetSpiConfig',hand_MCP2210,ChipConfigMode,Baud,IdleCS,ActiveCS,CSToDataDelay,DataToCSDelay,DataToDataDelay,TxSizePLL,SPIMode);
% err=calllib('mcp2210_dll_um_x64','Mcp2210_GetLastError');
% if err~=0
%     disp('Error during SPI configuration. Check the "Mcp2210 DLL User Guide" for error code:')
%     disp(err)
%     calllib('mcp2210_dll_um_x64','Mcp2210_Close',hand_MCP2210);
%     return
% end
% err=calllib('mcp2210_dll_um_x64','Mcp2210_xferSpiDataEx',hand_MCP2210,0,RxADC,Baud,TxSizeNULL,CSMaskNULL,IdleCS,ActiveCS,CSToDataDelay,DataToCSDelay,DataToDataDelay,SPIMode);
% if err~=0
%     disp('Error sending SPI data. Check the "Mcp2210 DLL User Guide" for error code:')
%     disp(err)
%     calllib('mcp2210_dll_um_x64','Mcp2210_Close',hand_MCP2210);
%     return
% end
%    % Check for lock
%    % Read the error signal with 10 bit ADC (MCP3002)
%    err=calllib('mcp2210_dll_um_x64','Mcp2210_xferSpiDataEx',hand_MCP2210,ADC_WORD(1,:),RxADC,Baud,TxSizeADC,CSMaskADC,IdleCS,ActiveCS,CSToDataDelay,DataToCSDelay,DataToDataDelay,SPIMode);
%    if err~=0
%        disp('Error sending SPI data. Check the "Mcp2210 DLL User Guide" for error code:')
%        disp(err)
%        calllib('mcp2210_dll_um_x86','Mcp2210_Close',hand_MCP2210);
%        return
%    end
%    
%    % The bus does not like to release, this forces it to release
%    err=calllib('mcp2210_dll_um_x64','Mcp2210_xferSpiDataEx',hand_MCP2210,0,RxADC,Baud,TxSizeNULL,CSMaskNULL,IdleCS,ActiveCS,CSToDataDelay,DataToCSDelay,DataToDataDelay,SPIMode);
%    if err~=0
%        disp('Error sending SPI data. Check the "Mcp2210 DLL User Guide" for error code:')
%        disp(err)
%        calllib('mcp2210_dll_um_x64','Mcp2210_Close',hand_MCP2210);
%        return
%    end
%     % Bus should now be released
% 
%     % Convert measured error signal to voltage level
%    rx=RxADC.value; % retrieve the value from pointer
%    binaryVoltage(1,1:8)=de2bi(rx(1,1),8,'left-msb'); %  most significant bits
%    binaryVoltage(1,9:16)=de2bi(rx(1,2),8,'left-msb'); % 8 least significant bits
%    binaryVoltage(1,1:6)=[0 0 0 0 0 0];
%    binaryVoltage=double(binaryVoltage); % convert to type double
%    VoltFraq=bi2de(binaryVoltage,'left-msb'); % convert binary to decimal number
%    Vmax=2.25; %Volts\
%    ErrorVoltage=Vmax*VoltFraq/1023; % convert to voltage level
% 
% 
%    % If error voltage is between 0.5 and 2 lasers are still locked
%    if ErrorVoltage<=0.5 || ErrorVoltage>=2
%        calllib('mcp2210_dll_um_x64','Mcp2210_Close',hand_MCP2210); % close the connection to mcp2210 chip
%        [handles.CWFineFreq,handles.PulseFineFreq]=Auto_Lock_UNB_BOTDA('COM8','COM3',handles.CWFineFreq,handles.PulseFineFreq);
%        % Reconnect to the mcp2210 chip
%        hand_MCP2210=calllib('mcp2210_dll_um_x86','Mcp2210_OpenByIndex',vid,pid,uint32(0),DevPath,DevPathSize);
%        err=calllib('mcp2210_dll_um_x86','Mcp2210_GetLastError');
%        if err==0
%            disp('Connected To MCP2210')
%            disp(' ')
%        else
%            try
%                temp=calllib('mcp2210_dll_um_x86','Mcp2210_Close',hand_MCP2210);
%                err=calllib('mcp2210_dll_um_x86','Mcp2210_GetLastError');
%                if (err==0) && (temp==0)
%                    hand_MCP2210=calllib('mcp2210_dll_um_x86','Mcp2210_OpenByIndex',vid,pid,uint32(0),DevPath,DevPathSize);
%                    err=calllib('mcp2210_dll_um_x86','Mcp2210_GetLastError');
%                    if err==0
%                        disp('Device Connected')
%                    else
%                        disp('Error connecting device. Check the "Mcp2210 DLL User Guide" for error code:')
%                        disp(err)    
%                        return
%         
%                end
%                else
%                    disp('Error connecting device. Check the "Mcp2210 DLL User Guide" for error code:')
%                    disp(err)    
%                    return
%                end
%            catch me
%                disp('Error connecting device. Check the "Mcp2210 DLL User Guide" for error code:')
%                disp(err)
%                return
%            end
%        end
%    end
%    count=0;
%    end
    
    
    
    
    
    
    
    
    
%    count=count+1;
    % Update handles
    handles = guidata(hObject);
end

% Display the directory path to where the data was saved once the
% measurements are stopped.
msgbox({'Data is saved here:';'C:\Users\Fiberlaser\Desktop\Measurements\Continuous\'});



% This is the old code-----------------------------------------------------
% ret=0;
% startpass =get(handles.measurestart,'string');
% endpass =get(handles.measureend,'string');
% AVGpass =get(handles.measureavg,'string');
% steppass =get(handles.measurestep,'string');
% lenghtpass =get(handles.measurefiber,'string');
% savepass =handles.save;
% basepass =handles.base;
% typepass=handles.type;
% 
% startpass = str2num(startpass);
% endpass = str2num(endpass);
% AVGpass = str2num(AVGpass);
% steppass = str2num(steppass);
% lenghtpass = str2num(lenghtpass);
% ret= measurementfunction(startpass,endpass,steppass,AVGpass,lenghtpass,savepass,basepass,typepass);
% if ret ==1
%     msgbox('Measurement is done')
% end
%--------------------------------------------------------------------------


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.type=5;
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.type=1;
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.type=3;
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.type=2;
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.type=4;
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on button press in StopButton.
function StopButton_Callback(hObject, eventdata, handles)
% hObject    handle to StopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.loopflag=false;
guidata(hObject,handles);
