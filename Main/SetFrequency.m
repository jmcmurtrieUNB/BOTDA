function [] = SetFrequency(Freq,LaserSelect)
% SetFrequency sets the frequency of the pure photonics PPCL300 CW laser in
% the BOTDA system.

% Inputs:
% Freq:         Desired frequency of the laser. Enter the value in THz with
%               precision up to 0.0001 THz. min =191.5 max = 196.25.
%               For 195.9872 THz enter 195.9872
%
% LaserSelect:  A string containing the COM port with which to connect. 
%               ie LaserSelect='COM4'

% Outputs:
% None

if Freq>196.25
    error('Maximum input is 196.25')
elseif Freq<191.5
    error('Minimum input is 191.5')
end

s=serial(LaserSelect);
try
if s.Status=='closed'
    fopen(s);
end

Byte0=hex2dec('01');
Byte1=hex2dec('35');
Byte2=0;
Byte3=floor(Freq);

Byte0=Checksum(Byte0,Byte1,Byte2,Byte3);

fwrite(s,[uint8(Byte0) uint8(Byte1) uint8(Byte2) uint8(Byte3)],'uint8');
response=fread(s,4,'uint8');

check=de2bi(response(1,1),'left-msb');
if check(1,7)==0 && check(1,8)==1
    error('Error! Laser returned an execution error')
elseif response(4,1)~= Byte3
    error(['Error! Laser was set to ' num2str(response(4,1)) ' THz'])
end

Byte0=hex2dec('01');
Byte1=hex2dec('36');
data=dec2hex(floor((Freq-floor(Freq))*10000),4);
Byte2=hex2dec(data(1,1:2));
Byte3=hex2dec(data(1,3:4));

Byte0=Checksum(Byte0,Byte1,Byte2,Byte3);

fwrite(s,[uint8(Byte0) uint8(Byte1) uint8(Byte2) uint8(Byte3)],'uint8');
response=fread(s,4,'uint8');

check=de2bi(response(1,1),'left-msb');
if check(1,7)==0 && check(1,8)==1
    error('Error! Laser returned an execution error.')
elseif response(4,1)~= Byte3
    error('Error! Line 57 of SetFrequency.m')
end




catch me
    disp('An Error occured during SetFrequency')
end

fclose(s);
delete(s);
clear s

end
