#ifndef	CLIB_POWERPACKER_PROTOS_H
#define	CLIB_POWERPACKER_PROTOS_H
/*
**	$Filename: clib/powerpacker_protos.h $
**	$Release: 1.3 $
**	$Revision: 35.2 $
**
**	C prototypes. For use with 32 bit integers only.
**
**	(C) Copyright 1991 Nico François
**	    All Rights Reserved
*/

ULONG ppLoadData (char *, ULONG, ULONG, UBYTE **, ULONG *, BOOL (*)());
void  ppDecrunchBuffer (UBYTE *, UBYTE *, ULONG *, ULONG);
ULONG ppCalcCheckSum (char *);
ULONG ppCalcPasskey (char *);
void  ppDecrypt (UBYTE *, ULONG, ULONG);
BOOL  ppGetPassword (struct Screen *, UBYTE *, ULONG, ULONG);
APTR  ppAllocCrunchInfo (ULONG, ULONG, BOOL (*)(), APTR);
void  ppFreeCrunchInfo (APTR);
ULONG ppCrunchBuffer (APTR, UBYTE *, ULONG);
BOOL  ppWriteDataHeader (BPTR, ULONG, BOOL, ULONG);
BOOL  ppEnterPassword (struct Screen *, UBYTE *);
char *ppErrorMessage (ULONG);

#endif	/* CLIB_POWERPACKER_PROTOS_H */
