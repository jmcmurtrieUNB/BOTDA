function [retval] = CsMl_ForceCalibration(handle)
% retval = CsMl_ForceCalibration(handle)
%
% CsMl_ForceCalibration forces calibration of all the channels of the 
% CompuScope system regardless of the setting of the channel.
% If retval is positive, the call succeeded.  
% If retval is negative, it represents an error code.  
% A descriptive error string may be obtained by calling CsMl_GetErrorString.

retval = CsMl(24, handle);

    