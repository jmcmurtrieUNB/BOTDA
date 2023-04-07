function [retval] = CsMl_Commit(handle, varargin)
% retval = CsMl_Commit(handle, version)
%
% CsMl_Commit sends the acquisition, channel and trigger parameters
% that are in the driver (either the default parameters or those set
% by calls to CsMl_ConfigureAcquisition, CsMl_ConfigureChannel or 
% CsMl_ConfigureTrigger) to the CompuScope system uniquely identified 
% by handle.  The handle must previously have been obtained 
% by calling CsMl_GetSystem.  If retval is positive, the call succeeded.
% If retval is negative, it represents an error code.  A descriptive error
% string may be obtained by calling CsMl_GetErrorString.  
%
% The varargin parameter is optional.  If used, it must be a structure 
% containing a Coerce field and / or an OnChange field.  If the Coerce field 
% is 1, any parameters that are invalid for the CompuScope system will be 
% coerced to valid ones.  If it is 0, they will not be coerced and an error 
% is returned in the event of invalid parameters.  If OnChange is 1, CsMl_Commit 
% will only send values to the CompuScope hardware if they have changed.  
% If it is 0, the values are sent to the CompuScope hardware regardless 
% of whether they have changed.  If the structure is not used, the default values 
% are Coerce = 0 and OnChange = 1.

retval = CsMl(7, handle, varargin);

    