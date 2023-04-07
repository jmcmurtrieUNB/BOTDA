function [retval, options] = CsMl_GetExtendedOptions(handle)
% [retval, options] = CsMl_GetExtendedOptions(handle)
%
% Extended options are optional programmed firmware images.  
% CsMl_GetExtendedOptions returns information about the optional programmed 
% firmware images available on the CompuScope system uniquely identified by 
% handle (the CompuScope system handle).  The handle must previously have been 
% obtained by calling CsMl_GetSystem.  If the call succeeds, retval will be 
% positive.  If the call fails, retval will be a negative number, which 
% represents an error code.  A descriptive error string may be obtained by 
% calling CsMl_GetErrorString.  
% 
% The extended option information is returned in the options structure.  
% The number of options elements is equal to the number of optional programmed 
% firmware images.
%
% The information available for the firmware images in options is:
% Image             - the image number, either 1 or 2.
% Option            - a string variable that describes an optional eXpert FPGA 
%                     data processing image (currently Signal Averaging,
%                     Finite Impulse Response, Peak Detection, Cascaded
%                     Streaming, Multiple Record Averaging, Storage Media
%                     Testing, 512 FFT, 1K FFT, 2K FFT or 4K FFT). If no 
%                     eXpert image is available, then the Option field will 
%                     be set to None.
% OptionConstant    - a constant that corresponds to the image.
% ModeConstant      - a constant that is bitwise ORed with the Acquisition Mode 
%                     (in CsMl_ConfigureAcquisition) to load the optional image.


[retval, options] = CsMl(19, handle);

    