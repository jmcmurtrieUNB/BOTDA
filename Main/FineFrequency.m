function [me, Freq] = FineFrequency(Freq,LaserSelect,ReadWrite)
% FineFrequency sets the frequency of the pure photonics PPCL300 laser in
% the BOTDA system.

% Inputs:
% Freq:         Desired frequency ofset from current (MHz)
%
% LaserSelect:  A string containing the COM port with which to connect. 
%               ie LaserSelect='COM4'
%
% ReadWrite:    1=Write 0=Read

% Outputs:
% me:           me=0 if no errors during execution


me=[];
response=zeros(4,1);
s=serial(LaserSelect);
try
if s.Status=='closed'
    fopen(s);
end
if ReadWrite==1 %Write
    Byte0=hex2dec('01');
    Byte2=bi2de(bitget(Freq,9:16));
    Byte3=bi2de(bitget(Freq,1:8));
elseif ReadWrite==0
    Byte0=hex2dec('00');
    Byte2=hex2dec('00');
    Byte3=hex2dec('00');
end
Byte1=hex2dec('62');

Freq=int16(Freq);

% Byte2=bi2de(bitget(Freq,9:16));
% Byte3=bi2de(bitget(Freq,1:8));
% Freq=de2bi(Freq,16,'left-msb');
% Byte2=bi2de(Freq(1,1:8),'left-msb');
% Byte3=bi2de(Freq(1,9:16),'left-msb');

Byte0=Checksum(Byte0,Byte1,Byte2,Byte3);

fwrite(s,[uint8(Byte0) uint8(Byte1) uint8(Byte2) uint8(Byte3)],'uint8');
response=fread(s,4,'uint8');

check=de2bi(response(1,1),8,'left-msb');

if check(1,7)==1 && check(1,8)==1
    while check(1,7)==1 && check(1,8)==1
        fwrite(s,[int8(0) int8(0) int8(0) int8(0)],'uint8');
        response=fread(s,4,'uint8');
        check=de2bi(response(1,1),8,'left-msb');
    end
end

Byte0=hex2dec('00');
Byte0=Checksum(Byte0,Byte1,Byte2,Byte3);

fwrite(s,[uint8(Byte0) uint8(Byte1) uint8(Byte2) uint8(Byte3)],'uint8');
response=fread(s,4,'uint8');

check=de2bi(response(1,1),8,'left-msb');

if check(1,7)==1 && check(1,8)==1
        temp=response(3:4,:);
        while check(1,7)==1 && check(1,8)==1
            fwrite(s,[int8(0) int8(0) int8(0) int8(0)],'int8');
            response=fread(s,4,'uint8');
            check=de2bi(response(1,1),8,'left-msb');
        end
        response(3:4,:)=temp;
        clear temp
end

if check(1,7)==0 && check(1,8)==1
    disp('Error! Laser returned an execution error. (set1)')
elseif response(4,1)~= Byte3
    temp(1,1:8)=de2bi(response(3,:),8,'left-msb');
    temp(1,9:16)=de2bi(response(4,:),8,'left-msb');
    temp=bi2de(temp,'left-msb');
    disp(['Error! Laser fine tune frequency was set to ' num2str(temp) ' MHz'])
end

catch me
%    if me.identifier=='MATLAB:serial:fopen:opfailed'
 %       msgbox(['No laser connected to ' LaserSelect],'Error','error');
  %  else
        msgbox(me.message)
  %  end
end
% f=int16(0);
% temp(1,1:8)=de2bi(response(3,:),8);
% temp(1,9:16)=de2bi(response(4,:),8);
% f=bitset(f,1:8,temp(1,9:16));
% bitset(f,9:16,temp(1,1:8));
% % f=int16(f);
% % temp=bi2de(temp,'left-msb');
% disp(['Fine tune frequency was set to ' num2str(f) ' MHz'])
if isempty(me)
    me=response(4,:);
end
fclose(s);
delete(s);
clear s

end