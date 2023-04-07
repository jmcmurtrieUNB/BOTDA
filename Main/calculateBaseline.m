function [intercept slope correction] = calculateBaseline(beginningData, endData, data)
%This function calculates the first order baseline coefficients for a BOTDA
%waveforms

format long
% beginning is in sample number
% end is in sample number
% data is a data set consisting of only time-domain waveforms - NO FREQUENCIES!!!
width = 5;      %width of averaging window divided by two
sampleSize = size(data);
for i = 1:sampleSize(1);
    startAVG = mean(data(i,(beginningData-width):(beginningData+width)));
    endAVG = mean(data(i,(endData-width):(endData+width)));
    slope(i,1) = (endAVG - startAVG)/(endData-beginningData);
    intercept(i,1) = startAVG - slope(i,1).*beginningData;         % b = y -mx
    correction(i,:) = slope(i,1).*(beginningData:1:endData) + intercept(i,1);   %y = mx + b
    dataToCorrect(i,:) = data(i,beginningData:endData);
%     plot(beginningData:1:endData, dataToCorrect(i,:) - correction(i,:), 'r');
%     hold on
%    % plot(data(i,:))
%     %axis([300 2000 2.135e9 2.1375e9])
%     hold off
%     pause
end

