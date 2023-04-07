function [fftdata] = CsMl_DecodeFftBlock(block, fftsize, samplebits, data, coherentgain)
% [fftdata] = CsMl_DecodeFftBlock(block, fftsize, samplebits, data, coherentgain)
%
% CsMl_DecodeFftBlock is used to convert an array of raw fft data
% (downloaded from a CompuScope system) into power spectrum values.
%
% The input parameters are:
% block        - The raw data is converted in blocks, each of which is fft size +
%                1. The extra data value is because the exponent is stored at 
%                the end of each block of data. This value is the block number
%                to convert.  Block numbers start at 1.
% fftsize      - The size of each fft block. This is determined by the FFT firmware. 
%                The size can be obtained by calling CsMl_GetFftSize.
% samplebits   - The number of bits used by the CompuScope digitizer. This
%                value can be retrieved by using CsMl_GetSystemInfo.
% data         - Buffer of raw data downloaded from the CompuScope system.
% coherentgain - If windowing is enabled, this value is the average of the
%                window coefficients. It's value can be obtained by calling
%                CsMl_ConfigureFftWindow. If windowing is not enabled, or if the 
%                parameter is not included, it's value is 1.
%
% The converted data is returned in fftdata. The size of fftdata is half of
% the fft size. If any errors occur during the conversion, the applicaltion
% will be halted and a descriptive output message will be sent to the
% MatLab console.


if 4 == nargin
    coherentgain = 1;
end;


[retval, fftdata] = CsMl(30, block, fftsize, samplebits, data, coherentgain);
