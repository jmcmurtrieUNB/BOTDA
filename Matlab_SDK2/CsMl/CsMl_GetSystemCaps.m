function [retval, caps] = CsMl_GetSystemCaps(handle, capsid)
% [retval, caps] = CsMl_GetSystemCaps(handle, capsid)
%
% CsMl_GetSystemCaps returns information about the capabilities of the 
% CompuScope system uniquely identified by handle (the CompuScope system handle).
% The system handle must previously have been obtained by calling CsMl_GetSystem. 
% While complicating a MATLAB program, this function may be used to allow the 
% program to support any possible configuration of CompuScope hardware.  MATLAB 
% SDK Main M files do not use this function.
% 
% The capsid parameter is an integer used to refer to different capability types
% when communicating with the driver. The capsid integers can be obtained by 
% using CsMl_Translate.  
% 
% The available capabilities (and their integer constants) are available from
% the file CsDefines.h (in hexadecimal), which is installed with the CompuScope driver.
%
% Note that for channel capabilities (InputRanges, Impedances, Couplings
% and Terminations), the value should be ORed with the channel of interest,
% i.e. 1 for Channel 1, 2 for Channel 2, etc. A 0 for the channel will
% return information about the external trigger.  BoardTriggerEngines will 
% return the number of trigger engines per board in the system.  FlexibleTrigger
% will return whether or not the system supports triggers from any board.
% If the call succeeds, retval will be positive and the requested information 
% is returned in the return structure caps.  The size of this structure will 
% depend on what information has been requested.  If the call fails, retval 
% will be a negative number, which represents an error code.  A descriptive 
% error string may be obtained by calling CsMl_GetErrorString. 

[retval, caps] = CsMl(17, handle, capsid);

    