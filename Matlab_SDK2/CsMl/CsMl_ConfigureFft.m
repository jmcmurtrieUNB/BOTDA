function [retval] = CsMl_ConfigureFft(handle, fftstruct)
% retval = CsMl_ConfigureFft(handle, fftstruct)
%
% CsMl_ConfigureFft sets the Fast Fourier Transform parameters for the 
% CompuScope system uniquely identified by handle (the CompuScope system 
% handle).  The handle must previously have been obtained by calling 
% CsMl_GetSystem.  If the call succeeds, retval will be positive.  If the call 
% fails, retval will be a negative number, which represents an error code.  
% A descriptive error string may be obtained by calling CsMl_GetErrorString.  
% 
% The FFT parameters are set using fftstruct.  Any parameters that are not set 
% in fftstruct will use their defaults.  Note that the CompuScope system must 
% have an optional FFT expert image available and loaded for this function to work.  
% The optional images are loaded by bitwise ORing a constant to the 
% Mode when CsMl_ConfigureAcquisition is called.  The constants and their 
% availability can be determined by calling CsMl_GetExtendedOptions.  
% 
% The available fields for fftstruct are:
% Enable        - set to 1 to enable or 0 to disable FFT (default is 1)
% Average       - set to 1 to set averaging or 0 to not use averaging in the firmware
%                (default is 0) Note: currently not implemented
% InverseFFT    - set to 1 to return an inverse fft (default is 0)
% bFftMulRec    - set to 1 to enable fft multiple record, 0 to disable (default is 0)
% RealOnly      - set to 1 to use only real values as input, 0 to use both real and imaginary 
%                (default is 1) Note: currently not implemented
% Window        - set to 1 to enable windowing, 0 to disable (default = 0)

% Note that windowing coefficients are set in CsMl_ConfigureFftWindow


[retval] = CsMl(29, handle, fftstruct);


    