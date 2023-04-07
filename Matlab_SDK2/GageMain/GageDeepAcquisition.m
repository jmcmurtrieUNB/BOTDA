% GageAcquire sample program
% This sample program demonstrates how to transfer a large amount of data
% by transferring a smaller chunk of data at a time to a file. Once all the
% files have been saved, they can be joined together. 
% To use this program, set the Acquisition.Depth and
% Acquisition.SegmentSize to values larger then the chunk size.

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

[ret, acqInfo] = CsMl_QueryAcquisition(handle);

ret = CsMl_Capture(handle);
CsMl_ErrorHandler(ret, 1, handle);

status = CsMl_QueryStatus(handle);
while status ~= 0
    status = CsMl_QueryStatus(handle);
end

transfer.Mode = CsMl_Translate('Default', 'TxMode');
transfer.Segment = 1;

chunk_size = 32768;

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
max_chunk = ceil(acqInfo.SegmentSize / chunk_size);
format_string = sprintf('%d', max_chunk);
MaxChunkNumber = length(format_string);
format_string = sprintf('%d', sysinfo.ChannelCount);
MaxChannelNumber = length(format_string);
format_string = sprintf('%%s_CH%%0%dd-%%0%dd.dat', MaxChannelNumber, MaxChunkNumber);

for i = 1:ChannelSkip:sysinfo.ChannelCount
    transfer.Start = -acqInfo.TriggerHoldoff;
    transfer.Channel = i;
    total_points = acqInfo.SegmentSize;
    chunk_number = 1;

    while (total_points > 0)
        if (total_points > chunk_size)
            transfer.Length = chunk_size;
        else
            transfer.Length = total_points;
        end;
%		Check if our start address is valid. acqInfo.Depth is
%		the last valid post-trigger sample, so the start address
%		cannot be beyond that.            
        if transfer.Start >= acqInfo.Depth
            break;
        end;
            
        % Transfer the data a chunk at a time and save each chunk to a
        % separate file
        [ret, data, actual] = CsMl_Transfer(handle, transfer);
        CsMl_ErrorHandler(ret, 1, handle);
  
        % Adjust the size so only the actual length of data is saved to the
        % file
        length = size(data, 2);
        if length > actual.ActualLength
            data(actual.ActualLength:end) = [];
            length = size(data, 2);
        end;        
    
        % Get channel info for file header    
        [ret, chanInfo] = CsMl_QueryChannel(handle, i);        
        filename = sprintf(format_string, 'DeepAcquisition', i, chunk_number);        
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
        chunk_number = chunk_number + 1;
        transfer.Start = transfer.Start + chunk_size;
        total_points = total_points - chunk_size;
    end;
end;

ret = CsMl_FreeSystem(handle);