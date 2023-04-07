function [retval] = CsMl_ResetTimeStamp(handle)
% retval = CsMl_ResetTimeStamp(handle)
%
% CsMl_ResetTimeStamp resets the time stamp counter associated with 
% the CompuScope system identified by handle.  The handle must have 
% previously been obtained by calling CsMl_GetSystem.  Subsequent time 
% stamp values will be measured with respect to the time of the reset event. 
% The time stamp counter should be reset at the beginning of program execution 
% to clear any initial large counter values.  If retval is positive, the call 
% succeeded.  If retval is negative, it represents an error code.  
% A descriptive error string may be obtained by calling CsMl_GetErrorString.

retval = CsMl(18, handle);

    