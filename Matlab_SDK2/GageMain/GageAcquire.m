% GageAcquire sample program
% This program demonstrates how to configure a system's capture, channel
% and trigger parameters, do a capture and retrieve the captured data. The
% data is saved to a seperate file for each channel and also displayed.

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

[ret] = CsMl_Commit(handle);
CsMl_ErrorHandler(ret, 1, handle);

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
end

% Regardless  of the Acquisition mode, numbers are assigned to channels in a 
% CompuScope system as if they all are in use. 
% For example an 8 channel system channels are numbered 1, 2, 3, 4, .. 8. 
% All modes make use of channel 1. The rest of the channels indices are evenly
% spaced throughout the CompuScope system. To calculate the index increment,
% user must determine the number of channels on one CompuScope board and	then
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
    % Save each channel to a seperate file
    filename = sprintf('Acquire_CH%d.dat', i);
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
    % The points array is used to adjust the horizontal axix in case we have
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