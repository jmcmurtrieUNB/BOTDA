% GageWriteSig sample program
% This program demonstrates how to configure a system's capture, channel
% and trigger parameters, do a capture, transfer 1 channel's data and save
% the data in the GageScope sig file format. This sample only saves 1
% record.  filename is the name of the file to write, it should have a .sig
% extension.  If the file exists it will be overwritten. The filename 
% parameter can also include a relative or absolute path to the file.

function [ret] = GageWriteSig(filename)

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


% Due to hardware alignment issues, we may not always get the amount of
% data that we request, and it may not always being where we requested it.
% To adjust for this, we'll pad the transfer length so we're sure to get
% what we really want and we'll transfer from the adjusted start address.
transfer.Length = transfer.Length + 64;

% transfer channel 1's data
transfer.Channel = 1; 
% Transfer the data in raw data mode, not as voltages
[ret, data, actual] = CsMl_Transfer(handle, transfer, 1);
CsMl_ErrorHandler(ret, 1, handle);

[ret, chanInfo] = CsMl_QueryChannel(handle, transfer.Channel);
CsMl_ErrorHandler(ret, 1, handle);

start = transfer.Start - actual.ActualStart;
length = transfer.Length - 64; % we only want to save the requested amount of data

sig.SampleRate = acqInfo.SampleRate;
sig.RecordStart = transfer.Start; % the requested start address
sig.RecordLength = length; % the requested length
sig.RecordCount = 1; % this sample only saves 1 record
sig.SampleBits = acqInfo.SampleBits;
sig.SampleSize = acqInfo.SampleSize;
sig.SampleOffset = acqInfo.SampleOffset;
sig.SampleRes = acqInfo.SampleResolution;
sig.Channel = transfer.Channel;
sig.InputRange = chanInfo.InputRange;
sig.DcOffset = chanInfo.DcOffset;
sig.TimeOffset = zeros(1,4);

% both the comment and name fields are optional and can be left out
% comment will be truncated at 255 characters, name will be truncated to 8
% characters
comment = 'Saved by GageWriteSig.m';
name = 'Test Signal';

[retval, sigheader] = CsMl_ConvertToSigHeader(sig, comment, name);
CsMl_ErrorHandler(ret, 1, handle);

ret = CsMl_FreeSystem(handle);

if sig.SampleSize == 1
    precision = 'uchar';
elseif sig.SampleSize == 4
    precision = 'int32';
else
    precision = 'int16';
end;

fid = fopen(filename, 'w');
header_size = fwrite(fid, sigheader, 'uchar');
if header_size == 512
    data_count = fwrite(fid, data, precision);
    if data_count ~= transfer.Length
        s = sprintf('Error: file data is %d samples, should be %d samples\n', data_count, transfer.Length);
        disp(s);
    else
        s = sprintf('%s written successfully\n', filename);
        disp(s);
    end;    
else
    s = sprintf('Error: sig header is %d bytes, should be 512 bytes\n', header_size);
    disp(s);
end;
fclose(fid);











