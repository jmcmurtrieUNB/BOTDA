function [retval, data, out] = CsMl_TransferEx(handle, transferstruct)
% [retval, data, out] = CsMl_Transfer(handle, transferstruct)
%
% CsMl_TransferEx transfers data for the specified number of segments
% for one channel or all channels of the CompuScope system uniquely 
% dentified by handle (the CompuScope system handle) to the variable data.  
% The handle must previously have been obtained by a call to
% CsMl_GetSystem.  The variable data will hold all the data for all the
% channels and segment (possibly interleaved together).  The data can be
% extracted by calling CsMl_ExtractEx.
% 
% The channel must be set using the transferstruct structure.  A channel 
% value of 0 will transfer all available channels (depending on the system 
% and the acquisition mode).  A value of 1 or higher will transfer just
% that channel.  Note that CompuScope channels being at 1. 
%
% If the call succeeds, retval will be positive. If the call fails, retval 
% will be a negative number which represents an error code.  A more descriptive 
% error string may be obtained by calling CsMl_GetErrorString. 
% 
% The transfer parameters are set in transferstruct.  All fields must be filled 
% in with valid values. The available fields are:
% Channel       - the Channel number from which to transfer data. 
%                 CompuScope channels begin at 1. A value of 0 will
%                 transfer all available channels in the system.
% Start Segment - the segment number at which to start the transfer. Must be 
%                 at least 1.
% Segment Count - the number of segments to transfer from each channel,
%                 starting from Start Segment.
% Start         - the address at which to start the transfer. The trigger
%                 address is represented by 0. Use a negative number to 
%                 download pre-trigger data.
% Length        - the number of samples to transfer starting from the Start
%                 address.
%
% Please see the CompuScope MATLAB SDK documentation for more information
% on these fields.
%
% If the call was successful, the transferred data is available in the
% return variable data. The size of the data array will be Length * Segment 
% Count * Channels.  Depending on they system and acquisition mode, the
% data may be interleaved together.  CsMl_ExtractEx.m can be used to convert
% the data into a 3-dimensional array of either voltages or raw data. The 
% return variable out contains the actual number of channels that were
% transferred (out.ChannelCount) and the data format that was used in the
% transfer (out.DataFormat).  The data format is a hexadecimal number that
% represents the interleaving of the data.  For example, a value of
% 0x11111111 represents no interleaving, while a value of 0x11221122 means
% the data is interleaved with 2 samples of channel 1 followed by 2 samples
% of channel 2, etc. Both these values (channel count and data format) are
% used by CsMl_ExtractEx.m to convert the data.

[retval, data, out] = CsMl(41, handle, transferstruct);
if 1 > retval
    return;
end;


    
    