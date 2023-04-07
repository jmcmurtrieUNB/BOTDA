function [ret] = ReadMrDataFiles(name, segments)
% ret = ReadMrDataFiles(name, segments)
%
% ReadMrDataFiles reads a series of multiple record files and displays them as a 
% mesh plot. This function assumes that multiple record files will be saved as 
% ascii files with the Actual Start address and the Actual Data Length present in 
% the header. It uses the CsMl_ReadDataFile function to actually read the files. 
% The first thing the function does is read the data files to determine the shortest 
% length.  The name parameter is a string which assumes the form BaseName_CHx_y.dat 
% where x is the channel number and y is the segment number. Only the BaseName_CHx 
% part is passed to the function. The segments parameter is the number of segments 
% (and files) to read. Note that this function assumes that the file naming convention 
% is the same as that used by our SDK sample programs.

max_segments = int2str(segments);

% Determine how many segments there are so we can format the filename so each
% one has the same amount of characters.
max_segment_size = length(max_segments);
format_string = sprintf('-%%0%dd.dat', max_segment_size);

shortest_length = 10000000000;
for i = 1:segments
    filename = name;
    segmentname = sprintf(format_string, i);
    filename = strcat(filename, segmentname);
    [data, actual_start, actual_length] = CsMl_ReadDataFile(filename);
    new_length = actual_length + actual_start;
    if new_length < shortest_length
        shortest_length = new_length;
    end;    
end;

for i = 1:segments
    filename = name;
    segmentname = sprintf(format_string, i);    
    filename = strcat(filename, segmentname);    
    [data, actual_start] = CsMl_ReadDataFile(filename);   
%   length = size(data, 1);
    
    data(shortest_length:end) = [];
    if i == 1
        alldata = cat(2, data);
    else
        all_length = size(alldata, 1);
        alldata = cat(2, alldata, data);
    end;
end;
mesh(alldata);