#ifndef _PROTO_MISC_H
#define _PROTO_MISC_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef CLIB_MISC_PROTOS_H
#include <clib/misc_protos.h>
#endif

#ifndef __NOLIBBASE__
extern struct Library *MiscBase;
#endif

#ifdef __GNUC__
#include <inline/misc.h>
#elif defined(__VBCC__)
#ifndef __PPC__
#include <inline/misc_protos.h>
#endif
#else
#include <pragma/misc_lib.h>
#endif

#endif	/*  _PROTO_MISC_H  */
