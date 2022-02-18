/*===========================================================================

  conio.h

  Copyright (c)2022 Kevin Boone, GPL v3.0

===========================================================================*/
#ifndef __CONIO_H
#define __CONIO_H

void puts2();
void puts2ln();
void putch();
void puteol();

/* Get a character, unbuffered, without echoing. */
int getchne();

/* Number of cycles that getchne() waited for a keystroke; intended
   for use as a seed for the random number generator */
extern int _keyseed;

#endif


