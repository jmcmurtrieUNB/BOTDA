function PlotPFTsequence(PFT, num, center, depth, pipenum, color, colorVec, colorIter)
% function PlotPFTsequence(PFT, num, center, depth, pipenum, color, colorVec, colorIter)
% PlotPFTsequence takes a PFT vector and rearranges the data and plots it. This
% function shows the difference in measurements between forward and reverse
% paths in a cable. This function uses a PFT matrix already stored in 
% MATLAB. To achieve this simply import a UNB measurement file into MATLAB.
% This function is to be used at Mactaquac to continously monitor the
% changes in temperature, since it appends the plots while MATLAB is
% running.
% PFT is a vector which is outputted by the BrillouinCurveFit function.
% num is the number of cables chained in the measurement.
% center a vector of center poisitions (in meters) of the cables. The order
% is the same as in the plot obtained via BrillouinCurveFit.
% depth is the cable distance (in meters)from the shack to the bottom of 
% the dam.
% pipenum is a vector of pipe numbers which were measured (if SEP2 followed 
% by SEP3 were measured, pipenum = [2 3]). Used for labeling the plots.
% color is a string of letters which represent the color of each measured
% cable.
% colorVec is the vector of colors to be used by plots.
% colorIter is the color specifier to be used. 
% Sample:
% PlotPFTsequence(PFT,2,[114.91 271.55],83.67,[3 2],'bb',colorVec,colorIter);

% Created 02/06/2014 by Gleb Egorov.
% Edited 05/06/2014 by Gleb Egorov.

%clf %should be commented if want to add more curves to existing plot.

% obtain index information from distance values. 0.102095 is the distance
% in meters between each PFT index.

%close all

cindex = ceil(center/0.102095);
hindex = floor(depth/0.102095);

% update a figure with the manipulated data.
for i=1:num
%for i=1:1
   figure(i+1)
   hold on
   x = fliplr((0:hindex)*0.102095);
%    plot(x,PFT((cindex(i)-hindex):cindex(i),3),colorVec(mod(colorIter,length(colorVec))+1));
   plot(x,PFT((cindex(i)-hindex):cindex(i),3));
%    plot(x,fliplr((PFT(cindex(i):(cindex(i)+hindex),3)')),[colorVec(mod(colorIter,length(colorVec))+1) '--']);
plot(x,fliplr((PFT(cindex(i):(cindex(i)+hindex),3)')),'--');
   hold off
end

% add labels to the plots.
for i=1:num
    figure(i+1)
    title(['Temperature vs. Depth in SEP' num2str(pipenum(i)) color(i)]);
    xlabel('Height From Bottom [m]');
    ylabel('Temperature [ ^\circC]'); 
    grid on
%     axis([min(x) max(x) -5 30]);
end

end