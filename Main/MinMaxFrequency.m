function [me] = MinMaxFrequency(LaserSelect)
% FineFrequency sets the frequency of the pure photonics PPCL300 laser in
% the BOTDA system.

% Inputs:
% Freq:         Desired frequency ofset from current (MHz)
%
% LaserSelect:  A string containing the COM port with which to connect. 
%               ie LaserSelect='COM4'

% Outputs:
% me:           me=0 if no errors during execution


me=0;

s=serial(LaserSelect);
try
if s.Status=='closed'
    fopen(s);
end

Byte0=hex2dec('00');
Byte1=hex2dec('4F');
Byte2=0;
Byte3=0;

Byte0=Checksum(Byte0,Byte1,Byte2,Byte3);

fwrite(s,[uint8(Byte0) uint8(Byte1) uint8(Byte2) uint8(Byte3)],'uint8');
response=fread(s,4,'uint8');

check=de2bi(response(1,1),8,'left-msb');

if check(1,7)==1 && check(1,8)==1
    while check(1,7)==1 && check(1,8)==1
        fwrite(s,[int8(0) int8(0) int8(0) int8(0)],'int8');
        response=fread(s,4,'int8');
        check=de2bi(response(1,1),8,'left-msb');
    end
end


if check(1,7)==0 && check(1,8)==1
    disp('Error! Laser returned an execution error. (set1)')
end

catch me
    if me.identifier=='MATLAB:serial:fopen:opfailed'
        msgbox(['No laser connected to ' LaserSelect],'Error','error');
    else
        msgbox(me.message)
    end
end
 temp(1,1:8)=de2bi(response(3,:),8,'left-msb');
    temp(1,9:16)=de2bi(response(4,:),8,'left-msb');
    temp=bi2de(temp,'left-msb');
    disp(['Fine tune frequency range is +/- ' num2str(temp) ' MHz'])
fclose(s);
delete(s);
clear s

end