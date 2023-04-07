function [retval] = CsMl_FreeAllSystems
% retval = CsMl_FreeAllSystems
%
% CsMl_FreeAllSystems aborts any acquisitions and frees all CompuScope 
% systems that are currently in use.  This routine should be used to free all
% CompuScope system handles in the case that a program ends and the value 
% of the current CompuScope handle(s) are unknown.  If the return value is 
% positive, the function succeeded.  If the function fails, the return value 
% will be negative.  A descriptive error string may be obtained by calling 
% CsMl_GetErrorString.

retval = CsMl(20);

    