function [retval] = CsMl_QueryStatus(handle)
% retval = CsMl_QueryStatus(handle)
%
% CsMl_QueryStatus queries the driver for the current acquisition status of the 
% CompuScope system uniquely identified by handle.  The handle must previously 
% have been obtained by calling CsMl_GetSystem.
% 
% Possible return values are:
%   0 = Ready for acquisition or data transfer
%   1 = Waiting for trigger event
%   2 = Triggered but still busy acquiring
%   3 = Data transfer is in progress
%
% A negative number denotes an error condition. A descriptive error string
% may be obtained by calling CsMl_GetErrorString.

retval = CsMl(9, handle);

    