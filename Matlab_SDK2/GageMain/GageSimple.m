% GageSimple.m sample program
% This program demonstrates using the default configuration parameters of a
% CompuScope system to capture on one channel, retrieve and display 
% the captured data.

clear;
systems = CsMl_Initialize;
CsMl_ErrorHandler(systems);

[ret, handle] = CsMl_GetSystem;
CsMl_ErrorHandler(ret);

[ret, sysinfo] = CsMl_GetSystemInfo(handle);
CsMl_ErrorHandler(ret, 1, handle);

s = sprintf('-----Board name: %s\n', sysinfo.BoardName);
disp(s);

[ret, acqinfo] = CsMl_QueryAcquisition(handle);
CsMl_ErrorHandler(ret, 1, handle);

transfer.Channel = 1;
transfer.Mode = CsMl_Translate('Default', 'TxMode');
transfer.Segment = 1;
transfer.Start = -acqinfo.TriggerHoldoff; % Default should be 0
transfer.Length = acqinfo.SegmentSize;    

ret = CsMl_Capture(handle);
CsMl_ErrorHandler(ret, 1, handle);

status = CsMl_QueryStatus(handle);
while status ~= 0
    status = CsMl_QueryStatus(handle);
end

[ret, data, actual] = CsMl_Transfer(handle, transfer);
CsMl_ErrorHandler(ret, 1, handle);

if actual.ActualLength ~= 0
    data(actual.ActualLength:end) = [];
end;   
plot(data);

ret = CsMl_FreeSystem(handle);