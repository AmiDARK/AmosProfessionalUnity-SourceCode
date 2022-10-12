#ifndef _PROTO_AMIGAGUIDE_H
#define _PROTO_AMIGAGUIDE_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef CLIB_AMIGAGUIDE_PROTOS_H
#include <clib/amigaguide_protos.h>
#endif

#ifndef __NOLIBBASE__
extern struct Library *AmigaGuideBase;
#endif

#ifdef __GNUC__
#include <inline/amigaguide.h>
#elif defined(__VBCC__)
#ifndef __PPC__
#include <inline/amigaguide_protos.h>
#endif
#else
#include <pragma/amigaguide_lib.h>
#endif

#endif	/*  _PROTO_AMIGAGUIDE_H  */
