#ifndef _VBCCINLINE_RAMDRIVE_H
#define _VBCCINLINE_RAMDRIVE_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

STRPTR __KillRAD0(__reg("a6") struct Device *)="\tjsr\t-42(a6)";
#define KillRAD0() __KillRAD0(RamdriveDevice)

STRPTR __KillRAD(__reg("d0") unsigned long unit, __reg("a6") struct Device *)="\tjsr\t-48(a6)";
#define KillRAD(unit) __KillRAD((unit), RamdriveDevice)

#endif /*  _VBCCINLINE_RAMDRIVE_H  */
