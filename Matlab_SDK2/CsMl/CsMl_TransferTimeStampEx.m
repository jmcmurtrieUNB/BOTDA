function [retval, data] = CsMl_TransferTimeStampEx(handle, start, count)
% [retval, data] = CsMl_TransferTimeStampEx(handle, start, count)
%
% CsMl_TransferTimeStampEx transfers time stamp data for any, or all, 
% segments in a multiple record capture by the CompuScope system uniquely 
% identified by handle (the CompuScope system handle) to the variable data.  
% The handle must previously have been obtained by a call o CsMl_GetSystem.  
% 
% If the call succeeds, retval will be positive. If the call fails, retval 
% will be a negative number which represents an error code.  A more descriptive 
% error string may be obtained by calling CsMl_GetErrorString. 
% 
% The start parameter specifies the segment to start retrieving time stamp
% data for.  The count parameter is the number of segments to retrieve time
% stamp data for, beginning from start. 
%
% If the call was successful, the variable data (an array of doubles) will 
% contain time stamp information (in microseconds) for each of requested 
% segments.  The start segment information will be in data(1), etc. The
% values indicate the time that has elpased, in microseconds, between the
% trigger time stamp for the corresponding segment and the last reset of
% the time stamping counter.

[retval, data] = CsMl(42, handle, start, count);

    
    