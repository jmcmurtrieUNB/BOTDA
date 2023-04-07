function [retval, sysinfo] = CsMl_GetSystemInfo(handle)
% [retval, sysinfo] = CsMl_GetSystemInfo(handle)
%
% CsMl_GetSystemInfo returns static information about the CompuScope system 
% uniquely described by handle (the CompuScope system handle).  The handle 
% must previously have been obtained by calling CsMl_GetSystem.  
% If the call succeeds, retval will be positive.  If the call fails, retval 
% will be a negative number, which represents an error code.  A descriptive 
% error string may be obtained by calling CsMl_GetErrorString.  
% 
% If the call was successful, the system information is returned in sysinfo.  
% 
% The available fields in sysinfo are:
% MaxMemory         - maximum available memory, in samples
% SampleBits        - vertical resolution, in bits
% SampleResolution  - number of ADC levels between 0 Volts and + or - full-scale
% SampleOffset      - ADC output that corresponds to 0 Volts
% BoardType         - numeric constant that indicates the board type
% BoardName         - text string containing the CompuScope model name
% AddonOptions      - options available on the optional add-on firmware
% BaseBoardOptions  - options available on the baseboard firmware
% TriggerCount      - number of trigger engines available in the CompuScope 
%                     system
% ChannelCount      - number of channels available in the CompuScope system
% BoardCount        - number of boards available in the CompuScope system
%
% Note that some of these values, particularly ChannelCount, SampleBits, 
% SampleResolution and SampleOffset, can change depending on the acquisition 
% Mode and options being used.  If you need to know the dynamic values of 
% these fields, they may be obtained by using CsMl_QueryAcquisition.

[retval, sysinfo] = CsMl(3, handle);

    