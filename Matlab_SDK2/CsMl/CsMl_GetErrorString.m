function [errtext] = CsMl_GetErrorString(errcode)
% errtext = CsMl_GetErrorString(errcode)
%
% CsMl_GetErrorString translates the error code returned by
% other CsMl_xxx functions into a descriptive error message. 

errtext = CsMl(16, errcode);

    