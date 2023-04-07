% GageMulrecAveraging.m sample progam
% This sample program demonstrates how to do a multiple record capture. The
% system's acquistion, channel and trigger parameters are set. The data is
% captured and retrieved and the data for each channel and multiple segment
% is saved to a separate file.

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
% If we change the mode, we'll keep a copy of the original capture mode in
% old_mode in case we need it later
old_mode = acqInfo.Mode;
% Check to see which optional fpga images are available
[ret, options] = CsMl_GetExtendedOptions(handle);

% Calculate the active channel count using the original
% mode, before we add the MulRec Averaging constant
ChannelCount = acqInfo.Mode * sysinfo.BoardCount;

% This next part determines if multiple record averaging  is available
% and which fpga image (1 or 2) it is on. If you know that your CompuScope 
% system has multiple record averaging and which image it is on you can 
% skip this step and just "or" (or add) the appropriate constant to the 
% acquisition mode. The constant for image 1 is 0x40000000 and for image 2 
% is 0x80000000.

mulrecavg_option = CsMl_Translate('mulrec averaging', 'Options');
if options(1).OptionConstant == mulrecavg_option
    mode = acqInfo.Mode + options(1).ModeConstant;
elseif options(2).OptionConstant == mulrecavg_option
    mode = acqInfo.Mode + options(2).ModeConstant;
else
    % system does not support mulrec averaging with TD, we'll try
    % regular mulrec averaging which has a value of 16
    disp('System does not support Multiple Record Averaging TD');
    disp('Trying to load Multiple Record Averaging');
    if options(1).OptionConstant == 16
        mode = acqInfo.Mode + options(1).ModeConstant;
    elseif options(2).OptionConstant == 16
        mode = acqInfo.Mode + options(2).ModeConstant;
    else
        disp('System does not support Multiple Record Averaging');
        CsMl_FreeSystem(handle);
    return;    
end;

acqInfo.Mode = mode;
% Set the number of multiple record captures.  This is done by setting the
% SegmentCount in acqInfo. The default is 1 (no multiple record).
acqInfo.SegmentCount = 5;
acqInfo.Depth = 1024;
acqInfo.SegmentSize = 1024;

ret = CsMl_ConfigureAcquisition(handle, acqInfo);
CsMl_ErrorHandler(ret);

% Set the number of averages to do per multiple record segment
CsMl_SetMulrecAverageCount(handle, 5);
ret = CsMl_Commit(handle);
CsMl_ErrorHandler(ret, 1, handle);
% If you are coercing the commit (we're not doing that here), you 
% should call CsMl_GetMulrecAveraging afterwards if you need to 
% know whether or not the driver has coerced it.
averagecount = CsMl_GetMulrecAverageCount(handle);

[ret, acqInfo] = CsMl_QueryAcquisition(handle);

ret = CsMl_Capture(handle);
CsMl_ErrorHandler(ret, 1, handle);

status = CsMl_QueryStatus(handle);
while status ~= 0
   status = CsMl_QueryStatus(handle);
end

% Multiple record average transfers should always be done in 32 bit mode
transfer.Mode = CsMl_Translate('DATA32', 'TxMode');
transfer.Start = -acqInfo.TriggerHoldoff;
transfer.Length = acqInfo.SegmentSize;    

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

% Format a string with the number of segments and channels so all filenames
% have the same number of characters.
format_string = sprintf('%d', acqInfo.SegmentCount);
MaxSegmentNumber = length(format_string);
format_string = sprintf('%d', sysinfo.ChannelCount);
MaxChannelNumber = length(format_string);
format_string = sprintf('%%s_CH%%0%dd-%%0%dd.dat', MaxChannelNumber, MaxSegmentNumber);

for channel = 1:ChannelSkip:sysinfo.ChannelCount
    transfer.Channel = channel;
    % Get channel info for file header    
    [ret, chanInfo] = CsMl_QueryChannel(handle, channel);            
    CsMl_ErrorHandler(ret, 1, handle);

    for i = 1:acqInfo.SegmentCount
        transfer.Segment = i;
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
    
        % Convert to volts and divide by the number of averages
%       data = (((acqInfo.SampleOffset - double(raw_data / averagecount)) / acqInfo.SampleResolution) * (chanInfo.InputRange / 2000)) + (chanInfo.DcOffset / 1000);    
        data = (((acqInfo.SampleOffset - double(raw_data) / double(averagecount)) / acqInfo.SampleResolution) * (chanInfo.InputRange / 2000)) + (chanInfo.DcOffset / 1000);    
     
        % Adjust the size so only the actual length of data is saved to the
        % file
        length = size(data, 2);
        if length > actual.ActualLength
            data(actual.ActualLength:end) = [];
            length = size(data, 2);
        end;                

        % Get information for ASCII file header
        info.Start = actual.ActualStart;
        info.Length = actual.ActualLength;
        info.SampleSize = acqInfo.SampleSize;
        info.SampleRes = acqInfo.SampleResolution;
        info.SampleOffset = acqInfo.SampleOffset;
        info.InputRange = chanInfo.InputRange;
        info.DcOffset = chanInfo.DcOffset;
        info.SegmentCount = acqInfo.SegmentCount;
        info.SegmentNumber = i;
        % There's no time stamp info with multiple record averaging
        info.TimeStamp = 0;

        filename = sprintf(format_string, 'MulRecAveraging', transfer.Channel, i);
        CsMl_SaveFile(filename, data, info);
    end;
end;    

ret = CsMl_FreeSystem(handle);
