#ifndef _PROTO_NONVOLATILE_H
#define _PROTO_NONVOLATILE_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef CLIB_NONVOLATILE_PROTOS_H
#include <clib/nonvolatile_protos.h>
#endif

#ifndef __NOLIBBASE__
extern struct Library *NVBase;
#endif

#ifdef __GNUC__
#include <inline/nonvolatile.h>
#elif defined(__VBCC__)
#ifndef __PPC__
#include <inline/nonvolatile_protos.h>
#endif
#else
#include <pragma/nonvolatile_lib.h>
#endif

#endif	/*  _PROTO_NONVOLATILE_H  */
