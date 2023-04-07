% GageFft.m sample progam
% This sample program demonstrates how to use Gage's expert FFT firmware. 
% The system's acquistion, channel and trigger parameters are set. The data is
% captured and retrieved from the board as fft samples.

clear;
systems = CsMl_Initialize;
CsMl_ErrorHandler(systems);
[ret, handle] = CsMl_GetSystem;
CsMl_ErrorHandler(ret);

[ret, sysinfo] = CsMl_GetSystemInfo(handle);

s = sprintf('-----Board name: %s\n', sysinfo.BoardName);
disp(s);

% We're using the default configuration parameters 
% for this system.  If you change any of the default acquisition,
% channel or trigger parameters you will need to call CsMl_Commit 
% for the new parameters to be sent to the driver and the hardware.


% We'll query the driver for the acquisition
% parameters so we know the mode before we change it to use
% the extended options.
[ret, acqInfo] = CsMl_QueryAcquisition(handle);
acqInfo.Mode = 1;

% Check to see which optional fpga images are available
[ret, options] = CsMl_GetExtendedOptions(handle);

% Calculate the active channel count using the original
% mode, before we add the MulRec Averaging constant
ChannelCount = acqInfo.Mode * sysinfo.BoardCount;

% This next part determines if the fft firmware is available
% and which fpga image (1 or 2) it is on. If you know that your CompuScope 
% system has the fft firmware and which image it is on you can 
% skip this step and just "or" (or add) the appropriate constant to the 
% acquisition mode. The constant for image 1 is 0x40000000 and for image 2 
% is 0x80000000.


% Also, in this case we're asking for the fft option (not a specific size)
% while the OptionConstant returned from CsMl_GetExtendedOptions will be
% the constant for the particular size of the FFT that's in the firmware.
% Because of this we can't test if they're equal, we need to bitwise and them
% together and see if the result is non-zero.
fft_option = CsMl_Translate('fft', 'Options');

if bitand(options(1).OptionConstant, fft_option) ~= 0
    mode = acqInfo.Mode + options(1).ModeConstant;
elseif bitand(options(2).OptionConstant, fft_option) ~= 0
    mode = acqInfo.Mode + options(2).ModeConstant;
else
    disp('System does not support Fast Fourier Transform');
    CsMl_FreeSystem(handle);
    return;    
end;

acqInfo.Mode = mode;
fftsize = CsMl_GetFftSize(handle);

acqInfo.Depth = 8192;
acqInfo.SampleRate = 100000000;
acqInfo.SegmentSize = acqInfo.Depth + acqInfo.TriggerHoldoff;
ret = CsMl_ConfigureAcquisition(handle, acqInfo);
CsMl_ErrorHandler(ret);

ret = CsMl_Commit(handle);
CsMl_ErrorHandler(ret, 1, handle);


[ret, acqInfo] = CsMl_QueryAcquisition(handle);

ret = CsMl_Capture(handle);
CsMl_ErrorHandler(ret, 1, handle);

status = CsMl_QueryStatus(handle);
while status ~= 0
   status = CsMl_QueryStatus(handle);
end

% Configure the FFT parameters before we do the transfer

fftparam.Enable = 1;
fftparam.Window = 1;
% fftparam.FftMulRec is equal to 0 by default. If you set it to one, you must
% be doing a multiple record capture or the data will not be correct
fftparam.FftMulRec = 0;

ret = CsMl_ConfigureFft(handle, fftparam);
CsMl_ErrorHandler(ret, 1, handle);

if fftparam.Window == 1
    windowcoeff = hamming(fftsize);
    [ret, coherentgain] = CsMl_ConfigureFftWindow(handle, windowcoeff);
else
    coherentgain = 1;
end;


% FFT transfers should always be done in fft transfer mode
transfer.Mode = CsMl_Translate('fft', 'TxMode');
transfer.Start = -acqInfo.TriggerHoldoff;
% Transfer length should be at least the fft size + 1. The extra sample is
% to hold the exponent, which is stored at the end of each fft block. In
% this example we're transferring an extra 128 points.
transfer.Length = acqInfo.SegmentSize + 128;    
transfer.Segment = 1;

% Regardless  of the Acquisition mode, numbers are assigned to channels in a 
% CompuScope system as if they all are in use. 
% For example an 8 channel system channels are numbered 1, 2, 3, 4, .. 8. 
% All modes make use of channel 1. The rest of the channels indices are evenly
% spaced throughout the CompuScope system. To calculate the index increment,
% user must determine the number of channels on one CompuScope board and then
% divide this number by the number of channels currently in use on one board.
% The latter number is the lower 12 bits of the acquisition mode.

MaskedMode = bitand(acqInfo.Mode, 15);
ChannelsPerBoard = sysinfo.ChannelCount / sysinfo.BoardCount;
ChannelSkip = ChannelsPerBoard / MaskedMode;

xaxis = MaskedMode;
yaxis = sysinfo.BoardCount;

% If we have more than 4 channels in the x-axis, let's increase
% the number of rows so it looks better.
if xaxis > 4
    xaxis = xaxis / 2;
    yaxis = yaxis * 2;
end;

ImageNumber = 1;
for channel = 1:ChannelSkip:sysinfo.ChannelCount
    transfer.Channel = channel;
    [ret, data, actual] = CsMl_Transfer(handle, transfer, 1);
    CsMl_ErrorHandler(ret, 1, handle);
    
    % If multiple record is on, then the number of fft blocks is equal to the
    % segment count. If not, the number of fft blocks is the actual transfer length
    % divided by fft size + 1. The extra 1 is for the exponent for each block.
    % The fft firmware will try to fit as many fft's as it can into the
    % transfer length.

    if (acqInfo.SegmentCount > 1)
        BlockCount = acqInfo.SegmentCount;
    else
        BlockCount = floor(actual.ActualLength / fftsize);
    end;    
    
    avg_fftdata = zeros(1, fftsize / 2);
    % This example averages each block of the fft so only 1 final, averaged
    % fft is displayed per channel
    for block = 1:BlockCount
        startpoint = ((block - 1) * (fftsize + 1)) + 1;
        endpoint = startpoint + fftsize;
        datablock = data(startpoint:endpoint);
        [fftdata] = CsMl_DecodeFftBlock(1, fftsize, sysinfo.SampleBits, datablock, coherentgain);
        % convert to db's
        % next 2 lines to get rid of log10(0) warnings
        indxs = find(fftdata==0);
        fftdata(indxs) = eps;
        fftdata = 10 * log10(fftdata);
        avg_fftdata = avg_fftdata + fftdata;
    end;
    avg_fftdata = avg_fftdata / BlockCount;
    plotsize = (fftsize / 2) - 1;
    xpoints = (0:plotsize) * (acqInfo.SampleRate / fftsize);
    subplot(yaxis, xaxis, ImageNumber);    
 
    plot(xpoints, avg_fftdata);
    str = sprintf('Channel %d', channel);
    title(str); 
    xlabel('Frequency (Hz)');
    ylabel('Power (Db)');        
    ImageNumber = ImageNumber + 1;
end;    

ret = CsMl_FreeSystem(handle);
