#ifndef _PROTO_SOCKET_H
#define _PROTO_SOCKET_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef CLIB_SOCKET_PROTOS_H
#include <clib/socket_protos.h>
#endif

#ifndef __NOLIBBASE__
extern struct Library *SocketBase;
#endif

#ifdef __GNUC__
#include <inline/socket.h>
#elif defined(__VBCC__)
#ifndef __PPC__
#include <inline/socket_protos.h>
#endif
#else
#include <pragma/socket_lib.h>
#endif

#endif	/*  _PROTO_SOCKET_H  */
