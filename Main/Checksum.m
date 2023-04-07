function Byte0 = Checksum(Byte0,Byte1,Byte2,Byte3)
% Checksum calculates the checksum and modifies Byte0 to include the
% required checksum for communication with the pure photonics PPCL300 laser

% INPUTS:
% Byte0:    Checksum and Read or Write bits. bits 31-24
% Byte1:    The register number. bits 23-16
% Byte2:    data bits 15-8
% Byte3:    data bits 7-0

% OUTPUTS:
% Byte0:    Modified Byte0 to include the required checksum

% Convert to Binary
Byte0=de2bi(Byte0,8,'left-msb');
Byte1=de2bi(Byte1,8,'left-msb');
Byte2=de2bi(Byte2,8,'left-msb');
Byte3=de2bi(Byte3,8,'left-msb');

% Calculate the checksum
bip8=xor(Byte0,xor(Byte1,xor(Byte2,Byte3)));
bip4=double(xor(bip8(1:4),bip8(5:8)));

% Modify Byte0 to include the checksum
Byte0(1,1:4)=bip4;
Byte0=bi2de(Byte0,'left-msb');

end

