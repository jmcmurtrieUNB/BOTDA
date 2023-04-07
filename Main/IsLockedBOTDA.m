function ret =IsLockedBOTDA(handle_MCP2210)
% Checks to see is lock is still established

% INPUTS:
% handle_2:    Handle for communications with MCP2210 board
%
%
% OUTPUTS:
% ret:         1 if locked, 0 if not locked
%   
%


% Variables setup
ADC_WORD(1,1)=bi2de([0 1 1 0 1 0 0 0],'left-msb');
ADC_WORD(1,2)=uint8(0);

% Read the error signal with 10 bit ADC (MCP3002)
err=calllib('mcp2210_dll_um_x64','Mcp2210_xferSpiDataEx',Handle_2,ADC_WORD(1,:),RxADC,Baud,TxSizeADC,CSMaskADC,IdleCS,ActiveCS,CSToDataDelay,DataToCSDelay,DataToDataDelay,SPIMode);
if err~=0
    disp('Error sending SPI data. Check the "Mcp2210 DLL User Guide" for error code:')
    disp(err)
    calllib('mcp2210_dll_um_x86','Mcp2210_Close',handle_MCP2210);
    return
end

% The bus does not like to release, this forces it to release
err=calllib('mcp2210_dll_um_x64','Mcp2210_xferSpiDataEx',handle_MCP2210,0,RxADC,Baud,TxSizeNULL,CSMaskNULL,IdleCS,ActiveCS,CSToDataDelay,DataToCSDelay,DataToDataDelay,SPIMode);
if err~=0
    disp('Error sending SPI data. Check the "Mcp2210 DLL User Guide" for error code:')
    disp(err)
    calllib('mcp2210_dll_um_x64','Mcp2210_Close',handle_MCP2210);
    return
end
% Bus should now be released

% Convert measured error signal to voltage level
rx=RxADC.value; % retrieve the value from pointer
binaryVoltage(1,1:8)=de2bi(rx(1,1),8,'left-msb'); %  most significant bits
binaryVoltage(1,9:16)=de2bi(rx(1,2),8,'left-msb'); % 8 least significant bits
binaryVoltage(1,1:6)=[0 0 0 0 0 0];
binaryVoltage=double(binaryVoltage); % convert to type double
VoltFraq=bi2de(binaryVoltage,'left-msb'); % convert binary to decimal number 
ErrorVoltage=Vmax*VoltFraq/1023; % convert to voltage level


% If error voltage is between 0.5 and 2 lasers are still locked
if ErrorVoltage<=0.5
    ret=0;
elseif ErrorVoltage>=2
    ret=0;
else
    ret=1;
end

end