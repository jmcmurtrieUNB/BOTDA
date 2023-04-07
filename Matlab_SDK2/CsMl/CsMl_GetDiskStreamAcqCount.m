function [retval] = CsMl_GetDiskStreamAcqCount(handle)
% retval = CsMl_GetDiskStreamAcqCount(handle)
%
% CsMl_GetDiskStreamAcqCount returns the number of acquisitions that
% have occurred so far on the CompuScope System uniquely defined by 
% handle. The handle must previously have been obtained by calling CsMl_GetSystem.  
% Because the acquisitions are occurring in a seperate thread, the 
% actual value reported may have changed by the time the amount is reported.

retval = CsMl(34, handle);

