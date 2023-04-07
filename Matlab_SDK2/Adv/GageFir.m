% GageFir sample program
% This program demonstrates how to check if the Finite Impulse Response 
% FPGA is available on the system and how to configure it. The data is then
% captured and the FIR applied. The captured data is saved to a seperate file 
% for each channel and also displayed both as filtered and unfiltered data.

% Get rid of any other variables when we start the program 
clear;
systems = CsMl_Initialize;
CsMl_ErrorHandler(systems);

[ret, handle] = CsMl_GetSystem;
CsMl_ErrorHandler(ret);

[ret, sysinfo] = CsMl_GetSystemInfo(handle);
CsMl_ErrorHandler(ret);

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
% If we change the mode, we'll keep a copy of the original capture mode in
% old_mode in case we need it later
old_mode = acqInfo.Mode;
% Check to see which optional fpga images are available
[ret, options] = CsMl_GetExtendedOptions(handle);

% Calculate the active channel count using the original
% mode, before we add the Fir Mode constant
ChannelCount = acqInfo.Mode * sysinfo.BoardCount;

% This next part determines if FIR is available and which fpga image 
% (1 or 2) it is on. If you know that your CompuScope system has FIR 
% and the image number it is on you can skip this step and just "or" 
% (or add) the appropriate constant to the acquisition mode. The constant 
% for image 1 s 0x40000000 and for image 2 is 0x80000000.
fir = 0;
firoption = CsMl_Translate('FIR', 'Options');
if options(1).OptionConstant == firoption
    mode = acqInfo.Mode + options(1).ModeConstant;
    fir = 1;
elseif options(2).OptionConstant == firoption
    mode = acqInfo.Mode + options(2).ModeConstant;
    fir = 1;
end;

if fir == 1
    acqInfo.Mode = mode;
    ret = CsMl_ConfigureAcquisition(handle, acqInfo);
    CsMl_ErrorHandler(ret);
else
    disp('System does not support Finite Impulse Response');
    CsMl_FreeSystem(handle);
    return;
end;    

ret = CsMl_Commit(handle);
CsMl_ErrorHandler(ret);

ret = CsMl_Capture(handle);
CsMl_ErrorHandler(ret, 1, handle);

status = CsMl_QueryStatus(handle);
while status ~= 0
    status = CsMl_QueryStatus(handle);
end

transfer.Mode = CsMl_Translate('Default', 'TxMode');
transfer.Segment = 1;
[ret, acqInfo] = CsMl_QueryAcquisition(handle);
transfer.Start = -acqInfo.TriggerHoldoff;
transfer.Length = acqInfo.SegmentSize;    

% Regardless  of the Acquisition mode, numbers are assigned to channels in a 
% CompuScope system as if they all are in use. 
% For example an 8 channel system channels are numbered 1, 2, 3, 4, .. 8. 
% All modes make use of channel 1. The rest of the channels indices are evenly
% spaced throughout the CompuScope system. To calculate the index increment,
% user must determine the number of channels on one CompuScope board and then
% divide this number by the number of channels currently in use on one board.
% The latter number is lower 12 bits of acquisition mode.

MaskedMode = bitand(acqInfo.Mode, 15);
ChannelsPerBoard = sysinfo.ChannelCount / sysinfo.BoardCount;
ChannelSkip = ChannelsPerBoard / MaskedMode;

% At this point we know FIR is available because if it is not, 
% we've ended the program.

% InitializeFirStruct can also be called with a filename.
% i.e. InitializeFirStruct('test.dat'); where test.dat must be an ascii
% file consisting of a 39 on the first line, the factor on the second line,
% and 20 parameters each on a seperate line. If the first line is 39 then
% Symmetrical39th field of firstruct will be on, otherwise it is off. The
% factor must be a power of 2 between 256 and 32768.

firStruct = InitializeFirStruct;

ImageNumber = 1;
m = sysinfo.ChannelCount / 2;
n = 2;
for i = 1:ChannelSkip:sysinfo.ChannelCount 
    % enable the FIR
    firStruct.Enable = 1;
    ret = CsMl_ConfigureFir(handle, firStruct);
    CsMl_ErrorHandler(ret, 1, handle);    
    
    transfer.Channel = i;
   
    % Transfer the data
    [ret, fir_data, actual_fir] = CsMl_Transfer(handle, transfer);
    CsMl_ErrorHandler(ret, 1, handle);
    
    % disable the FIR to transfer the original raw data
    firStruct.Enable = 0;
    ret = CsMl_ConfigureFir(handle, firStruct);
    CsMl_ErrorHandler(ret, 1, handle);        
    
    % Transfer the raw data
    [ret, raw_data, actual_raw] = CsMl_Transfer(handle, transfer);
        
	% Note: to optimize the transfer loop, everything from
	% this point on in the loop could be moved out and done
	% after all the channels are transferred.
    
    % Get channel info for file header        
    [ret, chanInfo] = CsMl_QueryChannel(handle, i);                
    % Save each channel to a seperate file
    filename = sprintf('FIR_CH%d.dat', i);
    % Get information for ASCII file header 
    info.Start = actual_fir.ActualStart;
    info.Length = actual_fir.ActualLength;
    info.SampleSize = acqInfo.SampleSize;
    info.SampleRes = acqInfo.SampleResolution;
    info.SampleOffset = acqInfo.SampleOffset;
    info.InputRange = chanInfo.InputRange;
    info.DcOffset = chanInfo.DcOffset;
    info.SegmentCount = acqInfo.SegmentCount;
    info.SegmentNumber = transfer.Segment;    
    
    % Save the channel with the filtered data
    CsMl_SaveFile(filename, fir_data, info);

    % Adjust the horizontal axis and plot the fir data 
    fir_length = size(fir_data, 2);
    xpos = actual_fir.ActualStart;
    for j = 1:fir_length
        fir_points(j) = xpos;
        xpos = xpos + 1;
    end;
    % Display the filtered and unfiltered data for this channel

    subplot(m, n, ImageNumber);
   
    plot(fir_points, fir_data);
    hold on;

    raw_length = size(raw_data, 2);

    xpos = actual_raw.ActualStart;
    for j = 1:raw_length
        raw_points(j) = xpos;
        xpos = xpos + 1;
    end;    

    plot(raw_points, raw_data, 'r');
    
    str = sprintf('Channel %d - Filtered (Blue) and Raw (Red) Data', i);
    title(str);     
    
    ImageNumber = ImageNumber + 1;
    hold off;
end;

ret = CsMl_FreeSystem(handle);