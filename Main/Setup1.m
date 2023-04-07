function [ret] = Setup1(handle,SampleNum,AVGNum)
% Set the acquisition, channel and trigger parameters for the system and
% calls ConfigureAcquisition, ConfigureChannel and ConfigureTrigger.

[ret, sysinfo] = CsMl_GetSystemInfo(handle);
CsMl_ErrorHandler(ret, 1, handle);

acqInfo.SampleRate = 1e9;
acqInfo.ExtClock = 0;
acqInfo.Mode = CsMl_Translate('Single', 'Mode');
acqInfo.SegmentCount = AVGNum;
acqInfo.Depth =SampleNum-2048;%samples after trigger
acqInfo.SegmentSize = SampleNum;%total number of samples
acqInfo.TriggerTimeout = -1;
acqInfo.TriggerHoldoff = 2048;%samples saved before trigger
acqInfo.TriggerDelay = 0;
acqInfo.TimeStampConfig = 1;

[ret] = CsMl_ConfigureAcquisition(handle, acqInfo);
CsMl_ErrorHandler(ret, 1, handle);




% Set up all the channels even though
% they might not all be used. For example
% in a 2 board master / slave system, in single channel
% mode only channels 1 and 3 are used.
for i = 1:sysinfo.ChannelCount
    chan(i).Channel = i;
    chan(i).Coupling = CsMl_Translate('AC', 'Coupling');
    chan(i).DiffInput = 0;
    chan(i).InputRange = 100;%100
    chan(i).Impedance = 50;
    chan(i).DcOffset = 0;
    chan(i).DirectAdc = 0;
   chan(i).Filter = 1; 
end;   

[ret] = CsMl_ConfigureChannel(handle, chan);
CsMl_ErrorHandler(ret, 1, handle);

trig.Trigger = 1;
trig.Slope = CsMl_Translate('Positive', 'Slope');
trig.Level = 50;
trig.Source = -1;
 
 trig.ExtCoupling = CsMl_Translate('DC', 'ExtCoupling');
% trig.ExtRange = 10000;

[ret] = CsMl_ConfigureTrigger(handle, trig);
CsMl_ErrorHandler(ret, 1, handle);

ret = 1;
