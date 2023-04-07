% GageMultipleRecord.m sample progam
% This sample program demonstrates how to do a multiple record capture. The
% system's acquistion, channel and trigger parameters are set. The data is
% captured and retrieved and the data for each channel and multiple segment
% is saved to a separate file.

clear;
systems = CsMl_Initialize;
CsMl_ErrorHandler(systems);
[ret, handle] = CsMl_GetSystem;
CsMl_ErrorHandler(ret);

[ret, sysinfo] = CsMl_GetSystemInfo(handle);

s = sprintf('-----Board name: %s\n', sysinfo.BoardName);
disp(s);

Setup(handle);

CsMl_ResetTimeStamp(handle);

ret = CsMl_Commit(handle);
CsMl_ErrorHandler(ret, 1, handle);

[ret, acqInfo] = CsMl_QueryAcquisition(handle);

ret = CsMl_Capture(handle);
CsMl_ErrorHandler(ret, 1, handle);

status = CsMl_QueryStatus(handle);
while status ~= 0
   status = CsMl_QueryStatus(handle);
end
% Get timestamp information
transfer.Channel = 1;
transfer.Mode = CsMl_Translate('TimeStamp', 'TxMode');
transfer.Length = acqInfo.SegmentCount;
transfer.Segment = 1;
[ret, tsdata, tickfr] = CsMl_Transfer(handle, transfer);

transfer.Mode = CsMl_Translate('Default', 'TxMode');
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
ChannelsPerBoard = sysinfo.ChannelCount / sysinfo.BoardCount;
ChannelSkip = ChannelsPerBoard / MaskedMode;

% Format a string with the number of segments and channels so all filenames
% have the same number of characters.
format_string = sprintf('%d', acqInfo.SegmentCount);
MaxSegmentNumber = length(format_string);
format_string = sprintf('%d', sysinfo.ChannelCount);
MaxChannelNumber = length(format_string);
format_string = sprintf('%%s_CH%%0%dd-%%0%dd.dat', MaxChannelNumber, MaxSegmentNumber);

for channel = 1:ChannelSkip:sysinfo.ChannelCount
    transfer.Channel = channel;
    for i = 1:acqInfo.SegmentCount
        transfer.Segment = i;
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
        [ret, chanInfo] = CsMl_QueryChannel(handle, channel);            
        CsMl_ErrorHandler(ret, 1, handle);
        % Get information for ASCII file header
        info.Start = actual.ActualStart;
        info.Length = actual.ActualLength;
        info.SampleSize = acqInfo.SampleSize;
        info.SampleRes = acqInfo.SampleResolution;
        info.SampleOffset = acqInfo.SampleOffset;
        info.InputRange = chanInfo.InputRange;
        info.DcOffset = chanInfo.DcOffset;
        info.SegmentCount = acqInfo.SegmentCount;
        info.SegmentNumber = i;
        info.TimeStamp = tsdata(i);

        filename = sprintf(format_string, 'MulRec', transfer.Channel, i);
        CsMl_SaveFile(filename, data, info);
    end;
end;    

ret = CsMl_FreeSystem(handle);
