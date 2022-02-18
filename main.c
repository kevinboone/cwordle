/*==========================================================================
    
  wordle-cpm   
  main.c
  Copyright (c)2022 Kevin Boone, GPLv3.0

==========================================================================*/

#include <stdio.h>
#include <fcntl.h>
#include "defs.h" 
#include "config.h" 
#include "conio.h" 
#include "rand.h" 
#include "string.h" 

/*==========================================================================
  rnd_word   
  Get a random word from the word list. Returns TRUE on success, FALSE
  otherwise. Assumes word list is 4096 lines long, and each line is
  terminated by <LF> (not <CR><LF>, to save a little space).
==========================================================================*/
BOOL rnd_word (word)
char *word;
  {
  int f = open (WORDFILE, O_RDONLY);
  if (f >= 0)
    {
    /* word list is 4096 * 6 = 24576, so offset will fit
       into a signed int. rand() gets a number 0-65535, so 
       masking 0x0FFF gets a number 0-4095 */
    int offset = 6 * (rand() & 0x0FFF);
    /* However, lseek takes a long offset and, as there are no
       function prototypes, we must specifically cast it. */
    lseek (f, (long)offset, 0);
    read (f, word, 5);
    word[5] = 0;
    close (f);
    return TRUE;
    }
  else
    {
    puts2 ("Can't open word list ");
    puts2ln (WORDFILE);
    return FALSE;
    }
  }

/*==========================================================================
  get_pos
  Returns the position of letter c in word. First check position i, 
    because we need to know if the letter is actually in the right place. 
==========================================================================*/
int get_pos (word, c, i)
char *word;
int c;
int i;
  {
  int n = 0;
  if (word[i] == c) return i;
  while (*word)
    {
    if (*word == c) return n;
    word++;
    n++;
    }
  return -1;
  }


/*==========================================================================
  show_hits
  Draw the grid showing which letters in guess match in word.
==========================================================================*/
void show_hits (word, guess)
char *word;
char *guess;
  {
  int i;
  for (i = 0; i < 5; i++)
    {
    int c = guess[i];
    int p = get_pos (word, tolower(c), i);
    if (p == i)
      {
      putchar ('!');
      putchar (toupper (guess[i]));
      putchar ('!');
      } 
    else if (p >= 0)
      {
      putchar (toupper (guess[i]));
      }
    else
      putchar ('_');
    putchar (' ');
    }
  puteol();
  }


/*==========================================================================
   loop 
   This is the main game loop. Enter a word, check if it's a match, 
     otherwise show the grid of matches. Repeat.
==========================================================================*/
void loop ()
  {
  char word[10];
  char guess[10];
  BOOL done = FALSE;
  
  while (!done)
    {
    int i;
    int guesses = 0;
    BOOL guessed = FALSE;
    rnd_word (word);

    /*puts ("Cheat: ");
    puts (word);
    puteol();*/

    while (!guessed)
      {
      char s[10];
      guesses++;
      utoa (guesses, s, 10);
      puts2 ("Guess ");
      puts2 (s);
      puts2 (": ");
      gets (guess);
      if (strlen (guess) == 5)
        {
        if (strcmp (guess, word) == 0)
          {
          int c;
          puts2 ("You got it: \"");
          puts2 (word);
          puts2 ("\", Again (Y/N)?");
          c = getchne();
          if (c == 'y' || c == 'Y')
            guessed = TRUE;
          else
            exit(0);
          }
       
        if (!guessed)
          show_hits (word, guess);
        }
      else
        {
        puts2 ("Your guess must have five letters.");
        guesses--;
        puteol ();
        }
      puteol();
      }
    }
  }

/*==========================================================================
  banner   
==========================================================================*/
void banner()
  {
  puts2ln 
("Guess five-letter words. Letters that are in the word, and in the right");
  puts2ln 
("place show like this: !X!. Letters that are in the word, but not in the");
  puts2ln 
("right place, show where you typed them. Unguessed letters are shown as a"); 
  puts2ln
("dash: _. Beware: some letters appear more than once in some words.");
  }

/*==========================================================================
  main   
==========================================================================*/
int main (argc, argv)
int argc;
char **argv;
  {
  int r;
  char s[10];
  if (rnd_word (s))
    {
    banner();
    puts2ln ("Press any key to start...");
    getchne();
    r = _keyseed;
    srand (r);

    loop();

    return 0;
    }
  }

