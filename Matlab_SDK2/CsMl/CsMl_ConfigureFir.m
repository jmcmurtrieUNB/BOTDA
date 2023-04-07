function [retval] = CsMl_ConfigureFir(handle, firstruct)
% retval = CsMl_ConfigureFir(handle, firstruct)
%
% CsMl_ConfigureFir sets the Finite Impulse Response parameters for the 
% CompuScope system uniquely identified by handle (the CompuScope system 
% handle).  The handle must previously have been obtained by calling 
% CsMl_GetSystem.  If the call succeeds, retval will be positive.  If the call 
% fails, retval will be a negative number, which represents an error code.  
% A descriptive error string may be obtained by calling CsMl_GetErrorString.  
% 
% The FIR parameters are set using firstruct.  Any parameters that are not set 
% in firstruct will use their defaults.  Note that the CompuScope system must 
% have an optional FIR image available and loaded for this function to work.  
% The optional images are loaded by bitwise ORing a constant to the 
% Mode when CsMl_ConfigureAcquisition is called.  The constants and their 
% availability can be determined by calling CsMl_GetExtendedOptions.  
% 
% The available fields for firstruct are:
% Enable            - either 0 or 1 to disable or enable FIR (default is 1)
% Symmetrical39th   - either 0 or 1 to not use or use symmetric coefficients
%                     (default is 1)
% Factor            - value by which to scale coefficients (default is 32768)
% Coefficients      - array of 20 FIR coefficients. Defaults are all 0


[retval] = CsMl(21, handle, firstruct);


    