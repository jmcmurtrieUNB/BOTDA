% GageMultipleSystems sample program
% This program demonstrates how to use multiple systems from within 1
% program. Each system is identified by a system handle, which uniquely
% identifies the system to the driver. Note that in this sample program
% we're handling error conditions ourselves to be sure that both system
% handles are freed if an error occurs.

clear;
systems = CsMl_Initialize;
CsMl_ErrorHandler(systems);

for i = 1:systems
    [ret, handle(i)] = CsMl_GetSystem;
    CsMl_ErrorHandler(ret);
    % If the error happens on the second system, free the first one and
    % exit
    if ret < 0
        if (i == 2)
            CsMl_FreeSystem(handle(i));
            return;
        end;
    end;    
end;    

for i = 1:systems
    [ret, sysinfo(i)] = CsMl_GetSystemInfo(handle(i));
    CsMl_ErrorHandler(ret);        
    s = sprintf('-----Board name: %s\n', sysinfo(i).BoardName);
    disp(s);
end;    


% Use the defaults for each system
for i = 1:systems
    [ret] = CsMl_Commit(handle(i));
    errstring = CsMl_ErrorHandler(ret, 0);
    if ret < 0
       CsMl_FreeSystem(handle(1));
       CsMl_FreeSystem(handle(2));
       error(errstring);
    end;
end;    

for i = 1:systems
    ret = CsMl_Capture(handle(i));
    errstring = CsMl_ErrorHandler(ret, 0);
    if ret < 0
       CsMl_FreeSystem(handle(1));
       CsMl_FreeSystem(handle(2));
       error(errstring);
    end;    
end;

for i = 1:systems
    status = CsMl_QueryStatus(handle(i));
    while status ~= 0
        status = CsMl_QueryStatus(handle(i));
    end;
end;    

for system = 1:systems
    transfer.Mode = CsMl_Translate('Default', 'TxMode');
    transfer.Segment = 1;
    [ret, acqInfo] = CsMl_QueryAcquisition(handle(system));
    transfer.Start = -acqInfo.TriggerHoldoff;
    transfer.Length = acqInfo.SegmentSize;
    
    % Regardless  of the Acquisition mode, numbers are assigned to channels in a 
    % CompuScope system as if they all are in use. 
    % For example an 8 channel system channels are numbered 1, 2, 3, 4, .. 8. 
    % All modes make use of channel 1. The rest of the channels indices are evenly
    % spaced throughout the CompuScope system. To calculate the index increment,
    % user must determine the number of channels on one CompuScope board and then
    % divide this number by the number of channels currently in use on one board.
    % The latter number is lower 12 bits of acquisition mode.

    MaskedMode = bitand(acqInfo.Mode, 15);
    ChannelsPerBoard = sysinfo(system).ChannelCount / sysinfo(system).BoardCount;
    ChannelSkip = ChannelsPerBoard / MaskedMode;
    xaxis = MaskedMode;
    yaxis = sysinfo(system).BoardCount;

    % If we have more than 4 channels in the x-axis, let's increase
    % the number of rows so it looks better.

    if xaxis > 4
        xaxis = xaxis / 2;
        yaxis = yaxis * 2;
    end;
    
    ImageNumber = 1;
    for i = 1:ChannelSkip:sysinfo(system).ChannelCount
        transfer.Channel = i;
        % Transfer the data
        [ret, data, actual] = CsMl_Transfer(handle(system), transfer);
        CsMl_ErrorHandler(ret, 0);
        if ret < 0
           CsMl_FreeSystem(handle(1));
           CsMl_FreeSystem(handle(2));
           error(errstring);            
        end;
        % Save each channel to a seperate file
        filename = sprintf('MultipleSystems_%d_CH%d.dat', system, i);
        
        % Adjust the size so only the actual length of data is saved to the
        % file
        length = size(data, 2);
        if length > actual.ActualLength
            data(actual.ActualLength:end) = [];
            length = size(data, 2);
        end;                
        % Get the information to write the ASCII header file
        [ret, chanInfo] = CsMl_QueryChannel(handle(system), i);        
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
        % The points array is used to adjust the horizontal axix in case we have
        % pretrigger data
        xpos = actual.ActualStart;
        xpos_end = length + xpos - 1;
        points = (xpos:xpos_end)';
        points = transpose(points);
        figure(system);
        set(gcf, 'Name', sysinfo(system).BoardName);
        subplot(yaxis, xaxis, ImageNumber); 
        plot(points, data);
        str = sprintf(' Channel %d', i);
        title(str);    
        ImageNumber = ImageNumber + 1;
    end;
end;    

for i = 1:systems
    ret = CsMl_FreeSystem(handle(i));
end;    