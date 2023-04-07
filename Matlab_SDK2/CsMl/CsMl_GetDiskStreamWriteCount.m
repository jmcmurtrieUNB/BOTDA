function [retval] = CsMl_GetDiskStreamWriteCount(handle)
% retval = CsMl_GetDiskStreamWriteCount(handle)
%
% CsMl_GetDiskStreamWriteCount returns the number of files that
% have been written so far by the CompuScope system uniquely identified
% by handle. The handle must previously have been obtained by calling 
% CsMl_GetSystem. Because the file saving is occurring in a 
% seperate thread, the actual value reported may have changed by the
% time the amount is reported.

retval = CsMl(35, handle);

