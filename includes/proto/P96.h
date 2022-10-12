#ifndef _PROTO_P96_H
#define _PROTO_P96_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef CLIB_P96_PROTOS_H
#include <clib/P96_protos.h>
#endif

#ifndef __NOLIBBASE__
extern struct Library *P96Base;
#endif

#ifdef __GNUC__
#include <inline/P96.h>
#elif defined(__VBCC__)
#ifndef __PPC__
#include <inline/P96_protos.h>
#endif
#else
#include <pragma/P96_lib.h>
#endif

#endif	/*  _PROTO_P96_H  */
