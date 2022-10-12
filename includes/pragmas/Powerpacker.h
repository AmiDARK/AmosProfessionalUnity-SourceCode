/*
 *   powerpacker.library   © 1991 Nico François
 *
 *   Release 1.3
 *
 */

#pragma libcall PPBase ppLoadData 1E BA910806
#pragma libcall PPBase ppDecrunchBuffer 24 0A9804
#pragma libcall PPBase ppCalcChecksum 2A 801
#pragma libcall PPBase ppCalcPasskey 30 801
#pragma libcall PPBase ppDecrypt 36 10803
#pragma libcall PPBase ppGetPassword 3C 109804
/* 2 obsolete functions here */
/* 3 private functions here */
#pragma libcall PPBase ppAllocCrunchInfo 60 981004
#pragma libcall PPBase ppFreeCrunchInfo 66 801
#pragma libcall PPBase ppCrunchBuffer 6C 09803
#pragma libcall PPBase ppWriteDataHeader 72 321004
#pragma libcall PPBase ppEnterPassword 78 9802
/* 1 private function here */
#pragma libcall PPBase ppErrorMessage 84 001
