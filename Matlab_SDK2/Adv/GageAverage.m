% GageAverage sample program
% This program demonstrates how to check if the HW Averaging FPGA is
% available on the system and how to configure it. The cumulative data
% is transferred, divided by the number of captures and saved to a 
% seperate file for each channel. The averaged data is also displayed.

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
% This is especially important so CsMl_QueryAcquisition will return
% the right values. 

% For averaging on a memoryless CompuScope system, if parameters are 
% changed and CsMl_Commit is called now, the SegmentCount should be 
% set to 1. After, when CsMl_Commit is called again to turn on averaging, 
% the SegmentCount can be set to any valid value.

% We'll query the driver for the acquisition
% parameters so we know the mode before we change it to use
% the extended options. If you're using
[ret, acqInfo] = CsMl_QueryAcquisition(handle);
% If we change the mode, we'll keep a copy of the original capture mode in
% old_mode in case we need it later
old_mode = acqInfo.Mode;
% Check to see which optional fpga images are available
[ret, options] = CsMl_GetExtendedOptions(handle);

% This next part determines if HW Averaging is available 
% and which fpga image (1 or 2) it is on. If you know that your CompuScope
% system has HW averaging and the image you can skip this step and just
% "or" (or add) the appropriate constant to the acquisition mode. The
% constant for image 1 is 0x40000000 and for image 2 is 0x80000000.
average = 0;
averageoption = CsMl_Translate('Averaging', 'Options');
if options(1).OptionConstant == averageoption
    mode = acqInfo.Mode + options(1).ModeConstant;
    average = 1;
elseif options(2).OptionConstant == averageoption
    mode = acqInfo.Mode + options(2).ModeConstant;
    average = 1;
else
    % If HW averaging is not available, check if
    % software averaging is.
    disp('System does not support HW Averaging');
    disp('Trying software averaging');
    capsid = CsMl_Translate('Modes', 'Caps');
    [ret, modes] = CsMl_GetSystemCaps(handle, capsid);
    % If we fail the call or sw averaging is not available
    % then just do a regular capture
    if ret >= 1
        modesize = size(modes, 2);
        swaveragemode = CsMl_Translate('Software Averaging', 'Mode');
        for i = 1:modesize
            if modes(i).Mode == swaveragemode
                average = 1;
                % we have software averaging so "or" (or add) the Software
                % Averaging constant (0x1000) to the mode.
                mode = acqInfo.Mode + swaveragemode;
                break;
            end;
        end;    
    end;
end;    
if average == 1
    acqInfo.Mode = mode;
    acqInfo.SegmentCount = 100; % Number of captures to perform
    ret = CsMl_ConfigureAcquisition(handle, acqInfo);
    CsMl_ErrorHandler(ret);
    % Averaging transfers used 32 bit mode.
    transfer.Mode = CsMl_Translate('DATA32', 'TxMode');
else
    disp('System does not support HW or SW averaging');
    ret = CsMl_FreeSystem(handle);
    return;
end;    

ret = CsMl_Commit(handle);
CsMl_ErrorHandler(ret);

% Get info that we'll need later on for the file header
[ret, acqInfo] = CsMl_QueryAcquisition(handle);

ret = CsMl_Capture(handle);
CsMl_ErrorHandler(ret, 1, handle);

status = CsMl_QueryStatus(handle);
while status ~= 0
    status = CsMl_QueryStatus(handle);
end

transfer.Segment = 1;
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
xaxis = MaskedMode;
yaxis = sysinfo.BoardCount;

% If we have more than 4 channels in the x-axis, let's increase
% the number of rows so it looks better.
if xaxis > 4
    xaxis = xaxis / 2;
    yaxis = yaxis * 2;
end;

ImageNumber = 1;

for i = 1:ChannelSkip:sysinfo.ChannelCount
    transfer.Channel = i;
    % Transfer the data
    
    % In this sample we are transferring the raw data (which is co-added)
    % and doing the conversion to voltages ourselves. In the conversion we
    % are also dividing the data by the number of averages to end up with
    % the averaged data. Otherwise, our Dc offset would be wrong.
    % Alternatively, we could transfer the data back as voltages (by not
    % using the last 1 in CsMl_Transfer), but we would have to multiply the
    % Dc offset by the number of averages when (and if) we converted the
    % data to voltages
    
    [ret, raw_data, actual] = CsMl_Transfer(handle, transfer, 1);
    CsMl_ErrorHandler(ret, 1, handle);

	% Note: to optimize the transfer loop, everything from
	% this point on in the loop could be moved out and done
	% after all the channels are transferred.    
    
     % Get channel info for file header        
    [ret, chanInfo] = CsMl_QueryChannel(handle, i);            

    % Convert to volts and divide by the number of averages
    data = (((acqInfo.SampleOffset - double(raw_data / acqInfo.SegmentCount)) / acqInfo.SampleResolution) * (chanInfo.InputRange / 2000)) + (chanInfo.DcOffset / 1000);    

    % Save each channel to a seperate file
    
    filename = sprintf('Average_CH%d.dat', i);
    % Get information for ASCII file header    
    info.Start = actual.ActualStart;
    info.Length = actual.ActualLength;
    info.SampleSize = acqInfo.SampleSize;
    info.SampleRes = acqInfo.SampleResolution;
    info.SampleOffset = acqInfo.SampleOffset;
    info.InputRange = chanInfo.InputRange;
    info.DcOffset = chanInfo.DcOffset;
    info.SegmentCount = acqInfo.SegmentCount;
    info.GroupNumber = 0; % Only averaging has the group number as 0
    
    CsMl_SaveFile(filename, data, info);

    % Adjust the horizontal axis and plot the data
    length = size(data, 2);
    xpos = actual.ActualStart;
    for j = 1:length
        points(j) = xpos;
        xpos = xpos + 1;
    end;
    subplot(yaxis, xaxis, ImageNumber); 
    plot(points, data);
    str = sprintf('Channel %d', i);
    title(str);    
    ImageNumber = ImageNumber + 1;
end;

ret = CsMl_FreeSystem(handle);