% GageAdvMulRecEx.m sample progam
% This sample program demonstrates how to do a multiple record capture and 
% then transfer all channels and segments at the same time with CsMl_TransferEx.
% The data is captured and retrieved and the data for each channel and multiple 
% record segment is saved to a separate file.

clear;
systems = CsMl_Initialize;
CsMl_ErrorHandler(systems);
[ret, handle] = CsMl_GetSystem;
CsMl_ErrorHandler(ret);

[ret, sysinfo] = CsMl_GetSystemInfo(handle);

s = sprintf('-----Board name: %s\n', sysinfo.BoardName);
disp(s);

% This next part determines if CsTransferEx and mulitiple segment transfers 
% are  available

transfer_ex = CsMl_Translate('transferex', 'Caps');
if 0 == transfer_ex
    disp('The current system does not support CsTransferEx() and multiple segment transfer');
    CsMl_FreeSystem(handle);
end;

% Set the number of multiple record captures.  This is done by setting the
% SegmentCount in acqInfo. The default is 1 (no multiple record). We're
% using the defaults for everything else.
acqInfo.SegmentCount = 5;
acqInfo.Depth = 1024;
acqInfo.SegmentSize = 1024;

% This mode of time stamp transfer must used the fixed onboard oscillator
time_stamp_clock = CsMl_Translate('FixedClock', 'TimeStamp');
acqInfo.TimeStampConfig = time_stamp_clock;

ret = CsMl_ConfigureAcquisition(handle, acqInfo);
CsMl_ErrorHandler(ret);

% Reset the time stamp counter so we start at 0
CsMl_ResetTimeStamp(handle);

% CsMl_Commit sends our acquisition, channel and trigger parameters to the
% driver and hardware.
ret = CsMl_Commit(handle);

CsMl_ErrorHandler(ret, 1, handle);

% We'll query the driver for the acquisition parameters in case we need
% them later on
[ret, acqInfo] = CsMl_QueryAcquisition(handle);

ret = CsMl_Capture(handle);
CsMl_ErrorHandler(ret, 1, handle);

% wait for the capture to finish
status = CsMl_QueryStatus(handle);
while status ~= 0
   status = CsMl_QueryStatus(handle);
end

transfer.Start = -acqInfo.TriggerHoldoff;
transfer.Length = acqInfo.SegmentSize;    
transfer.StartSegment = 1;
transfer.SegmentCount = acqInfo.SegmentCount;
transfer.Channel = 0; % 0 means get all the channels

[ret, data, out] = CsMl_TransferEx(handle, transfer);
% data is a 1 x buffer length matrix (where buffer length is # of channels
% * # of segments * data length) of raw data.

dataInfo.DataFormat = out.DataFormat;
dataInfo.ChannelCount = out.ChannelCount;
dataInfo.Length = transfer.Length;
dataInfo.SegmentCount = transfer.SegmentCount;
[ret, new_data] = CsMl_ExtractEx(handle, data, dataInfo);

% pTimeStampData will be a 1 x SegmentCount matrix of doubles where each
% value is the time stamp in microseconds
[ret, pTimeStampData] = CsMl_TransferTimeStampEx(handle, transfer.StartSegment, transfer.SegmentCount);

% Format a string with the number of segments and channels so all filenames
% have the same number of characters.
format_string = sprintf('%d', acqInfo.SegmentCount);
MaxSegmentNumber = length(format_string);
format_string = sprintf('%d', sysinfo.ChannelCount);
MaxChannelNumber = length(format_string);
format_string = sprintf('%%s_CH%%0%dd-%%0%dd.dat', MaxChannelNumber, MaxSegmentNumber);

% if dataInfo.ChannelCount is > 1 we retrieved all the channels. Otherwise
% we on retrieved 1. We need the channel skip because, regardless  of the 
% Acquisition mode, numbers are assigned to channels in a CompuScope system 
% as if they all are in use. For example an 8 channel system channels are 
% numbered 1, 2, 3, 4, .. 8. All modes make use of channel 1. The rest of 
% the channels indices are evenly spaced throughout the CompuScope system. 
% To calculate the index increment, user must determine the number of channels 
% on one CompuScope board and then divide this number by the number of channels 
% currently in use on one board.

if dataInfo.ChannelCount > 1
    MaskedMode = bitand(acqInfo.Mode, 15);
    ChannelsPerBoard = sysinfo.ChannelCount / sysinfo.BoardCount;
    ChannelSkip = ChannelsPerBoard / MaskedMode;
    StartChannelName = 1;
else
    ChannelSkip = 1;
    if transfer.Channel == 0
        StartChannelName = 1;  % case where there's only 1 channel but we said transfer all
    else
        StartChannelName = transfer.Channel;
    end;
end;

for channel = 1:out.ChannelCount
    % Get channel info for file header  
    % This can also be moved outside the loop to optimize
    [ret, chanInfo] = CsMl_QueryChannel(handle, channel);            
    CsMl_ErrorHandler(ret, 1, handle);

    channel_data = new_data(:,:,channel);
    for i = 1:acqInfo.SegmentCount
        segment_data = channel_data(:,i);
    
    	% Note: to optimize the transfer loop, everything from
    	% this point on in the loop could be moved out and done
    	% after all the channels are transferred.
    
        % Get information for ASCII file header
        info.Start = transfer.Start;
        info.Length = transfer.Length;
        info.SampleSize = acqInfo.SampleSize;
        info.SampleRes = acqInfo.SampleResolution;
        info.SampleOffset = acqInfo.SampleOffset;
        info.InputRange = chanInfo.InputRange;
        info.DcOffset = chanInfo.DcOffset;
        info.SegmentCount = acqInfo.SegmentCount;
        info.SegmentNumber = i;
        info.TimeStamp = pTimeStampData(i);

        filename = sprintf(format_string, 'AdvMulRecEx', StartChannelName, i);
        % Note: if you want to save the file as raw data, you should set
        % rawdata to 1 in BOTH CsMl_ExtractEx and CsMl_SaveFile
        CsMl_SaveFile(filename, segment_data, info);
    end;
    StartChannelName = StartChannelName + ChannelSkip;
end;    

ret = CsMl_FreeSystem(handle);
