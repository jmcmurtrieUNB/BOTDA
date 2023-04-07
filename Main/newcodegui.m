function varargout = newcodegui(varargin)
% NEWCODEGUI MATLAB code for newcodegui.fig
%      NEWCODEGUI, by itself, creates a new NEWCODEGUI or raises the existing
%      singleton*.
%
%      H = NEWCODEGUI returns the handle to a new NEWCODEGUI or the handle to
%      the existing singleton*.
%
%      NEWCODEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEWCODEGUI.M with the given input arguments.
%
%      NEWCODEGUI('Property','Value',...) creates a new NEWCODEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before newcodegui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to newcodegui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help newcodegui

% Last Modified by GUIDE v2.5 04-May-2018 17:06:59

% Begin initialization code - DO NOT EDIT

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
warning_message='daq:digitalio:adaptorobsolete';
warning('off',warning_message);
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @newcodegui_OpeningFcn, ...
                   'gui_OutputFcn',  @newcodegui_OutputFcn, ...
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


% --- Executes just before newcodegui is made visible.
function newcodegui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to newcodegui (see VARARGIN)
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


%Splash image begin%
%**********************
% create a figure that is not visible yet, and has minimal titlebar properties
addpath 'C:\Program Files\Gage\CompuScope\CompuScope MATLAB SDK\CsMl';
addpath('C:\Users\Fiberlaser\OneDrive - University of New Brunswick\Matlab_SDK2\mcp2210_dll_v2.1.0\unmanaged\dll')
fh = figure('Visible','off','MenuBar','none','NumberTitle','off');

% put an axes in it
ah = axes('Parent',fh,'Visible','off');

% put the image in it
load splashimage.mat
ih = image(h);
colormap('default')

% set the figure size to be just big enough for the image, and centered at
% the center of the screen
imxpos = get(ih,'XData');
imypos = get(ih,'YData');
set(ah,'Unit','Normalized','Position',[0,0,1,1]);
figpos = get(fh,'Position');
figpos(3:4) = [imxpos(2) imypos(2)];
set(fh,'Position',figpos);
movegui(fh,'center')

% make the figure visible
set(fh,'Visible','on');

% ht = timer('StartDelay',5,'ExecutionMode','SingleShot');
% set(ht,'TimerFcn','close(fh);stop(ht);delete(ht)');
% start(ht);
%pause(1);% compile the Mex Files here 
% close(fh);
%Splash image end
%*******************************





%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Laser_Initialization(varargin)





close(fh);
% Choose default command line output for newcodegui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes newcodegui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = newcodegui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in opendatafile.
function opendatafile_Callback(hObject, eventdata, handles)
% hObject    handle to opendatafile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plotwindow;

% --- Executes on button press in oscmode.
function oscmode_Callback(hObject, eventdata, handles)
% hObject    handle to oscmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
oscwindow;

% --- Executes on button press in measurement.
function measurement_Callback(hObject, eventdata, handles)
% hObject    handle to measurement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
measurementwindow;

% --- Executes on button press in help.
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open('C:\Matlab_SDK\CsMl\BOTDAUserGuide.pdf');

% --- Executes on button press in about.
function about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
aboutwindow

% --- Executes on button press in convert.
function convert_Callback(hObject, eventdata, handles)
% hObject    handle to convert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,FilePath]=uigetfile();
load([FilePath FileName]);
complete = strcat(FilePath,FileName);


datafile='fiberbox10try1.bin';

invert=1;

[fid, message]=fopen('OldSystemDataFile','w');

if(fid==-1) % error
        error(message);
        return
end


SFinalAVG= -1*(FinalAVG(:,(21:end)));
fsize=size(SFinalAVG);
[intercept slope correction]= calculateBaseline(256,(fsize(2)-100),SFinalAVG);
%% Write header
acquisition_count=1;
acquisition_period=-1;%************
start_freq=10.87e3;%****************
stop_freq=11.1e3;%*******************
step_freq=2;%**********************
line_count=fsize(1,1);%***********************
reserved1=1;
fibre_start_time=1;
run_start_time=-100;
points=fsize(1,2);%*******************************
averages=1000;
sample_period=1e-9;
vga_gain=0;
reserved3=0;
reserved4=0;
signal_conversion=0;
reserved5=0;
baseline_order=1;
reserved6=1;
run_notes=zeros(1,1016);
version=2.2;
start_time=0;
stop_time=0;

for beg= 1:1:line_count;
    freq1(1,beg)=(start_freq+(beg*step_freq)-step_freq);
end
fwrite(fid,acquisition_count,'int');        % number of acquisitions in this file
fwrite(fid,acquisition_period,'int');       %  period in minutes, 0 for continuous, -1 for single shot
fwrite(fid,start_freq,'double');
fwrite(fid,stop_freq,'double');
fwrite(fid,step_freq,'double');
fwrite(fid,line_count,'*int');
fwrite(fid,reserved1,'*int');
fwrite(fid,fibre_start_time,'double');
fwrite(fid,run_start_time,'uint64');
fwrite(fid,points,'int');
fwrite(fid,averages,'int');
fwrite(fid,sample_period,'double');
fwrite(fid,vga_gain,'int');
fwrite(fid,reserved3,'int');
fwrite(fid,reserved4,'double');
fwrite(fid,signal_conversion,'double');
fwrite(fid,reserved5,'int');
fwrite(fid,baseline_order,'int');
fwrite(fid,reserved6,'int');
fwrite(fid,run_notes,'*char');
fwrite(fid,2,'int16');
fwrite(fid,2,'int16');

 coefficients = [intercept slope zeros(line_count,4)];
 baseline_coeff(1,:,:) = coefficients;
     
     % data will be stored as row (i)=acq#, col (j)=freq#, page=data points
     for l=1:acquisition_count;
         for j=1:line_count;
             fwrite(fid, freq1(l,j)/1e6, 'double');                                      %freq(l,j)=fread(fp,1,'double');
             fwrite(fid, (baseline_coeff(l,j,:)+2147483648),'double');                         %baseline_coeff(l,j,:)=fread(fp,6,'double');
% 
             fwrite(fid,reserved3,'double');                                %pulse_width(l,j)=fread(fp,1,'double');
             fwrite(fid,reserved3,'double');                                %pulse_power(l,j)=fread(fp,1,'double');
             fwrite(fid,reserved3,'double');                                   %cw_power(l,j)=fread(fp,1,'double');
             fwrite(fid, SFinalAVG(j,:),'double');                                   %trace(l,j,:)=fread(fp,cast(points,'double'),'*int16');
         end
         fwrite(fid,start_time(l),'uint64');                                      %start_time(l)=fread(fp,1,'uint64'); % was 'long'
         fwrite(fid,stop_time(l),'uint64');                                        %stop_time(l)=fread(fp,1,'uint64'); % was 'long'
% 
     end
fclose(fid);


% --- Executes on button press in curvefit.
function curvefit_Callback(hObject, eventdata, handles)
% hObject    handle to curvefit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,FilePath]=uigetfile();
load([FilePath FileName]);
complete = strcat(FilePath,FileName);
SFinalAVG=FinalAVG(:,(21:end));
jsize=size(SFinalAVG);
%*******************************************************************
x1=1:jsize(1);
xx=1:.1:jsize(1);
xsize=size(xx);
SFinalAVG1=zeros(xsize(2),jsize(2));
for r=1:jsize(2);
    SFinalAVG1(:,r)=spline(x1,SFinalAVG(:,r),xx);
end

jsize=size(SFinalAVG1);
%**********************************************************************





yfit=zeros((2*jsize(1))-1,jsize(2));
StartFreq=FinalAVG(1,2);
EndFreq=FinalAVG(1,5);
StepSize=FinalAVG(1,3);
f=StartFreq:StepSize:EndFreq;

fb=11e9;


delf=35e6; % The gain profile has a 35 MHz width
size_f = length(f);

avg=0;
for j=1:jsize(2)
    j
    avg=0;
    for x=10:30
        avg=avg+SFinalAVG1(x,j);
    end
    avg=avg/20;
 
    
        SFinalAVG1(:,j)=SFinalAVG1(:,j)+abs(avg);
   
end

amp=max(abs(SFinalAVG1));

amp=max(amp);
bg=amp*(1+4*((f-fb)./delf).^2).^-1; % Calculate the Brillouin gain over the frequency range
% %****************************************
% amp=max(SFinalAVG);
% amp=max(amp);
% bg=amp*(1+4*((f-fb)./delf).^2).^-1; % Calculate the Brillouin gain over the frequency range
% %********************************************************************************************
for i=1:jsize(2)
    yfit(:,i)=(xcorr(bg,SFinalAVG1(:,i)))';
end
[fx fy]=max(yfit);
figure();
plot(fy);

BrillouinPeaks=sprintf('BrillouinPeaks');
%save(myfinaldata, 'FinalAVG');
save(['C:\CurveFitDATA\' BrillouinPeaks '.mat'], 'fy');


myfinaldata=sprintf('CurveFitData');
%save(myfinaldata, 'FinalAVG');
save(['C:\CurveFitDATA\' myfinaldata '.mat'], 'yfit');
h = msgbox('Curve fit using correlation method is applied, with Brillouin linewidth=35MHz, fb=11GHz, filename is curvefitdata' );


% --- Executes on button press in ContinuousMeasurements.
function ContinuousMeasurements_Callback(hObject, eventdata, handles)
% hObject    handle to ContinuousMeasurements (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ContinuousMeasurementsWindow;
