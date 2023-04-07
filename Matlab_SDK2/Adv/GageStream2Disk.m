% GageStream2Disk sample program
% This program demonstrates how to configure a system's capture, channel
% and trigger parameters, do a capture using the DiskStream subsytem. Each
% channel's acquired data is transferred and saved to GageScope SIG files.

clear;

systems = CsMl_Initialize;
CsMl_ErrorHandler(systems);

[ret, handle] = CsMl_GetSystem;
CsMl_ErrorHandler(ret);

[ret, sysinfo] = CsMl_GetSystemInfo(handle);
CsMl_ErrorHandler(ret);

s = sprintf('-----Board name: %s\n', sysinfo.BoardName);
disp(s);

[ret, acqInfo] = CsMl_QueryAcquisition(handle);
CsMl_ErrorHandler(ret, 1, handle);

% set the Acquisition parameters here, anything that's not set
% will used the driver defaults. The channel and trigger values are
% set to the defaults.  To see how to change them, see the Setup.m file
% in the scripts\Main directory.

acqInfo.Mode = 2;
acqInfo.SegmentSize = 8192;
acqInfo.Depth = 8192;
acqInfo.SampleRate = 100000000;
acqInfo.SegmentCount = 1;

[ret] = CsMl_ConfigureAcquisition(handle, acqInfo);
CsMl_ErrorHandler(ret, 1, handle);

% commit the changes
[ret] = CsMl_Commit(handle);
CsMl_ErrorHandler(ret, 1, handle);

% the following are application specific. 
base_path = 'Signal Files';
channels = [1]; 
ds.ChannelCount = 1;
ds.Timeout = -1;
ds.TransferStart = -acqInfo.TriggerHoldoff;
ds.TransferLength = acqInfo.SegmentSize;
ds.RecordStart = 1;
ds.RecordCount = acqInfo.SegmentCount;
ds.AcqCount = 1;

[ret, filecount] = CsMl_InitializeDiskStream(handle, base_path, channels, ds);
if 1 == ret
    filecount = filecount * ds.ChannelCount;
    CsMl_StartDiskStream(handle);
    while (0 == CsMl_GetDiskStreamStatus(handle, 500))
		% The following code can be used to moniter the acquisition and write status
		% of the driver.  To optimize performance you would probably want to remove the
		% lines of code below.  Because the acquisition and write routines are 
		% seperate threads, the counts will often appear to jump instead of increment by
		% one each time.
        ac = CsMl_GetDiskStreamAcqCount(handle);
        wc = CsMl_GetDiskStreamWriteCount(handle);
        s = sprintf('Acq Count: %d out of %d \tWrite Count: %d out of %d', ac, ds.AcqCount, wc, filecount);
        disp(s);
    end;
    ac = CsMl_GetDiskStreamAcqCount(handle);
    wc = CsMl_GetDiskStreamWriteCount(handle);
    s = sprintf('\nDiskSteam complete\n\tAcq Count: %d out of %d \tWrite Count: %d out of %d', ac, ds.AcqCount, wc, filecount);
    disp(s);
    CsMl_StopDiskStream(handle); 
    ret = CsMl_GetDiskStreamError(handle);
    if ret ~= 1
	    if  ret == -9999
	        disp('File or directory error. See event log more more details.');
        else
            disp(CsMl_GetErrorString(errmsg));
        end;
    end;
    CsMl_CloseDiskStream(handle);   
else
    CsMl_ErrorHandler(ret, 1, handle);
end;    

ret = CsMl_FreeSystem(handle);
