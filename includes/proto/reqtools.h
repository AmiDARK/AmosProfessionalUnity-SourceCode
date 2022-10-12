#ifndef _PROTO_REQTOOLS_H
#define _PROTO_REQTOOLS_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef CLIB_REQTOOLS_PROTOS_H
#include <clib/reqtools_protos.h>
#endif

#ifndef __NOLIBBASE__
extern struct ReqToolsBase *ReqToolsBase;
#endif

#ifdef __GNUC__
#include <inline/reqtools.h>
#elif defined(__VBCC__)
#ifndef __PPC__
#include <inline/reqtools_protos.h>
#endif
#else
#include <pragma/reqtools_lib.h>
#endif

#endif	/*  _PROTO_REQTOOLS_H  */
