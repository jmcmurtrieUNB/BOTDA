/*---------------------------------------------------------------------------*/
/* file : MMP.h                                                              */
/* date : gma, 08.98                                                         */
/* info : Interface for MMP.DLL                                              */
/*---------------------------------------------------------------------------*/
/*                                                                           */
/* MapMemPlus V2.0                                                           */
/* Universal Driver for Windows NT                                           */
/* Copyright (C) 1998  eivd - ECOLE D'INGENIEURS DU CANTON DE VAUDD          */
/*                     IAI - INSTITUT D'AUTOMATISATION INDUSTRIELLE          */
/*                     CH-1401 Yverdon-Les-Bains (Switzerland)               */
/*                                                                           */
/* http://www.eivd.ch                                                        */
/* mailto:mondada@einev.ch                                                   */
/*                                                                           */
/*---------------------------------------------------------------------------*/

#ifndef _MMP_H_
#define _MMP_H_

#include <windows.h>

#ifdef __cplusplus
extern "C" {
#endif

/*---------------------------------------------------------------------------*/

typedef enum _MMPSTATUS
  {
  MMP_OK = 0,
  MMP_DEV_OPEN_ERR,
  MMP_DEV_CLOSE_ERR,
  MMP_DEV_IO_CTRL_ERR,
  MMP_MAP_ERR,
  MMP_PRIORITY_ERROR,
  MMP_SETUP_IRQ_ERROR,
  MMP_SETUP_THREAD_ERROR
  } MMPERROR;

typedef ULONG (_stdcall *MMP_FUNC)(ULONG, ULONG);

typedef void (_stdcall *MMP_IRQ_FUNC)(void);

typedef enum _INTERFACE_TYPE {
    InterfaceTypeUndefined = -1,
    Internal,
    Isa,
    Eisa,
    MicroChannel,
    TurboChannel,
    PCIBus,
    VMEBus,
    NuBus,
    PCMCIABus,
    CBus,
    MPIBus,
    MPSABus,
    ProcessorInternal,
    InternalPowerBus,
    PNPISABus,
    MaximumInterfaceType
}INTERFACE_TYPE, *PINTERFACE_TYPE;

typedef enum {
    ConfigurationSpaceUndefined = -1,
    Cmos,
    EisaConfiguration,
    Pos,
    CbusConfiguration,
    PCIConfiguration,
    VMEConfiguration,
    NuBusConfiguration,
    PCMCIAConfiguration,
    MPIConfiguration,
    MPSAConfiguration,
    PNPISAConfiguration,
    MaximumBusDataType
} BUS_DATA_TYPE;

typedef LARGE_INTEGER PHYSICAL_ADDRESS;

typedef struct
{
    INTERFACE_TYPE   InterfaceType; /* Isa, Eisa, etc....                    */
    ULONG            BusNumber;     /* Bus number, i.e. 0 for std x86 ISA    */
    PHYSICAL_ADDRESS BusAddress;    /* Bus-relative address (physical addr)  */
    ULONG            AddressSpace;  /* 0 is memory, 1 is I/O                 */
    ULONG            Length;        /* Length of section to map              */
} PHYSICAL_MEMORY_INFO, *PPHYSICAL_MEMORY_INFO;

typedef enum {
    MMPLevelSensitive,
    MMPLatched
    } MMP_IRQ_MODE;

typedef struct {
    USHORT VendorID;
    USHORT DeviceID;
    USHORT Command;
    USHORT Status;
    UCHAR RevisionID;
    UCHAR ProgIf;
    UCHAR SubClass;
    UCHAR BaseClass;
    UCHAR CacheLineSize;
    UCHAR LatencyTimer;
    UCHAR HeaderType;
    UCHAR BIST;
    union {
         struct _PCI_HEADER_TYPE_0 {
             ULONG BaseAddresses[6];
             ULONG Reserved1[2];
             ULONG ROMBaseAddress;
             ULONG Reserved2[2];
             UCHAR InterruptLine;
             UCHAR InterruptPin;
             UCHAR MinimumGrant;
             UCHAR MaximumLatency;
         } type0;
     } u;
     UCHAR DeviceSpecific[192];
} PCI_COMMON_CONFIG;

typedef struct {
    union {
        struct {
            unsigned int DeviceNumber:5;
            unsigned int FunctionNumber:3;
            unsigned int Reserved:24;
        } bits;
        ULONG AsULONG;
    } u;
} PCI_SLOT_NUMBER;

typedef struct {
    UCHAR ReturnCode;
    UCHAR ReturnFlags;
    UCHAR MajorRevision;
    UCHAR MinorRevision;
    USHORT Checksum;
    UCHAR NumberFunctions;
    UCHAR FunctionInformation;
    ULONG CompressedId;
} CM_EISA_SLOT_INFORMATION;

/*---------------------------------------------------------------------------*/

MMPERROR __stdcall MMPLastError(void);

MMPERROR __stdcall MMPOpen(void);
MMPERROR __stdcall MMPClose(void);

MMPERROR __stdcall MMPMapUserPhysicalMem(PHYSICAL_MEMORY_INFO pmi, PVOID *pPartyMem);
MMPERROR __stdcall MMPUnmapUserPhysicalMem(PVOID pPartyMem);

MMPERROR __stdcall MMPGetID(char *ID);

ULONG __stdcall MMPInp(ULONG IOAddr);
void  __stdcall MMPOutp(ULONG IOAddr, ULONG Data);
ULONG __stdcall MMPInpw(ULONG IOAddr);
void  __stdcall MMPOutpw(ULONG IOAddr, ULONG Data);

ULONG __stdcall MMPKernelModeExec(MMP_FUNC Func, ULONG Param1, ULONG Param2);

MMPERROR __stdcall MMPSetIrqFunc(
  int          Irq,
  MMP_IRQ_MODE IrqMode,
  MMP_IRQ_FUNC IrqFunc,
  int          RealTime);

MMPERROR __stdcall MMPSetIrqFuncWithAck(
  int          Irq,
  MMP_IRQ_MODE IrqMode,
  MMP_IRQ_FUNC IrqFuncPtr,
  int          RealTime,
  int          AckMode,
  ULONG        AckAddr,
  ULONG        AckData);

void __stdcall MMPRemoveIrqFunc(void);

ULONG __stdcall MMPGetIrqLost(void);

ULONG __stdcall MMPGetBusData(
  BUS_DATA_TYPE BusDataType,
  ULONG  BusNumber,
  ULONG  SlotNumber,
  PVOID  OutDataBuffer,
  ULONG  OutDataBufferLength);

/*---------------------------------------------------------------------------*/

#ifdef __cplusplus
}
#endif

#endif
