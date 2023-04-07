clear
clc
format long
% sensortool.m
%
% version 0.1 beta
%
% Anthony Brown, October 2005
%
% A MATLAB implementation of sensortool and spectrum, all rolled into one
% pretty (er, welll, sort of) package
%
% Usage : sensortool (datafile)

%clear all;
datafile='fiberbox10try1.bin';

invert=1;

[fid, message]=fopen('fiberbox10try1.bin','w');

if(fid==-1) % error
        error(message);
        return
end

load('fiberbox10.mat');
fsize=size(SFinalAVG);
[intercept slope correction]= calculateBaseline(8,(fsize(1,2)-15),SFinalAVG);
%% Write header
acquisition_count=1;
acquisition_period=-1;%************
start_freq=10.87e9;%****************
stop_freq=11.1e9;%*******************
step_freq=2e6;%**********************
line_count=fsize(1,1);%***********************
reserved1=1;
fibre_start_time=64;
run_start_time=0;
points=fsize(1,2);%*******************************
averages=1000;
sample_period=1e-9;
vga_gain=1;
reserved3=1;
reserved4=1;
signal_conversion=1;
reserved5=1;
baseline_order=1;
reserved6=1;
run_notes='runnotessize';
version=2.2;
start_time=0;
stop_time=0;

for beg= 1:1:line_count;
    freq1(1,beg)=(start_freq+(beg*step_freq)-step_freq);
end

fwrite(fid,acquisition_count,'*int');        % number of acquisitions in this file
fwrite(fid,acquisition_period,'*int');       %  period in minutes, 0 for continuous, -1 for single shot
fwrite(fid,start_freq,'double');
fwrite(fid,stop_freq,'double');
fwrite(fid,step_freq,'double');
fwrite(fid,line_count,'*int');
fwrite(fid,reserved1,'*int');
fwrite(fid,fibre_start_time,'double');
fwrite(fid,run_start_time,'uint64');
fwrite(fid,averages,'*int');
fwrite(fid,points,'*int');
fwrite(fid,sample_period,'double');
fwrite(fid,vga_gain,'int');
fwrite(fid,reserved3,'int');
fwrite(fid,reserved4,'double');
fwrite(fid,signal_conversion,'double');
fwrite(fid,reserved5,'*int');
fwrite(fid,baseline_order,'*int');
fwrite(fid,reserved6,'*int');
fwrite(fid,run_notes,'*char');
fwrite(fid,2,'*int16');
fwrite(fid,2,'*int16');
 coefficients = [intercept slope zeros(line_count,4)];
 baseline_coeff(1,:,:) = coefficients;
     
     % data will be stored as row (i)=acq#, col (j)=freq#, page=data points
     for l=1:acquisition_count;
         for j=1:line_count;
             fwrite(fid, freq1(l,j)/1e6, 'double');                                      %freq(l,j)=fread(fp,1,'double');
             fwrite(fid, (baseline_coeff(l,j,:)+2147483648),'double');                         %baseline_coeff(l,j,:)=fread(fp,6,'double');
% 
             fwrite(fid,reserved3,'double');                                %pulse_width(l,j)=fread(fp,1,'double');
             fwrite(fid,reserved3,'double');                                %pulse_power(l,j)=fread(fp,1,'double');
             fwrite(fid,reserved3,'double');                                   %cw_power(l,j)=fread(fp,1,'double');
             fwrite(fid, SFinalAVG,'double');                                   %trace(l,j,:)=fread(fp,cast(points,'double'),'*int16');
         end
         fwrite(fid,start_time(l),'uint64');                                      %start_time(l)=fread(fp,1,'uint64'); % was 'long'
         fwrite(fid,stop_time(l),'uint64');                                        %stop_time(l)=fread(fp,1,'uint64'); % was 'long'
% 
     end
fclose(fid);