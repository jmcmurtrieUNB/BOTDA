function [retval] = CsMl_GetMulrecAverageCount(handle)
% retval = CsMl_GetMulrecAverageCount(handle)
%
% CsMl_GetMulrecAverageCount retrieves the number of multiple record averages 
% that has been set for the CompuScope system uniquely identified by handle 
% (the CompuScope system handle).  The handle must previously have been obtained 
% by calling CsMl_GetSystem.  If the call succeeds, retval will be positive.  
% This value will be the number of averages that has been set in the
% firmware. If the call fails, retval will be a negative number, which represents 
% an error code.  A descriptive error string may be obtained by 
% calling CsMl_GetErrorString.  
%
% The CompuScope system must have the Multiple Record Averaging expert
% firmware enabled for this call to execute properly.


[retval] = CsMl(26, handle);


    