'***
' QBX.BI - Assembly Support Include File
'
'       Copyright <C> 1987-1989 Microsoft Corporation
'
' Purpose:
'      This include file defines the types and gives the DECLARE
'       statements for the assembly language routines Absolute,
'       Interrupt, InterruptX, Int86Old, and Int86XOld.
'
'***************************************************************************
'
' Define the type needed for Interrupt
'
TYPE RegType
     ax    AS INTEGER
     bx    AS INTEGER
     cx    AS INTEGER
     dx    AS INTEGER
     bp    AS INTEGER
     si    AS INTEGER
     di    AS INTEGER
     flags AS INTEGER
END TYPE
'
' Define the type needed for InterruptX
'
TYPE RegTypeX
     ax    AS INTEGER
     bx    AS INTEGER
     cx    AS INTEGER
     dx    AS INTEGER
     bp    AS INTEGER
     si    AS INTEGER
     di    AS INTEGER
     flags AS INTEGER
     ds    AS INTEGER
     es    AS INTEGER
END TYPE
'
'                 DECLARE statements for the 5 routines
'                 -------------------------------------
'
' Generate a software interrupt, loading all but the segment registers
'
DECLARE SUB Interrupt (intnum AS INTEGER,inreg AS RegType,outreg AS RegType)
'
' Generate a software interrupt, loading all registers
'
DECLARE SUB InterruptX (intnum AS INTEGER,inreg AS RegTypeX, outreg AS RegTypeX)
'
' Call a routine at an absolute address.
' NOTE: If the routine called takes parameters, then they will have to
'       be added to this declare statement before the paone of them
onto your hard drive. Go to your D: drive where the floppy is and
type

N-STALL  <name>

and it will automatically create a directory on C:, unzip all the
stuff to C: and switch you over to C:

For example, to install notrus you would type

N-STALL notrus

If you load one and don't like it, you can remove it from your
hard drive by using UNINSTAL.  Go to your D: drive where the
floppy is and type

UNINSTAL <name>

For example, to uninstall h