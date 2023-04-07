function [SFinalAVG,yy]=basefunc(SFinalAVG)
fsize=size(SFinalAVG);
avgb=0;
avge=0;
yy=zeros(fsize(1),fsize(2));
xq=1:fsize(2);
v=[avgb,avge];
x=[1,fsize(2)];
for m = 1:1:fsize(1)
    avgb=0;
    avge=0;
    for n = 1:2000
        avgb=avgb+ SFinalAVG(m,n);
        avge=avge+SFinalAVG(m,fsize(2)-n);
    end
    avgb=avgb/2000;
    avge=avge/2000;
    v=[avgb,avge];
    yy(m,:)=interp1(x,v,xq);
    %yy(m,:)=interp1(x,v,xq);
end

SFinalAVG=SFinalAVG-yy;
%SFinalAVG(:,(2049:(fsize-2048)))=SFinalAVG(:,(2049:(fsize-2048)))-yy(:,(2049:(fsize-2048)));


