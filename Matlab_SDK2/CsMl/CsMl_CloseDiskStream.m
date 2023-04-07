function [retval] = CsMl_CloseDiskStream(handle)
% retval = CsMl_CloseDiskStream(handle)
%
% CsMl_CloseDiskStream closes the DiskStream subsystem on the CompuScope
% system uniquely described by handle. The handle must previously have 
% been obtained by calling CsMl_GetSystem. 
%
% CsMl_CloseDiskStream cleans up any resources that were allocated when
% CsMl_InitializeDiskStream was called. CsMl_CloseDiskStream should be
% called after all other CsMl_DiskStream functions have been called.
% Once CsMl_CloseDiskStream is called, CsMl_InitializeDiskStream would 
% need to be called again in order to use DiskStream functionality. If 
% the return value is positive, it means the call was completed successfully. 
% If the return value is negative, it represents an error code.  A descriptive 
% error string may be obtained by using CsMl_GetErrorString.

retval = CsMl(38, handle);

