RELEASE NOTES

*****************************************************
COMPUSCOPE SDK FOR MATLAB FOR WINDOWS
*****************************************************

The CompuScope SDK for MATLAB for Windows version 
4.xx.xx is a completely redesigned, and improved 
version of our CompuScope MATLAB SDK, with completely 
new sample programs.

The CompuScope SDK for MATLAB version 4.xx exploits 
the completely re-engineered API used by CompuScope 
drivers version 4.xx.

The new SDK and driver architecture was designed in 
conjunction with the release of GaGe's 
second-generation PCI CompuScope cards. Accordingly, 
the new SDK is recommended for future development as 
it exploits new features available with 
second-generation CompuScope cards.  Users who have 
been working with older MATLAB SDK versions (3.xx) 
may NOT want to upgrade to the new SDK, and continue 
development with the older SDK (3.xx) to avoid 
extensive re-work of their application programming.

Please refer to the CompuScope SDK for MATLAB manual 
for the requirements for using this SDK and 
descriptions of the sample programs.


-----------------------------------------------------
ENHANCEMENTS FOR VERSION 4.80.22
-----------------------------------------------------

   None


-----------------------------------------------------
BUG FIXES FOR VERSION 4.80.22
-----------------------------------------------------

1)  Minor bug fixes.


-----------------------------------------------------
KNOWN BUGS FOR VERSION 4.80.22
-----------------------------------------------------

1) Trigger delay should not be used with 
   GageStream2Disk.

2) When upgrading from a previous SDK version, the 
   startup.m file will get deleted from the 
   toolbox\local folder.  The paths included in this 
   file will have to be added manually for the 
   sample to work.

3) GageStream2Disk captures will not display 
   correctly in GageScope if the capture is larger 
   than the GageScope buffer size and has pretrigger 
   data; pretrigger data will not be aligned 
   correctly if align by trigger address is used.

4) The time stamp in the header of the Sig file 
   captured with GageStream2Disk will all have the 
   same value for all captures of a mulrec set.  
   This is not the case for individual capture though.


-----------------------------------------------------
ABOUT THE COMPUSCOPE SDK FOR MATLAB FOR WINDOWS
-----------------------------------------------------

NOTE: When writing an M-file for the CompuScope SDK 
      for MATLAB, do not use the MATLAB "clear all" 
      function.  This will clear out all function 
      pointers and the dlls will have to be 
      reinitialized.  Use the "clear" function 
      instead.

GaGe's CompuScope SDK for MATLAB for Windows allows 
you to control one or more CompuScope cards from the 
MATLAB environment.

The CompuScope Win 2K/XP/Vista/7 Drivers Version 
4.8x.xx support all current CompuScope PCI bus cards.  
These cards include: Cobra CompuScope cards (CSxyG8), 
CS82G*, BASE-8 cards and CobraMax CompuScope cards 
(CScdG8), CS8500*, CS12XY 12-bit Razor CompuScope 
cards, CS82XX 12-bit Octopus CompuScope cards, 
CS12400, CS12100*, CS1250*, CS1220, CS14XY 14-bit 
Razor CompuScope cards, CS83XX 14-bit Octopus 
CompuScope cards, Eon CompuScope cards, CS14200, 
CS14105, CS14100*, CS1450*, CS16XY 16-bit Razor 
CompuScope cards, CS1610*, CS1602*, CS84XX 16-bit 
Octopus CompuScope cards, and CS3200*.

* These drivers also support all current 
CompactPCI/PXI-class CompuScope cards.  These cards 
include: CS82GC*, CS14100C*, CS1610C* and CS3200C*.

CS85G and CS85GC CompuScope cards are not supported 
under CompuScope SDK for C/C# for Windows version 
3.80.00 and subsequent versions.  Note that 
CompuScope SDK for C/C# for Windows version 3.60.00 
was the LAST version to support the CS85G and CS85GC 
CompuScope cards.

ISA and X012/PCI CompuScope cards are not supported 
under CompuScope SDK for C/C# for Windows version 
3.48.00 and subsequent versions.  Note that 
CompuScope SDK for C/C# for Windows version 3.46.00 
was the LAST version to support all ISA and X012/PCI 
CompuScope cards.

The CompuScope ISA and X012/PCI cards include: 
CS8012A/PCI, CS8012/PCI, CS6012/PCI, CS1012/PCI, 
CS512/PCI, CS8012/DIM24/PCI, CS8012/DIM12/PCI, 
CS8012/DIM24, CS8012/DIM12, CS8012A, CS8012, CS6012, 
CS1012, CS512, CS2125, CS265, CS250, CS225, CS220, 
and CSLITE.



-----------------------------------------------------
WHAT TO LOOK OUT FOR WHEN INSTALLING THE COMPUSCOPE 
SDK FOR MATLAB FOR WINDOWS
-----------------------------------------------------

1) You MUST install the CompuScope Drivers before 
   attempting to use the CompuScope SDK for MATLAB.  
   Without the proper drivers, the CompuScope SDK for 
   MATLAB will not function properly.  See the Driver 
   Installation section of the Startup Guide for 
   instructions on installing the CompuScope Windows
   Drivers and the CompuScope SDK for MATLAB for 
   Windows.

2) The installation will fail if the installer is not 
   an Administrator.

3) Please note that you will be asked to enter a 
   software key during the SDK installation process.  
   This software key is provided upon purchase of the 
   SDK.

4) We recommend that you use the default installation 
   directory; however, you will be prompted to change 
   it if you wish.

5) If during the installation of the SDK you receive 
   a message stating that the MATLAB path could not 
   be modified to include the CompuScope MATLAB SDK 
   path, then you will have to do one of the 
   following:

   a) Copy the contents of addpath.m from the SDK's 
      Main directory to your MATLAB 
      directory\toolbox\local\startup.m, if this file 
      currently exists or else create the file with 
      the contents of addpath.m.

   b) Run addpath.m from the SDK's Main directory 
      every time you load up MATLAB.

   c) Add the path of the three SDK directories (Adv, 
      CsMl, and Main) through the "Set Path" function 
      under "File".

See your CompuScope SDK for MATLAB User's Guide for 
more details on using the CompuScope SDK for MATLAB.



=====================================================
Comments and suggestions can be addressed to:

Project Manager - CompuScope SDK for MATLAB for Windows
Gage Applied Technologies


In North America:
Tel:    800-567-GAGE
Fax:    800-780-8411

Outside North America:
Tel:    +1-514-633-7447
Fax:    +1-514-633-0770

E-mail:   prodinfo@gage-applied.com
Web site: www.gage-applied.com
