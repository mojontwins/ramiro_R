// MT Engine MK2 v0.90b
// Copyleft 2016 the Mojon Twins

// enems.h
// General enemy definitions. Incluses enems.bin and hotspots.bin as generated by ene2bin.exe

// This is BROKEN. For the time being.
#define BADDIES_COUNT 33
// End of BROKEN stuff

typedef struct {
	int x, y;
	unsigned char x1, y1, x2, y2;
	signed char mx, my;
	char t;
	unsigned char life;
} BADDIE;

extern BADDIE baddies [0];

#asm
	._baddies
		BINARY "../bin/enems.bin"
#endasm

#ifndef DISABLE_HOTSPOTS
typedef struct {
	unsigned char xy, tipo, act;
} HOTSPOT;

extern HOTSPOT hotspots [0];

#asm
	._hotspots
		BINARY "../bin/hotspots.bin"
#endasm
#endif
