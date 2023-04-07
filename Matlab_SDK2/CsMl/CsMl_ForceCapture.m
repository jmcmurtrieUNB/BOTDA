function [retval] = CsMl_ForceCapture(handle)
% retval = CsMl_ForceCapture(handle)
%
% CsMl_ForceCapture forces a trigger event to occur on the CompuScope 
% system uniquely identified by handle.  The handle must previously have 
% been obtained by calling CsMl_GetSystem.  If retval is positive, the call 
% succeeded.  If retval is negative, it represents an error code.  
% A descriptive error string may be obtained by calling CsMl_GetErrorString.

retval = CsMl(10, handle);

    