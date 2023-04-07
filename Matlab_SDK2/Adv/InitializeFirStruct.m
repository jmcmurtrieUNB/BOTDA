function [firStruct] = InitializeFirStruct(datafile)
% initializes the FIR structure with values
%

% InitializeFirStruct can also be called with a filename.
% i.e. InitializeFirStruct('test.dat'); where test.dat must be an ascii
% file consisting of a 39 on the first line, the factor on the second line,
% and 20 parameters each on a seperate line. If the first line is 39 then
% Symmetrical39th field of firstruct will be on, otherwise it is off. The
% factor must be a power of 2 between 256 and 32768.

if nargin >= 1
    % zero out the firStruct.Values array in case the file doesn't have
    % enough data, we'll put zeros where there's no data. ???
    firStruct.Values = zeros(1, 20);
    firStruct.Enable = 1;
    fir_parameters = load(datafile, '-ascii');
    if fir_parameters(1) == 39
        firStruct.Symmetrical39th = 1;
    else
        firStruct.Symmetrical39th = 0;
    end;
    firStruct.Factor = fir_parameters(2);
    
    % Set the index to skip over the 2 values we've already used.
    % Set the length to be the length of the file array minus the 2
    % values we've already used. Lenght shouldn't be more than 20.

    index = 3;
    count = length(fir_parameters) - 2;
    if count > 20
        count = 20;
    end;
    for i = 1:count 
        firStruct.Values(i) = fir_parameters(index);
        index = index + 1;
    end;
else    
    firStruct.Enable = 1;
    firStruct.Symmetrical39th = 1;
    firStruct.Factor = 32768;
    firStruct.Values(1) = 4194;
    firStruct.Values(2) = 3868;        
    firStruct.Values(3) = 2969;        
    firStruct.Values(4) = 1712;    
    firStruct.Values(5) = 382;    
    firStruct.Values(6) = -746;    
    firStruct.Values(7) = -1485;    
    firStruct.Values(8) = -1770;
    firStruct.Values(9) = -1658;
    firStruct.Values(10) = -1289;
    firStruct.Values(11) = -830;
    firStruct.Values(12) = -420;
    firStruct.Values(13) = -136;
    firStruct.Values(14) = 5;
    firStruct.Values(15) = 41;
    firStruct.Values(16) = 21;
    firStruct.Values(17) = -11;
    firStruct.Values(18) = -35;
    firStruct.Values(19) = -44;
    firStruct.Values(20) = -44;            
end;