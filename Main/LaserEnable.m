function [me] = LaserEnable(LaserSelect)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

me=[];

Byte0=hex2dec('01');
Byte1=hex2dec('32');
Byte2=hex2dec('00');
Byte3=hex2dec('08');

Byte0=Checksum(Byte0,Byte1,Byte2,Byte3);

s=serial(LaserSelect);

try
if s.Status=='closed'
    fopen(s);
end

fwrite(s,[uint8(Byte0) uint8(Byte1) uint8(Byte2) uint8(Byte3)],'uint8');
response=fread(s,4,'uint8');

check=de2bi(response(1,1),8,'left-msb');
temp=response(4,1);
while check(1,7)==1 && check(1,8)==1
    fwrite(s,[uint8(0) uint8(0) uint8(0) uint8(0)],'uint8');
    response=fread(s,4,'uint8');
    check=de2bi(response(1,1),8,'left-msb');
end
response(4,1)=temp;
if check(1,7)==0 && check(1,8)==1
    error('Error! Laser returned an execution error during enable')
elseif response(4,1)~= Byte3
    error(['Error! Laser did not return desired response.(Enable)'])
end

catch me
    if me.identifier=='MATLAB:serial:fopen:opfailed'
        msgbox(['No laser connected to ' LaserSelect],'Error','error');
    else
        msgbox(me.message)
    end
end

fclose(s);
delete(s);
clear s

end
