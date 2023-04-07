function BrillouinPipeDisplay(PFS,Diameter,Pitch,SamPerRev)
% Pipe Display
% Input is measured strain along helically wrapped fiber on pipe; 
%    format is: position (m), frequency (Hz), strain (micro)
% Also needed is: 
%    the diameter of the pipe (mm) - Diameter
%    the pitch of the windings (mm) - Pitch
%    the samples per revolution on the display - SamPerRev
% BrillouinPipeDisplay(PFT,1200,25,100); 
Circumf = pi*Diameter;
OneTurn = sqrt(Circumf^2 + Pitch^2);
[x,y]=size(PFS); % Extract the cable length
CableLength = PFS(x,1);
PosNew=0:(OneTurn/SamPerRev)/1000:CableLength;
% Resample the data to have the specified number of samples per revolution
ReSampStrain=spline(PFS(:,1),PFS(:,3),PosNew); % Resample the measured data
[X,Y,Z]=cylinder((Diameter/2),SamPerRev); % Create SamPerRev segments around the cylinder
% Determine length of pipe in revolutions
PipeLength = round(CableLength/OneTurn*1000);
Xnew = repmat(X(1,:),PipeLength,1);
Ynew = repmat(Y(1,:),PipeLength,1);
for pos = 1:PipeLength
    Znew(pos,:) = (Z(1,:)+1)*pos;
end
C=Znew;
%Write the strain values into C
count=1;
siz=max(size(ReSampStrain));
for pos = 1:PipeLength
    for azimuth = 1:SamPerRev
        if count>siz
            C(pos,azimuth)=C(pos-1,azimuth);
        else
        C(pos,azimuth)= ReSampStrain(count);
        end
        count=count+1;
    end
end
surf(Xnew,Ynew,Znew,C)
colormap jet
colorbar
title('Strain from Internal Pressure')
end