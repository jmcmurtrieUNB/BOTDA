function [retval] = CsMl_SetMulrecAverageCount(handle, avgcount)
% retval = CsMl_SetMulrecAverageCount(handle, avgcount)
%
% CsMl_SetMulrecAverageCount sets the number of multiple record averages for the 
% CompuScope system uniquely identified by handle (the CompuScope system 
% handle).  The handle must previously have been obtained by calling 
% CsMl_GetSystem.  If the call succeeds, retval will be positive.  If the call 
% fails, retval will be a negative number, which represents an error code.  
% A descriptive error string may be obtained by calling CsMl_GetErrorString.  
% 
% The avgcount parameter holds the value of the number of averages to
% perform for each multiple record segment.  This number is not validated
% in the driver until CsMl_Commit is called executed.
%
% The CompuScope system must have the Multiple Record Averaging expert
% firmware enabled for this call to execute properly.

[retval] = CsMl(25, handle, avgcount);


    