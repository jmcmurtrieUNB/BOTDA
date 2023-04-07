function [retval] = CsMl_GetDiskStreamStatus(handle, time_to_wait_in_ms)
% retval = CsMl_GetDiskStreamStatus(handle, time_to_wait_in_ms)
%
% CsMl_GetDiskStreamStatus returns the status of the current DiskStream
% acquisition on the CompuScope system uniquely defined by handle. The 
% handle must previously have been obtained by calling CsMl_GetSystem.  
%
% A return value of 1 indicates that the current requested 
% number of acquistions, transfers and writes are finished. A 0 indicates 
% that the system is not finished.  The optional time_to_wait_in_ms parameter 
% is the number of milliseconds to wait before returning the result. A longer
% wait time may make the overall system more responsive, while a shorter 
% wait time is more accurate.  If the paramete is not used, a default value
% of 0 is used.

if 1 == nargin
    retval = CsMl(33, handle);
else
    retval = CsMl(33, handle, time_to_wait_in_ms);
end;


