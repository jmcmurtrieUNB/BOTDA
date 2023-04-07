


% CW Laser Parameters
CW.Name='COM8';
CW.Frequency=195.62114;
CW.Power=13;
CW.Enabled=0;

% Pulse Laser Parameters
Pulse.Name='COM3';
Pulse.Frequency=195.6103;
Pulse.Power=13;
Pulse.Enabled=0;

% 0=dither 1=no dither 2=whisper
CW.Mode=2;
Pulse.Mode=2;

%% Tx CW Laser Parameter and Enable Laser
ret=LaserPower(CW.Power,CW.Name); % Set the CW laser power level
if isempty(ret)
    ret=LaserSetFrequency(CW.Frequency,CW.Name); % Sets the CW laser operating frequency
    if isempty(ret)
        ret=LaserEnable(CW.Name); % Turn the laser on
        if isempty(ret)
            time=tic;
            CW.Enabled=1;
        end
    end
end

%% Tx Pulse Laser Parameter and Enable Laser
ret=LaserPower(Pulse.Power,Pulse.Name); % Set the pulse laser power level
if isempty(ret)
    ret=LaserSetFrequency(Pulse.Frequency,Pulse.Name); % Sets the pulse laser operating frequency
    if isempty(ret)
        ret=LaserEnable(Pulse.Name); % Turn the laser on
        if isempty(ret)
            time=tic;
            Pulse.Enabled=1;
        end
    end
end

%% Change the Operating Mode of the Lasers

% ret=LaserMode(CW.Name,CW.Mode,0);

% if ret<0
%     msgbox(['Error! CW laser did not return desired response while reading the laser mode. Error code ' num2str(ret)],'Error','error')
% elseif ret~=CW.Mode
%     ret=LaserMode(Pulse.Name,Pulse.Mode,0)
%     if ret<0
%         msgbox(['Error! Pulse laser did not return desired response while reading the laser mode. Error code ' num2str(ret)],'Error','error')
%     elseif  ret~=Pulse.Mode
%         if CW.Enabled==1 && Pulse.Enabled==1
%             t=toc(time);
%             if t<60
%                 H=waitbar(t/60,'Changing Mode. Please Wait...');
%                 while t<60
%                     H=waitbar(t/60,H);
%                     pause(0.25)
%                     t=toc(time);
%                 end
%                 close(H);
%             end
%             ret=LaserMode(CW.Name,CW.Mode,1);
%             ret=LaserMode(Pulse.Name,Pulse.Mode,1);
%         else
%             warndlg('Must Enable both lasers before the mode can be changed.','Warning')
%         end
%     end
% end

if CW.Enabled==1 && Pulse.Enabled==1
    t=toc(time);
    if t<60
        H=waitbar(t/60,'Changing Mode. Please Wait...');
        while t<60
            H=waitbar(t/60,H);
            pause(0.25)
            t=toc(time);
        end
        close(H);
    end
    UNB_BOTDA_Lock(4);
    pause(5)
    ret=LaserMode(CW.Name,CW.Mode);
    ret=LaserMode(Pulse.Name,Pulse.Mode);
else
    warndlg('Must Enable both lasers before the mode can be changed.','Warning')
end

pause(0.1)

