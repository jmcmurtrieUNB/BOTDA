function varargout = measurementwindow(varargin)
% MEASUREMENTWINDOW MATLAB code for measurementwindow.fig
%      MEASUREMENTWINDOW, by itself, creates a new MEASUREMENTWINDOW or raises the existing
%      singleton*.
%
%      H = MEASUREMENTWINDOW returns the handle to a new MEASUREMENTWINDOW or the handle to
%      the existing singleton*.
%
%      MEASUREMENTWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MEASUREMENTWINDOW.M with the given input arguments.
%
%      MEASUREMENTWINDOW('Property','Value',...) creates a new MEASUREMENTWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before measurementwindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to measurementwindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help measurementwindow

% Last Modified by GUIDE v2.5 04-May-2018 17:10:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @measurementwindow_OpeningFcn, ...
                   'gui_OutputFcn',  @measurementwindow_OutputFcn, ...
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


% --- Executes just before measurementwindow is made visible.
function measurementwindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to measurementwindow (see VARARGIN)

% Choose default command line output for measurementwindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes measurementwindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = measurementwindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
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


% --- Executes on button press in measurments.
function measurments_Callback(hObject, eventdata, handles)
% hObject    handle to measurments (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ret=0;
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
ret= measurementfunction(startpass,endpass,steppass,AVGpass,lenghtpass,savepass,basepass,typepass);
if ret ==1
    msgbox('Measurement is done')
end


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
