function [errtext] = CsMl_ErrorHandler(errcode, stoponerror, handle)
% errtext = CsMl_ErrorHandler(errcode, stoponerror, handle)
%
% CsMl_ErrorHandler processes errors from other CsMl_xxx calls.  The return 
% value is a descriptive error string, which describes the error 
% condition that has occurred.  If errcode was not a valid error code,
% the function simply returns without taking any action.  If errcode was a 
% valid error code and the stoponerror flag is not set to 1, the function 
% just returns the corresponding error string.  If stoponerror is set to 1 
% (which is the default), the function will stop execution of the program, 
% return control to the MATLAB command window and display the error message.  
% If handle is used, and is non-zero, the CompuScope system handle is freed if 
% and when program execution is stopped.  
% 
% Note that stoponerror and handle are optional.


errtext = '';
% If error code is not negative, return. 0 is an unnecessary operation
% but still considered a success.
if errcode >= 0
    return;
end;

errtext = CsMl(16, errcode);
if nargin > 1
    if 0 == stoponerror
        return;
    end;
end;    

if nargin == 3
    if 1 == stoponerror
        if 0 ~= handle
            CsMl_FreeSystem(handle);
        end;
    end;
end;
error(errtext);


    