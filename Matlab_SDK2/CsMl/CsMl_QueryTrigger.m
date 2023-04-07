function [retval, triggerinfo] = CsMl_QueryTrigger(handle, trigger)
% [retval, triggerinfo] = CsMl_QueryTrigger(handle, trigger)
%
% CsMl_QueryTrigger returns information about the specified trigger in 
% the CompuScope system uniquely identified by handle (the CompuScope 
% system handle).  The trigger input parameter starts at 1.  
% The handle must previously have been obtained by calling CsMl_GetSystem. 
% If the call succeeds, retval will be positive.  If the call fails, 
% retval will be a negative number, which represents an error code.  
% A descriptive error string may be obtained by calling CsMl_GetErrorString.  
% 
% If the call succeeds, information about the current state of the trigger 
% parameters are returned in triggerinfo.  
% 
% The fields returned are:
% Trigger       - the trigger engine in question. Trigger numbers start at 1
% Slope         - the slope that will cause a trigger event to occur
%                 (0 = falling or negative, 1 = rising or positive)
% Level         - the trigger level (in % of full-scale) at which a 
%                 trigger occurs
% Source        - the trigger source 
%                 (External = -1, Disable = 0, Channel 1 = 1, Channel 2 = 2, etc.)
% ExtCoupling   - the coupling for external trigger (DC = 1, AC = 2)
% ExtRange      - the external trigger range in full-scale millivolts (e.g.
%                 10000 = +/- 5 volts.)
% ExtImpedance	- the external trigger impedance in Ohm. 1000000 signifies HiZ impedance

[retval, triggerinfo] = CsMl(15, handle, trigger);


    