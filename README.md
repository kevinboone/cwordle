# cwordle -- a Wordle-like word guessing game for CP/M

Version 0.1a, February 2020

## What is this?

`cwordle` is a console-based word-guessing game for CP/M (Z80 or 8080) with
similarities to Wordle.

## Installation

Copy `cwordle.com` and `cwordle.lst` to the same drive. Optionally,
copy `CWORDLE.TXT`, which contains brief instructions.

## Building

`cwordle` is written in K&R C and 8080 assembler. It is designed to be build
using the Manx Aztec C compiler for 8080. The Makefile is for building on
Linux, but it's perfectly possible (but slow) to build on a CP/M machine.

## How to play

Guess five-letter words. The default word list has no proper nouns, so letter
case is not significant.  All words are British English, but some are obscure,
and some are vulgar. 

For each guess the program displays which guessed letters are in the right
place in the secret word, which are in the wrong place, and which are not in
the secret word at all. These letters are shown on a five-column grid. A letter
that is in the correct place is show like this: !X!.

Some words have repeated letters, and these create a particular challenge,
because the program won't tell the user how many times a letter appears. 

Play continues until the word is guessed, or the user hits ctrl+c.  As an added
irritation, the program doesn't report the secret word it the user abandons the
game. There are no cheats or hints.

## Customizing the word list

`cwordle` assumes that the word list consists of 4096 5-letter lower-case
words, comprising only ASCII characters. Each word is followed by an LF (10)
character (as on Unix, but not usually on CP/M -- this is just to save a bit of
space over using CR-LF). You can replace any or all of the words, so long as
the format remains the same. 

## Limitations

The program doesn't insist that the words entered by the user are in the
dictionary, so it's possible to "probe" the secret word by entering specific
letter patterns. Users are expected to behave themselves -- checking the
dictionary for every word would be too slow for some CP/M machines, or use too
much memory, or both. 

The "Press any key..." message when the program starts is actually a part of
the program logic: the time taken for the user to press a key is used to seed
the random number generator, which is used to select random words from the
list. This seems to work in practice, although it's not particularly robust.
Still, 8080-based CP/M machines don't provide any other way to generate random
numbers.

Although it's tiny by contemporary standard, at 10kB, `cwordle` is hugely too
big for a simple CP/M program. That's the hazard of working mostly in C, rather
than assembly. 

## Author and copying

`cwordle` is Copyright (c)2022 Kevin Boone, released under the terms of the GNU
Public Licence v3.0, in the hope that it will be useful. There is no warranty
of any kind.


