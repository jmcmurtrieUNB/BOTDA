function [retval] = CsMl_ConfigureTrigger(handle, trigstruct)
% retval = CsMl_ConfigureTrigger(handle, trigstruct)
%
% CsMl_ConfigureTrigger sets the trigger parameters for the CompuScope system 
% uniquely identified by handle (the CompuScope system handle).  
% The handle must previously have been obtained by calling CsMl_GetSystem.  
% If the call succeeds, retval will be positive.  If the call fails, retval 
% will be a negative number, which represents an error code.  
% A descriptive error string may be obtained by calling CsMl_GetErrorString.  
% 
% The trigger parameters are set using trigstruct, which may be a structure or 
% an array of structures for multiple trigger engine usage.  The trigger field 
% in the structure is mandatory.  Any other parameters that are not set in 
% trigstruct will not be changed in the driver.  Note that the parameter 
% settings are not passed to the CompuScope hardware until CsMl_Commit is called.  
% Furthermore, invalid parameter values are not caught until CsMl_Commit is 
% called. 
%
% The fields of trigstruct can include:
% Trigger       - the trigger engine to set. Trigger numbers start at 1
% Slope         - a value indicating the slope that causes a trigger event 
%                 to occur. Use CsMl_Translate to translate a descriptive 
%                 string into its corresponding index value.
% Level         - the level (in % of full-scale) at which a trigger occurs
% Source        - a value that sets the trigger source (e.g. External (-1), 
%                 Disable (0), 1, 2, 3, etc.). Use CsMl_Translate to translate 
%                 a descriptive string into its corresponding index value.
% ExtCoupling   - a value that sets the coupling for external trigger input 
%                 (DC or AC). Use CsMl_Translate to translate a descriptive 
%                 string into its corresponding index value. Note that
%                 Channel numbers are just numbers (1, 2, 3, etc) not
%                 names.
% ExtRange      - the external trigger input range in full-scale millivolts
%                 (e.g. 10000 = +/- 5 volt range).
% ExtImpedance	- the external trigger impedance in Ohms. Set 1000000 for HiZ

[retval] = CsMl(6, handle, trigstruct);
    