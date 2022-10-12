#ifndef _PROTO_LOWLEVEL_H
#define _PROTO_LOWLEVEL_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef CLIB_LOWLEVEL_PROTOS_H
#include <clib/lowlevel_protos.h>
#endif

#ifndef __NOLIBBASE__
extern struct Library *LowLevelBase;
#endif

#ifdef __GNUC__
#include <inline/lowlevel.h>
#elif defined(__VBCC__)
#ifndef __PPC__
#include <inline/lowlevel_protos.h>
#endif
#else
#include <pragma/lowlevel_lib.h>
#endif

#endif	/*  _PROTO_LOWLEVEL_H  */
