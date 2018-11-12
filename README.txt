# Introduction

This is a disassembly of Chuckie Egg for the BBC Micro targeting the beebasm assembler.

It exactly reproduces the executable from the version of Chuckie Egg here:
http://www.bbcmicro.co.uk/game.php?id=25
It doesn't include the loading program, which is purely decorative.

The build creates a new executable and compares it to the original; and creates a bootable ssd.

This initial version is entirely machine-generated.  It doesn't have any comments.  However, all the variables and labels have been given meaningful names.  Bytes from &80-&8F are used as scratch space so they are mostly unlabelled.

The disassembler splits the source into scope blocks.  It chooses the minimum number of blocks such that code is always in a block and the entry point isn't.  So the blocks are rather arbitrary.  If the entry point had been at the start then there would be only one block.

All references to memory locations are symbolic except for three because the disassembler isn't smart enough to spot them:

* The reference to sprite_lookup_table (&1100) in lookup_sprite.
* The reference to the high score table (&0430) in location_of_highscore_x.
* The reference to the screen start (&3000) in calculate_screen_location.

And one because it creates too many false positives:

* The interval timer buffer (&0000) used in wait_for_interval_timer.

# TODO

Step away from the disassembler and:

* Fix the four memory references
* Give names to all the magic numbers (bit masks, osbyte calls, etc.)
* Add comments

# Terminology

Invented and used in the labels.

* Scenario - one of the eight level designs.
* Round - a pass through the eight designs.  i.e. Round 0 is levels 1-8, round 1 is levels 9-16, etc.
* Cell - an 8x8 segment of the screen.  It contains a piece of wall or ladder or an egg or whatever.
* Board - a 20x25 array with one byte per cell.  It is initialised from the current scenario.
* Carousel - the sequence of screens shown before a game starts.

# Notes

Y coordinates go upwards from 0 at the bottom of the screen.

Each byte in the board describes the corresponding cell and is interpreted thus:

* 1 - wall
* 2 - ladder - bits 1 and 2 can be set together
* 4 - egg - top nibble is egg number from zero
* 8 - grain - top nibble is grain number from zero

The player state at &0500 is replicated every 64 bytes, once for each of the four players.  The current player number times 64 is stored in player_data_index.

key_press_bits are:

*   1 - right
*   2 - left
*   4 - down
*   8 - up
*  16 - jump
* 128 - ESC+H

chicken_directions are mutually exclusive when stored, but any combination can be set while a direction is being chosen:

* 1 - left
* 2 - right
* 4 - up
* 8 - down

chicken_states are mutually exclusive:

*  0 - plumb on cell, need to make choice of next direction
*  1 - halfway through executing chosen move
*  2 - going down for grain
*  4 - the actual consumption step
*  8 - coming up
* 16 - and finishing

duck_direction_flap:

* Bit 1 - 0 wing down, 1 wing up
* Bit 2 - 0 right, 2 left

harry_state:

* 0 - on wall
* 1 - on ladder
* 2 - in jump
* 3 - falling
* 4 - on lift
