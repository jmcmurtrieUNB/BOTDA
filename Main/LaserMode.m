function [me] = LaserMode(LaserSelect,mode)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

me=[];
% Change Dither Mode
Byte0=hex2dec('01');
Byte1=hex2dec('90');
Byte2=hex2dec('00');
Byte3=mode;

Byte0=Checksum(Byte0,Byte1,Byte2,Byte3);

% Open connection to laser
s=serial(LaserSelect);
try
    if s.Status=='closed'
        fopen(s);
    end


    fwrite(s,[uint8(Byte0) uint8(Byte1) uint8(Byte2) uint8(Byte3)],'uint8');
    response=fread(s,4,'uint8');

    check=de2bi(response(1,1),8,'left-msb');
    
    while check(1,7)==1 && check(1,8)==1
        fwrite(s,[uint8(0) uint8(0) uint8(0) uint8(0)],'uint8');
        response=fread(s,4,'uint8');
        check=de2bi(response(1,1),8,'left-msb');
    end

    if check(1,7)==0 && check(1,8)==1
        msgbox('Error! Laser returned an execution error while changing mode','Error','error')
    elseif response(4,1)~= Byte3
        warndlg('Error! Laser did not return desired response while changing mode. Something may be set incorrectly.')
    end
catch me
   % if me.identifier=={'MATLAB:serial:fopen:opfailed'}
   %     msgbox(['No laser connected to ' LaserSelect],'Error','error');
   % else
        msgbox(me.message)
  %  end
end

fclose(s);
delete(s);
clear s

end

