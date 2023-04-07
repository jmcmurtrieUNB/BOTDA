function [retval, coherentgain] = CsMl_ConfigureFftWindow(handle, coefficients)
% [retval, coherentgain] = CsMl_ConfigureFftWindow(handle, coefficients)
%
% CsMl_ConfigureFftWindow sets the FFT window coefficients for the 
% CompuScope system uniquely identified by handle (the CompuScope system 
% handle).  The handle must previously have been obtained by calling 
% CsMl_GetSystem.  If the call succeeds, retval will be positive.  If the call 
% fails, retval will be a negative number, which represents an error code.  
% A descriptive error string may be obtained by calling CsMl_GetErrorString. If
% one of the parameters is wrong, but does not cause a driver error, the
% m-file will be halted and a descriptive message output to the Matlab
% console.  Note that the CompuScope system must have FFT firmware
% avalailable and it must have been enabled by calling CsMl_ConfigureFft
% for this function to work properly.  Also, fftstruct.Window must be set
% to 1 for this function to work correctly, otherwise an error will occur.
% 
% The window coefficients can be obtained by using one of the Matlab
% windowing functions (i.e. hamming, hanning, etc). The number of elements
% in the array should be equal to the size of the fft (which can be
% obtained by calling CsMl_GetFftSize.m). Coefficients are scaled by 8191 since
% we are doing a 14-bit FFT.
% 
% The coherentgain is the average of the coefficients and is used in 
% CsMl_DecodeFftBlock.

coherentgain = sum(coefficients) / length(coefficients);
coefficients = floor(coefficients * 8191);

retval = CsMl(28, handle, coefficients);
