function [retval, data, actual] = CsMl_Transfer(handle, transferstruct, rawdata)
% [retval, data, actual] = CsMl_Transfer(handle, transferstruct, rawdata)
%
% CsMl_Transfer transfers data for one channel from the CompuScope system 
% uniquely identified by handle (the CompuScope system handle) to the 
% variable data.  The handle must previously have been obtained by a call 
% to CsMl_GetSystem.  
% 
% The channel must be set using the transferstruct structure.  The optional 
% rawdata parameter may be used to set whether the data are converted into 
% voltages or are returned as raw integer values that correspond to raw ADC 
% code values.  If the rawdata parameter is not present or is 0, the values 
% will be converted to voltages based on the channel's input range.  If the 
% rawdata parameters is 1, the data is returned as raw values.  The type of 
% raw value is dependent on the CompuScope board. 
% 
% If the call succeeds, retval will be positive. If the call fails, retval 
% will be a negative number which represents an error code.  A more descriptive 
% error string may be obtained by calling CsMl_GetErrorString. 
% 
% The transfer parameters are set in transferstruct.  The available fields are:
% Channel   - the Channel number from which to transfer data. 
%             CompuScope channels begin at 1
% Mode      - the transfer mode.  Use 0 for CompuScope waveform data and
%             2 for Time Stamp data.
% Segment   - the segment number to transfer. Must be 1 for Single Record 
%             acquisition.  
% Start     - the address at which to start the transfer. The trigger
%             address is represented by 0. Use a negative number to 
%             download pre-trigger data.
% Length    - the number of samples to transfer starting from the Start
%             address
%
% Please see the CompuScope MATLAB SDK documentation for more information
% on these fields.
%
% If the call was successful, the transferred data is available in the
% return variable data. An optional return variable, actual, can be used to
% return the actual start address (actual.ActualStart) and actual data length
% (actual.ActualLength) returned by the driver. The actual and requested start 
% address and actual and requested length may be different due to alignment 
% requirements in the driver. See the main example scripts to see how the
% actual addresses are used. If the mode of transfer was TimeStamp mode, 
% the tick frequency used is returned in the actual variable.

[retval, data, actual] = CsMl(12, handle, transferstruct);
if 1 > retval
    return;
end;
% If the transfer mode is Time stamp then don't convert the data
% just return
if (transferstruct.Mode == 2)
    return;
end;    

if 3 == nargin 
    if (1 == rawdata)
        return;
    end
end    
% If rawdata is not 1, or is not even passed as a parameter
% convert the data to volts
% Get the SampleResolution and SampleOffset from QueryAcqusition rather
% then from GetSystemInfo because these values might change if FPGA images
% are loaded
[ret, acq] = CsMl_QueryAcquisition(handle);
channel = transferstruct.Channel;
[ret, chan] = CsMl_QueryChannel(handle, channel);
data = (((acq.SampleOffset - double(data)) / acq.SampleResolution) * (chan.InputRange / 2000)) + (chan.DcOffset / 1000);

    
    