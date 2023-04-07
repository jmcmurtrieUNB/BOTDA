function [retval] = CsMl_ConfigureChannel(handle, chanstruct)
% retval = CsMl_ConfigureChannel(handle, chanstruct)
%
% CsMl_ConfigureChannel sets the channel parameters for the CompuScope system 
% uniquely identified by handle (the CompuScope system handle).  The handle must 
% previously have been obtained by calling CsMl_GetSystem. 
% If the call succeeds, retval will be positive.  If the call fails, retval will 
% be a negative number, which represents an error code.  A descriptive error 
% string may be obtained by calling the function CsMl_GetErrorString.  
% 
% The Channel parameters are set using chanstruct, which may be a structure or 
% an array of structures for multiple channel configuration.  The channel field 
% in the structure is mandatory.  Any other parameters that are not set in 
% chanstruct are not changed in the driver.  Note that the parameter settings 
% are not passed to the CompuScope hardware until CsMl_Commit is called.  
% Furthermore, invalid parameter values are not caught until CsMl_Commit is 
% called.
%
% The fields of chanstruct can include:
% Channel       - the Channel to set. CompuScope channels begin at 1
% Coupling      - a value indicating the coupling of the channel, either 
%                 DC or AC. Use CsMl_Translate to translate a descriptive 
%                 string into its corresponding index value.
% DiffInput     - flag to turn on (1) or off (0) differential input
% InputRange    - full scale input range in mV (e.g. +/1 volt = 2000)
% Impedance     - input impedance of the channel in Ohms (50 or 1000000)
% DcOffset      - voltage (in mV) by which to offset the midpoint of the 
%                 input range
% DirectAdc     - flag to turn on (1) or off (0) direct ADC if available
% Filter        - 1 turns on filter, 0 turns filter off (0 is default)

[retval] = CsMl(5, handle, chanstruct);


    
