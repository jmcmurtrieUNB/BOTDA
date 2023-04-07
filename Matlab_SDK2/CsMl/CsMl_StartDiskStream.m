function [retval] = CsMl_StartDiskStream(handle)
% retval = CsMl_StartDiskStream(handle)
%
% CsMl_StartDiskStream starts the capture, transfer and saving of 
% DiskStream acquisitions on the CompuScope system uniquely identified
% by handle. The handle must previously have been obtained by calling 
% CsMl_GetSystem.
%
% The DiskStream system must first be initialized by calling 
% CsMl_InitializeDiskStream. Because CsMl_StartDiskStream intializes 
% and starts several threads, it is often not possible to have a return 
% value if an error occurs. To retrieve an error that has occurred during 
% an acquisition, CsMl_GetDiskStreamGetError should be called after the acquistion 
% has finished, but before calling CsMl_CloseDiskStream. Errors that
% may occur before the acquisition has begun will be reported in retval.
% If the return value is negative, it represents an error code.  
% A descriptive error string may be obtained by using CsMl_GetErrorString.

retval = CsMl(32, handle);
