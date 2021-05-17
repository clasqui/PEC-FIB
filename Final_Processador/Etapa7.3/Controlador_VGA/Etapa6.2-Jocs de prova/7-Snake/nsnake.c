/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *\
 * nSnake - The classic snake game with ncurses.                              *
 * Copyright (C) 2011-2012  Alexandre Dantas (kure)                           *
 *                                                                            *
 * This file is part of nSnake.                                               *
 *                                                                            *
 * nSnake is free software: you can redistribute it and/or modify             *
 * it under the terms of the GNU General Public License as published by       *
 * the Free Software Foundation, either version 3 of the License, or          *
 * any later version.                                                         *
 *                                                                            *
 * This program is distributed in the hope that it will be useful,            *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of             *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *
 * GNU General Public License for more details.                               *
 *                                                                            *
 * You should have received a copy of the GNU General Public License          *
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.      *
 *                                                                            *
 * homepage: http://sourceforge.net/projects/nsnake/                          *
 *                                                                            *
\* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

/** @file nsnake.c
 *
 *  The core functions of the game - except for the main.
 */

/*
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
*/

#include "lib_sisa.h"
#include "nsnake.h"
#include "engine.h"
#include "fruit.h"
#include "player.h"


struct game_t game;


/**	Aborts the game and displays the error message
 *
 * 	@note	EXIT_FAILURE is a portable constant for indicating
 * 		failure upon exiting a program.
 */
void nsnake_abort (char* error_msg)
{
	engine_exit ();
	mvprintw1(0,  0, error_msg);	// printf ("%s", error_msg);
	exit(-1);			// exit (EXIT_FAILURE);
}


/**	Interrupts the game and quits to the terminal.
 *
 * 	@note	EXIT_SUCCESS is a portable constant for indicating
 * 		success upon exiting a program.
 */
void nsnake_exit ()
{
	exit(0);	// exit (EXIT_SUCCESS);
}

/**	Starts all the necessairy stuff.
 *
 *	Sets all the global variables and call the initial functions so the
 *	game may start.
 * 	@see	hscore_init()
 * 	@see	player_init()
 * 	@see	fruit_init()
 * 	@see	engine_show_screen()
 */
void nsnake_init ()
{
	player_init ();
	fruit.bonus=5;
	fruit_init ();
	engine_show_screen ();
}


/**	It, umm, pauses the game, i guess
 */
void nsnake_pause ()
{
	engine_show_pause ();
}


/*------------------------------END-------------------------------------------*/
