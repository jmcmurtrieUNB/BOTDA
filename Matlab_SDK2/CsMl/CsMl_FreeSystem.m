function [retval] = CsMl_FreeSystem(handle)
% retval = CsMl_FreeSystem(handle)
%
% CsMl_FreeSystem frees the CompuScope system uniquely identified 
% by handle.  The handle must previously have been obtained by
% calling CsMl_GetSystem.  If retval is positive, the call succeeded.  
% If retval is negative, it represents an error code.  
%
% Once a system is freed, it may be used by other applications.

retval = CsMl(2, handle);

    