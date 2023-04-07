function [retval, data] = CsMl_Extract(handle, buffer, dataInfo, rawdata)
% [retval, data] = CsMl_ExtractEx(handle, buffer, dataInfo, format)
%
% CsMl_ExtractEx takes the interleaved buffer obtained from CsMl_TransferEx 
% and converts it into a 3 dimensional array of data * segments * channels.
% The buffer is a 1-dimensional array containing raw data for all segments
% for 1 or all channels of a CompuScope system uniquely identified by handle 
% (the CompuScope system handle).  The handle must previously have been 
% obtained by a call to CsMl_GetSystem.  
% 
% The buffer variable is a 1-dimensional array containing raw data for all
% segments for 1 or all channels of the CompuScope system. The optional 
% rawdata parameter may be used to set whether the data are converted into 
% voltages or are returned as raw integer values that correspond to raw ADC 
% code values.  If the rawdata parameter is not present or is 0, the values 
% will be converted to voltages based on the channel's input range.  If the 
% rawdata parameters is 1, the data is returned as raw values.  The type of 
% raw value is dependent on the CompuScope board. 
% 
% If the call succeeds, retval will be positive. If the call fails, retval 
% will be a negative number which represents an error code.  A more descriptive 
% error string may be obtained by calling CsMl_GetErrorString. 
% 
% The dataInfo variable is a structure containing information about the
% data to be converted. All fields must be filled in with valid values. The
% available fields are:
% DataFormat   - the format of the interleaved data.
% ChannelCount - the number of channels in buffer.
% SegmentCount - the number of segments in buffer.
% Length       - the number of samples in each segment.
%
% DataFormat and ChannelCount are returned by CsMl_TransferEx.m.
%
% Please see the CompuScope MATLAB SDK documentation for more information
% on these fields.
%
% If the call was successful, the converted values are available in the
% return variable data. 

% Non-interleaved mode ('11111111') and stacked mode ('ffffffff') and
% handled the same way
if dataInfo.DataFormat == hex2dec('11111111') || dataInfo.DataFormat == hex2dec('ffffffff')
    data = reshape(buffer, dataInfo.Length, dataInfo.SegmentCount, dataInfo.ChannelCount);
    retval = 1;
elseif dataInfo.DataFormat == hex2dec('11112222') || dataInfo.DataFormat == hex2dec('11221122')
    Channel1 = [];
    Channel2 = [];
    BufferLength = dataInfo.ChannelCount * dataInfo.SegmentCount * dataInfo.Length;
    if dataInfo.DataFormat == hex2dec('11221122')
        ChunkSize = 4;
    else
        ChunkSize = 8;
    end
    Increment = ChunkSize / 2;
    for i=1:ChunkSize:BufferLength
        Channel1 = horzcat(Channel1, buffer(i:i + Increment - 1));
        Channel2 = horzcat(Channel2, buffer(i+Increment:i + ChunkSize - 1));
    end;
    new_buffer = horzcat(Channel1, Channel2);
    data = reshape(new_buffer, dataInfo.Length, dataInfo.SegmentCount, dataInfo.ChannelCount);
    retval = 1;
% elseif dataInfo.DataFormat == hex2dec('11221122')
%     Channel1 = [];
%     Channel2 = [];
%     BufferLength = dataInfo.ChannelCount * dataInfo.SegmentCount * dataInfo.Length;
%     ChunkSize = 4;
%     Increment = ChunkSize / 2;
%     for i=1:ChunkSize:BufferLength
%         Channel1 = horzcat(Channel1, buffer(i:i + Increment - 1));
%         Channel2 = horzcat(Channel2, buffer(i+Increment:i + ChunkSize - 1));
%     end;
%     new_buffer = horzcat(Channel1, Channel2);
%     data = reshape(new_buffer, dataInfo.Length, dataInfo.SegmentCount, dataInfo.ChannelCount);
%     retval = 1;    
else
    retval = -27; % Invalid parameter
end;

if 4 == nargin 
    if (1 == rawdata)
        return;
    end
end    
% If rawdata is not 1, or is not even passed as a parameter
% convert the data to volts
% Get the SampleResolution and SampleOffset from QueryAcqusition rather
% then from GetSystemInfo because these values might change if FPGA images
% are loaded
[ret, acq] = CsMl_QueryAcquisition(handle);
channel = 1;%transferstruct.Channel;
[ret, chan] = CsMl_QueryChannel(handle, channel);
data = (((acq.SampleOffset - double(data)) / acq.SampleResolution) * (chan.InputRange / 2000)) + (chan.DcOffset / 1000);

    
    