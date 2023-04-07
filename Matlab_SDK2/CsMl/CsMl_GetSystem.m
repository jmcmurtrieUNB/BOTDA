function [retval, handle] = CsMl_GetSystem(varargin)
% [retval, handle] = CsMl_GetSystem(varargin)
%
% CsMl_GetSystem returns a handle that uniquely identifies a CompuScope
% system.  If retval is positive, the call succeeded and handle represents 
% a value that can be used to uniquely identify the CompuScope system for 
% other calls.  If retval is negative, it represents an error code and handle 
% will be 0.  The CsMl_GetErrorString.m script file can be used to translate 
% the error code into a descriptive string.  
% 
% The varargin parameter is an optional structure parameter that allows the 
% user to specify attributes of the requested CompuScope system.  
% The allowed structure fields are Board, Channels, SampleBits and Index.  
% Board describes a board type.  Board types can be obtained using the 
% CsMl_Translate.m file.  Channels represents the number of channels.  
% SampleBits is the vertical resolution of a CompuScope system and Index is the 
% system number (beginning with 1).  A zero in any of the fields means that any 
% detected CompuScope system with that attribute is acceptable.  If the varargin 
% parameter is not used, a handle to the first available CompuScope system found 
% will be returned.

retval = CsMl(1, varargin);

if retval <= 0
    handle = 0;
else
    handle = retval;
    retval = 1;
end



    