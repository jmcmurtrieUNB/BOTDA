function [BoardType] = CsMl_BoardNameToType(BoardName)
% BoardType = CsMl_BoardNameToType(BoardName)
%
% CsMl_BoardNameToType is provided for convenience and allows conversion of 
% board names into their matching board types. A board type is an integer constant
% used by the CompuScope driver to identify the boards.  The board type is only
% needed as an optional parameter to CsMl_GetSystem. If the board name
% cannot be identified, a 0 is returned.  Otherwise the board type
% that matches the board name is returned.

if (nargin == 0)
    BoardType = 0;
    return;
end
name = upper(BoardName);
switch name
    case 'CS8500'
        BoardType = 1;
    case 'CS82G'
        BoardType = 2;
    case 'CS12100'
        BoardType = 3;
    case 'CS1250'
        BoardType = 4;
    case 'CS1220'
        BoardType = 5;
    case 'CS1210'
        BoardType = 6;
    case 'CS14100'
        BoardType = 7;
    case 'CS1450'
        BoardType = 8;
    case 'CS1610'
        BoardType = 9;
    case 'CS1602'
        BoardType = 10;
    case 'CS3200'
        BoardType = 11;
    case 'CS85G'
        BoardType = 12;
    case 'CS14200'
        BoardType = 13;        
    case 'CS14105'
        BoardType = 14;
    case 'CS12400'
        BoardType = 15;     
    case 'CS14200V2'
        BoardType = 16;
    case 'CS8220'
        BoardType = 64;
    case 'CS8221'
        BoardType = 65;
    case 'CS8222'
        BoardType = 66;
    case 'CS8223'
        BoardType = 67;
    case 'CS8224'
        BoardType = 68;
    case 'CS8225'
        BoardType = 69;
    case 'CS8226'
        BoardType = 70;
    case 'CS8227'
        BoardType = 71;
    case 'CS8228'
        BoardType = 72;
    case 'CS8229'
        BoardType = 73;        
    case 'CS8240'
        BoardType = 80;
    case 'CS8241'
        BoardType = 81;
    case 'CS8242'
        BoardType = 82;
    case 'CS8243'
        BoardType = 83;
    case 'CS8244'
        BoardType = 84;
    case 'CS8245'
        BoardType = 85;
    case 'CS8246'
        BoardType = 86;
    case 'CS8247'
        BoardType = 87;
    case 'CS8248'
        BoardType = 88;
    case 'CS8249'
        BoardType = 89;                
    case 'CS8280'
        BoardType = 96;
    case 'CS8281'
        BoardType = 97;
    case 'CS8282'
        BoardType = 98;
    case 'CS8283'
        BoardType = 99;
    case 'CS8284'
        BoardType = 100;
    case 'CS8285'
        BoardType = 101;
    case 'CS8286'
        BoardType = 102;
    case 'CS8287'
        BoardType = 103;
    case 'CS8288'
        BoardType = 104;
    case 'CS8289'
        BoardType = 105;                        
    case 'CS8320'
        BoardType = 128;
    case 'CS8321'
        BoardType = 129;
    case 'CS8322'
        BoardType = 130;
    case 'CS8323'
        BoardType = 131;
    case 'CS8324'
        BoardType = 132;
    case 'CS8325'
        BoardType = 133;
    case 'CS8326'
        BoardType = 134;
    case 'CS8327'
        BoardType = 135;
    case 'CS8328'
        BoardType = 136;
    case 'CS8329'
        BoardType = 137;        
    case 'CS8340'
        BoardType = 144;
    case 'CS8341'
        BoardType = 145;
    case 'CS8342'
        BoardType = 146;
    case 'CS8343'
        BoardType = 147;
    case 'CS8344'
        BoardType = 148;
    case 'CS8345'
        BoardType = 149;
    case 'CS8346'
        BoardType = 150;
    case 'CS8347'
        BoardType = 151;
    case 'CS8348'
        BoardType = 152;
    case 'CS8349'
        BoardType = 153;                
    case 'CS8380'
        BoardType = 160;
    case 'CS8381'
        BoardType = 161;
    case 'CS8382'
        BoardType = 162;
    case 'CS8383'
        BoardType = 163;
    case 'CS8384'
        BoardType = 164;
    case 'CS8385'
        BoardType = 165;
    case 'CS8386'
        BoardType = 166;
    case 'CS8387'
        BoardType = 167;
    case 'CS8388'
        BoardType = 168;
    case 'CS8389'
        BoardType = 169;               
    case 'CSVS8'
        BoardType = 2049;
    case 'CSVS12'
        BoardType = 2050;
    case 'CS8VS14'
        BoardType = 2051;
    case 'CSVS16'
        BoardType = 2052;        
    case 'CS82GC'
        BoardType = bitor(32768, 2);
    case 'CS14100C'
        BoardType = bitor(32768, 7);
    case 'CS1610C'
        BoardType = bitor(32768, 9);        
    case 'CS3200C'
        BoardType = bitor(32768, 11);        
    case 'CS85GC'
        BoardType = bitor(32768, 12);                
    otherwise
        BoardType = 0;
end        
