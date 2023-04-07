% GageCoerce sample program

% This program demonstrates how to configure a system's capture, channel
% and trigger parameters, do a capture and retrieve the captured data. The
% data is saved to a seperate file for each channel and also displayed. In
% this program, the Coerce flag is set so if an incorrect parameters is
% given the driver will coerce the value to a correct one.

clear;
systems = CsMl_Initialize;
CsMl_ErrorHandler(systems);

[ret, handle] = CsMl_GetSystem;
CsMl_ErrorHandler(ret);

[ret, sysinfo] = CsMl_GetSystemInfo(handle);
CsMl_ErrorHandler(ret);

s = sprintf('-----Board name: %s\n', sysinfo.BoardName);
disp(s);

Setup(handle);

flags.Coerce = 1;
flags.OnChange = 1;
[ret] = CsMl_Commit(handle, flags);
CsMl_ErrorHandler(ret, 1, handle);

% If the return value is greater than 1 something has been coerced. If
% this is the case we print out all the acquisition, channel and trigger
% parameters.
if ret > 1
    disp('One or more capture parameters was invalid and has been coerced.');
    [ret, acqstruct] = CsMl_QueryAcquisition(handle);
    if ret < 1
        disp('Could not get acquisition information');
    else
        disp(' ');
        disp('Current acquisition parameters...');
        disp(' ');
        
        str = sprintf('Sample Rate: %d Hz', acqstruct.SampleRate);
        disp(str);

        if acqstruct.ExtClock == 1
            s = 'On';
        else
            s = 'Off';
        end;
        str = sprintf('External Clock: %s', s);
        disp(str);        

        MaskedMode = bitand(acqstruct.Mode, 15);
        if MaskedMode == 8
            s = 'Octal';
        elseif MaskedMode == 4
            s = 'Quad';
        elseif MaskedMode == 2
            s = 'Dual';
        elseif MaskedMode == 1
            s = 'Single';
        else
            s = sprintf('%d', MaskedMode);
        end;
        str = sprintf('Mode: %s', s);
        disp(str);        

        str = sprintf('Segment Count: %d', acqstruct.SegmentCount);
        disp(str);        

        str = sprintf('Depth: %d', acqstruct.Depth);
        disp(str);        

        str = sprintf('Segment Size: %d', acqstruct.SegmentSize);
        disp(str);        

        str = sprintf('Trigger Timeout: %d microseconds', acqstruct.TriggerTimeout);
        disp(str);        

        str = sprintf('Trigger Delay: %d samples', acqstruct.TriggerDelay);
        disp(str);     

        str = sprintf('Trigger Holdoff: %d samples', acqstruct.TriggerHoldoff);
        disp(str);        
    end;

    MaskedMode = bitand(acqstruct.Mode, 15);
    ChannelsPerBoard = sysinfo.ChannelCount / sysinfo.BoardCount;
    ChannelSkip = ChannelsPerBoard / MaskedMode;    
    
    for i = 1:ChannelSkip:sysinfo.ChannelCount
        [ret, chanstruct(i)] = CsMl_QueryChannel(handle, i);
        if ret < 1
            str = sprintf('Could not get channel info for Channel %d', i);
            disp(str);
            disp(' ');
            continue;
        end;
        str = sprintf('Current channel %d parameters ...', i);
        disp(' ');
        disp(str);
        disp(' ');
        
        if chanstruct(i).Coupling == 2
            s = 'AC';
        elseif chanstruct(i).Coupling == 1
            s = 'DC';
        else
            s = sprintf('%d', chanstruct(i).Coupling);
        end;
        str = sprintf('Coupling: %s', s);
        disp(str);                    

        if chanstruct(i).DiffInput == 1
            s = 'On';
        else
            s = 'Off';
        end;
        str = sprintf('Differential Input: %s', s);
        disp(str);                                

        str = sprintf('Input Range: %d mV', chanstruct(i).InputRange);
        disp(str);                                

        str = sprintf('Impedance: %d Ohms', chanstruct(i).Impedance);
        disp(str);                                

        str = sprintf('DC Offset: %d mV', chanstruct(i).DcOffset);
        disp(str);                                

        if chanstruct(i).DirectAdc == 1
            s = 'On';
        else
            s = 'Off';
        end;
        str = sprintf('Direct ADC: %s', s);
        disp(str);                                
    end;

    [ret, trigstruct] = CsMl_QueryTrigger(handle, 1);
    if ret < 1
        disp('Could not get trigger info for trigger');
    else
        disp(' ');
        disp('Current trigger parameters ...');
        disp(' ');
        
        if trigstruct.Slope == 0
            s = 'Falling';
        elseif trigstruct.Slope == 1
            s = 'Rising';
        else
            s = sprintf('%d', trigstruct.Slope);
        end;
        str = sprintf('Slope: %s', s);
        disp(str);

        str = sprintf('Level: %d%%', trigstruct.Level);
        disp(str);

        if trigstruct.Source == -1
            s = 'External';
        elseif trigstruct.Source == 0
            s = 'Disabled';
        else
            s = sprintf('Channel %d', trigstruct.Source);
        end;
        str = sprintf('Source: %s', s);
        disp(str);

        if trigstruct.ExtCoupling == 2
            s = 'AC';
        elseif trigstruct.ExtCoupling == 1
            s = 'DC';
        else
            s = sprintf('%s', s);
        end;
        str = sprintf('External Coupling: %d', trigstruct.ExtCoupling);
        disp(str);
  
        str = sprintf('External Range: %d mV', trigstruct.ExtRange);
        disp(str);
    end;
end;    

transfer.Mode = CsMl_Translate('Default', 'TxMode');
transfer.Segment = 1;
[ret, acqInfo] = CsMl_QueryAcquisition(handle);
transfer.Start = -acqInfo.TriggerHoldoff;
transfer.Length = acqInfo.SegmentSize;    

ret = CsMl_Capture(handle);
CsMl_ErrorHandler(ret, 1, handle);

status = CsMl_QueryStatus(handle);
while status ~= 0
    status = CsMl_QueryStatus(handle);
end;

% Regardless  of the Acquisition mode, numbers are assigned to channels in a 
% CompuScope system as if they all are in use. 
% For example an 8 channel system channels are numbered 1, 2, 3, 4, .. 8. 
% All modes make use of channel 1. The rest of the channels indices are evenly
% spaced throughout the CompuScope system. To calculate the index increment,
% user must determine the number of channels on one CompuScope board and then
% divide this number by the number of channels currently in use on one board.
% The latter number is lower 12 bits of acquisition mode.

MaskedMode = bitand(acqInfo.Mode, 15);
ChannelsPerBoard = sysinfo.ChannelCount / sysinfo.BoardCount;
ChannelSkip = ChannelsPerBoard / MaskedMode;
xaxis = MaskedMode;
yaxis = sysinfo.BoardCount;

% If we have more than 4 channels in the x-axis, let's increase
% the number of rows so it looks better.

if xaxis > 4
    xaxis = xaxis / 2;
    yaxis = yaxis * 2;
end;

ImageNumber = 1;
for i = 1:ChannelSkip:sysinfo.ChannelCount
    transfer.Channel = i;
    % Transfer the data
    [ret, data, actual] = CsMl_Transfer(handle, transfer);
    CsMl_ErrorHandler(ret, 1, handle);
    
	% Note: to optimize the transfer loop, everything from
	% this point on in the loop could be moved out and done
	% after all the channels are transferred.
    
    % Adjust the size so only the actual length of data is saved to the
    % file
    length = size(data, 2);
    if length > actual.ActualLength
        data(actual.ActualLength:end) = [];
        length = size(data, 2);
    end;        
    
    % Get channel info for file header    
    [ret, chanInfo] = CsMl_QueryChannel(handle, i);    
    % Save the data to a file, one for each channel
    filename = sprintf('Coerce_CH%d.dat', i);
    % Get information for ASCII file header
    info.Start = actual.ActualStart;
    info.Length = actual.ActualLength;
    info.SampleSize = acqInfo.SampleSize;
    info.SampleRes = acqInfo.SampleResolution;
    info.SampleOffset = acqInfo.SampleOffset;   
    info.InputRange = chanInfo.InputRange;
    info.DcOffset = chanInfo.DcOffset;
    info.SegmentCount = acqInfo.SegmentCount;
    info.SegmentNumber = transfer.Segment;    

    CsMl_SaveFile(filename, data, info);
    % Adjust the horizontal axis and plot the data
    length = size(data, 2);
    % The points array is used to adjust the horizontal axis in case we have
    % pretrigger data
    xpos = actual.ActualStart;
    xpos_end = length + xpos - 1;
    points = (xpos:xpos_end)';
    points = transpose(points);
    subplot(yaxis, xaxis, ImageNumber); 
    plot(points, data);
    str = sprintf('Channel %d', i);
    title(str);    
    ImageNumber = ImageNumber + 1;
end;

ret = CsMl_FreeSystem(handle);