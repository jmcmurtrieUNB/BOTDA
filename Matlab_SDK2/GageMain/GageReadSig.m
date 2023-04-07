% GageReadSig sample program
% This program demonstrates how to read and display a GageScope sig file
% Parameters are a string representing the file to read, and an optional
% flag to convert to volts. If the flag is present and not equal to 0, the 
% data will be converted to voltages. Otherwise the raw data will be
% displayed.

function [ret] = GageReadSig(filename, convert_to_volts)

fid = fopen(filename, 'r');
header_data = fread(fid, 512, 'schar');
sigheader = int8(header_data);
[ret, sig, comment, name] = CsMl_ConvertFromSigHeader(sigheader);
CsMl_ErrorHandler(ret);

if sig.SampleSize == 1
    precision = 'uchar';
elseif sig.SampleSize == 4
    precision = 'int32';
else
    precision = 'int16';
end;

data = fread(fid, sig.RecordLength, precision);

if nargin > 1 & convert_to_volts ~= 0 % plot voltages
   data = (((sig.SampleOffset - double(data)) / sig.SampleRes) * (sig.InputRange / 2000)) + (sig.DcOffset / 1000);      
   xpos = sig.RecordStart / sig.SampleRate;
   xpos_end = (sig.RecordLength + sig.RecordStart - 1) / sig.SampleRate;
   interval = 1 / sig.SampleRate;
   points = (xpos:interval:xpos_end)';
else % plot raw data
    xpos = sig.RecordStart;
    xpos_end = sig.RecordLength + xpos - 1;
    points = (xpos:xpos_end)';
end


if size(points) > sig.RecordLength
    points(sig.RecordLength:end) = [];
end;
points = transpose(points);
plot(points, data);
if nargin > 1 & convert_to_volts ~= 0
   xlabel('Time (seconds)');
   ylabel('Amplitude (volts)');
else
    xlabel('Samples');
    ylabel('Raw values');    
end;
