function [retval, filecount] = CsMl_InitializeDiskStream(handle, base_directory, channels, ds_struct)
% [retval, filecount] = CsMl_InitializeDiskStream(handle, base_directory, channels, ds_struct)
%
% CsMl_InitializeDiskStream initializes the DiskStream system and must be
% called before any of the other DiskStream functions can be used. This call
% initializes data structures and precreates the SIG files by writing the
% SIG file headers to disk. The data structures created here on deallocated
% and destroyed by calling CsMl_CloseDiskStream.
%
% The required number of SIG files are pre-created by this function to speed up
% the acquistion,  transfer and write cycle when CsMl_StartDiskStream is called.
% Files are organized as according to the transfer length as follows:
%
% 1) Transfer lengths < 1 MByte are saved together in SIG files up to 1 MByte in size.
%    For example, 4 acquistions of 512 Kbytes would be saved as 2 1 %  megabytes files.
%
% 2) Transfer lengths > 1Mbytes and < 250 Mbytes are saved in their own file.
%
% 3) Transfer lengths > 250 Megabytes are split across multiple files.
%
% If the call succeeds, retval will be positive. If the call fails, retval 
% will be a negative number which represents an error code.  A more descriptive 
% error string may be obtained by calling CsMl_GetErrorString. 
%
% The handle is a number uniquely describing a CompuScope system. It is 
% obtained by calling CsMl_GetSystem. The handle parameter is not optional 
% and must be there for the function to succeed.  The other parameters are 
% optional, but for any parameter to be used, it's preceeding parameters must
% exist as well.  
%
% The base_directory parameter is a string denoting the folder in which to 
% save the sig files. If it is not an absolute path (i.e e:\SigFiles), it 
% is assumed to be a folder beneath the current directory. If it is not used, 
% the default value is 'Signal Files'.  The channels parameter is an array
% of channels (i.e [1] for channel 1, [1, 3] for channels 1 and 3, etc.) 
% that will be transferred to files. If no array is given the default is
% channel 1.
% 
% The other parameters are set in ds_struct.  The available fields are:
% Timeout        - the timeout in milliseconds to wait for a trigger. A value 
%                  of -1 means wait infinitely. After the timeout period has 
%                  elapsed, the trigger is forced. The default value is -1.
% TransferStart  - the address at which to start the transfer. The trigger
%                  address is represented by 0. Use a negative number to 
%                  download pre-trigger data. The default is 0.
% TransferLength - the number of samples to transfer starting from the 
%                  TransferStart address. The default is 8192.
% RecordStart    - the segment number to start transferring from. Must 
%                  be 1 for Single Record acquisitions. The default is 1.
% RecordCount    - the number of segments to transfer. Must be 1 for 
%                  Single Record acquistions. The default is 1.
% AcqCount       - the number of acquisitions to make during the DiskStream
%                  process. The default is 1.
% ChannelCount	 - the number of channels to transfer and save. The first ChannelCount
%		   non-zero values of the Channels array will be used. The default
%		   value is 1.
% TimeStamp      - whether or not to write the time stamp value to the
%                  header of the SIG file. A 1 means write the time stamp, 0 means don't.
%                  The default is 1. The Time stamp will have a resolution of 100ths of
%		   a second.
%
% Please see the CompuScope MATLAB SDK documentation for more information
% on these fields.
%
% If retval is positive, the call was successful and the DiskStream structures 
% were allocated and the system is ready to use. If the call fails, retval 
% will be a negative number, which represents an error code.  A descriptive 
% error string may be obtained by calling CsMl_GetErrorString.
% If call has suceeded filecount will contain the number of file that will be created by the operation.



if 1 == nargin
    [retval, filecount] = CsMl(31, handle);
elseif 2 == nargin
    [retval, filecount] = CsMl(31, handle, base_directory);
elseif 3 == nargin
    [retval, filecount] = CsMl(31, handle, base_directory, channels);
elseif 4 == nargin
    [retval, filecount] = CsMl(31, handle, base_directory, channels, ds_struct);
end;
