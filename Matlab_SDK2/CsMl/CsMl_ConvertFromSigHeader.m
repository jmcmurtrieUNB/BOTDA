function [retval, sigstruct, comment, name] = CsMl_ConvertFromSigHeader(sigheader)
% [retval, sigstruct, comment, name] = CsMl_ConvertFromSigHeader(sigheader)
%
% CsMl_ConvertFromSigHeader reads a GageScope signal (sig) file header
% passed as a parameter and returns a sigstruct structure (described below)
% containing the relevant information in the header. The comment and name
% fields of the header are returned as strings in the comment and name
% parameters.  The sigheader structure passed to the function is an array
% of 512 int8's read from the beginning of the sig file. Note that the
% fread function will return the values as doubles and the array should be
% cast to int8 before passing it to this function.
%
% If retval is positive, the call succeeded. If retval is negative, it 
% represents an error code.  A descriptive error string may be obtained by 
% calling CsMl_GetErrorString.  
% 
% The available fields in sigStruct are:
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
% TimeStamp     - an array of 4 uInt16's containing (in order), hour,
%                 minute, second and 100ths of a second. 

[retval, sigstruct, comment, name] = CsMl(40, sigheader);    