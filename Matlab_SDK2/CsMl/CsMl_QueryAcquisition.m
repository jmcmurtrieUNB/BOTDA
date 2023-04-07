function [retval, acqinfo] = CsMl_QueryAcquisition(handle)
% [retval, acqinfo] = CsMl_QueryAcquisition(handle)
%
% CsMl_QueryAcquisition returns information about the CompuScope system 
% uniquely identified by handle (the CompuScope system handle).  The handle 
% must previously have been obtained by calling CsMl_GetSystem.  If the call 
% succeeds, retval will be positive.  If the call fails, retval will be a 
% negative number, which represents an error code.  A descriptive error string 
% may be obtained by calling CsMl_GetErrorString.  
% 
% If the call is successful, information about the current state of the 
% acquisition parameters are returned in acqinfo.  
% 
% The fields returned are:
%   SampleRate      - rate at which waveforms will be digitized
%   ExtClock        - a flag which tells if external clocking is on (1) 
%                     or off (0)
%   Mode            - the current acquisition mode 
%                     (1 = Single, 2 = Dual, 4 = Quad, 8 = Octal)
%   SampleBits      - vertical resolution, in bits
%   SampleRes       - number of ADC levels between 0 Volts and + or - full scale
%   SampleSize      - size of each data sample, in bytes
%   SegmentCount    - number of multiple record segments that will be acquired
%   Depth           - post-trigger depth, in samples
%   SegmentSize     - amount of memory allocated for each segment, in samples.  
%                     Equal to the maximum total amount of pre- and post-trigger 
%                     data.
%   TriggerTimeout  - how long to wait before forcing a trigger (in
%                     microseconds). A -1 means wait indefinitely.
%   TriggerDelay    - how long to delay the start of the depth counter
%                     after the trigger event has occurred, in samples
%   TriggerHoldoff  - amount of ensured pre-trigger data, in samples
%   SampleOffset    - ADC value which represents 0 volts
%   TimeStampConfig - values for time stamp configuration

[retval, acqinfo] = CsMl(13, handle);


    