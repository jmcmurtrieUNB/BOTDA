function [retval, sigheader] = CsMl_ConvertToSigHeader(sigstruct, comment,  name)
% [retval, sigheader] = CsMl_ConvertToSigHeader(sigstruct, comment, name)
%
% CsMl_ConvertToSigHeader converts the sigstruct structure passed as a
% parameter to a GageScope SIG file header.  The fields of the sigstruct
% structure are described below.  Additionally, there are optional comment
% and name parameters.  These are strings that, if present, will be used to
% fill in the comment and name fields of the SIG file header.  If they are
% not present, default values will be used for both fields. Note that if
% the comment field is left out, the name parameter cannot be used.
%
% The returned sigheader is an array of 512 bytes represented by a 512 by 1
% matrix of bytes. This array can be directly saved to file as the header
% of a SIG file.  The captured data should be saved after the header. It is
% the user's responsibility to ensure that the values in the header match
% the data. For example, that the sample bit and sample size fields in the 
% sigstruct structure match the actual data saved, and that the
% RecordLength matches the actual amount of data saved. The fields of the
% sigstruct structure can be filled in using the corresponding values of
% the CSACQUISITIONCONFIG and CSCHANNELCONFIG structures.  If any field,
% except for Channel and TimeStamp, is missing an error will occur and the
% script will end.  No error value is returned, but an error message is 
% printed to the console.  If Channel is missing a default value of 1 is 
% used. If the time stamp field is missing, default values of 0 are used. 
%
% If retval is positive, the call succeeded. If retval is negative, it 
% represents an error code.  A descriptive error string may be obtained by 
% calling CsMl_GetErrorString.  If any fields in the sigstruct structure
% are missing, the function will fail with an error string being sent to
% the Matlab console.
% 
% The available fields in sigstruct are:
%
% SampleRate    - Sample rate value in Hz
% RecordStart   - Starting address (in samples) of each segment in the file
% RecordLength  -  Length (in samples) of each segment in the file
% RecordCount   - Number of segments saved in the file
% SampleBits    - Actual vertical resolution, in bits, of the CompuScope system
% SampleSize    - Actual sample size, in Bytes, for the CompuScope system
% SampleOffset  - Actual sample offset for the CompuScope system
% SampleRes     - Actual sample resolution for the CompuScope system
% Channel       - Channel number that is in the file. 1 corresponds to the first channel
% InputRange    - Channel full scale input range, in mV peak-to-peak
% DcOffset      - Channel DC offset, in mV
% TimeStamp     - an array of 4 doubles containing (in order), hour,
%                 minute, second and 100ths of a second. Can be obtained by using the clock
%                 funtion in Matlab


if nargin == 1
    [retval, sigheader] = CsMl(39, sigstruct);
elseif nargin == 2
    [retval, sigheader] = CsMl(39, sigstruct, comment);
else
    [retval, sigheader] = CsMl(39, sigstruct, comment, name);
end;    