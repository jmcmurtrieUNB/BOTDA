clearvars -except FinalAVG
% FinalAVG must already be in the workspace

%% 3D plot
offset=2048+20;
shift=500;
s=size(FinalAVG); %size
points=s(2)-4116;% 2048 points at start and end + 20 columns of header info = 4116

if FinalAVG(1,6)==0 %New data has the cable length store in the matrix, old data does not
    cableL=(points/10)-1;
else
    cableL=FinalAVG(1,6);
end
cableL = round(cableL/0.102095);
position = 0:0.102095:(cableL+shift)*0.102095; %Length of valid measurements
Freqs=FinalAVG(:,1)/1e9;
z=FinalAVG(:,offset:offset+cableL+shift);
[x,y]=meshgrid(position,Freqs);
colormap jet
figure(50);
surf(x,y,z,'EdgeColor','Interp')
xlabel('Position (m)')
ylabel('\Deltaf (GHz)')
zlabel('Intensity (a.u.)')
title('SEPI-3: Jan 13, 2022')
colormap jet
%% 2D PLot

[PFT fy] = BrillouinCurveFit2021(35e6,0.1e6,10.9778e9,0.7581,FinalAVG);
%PlotPFTsequence(PFT,1,50,50,3,'b');
figure
plot(PFT(:,1),PFT(:,3));
xlabel('Position (m)')
ylabel('Temperature ^oC')
title('SEPI-3: Jan 13, 2022')
axis([0 188.1 -20 40]);
