function [retval] = CsMl_ConfigureAcquisition(handle, acqstruct)
% retval = CsMl_ConfigureAcquisition(handle, acqstruct)
%
% CsMl_ConfigureAcquisition sets the acquisition parameters for the CompuScope 
% system uniquely identified by handle (the CompuScope system handle).  
% The handle must previously have been obtained by calling CsMl_GetSystem.
% If the call succeeds, retval will be positive.  If the call fails, retval will 
% be a negative number, which represents an error code.  A descriptive error 
% string may be obtained by calling the function CsMl_GetErrorString.  
% 
% The acquisition parameters are set using acqstruct.  Any parameters that are 
% not set in acqstruct are not changed in the driver.  Note that the parameter 
% settings are not passed to the CompuScope hardware until CsMl_Commit is called.  
% Furthermore, invalid parameter values are not caught until CsMl_Commit is 
% called.
%
% The fields of acqstruct can include:
%   SampleRate      - the rate at which to digitize the waveform
%   ExtClock        - a flag to set external clocking on (1) or off (0)
%   Mode            - acquisition mode (1 = Single, 2 = Dual, 4 = Quad, 8 = Octal)
%   SegmentCount    - the number of segments to acquire
%   Depth           - post-trigger depth, in samples
%   SegmentSize     - post and pre-trigger depth
%   TriggerTimeout  - how long to wait before forcing a trigger (in
%                     microseconds). A value of -1 means wait indefinitely.
%   TriggerHoldoff  - the amount of ensured pre-trigger data in samples
%   TriggerDelay    - how long to delay the start of the depth counter
%                     after the trigger event has occurred, in samples
%   TimeStampConfig - the values for time stamp configuration


[retval] = CsMl(4, handle, acqstruct);


    