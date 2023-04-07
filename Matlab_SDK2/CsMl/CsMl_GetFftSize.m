function [retval] = CsMl_GetFftSize(handle)
% retval = CsMl_GetFftSize(handle)
%
% CsMl_GetFftSize retrieves the size of the fast fourier transform
% that can be done on the firmware that in the CompuScope system uniquely 
% identified by handle (the CompuScope system handle).  The handle must 
% previously have been obtained by calling CsMl_GetSystem.  If the call 
% succeeds, retval will be positive.  
% This value will be the size of the fft that can be caclulate by the
% firmware. If the call fails, retval will be a negative number, which represents 
% an error code.  A descriptive error string may be obtained by 
% calling CsMl_GetErrorString.  
%
% The CompuScope system must have the FFT expert fimware loaded and
% enabled for this call to execute properly.

[retval] = CsMl(27, handle);


    