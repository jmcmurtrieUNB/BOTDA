function [retval, channelinfo] = CsMl_QueryChannel(handle, channel)
% [retval, channelinfo] = CsMl_QueryChannel(handle, channel)
%
% CsMl_QueryChannel returns information about the specified channel in the 
% CompuScope system uniquely identified by handle (the CompuScope system 
% handle).  The channel input parameter starts at 1.  
% The handle must previously have been obtained by calling CsMl_GetSystem.  
% If the call succeeds, retval will be positive.  If the call fails, retval 
% will be a negative number, which represents an error code.  A descriptive 
% error string may be obtained by calling CsMl_GetErrorString.  
% 
% If the call succeeds, information about the current state of the channel 
% parameters are returned in channelinfo.  
% 
% The values returned are:
% Channel       - the channel in question. CompuScope channels begin at 1
% Coupling      - the coupling of the channel, (DC = 1, AC = 2)
% DiffInput     - flag that tells if differential input is on (1) or off (0)
% InputRange    - full scale input range in mV (e.g. +/1 volt = 2000)
% Impedance     - input impedance of the channel in Ohms (50 or 1000000)
% DcOffset      - voltage (in mV) by which the midpoint of the input range is 
%                 offset
% DirectAdc     - flag that tells if Direct-to-ADC is on (1) or off (0)
% Filter	- flag that tells if the filter is turned on (1) or off (0)

[retval, channelinfo] = CsMl(14, handle, channel);


    