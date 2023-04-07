function [data, ActualStart, ActualLength] = CsMl_ReadDataFile(filename)
% [data, ActualStart, ActualLength] = CsMl_ReadDataFile(filename)
%
% CsMl_ReadDataFile reads data from ASCII DAT files and adjusts the data to 
% account for alignment issues using the Start address and Data length fields 
% saved in the ASCII file header.  If these fields are not within the DAT file, 
% no adjustment is done.  The adjusted data are returned in the data return 
% field.  If the ActualStart return variable is present, the actual start of 
% the data from the header field is returned.  If the ActualLength return 
% variable is present, the data length field from the file header is returned.  
% The ActualStart and ActualLength return variables are optional.  
% If, however, ActualLength is used, then ActualStart must be used as well.

fid = fopen(filename, 'r');
ActualStart = 0;
ActualLength = 0;

% This code assumes that the header begins and ends with a series
% of dashes
str = fgetl(fid);
first_dashes = strfind(str, '----');
while isempty(first_dashes)
    str = fgetl(fid);
    first_dashes = strfind(str, '----');
end;

if (first_dashes)
    while 1
        str = fgetl(fid);
        second_dashes = strfind(str, '----');
        if second_dashes
            break;
        end;
        str = lower(str);
        if nargout > 1
            if strfind(str, 'start address')
                [a, b, c, ActualStart] = strread(str, '%s%s%s%f');
            end;
        end;
        if nargout > 2
            if strfind(str, 'data length')
                [a, b, c, ActualLength] = strread(str, '%s%s%s%f');
            end;
        end;
    end;        
end;

[data, count] = fscanf(fid, '%f', inf);

% If we never got the ActualLength value from the file, 
% don't adjust anything
    
if ActualLength ~= 0
    data(ActualLength:end) = [];
end;   

if ActualStart ~= 0
    data(1:-ActualStart) = [];
end;    