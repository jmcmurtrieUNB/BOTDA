function rxy = crosscorr(x,y)
% Function which computes cross correlation of two discrete sequences.
% Uses fft method to evaluate the cross correlation quicker.
% The output of the method has to be flipped. 
%
% rxy is the cross correlation of x and y.
% x and y are input discrete signals.

lx=length(x);
ly=length(y);
n=lx+ly-1;

X = fft(x,n);
Y = fft(y,n);
H = conj(Y);

flip = ceil(n/2);

% Unflipped correlation
temp = ifft(X.*H,n);

% Flips the temp variable and updates the rxy output.
rxy(1:(n-flip))=temp(flip+1:n);
rxy(n-flip+1:n)=temp(1:flip);
end