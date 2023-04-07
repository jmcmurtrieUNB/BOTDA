function [R] = FreqCalcs(RFout)
%--------------------------------------------------------------------------
% Written by:
% James McMurtrie,  March 3, 2018
%
%
% Calcualtes the binary values requires to write to the EV-ADF4159
% frequency sythesizer / PLL evaluation board
%
% Write to the ADF board row-wise(left-msb)
% R(1,:), R(2,:), R(3,:), ... ,R(11,:)
%
% Note that there are only 7 registers in the ADF4159, but 3 of them must be written to
% twice making a total of 11 write commands, thus 11 rows in R
%
% I began by storing the values for register 0 in row 1, register 1 in row
% 2, register 2 in row 3 etc. , but the registers must be written to in
% descending order(7,6,6,5,5,4,4,3,2,1,0) and found that writting row 11
% first down to row 1 was counter intuitive, therefor at the bottom of this
% function the rows are swapped so row 1 is written first then row 2 3 etc.
%
% INPUTS:
% RFout = the desired output frequency

% OUTPUTS:
% R = each row represents a binary register value to write(left-msb)
%--------------------------------------------------------------------------
%% Calculations
REF_in = 100e6; % Reference frequency: 100MHz. From crystal on eval board

D = 0; % D is the RF REF_in doubler bit, bit DB20 in register 2. (0 or 1)
T = 0; % T is the ref. divide-by-2 bit, bit DB21 in register 2 (0 or 1)
RD = 1; % R is the RF ref. division factor. (1 to 32). 100MHz/1 = 100MHz
PFD = REF_in*((1+D)/(RD*(1+T))); % Phase Frequency Detect

N = floor(RFout/PFD); % integer division factor
F_msb = floor(((RFout/PFD)-N)*2^12); % 12 bit MSB FRAC value in register 0
F_lsb = round(((((RFout/PFD)-N)*2^12)-F_msb)*2^13); % 13 bit LSB FRAC value in register 1

R = zeros(11,32); % allocate space for register values

%% Register 0
R(1,1) = 0; % Ramp Disabled
R(1,2:5) = [0 1 1 0]; % Muxout Control = Digital Lock Detect
R(1,6:17) = de2bi(N,12,'left-msb'); % 12 bit integer value N
R(1,18:29) = de2bi(F_msb,12,'left-msb');% 12 bit MSB FRAC value
R(1,30:32) = [0 0 0]; % Register Number: 0

%% Register 1
R(2,1:3) = 0; % Reserved
R(2,4) = 0; % Phase Adjust: 0=Disabled 1=Enabled
R(2,5:17) = de2bi(F_lsb,13,'left-msb'); % 13 bit LSB FRAC value
R(2,18:29) = 0; % Phase Adjust Value: Phase Shift =(PhaseValue * 360)/2^12
R(2,30:32) = [0 0 1]; % Register Number: 1

%% Register 2 
R(3,1:3) = 0; % Reserved
R(3,4) = 0; % Cycle Slip Reduction: 0=Disabled 1=Enabled
R(3,5:8) = [0 1 1 1]; %CP Current 0000=0.31mA linearly up to 1111=5.0mA
R(3,9) = 0; % Reserved
if RFout<=8e9 && RFout>=3e9
    R(3,10) = 0; % Prescaler = 4/5 for RFout between 3 and 8GHz
elseif RFout>8e9 && RFout<=13e9
    R(3,10) = 1; % Prescaler = 8/9 for RFout between 8 and 13GHz
else
    disp('ERROR: Output frequency not within limits of board. 3-13GHZ');
    return
end
R(3,11) = 0; % R Divider: 0=Disabled 1=Enabled
R(3,12) = 0; % Reference Doubler: 0=Disabled 1=Enabled
R(3,13:17) = [0 0 0 0 1]; % R Counter Divide Ratio 00001=1 11111=31 00000=32
R(3,18:29) = de2bi(1,12,'left-msb'); % CLK Divider Value: set to 1
R(3,30:32) = [0 1 0]; % Register Number: 2

%% Register 3
R(4,1:7) = 0; % Reserved
R(4,8:10) = [1 0 0]; % Negative Bleed Current for Charge Pump. Refer to DB22-DB24 in the ADF4159 datasheet for the logic table
R(4,11) = 0; % Negative Bleed Current Enable: 0=Disabled 1=Enabled
R(4,12:14) = 0; % Reserved
R(4,15) = 1; % Reserved
R(4,16) = 1; % Loss of Lock Indication Enable: 0=Disabled 1=Enabled
R(4,17) = 0; % N SEL: Delayes the loading of FRAC by 4 cycles. 0=Disabled 1=Enabled
R(4,18) = 0; % 0 resets the sigma-delta modulator on each write to R0. 1 = no reset
R(4,19:20) = [0 0]; % Reserved
R(4,21:22) = [0 0]; % Ramp Mode. Refer to Figure 28 in the ADF4159 datasheet for the logic table
R(4,23) = 0; % Phase Shift Keying: 0=Disabled 1=Enabled
R(4,24) = 0; % Frequency Shift Keying: 0=Disabled 1=Enabled
R(4,25) = 0; % Lock Detect Precision: 0=Five consecutive pulses less than 14ns , 1=Five consecutive pulses less than 6ns
R(4,26) = 0; % Phase Detector Polarity: 0=Negative 1=Positive
R(4,27) = 0; % Power-Down: Setting bit=0 peforms a software power-down. Data in the registers is maintained during this power-down
R(4,28) = 0; % Charge Pump Three State: 0=Normal Mode 1=Three State Mode
R(4,29) = 0; % Counter Reset: 0=Nomal Operation 1=RF Synthesizer Counter Held in Reset
R(4,30:32) = [0 1 1]; % Register Number: 3

%% Register 4
% This register is double buffered, therefor must be written to twice.
% These are the values for the second write
R(5,1) = 0; % LE Selection 0=From PIN 1=Sync With REFin from external
R(5,2:6) = 0; % Sigma-Delta Modulator Mode
R(5,7:11) = 0; % Ramp Status: Refer to 29 in ADF4159 datasheet for the logic table. 00000=Normal
R(5,12:13) = [1 1]; % CLK Divider Mode: Refer to 29 in ADF4159 datasheet for the logic table. 11=Ramp Divder
R(5,14:25) = [0 0 0 0 0 0 0 0 0 0 1 0]; % CLK Divider Value: Binary number is the divider number. set to 2
R(5,26) = 1; % CLK Divider Select. On second write must be set to 1.
R(5,27:29) = 0; % Reserved
R(5,30:32)= [1 0 0]; % Register Number: 4

% These are the values for the first write
R(6,:) = R(5,:); % Most bits are the same
R(6,26) = 0; % CLK Divider Select. On first write must be set to 0.

%% Register 5
% This register is double buffered, therefor must be written to twice.
% These are the values for the second write
R(7,1) = 0; % Reserved
R(7,2) = 0; % TX Data Invert: 0=Non-inverted 1=Inverted
R(7,3) = 0; % Tx Data Ramp CLK: 0=CLK DIV 1=TX Data
R(7,4) = 0; % Parabolic Ramp
R(7,5:6) = 0; % Interrupt off. Refer to figure 30 in ADF4159 datasheet for the logic table
R(7,7) = 0; % Frequency Shift Keying RAMP. 0=Disabled 1=Enabled
R(7,8) = 0; % Dual Ramp. 0=Disabled 1=Enabled
R(7,9) = 1; % Deviation Select. On second write must be set to 1.
R(7,10:13) = 0; % 4 bit Deviation offset word
R(7,14:29) = 0; % 16 bit Deviation offset word
R(7,30:32) = [1 0 1]; % Register Number: 5

% These are the values for the first write
R(8,:) = R(7,:); % Most bits are the same
R(8,9) = 0; % Deviation Select. On first write must be set to 0.

%% Register 6
% This register is double buffered, therefor must be written to twice.
% These are the values for the second write
R(9,1:8) = 0; % Reserved
R(9,9) = 1; % Step Select. On second write must be set to 1.
R(9,10:29) = 0; % Step Word: number of steps in the ramp
R(9,30:32) = [1 1 0]; % Register Number: 6

% These are the values for the first write
R(10,:) = R(9,:); % Most bits are the same
R(10,9) = 0; % Step Select. On first write must be set to 0.

%% Register 7
R(11,1:8) = 0; % Reserved
R(11,9) = 0; % Tx Data Trigger Delay. 0=Disabled 1=Enabled
R(11,10) = 0; % Triangular Delay. 0=Disabled 1=Enabled
R(11,11) = 0; % Single Full Triangle. 0=Disabled 1=Enabled
R(11,12) = 0; % Tx Data Trigger. 0=Disabled 1=Enabled
R(11,13) = 0; % Fast Ramp. 0=Disabled 1=Enabled
R(11,14) = 0; % Ramp Delay Fast Lock. 0=Disabled 1=Enabled
R(11,15) = 0; % Ramp Delay. 0=Disabled 1=Enabled
R(11,16) = 0; % Delay Clock Select. 0=PFD CLK 1=(PFD CLK)*(CLK1)
R(11,17) = 0; % Delayed Start Enable. 0=Disabled 1=Enabled
R(11,18:29) = 0; % 12 bit Delayed Start Word
R(11,30:32) = [1 1 1]; % Register Number: 7

%% Row swapping
% This was done so writting to the ADF 4159 chip was done in a more
% intuitive order. (Explanation in description at top)

Temp = R; % Temporarry value
k=11; % Used for counter in loop below
for i=1:11
    R(i,:) = Temp(k,:);
    k=k-1;
end
end
