function [retval] = CsMl_StopDiskStream(handle)
% retval = CsMl_StopDiskStream(handle)
%
% CsMl_StopDiskStream stops the current DiskStream acquition, transfer or
% file save of the CompuScope system uniquely identified by handle, in the 
% case that it is necessary to abort before the requested number of acquistions 
% has been completed. The handle must previously have been obtained by calling 
% CsMl_GetSystem.
%
% Note that because the requested number of SIG files is pre-created during 
% CsMl_InitializeDiskStream, there will be files consisting of only a header 
% (and no data) if the acquistion is aborted early. The return value is returned 
% in retval. If the return value is positive, it represents success. If the return 
% value is negative, it represents an error code. A descriptive error 
% string may be obtained by using CsMl_GetErrorString.

retval = CsMl(36, handle);
