function [retval] = CsMl_GetDiskStreamError(handle)
% retval = CsMl_GetDiskStreamError(handle)
%
% CsMl_GetDiskStreamError is used to report errors that occur during
% the acquisition, transfer or saving of a DiskStream acquisition on the
% CompuScope system uniquely described by handle. The handle must previously have 
% been obtained by calling CsMl_GetSystem.  
%
% Because the acquisition, transfer and file saving are done by seperate threads,
% it is difficult to report the error immediately.  Therefore, the errors
% are saved and can be retrieved by this function after CsMl_StopDiskStream
% has been called or the acquistion has otherwise completed. This function
% should be called before calling CsMl_CloseDiskStream. An error code is
% returned in retval, and a descriptive error message can be obtained by
% calling CsMl_GetErrorString. In the case of multiple errors, only the 
% first error is returned.  This function is intended for the case where
% errors are occurring and the other CsMl_DiskStream functions are not
% returning errors.

retval = CsMl(37, handle);

