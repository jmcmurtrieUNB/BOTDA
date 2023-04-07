function [retval] = CsMl_Capture(handle)
% retval = CsMl_Capture(handle)
%
% CsMl_Capture begins an acquisition using the current acquisition
% parameters on the CompuScope system uniquely defined by handle. 
% The handle must previously have been obtained by calling CsMl_GetSystem.  
% If retval is positive, the call succeeded.  If retval is negative, it 
% represents an error code.  A descriptive error string may be obtained 
% by calling CsMl_GetErrorString.

retval = CsMl(8, handle);

    