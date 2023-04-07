function [ret] = CsMl_SaveFile(filename, data, headerinfo, rawdata)
% ret = CsMl_SaveFile(filename, data, headerinfo)
%
% CsMl_SaveFile saves a buffer of data acquired by a CompuScope system to 
% an ASCII DAT file. The function optionally writes a header to the file if the 
% required information is present.  The data are written following the
% header.  The rawdata field should be set to 1 if the values in data are
% raw data from the CompuScope board (not voltages).  If the rawdata field
% is not used, or is not equal to 1, it is assumed that the values in data
% are voltages.
% 
% The optional information that can be set in the headerinfo structure is:
% StartAddress  - the actual start address (returned by CsMl_Transfer)
% Length        - the actual length of data (returned by CsMl_Transfer)
% SampleSize    - size of each data sample, in bytes 
%                 (returned by CsMl_QueryAcquisition)
% SampleRes     - number of levels between 0 and full scale 
%                 (returned by CsMl_QueryAcquisition)
% SampleOffset  - value that represents 0 volts 
%                 (returned by CsMl_QueryAcquisition)
% InputRange    - full-scale input range in millivolts 
%                 (returned by CsMl_QueryChannel)
% DcOffset      - voltage (in mV) by which the midpoint of the input range 
%                 is offset 
%                 (returned by CsMl_QueryChannel) 
% SegmentCount  - number of segments acquired 
%                 (1 for single record acquisitions, some value other than 1 
%                 for multiple record acquisitions).
% SegmentNumber - the multiple record segment number
% TimeStamp     - time stamp info for Multiple Record acquisitions 
%                 (returned by CsMl_Transfer)

fid = fopen(filename, 'w');
if -1 == fid
    ret = -1;
    return;
end;

% Write header
if nargin > 2
    fprintf(fid, '------------------\r\n');
    if isfield(headerinfo, 'Start')
        fprintf(fid, 'Start address  = %d\r\n', headerinfo.Start);
    end;
    if isfield(headerinfo, 'Length')
        fprintf(fid, 'Data length    = %d\r\n', headerinfo.Length);
    end;
    if isfield(headerinfo, 'SampleSize')
        fprintf(fid, 'Sample size    = %d\r\n', headerinfo.SampleSize);
    end;
    if isfield(headerinfo, 'SampleRes')
        fprintf(fid, 'Sample res     = %d\r\n', headerinfo.SampleRes);
    end;    
    if isfield(headerinfo, 'SampleOffset')
        fprintf(fid, 'Sample offset  = %d\r\n', headerinfo.SampleOffset);
    end;
    if isfield(headerinfo, 'InputRange')
        fprintf(fid, 'Input range    = %d\r\n', headerinfo.InputRange);
    end;    
    if isfield(headerinfo, 'DcOffset')
        fprintf(fid, 'Dc offset      = %d\r\n', headerinfo.DcOffset);
    end;        
    if isfield(headerinfo, 'SegmentCount')
        fprintf(fid, 'Segment count  = %d\r\n', headerinfo.SegmentCount);
    end;            
    if isfield(headerinfo, 'SegmentNumber')
        fprintf(fid, 'Segment number = %d\r\n', headerinfo.SegmentNumber);
    end;    
    if isfield(headerinfo, 'TimeStamp')
        fprintf(fid, 'Time stamp     = %.2f microseconds\r\n', headerinfo.TimeStamp);
    end;        
    fprintf(fid, '------------------\r\n');
end;

if 4 == nargin 
    if (1 == rawdata)
        ret = fprintf(fid, '%.0f\r\n', double(data));
    else
        ret = fprintf(fid, '%6.4f\r\n', data);
    end;
else
    ret = fprintf(fid, '%6.4f\r\n', data);
end;    


%ret = fprintf(fid, '%6.4f\r\n', data);
if ret < 0
    message = ferror(fid);
    file_message = strcat('Could not save file', filename);
    disp(file_message); 
    disp(message);
    fclose(fid);
    return;
end;    
fclose(fid);
ret = 1;
