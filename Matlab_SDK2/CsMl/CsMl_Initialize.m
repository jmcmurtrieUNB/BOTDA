function [retval] = CsMl_Initialize()
% retval = CsMl_Initialize()
%
% CsMl_Initialize initializes a CompuScope system and is typically the 
% first CompuScope call made in a program . If the return value is 
% positive, it represents the number of CompuScope systems found.  
% If the return value is negative, it represents an error code.  
% A descriptive error string may be obtained by using CsMl_GetErrorString.

retval = CsMl(0);
