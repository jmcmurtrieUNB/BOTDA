function [ret] = DisplayData(data, start)
% Plots the data using start as the start address. If start is not present a 
% default of 0 is assumed. Start is used to set the start of the horizontal
% timebase. If there is pretrigger data in the data (indicated by the start 
% being negative) the horizontal timebase is adjusted.

startPoint = 0;
dataLength = size(data, 2);
% just in case the data is transposed
if 1 == dataLength
    dataLength = size(data, 1);
end;

if nargin > 1
    startPoint = start;
end;

% Adjust the horizontal axis and plot the data
% The points array is used to adjust the horizontal axix in case we have
% pretrigger data
xpos = startPoint;
xpos_end = dataLength + xpos - 1;
points = (xpos:xpos_end)';
if size(points) > dataLength
    points(dataLength:end) = [];
end;    
points = transpose(points);
plot(points, data);



