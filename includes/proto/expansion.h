#ifndef _PROTO_EXPANSION_H
#define _PROTO_EXPANSION_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef CLIB_EXPANSION_PROTOS_H
#include <clib/expansion_protos.h>
#endif

#ifndef __NOLIBBASE__
extern struct ExpansionBase *ExpansionBase;
#endif

#ifdef __GNUC__
#include <inline/expansion.h>
#elif defined(__VBCC__)
#ifndef __PPC__
#include <inline/expansion_protos.h>
#endif
#else
#include <pragma/expansion_lib.h>
#endif

#endif	/*  _PROTO_EXPANSION_H  */
