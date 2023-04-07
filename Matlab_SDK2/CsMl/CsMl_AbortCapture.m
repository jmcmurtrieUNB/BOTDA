function [retval] = CsMl_AbortCapture(handle)
% retval = CsMl_AbortCapture(handle)
%
% CsMl_AbortCapture aborts an acquisition on the CompuScope system uniquely
% identified by handle.  The handle must previously have been obtained 
% by calling CsMl_GetSystem.  If retval is positive, the call succeeded.
% If retval is negative, it represents an error code.  A descriptive error
% string may be obtained by calling CsMl_GetErrorString.

retval = CsMl(11, handle);

    