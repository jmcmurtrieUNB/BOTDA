auto=true;
t=tic;
d = dialog('Position',[500 500 250 150],'Name','Auto Setup');
    txt = uicontrol('Parent',d,...
           'Style','text',...
           'Position',[20 100 210 40],...
           'String','Automatic setup and continuous measurements will begin in 1 minute. Click "Cancel" to exit automatic mode.');
    btn = uicontrol('Parent',d,...
           'Position',[140 20 70 25],...
           'String','Cancel',...
           'Callback','delete(gcf);d=[];auto=false;');
    btn2 = uicontrol('Parent',d,...
            'Position',[40 20 70 25],...
            'String','Continue',...
            'Callback','delete(gcf);d=[];');
time=toc(t) ;
while time<60
    if isempty(d)
        break;
    end
    txt2 = uicontrol('Parent',d,...
    'Style','text',...
    'Position',[20 50 210 40],...
    'String',[num2str(60-round(toc(t))) 's']);
    time=toc(t);
    pause(0.1)
end
addpath('C:\Users\e5862\Desktop\Matlab_SDK\CsMl');
if ~isempty(d) 
    delete(d)
end
clear d
clear txt
clear btn
clear btn2
    
if auto
    H=msgbox('Auto Mode');
    pause(1)
    close(H)
    clear H
    
    %lasers Enable
    
    % Set freq
    
    ContinuousMeasurementsWindow2;

elseif ~auto
    H=msgbox('Manual Mode');
    pause(1)
    close(H)
    clear H
    newcodegui;
end