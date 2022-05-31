## APCSFinalProject
Final project for APCS MKS22X course at Stuyvesant High School.

## Group Information

Group: Ninth Pointer

Group Members: Nicholas Tarsis, Frank Chun Yeung Wong

Project Description: A highly customisable tetris game implemented in Processing, with all proper features that are in actual Tetris, such as but not limited to proper rotation with wall kicks, scoring, keybindings, slow and hard drop, etc., with different gamemodes and things like block textures, as well as the ability for local multiplayer using different keybinds for each board, as well as additional features ("mods") that aren't in the Tetris base game as stretch goals.

Project Prototype & Documentation Document: https://docs.google.com/document/d/1FvqMwXQw_hHUwzitesEkLyG_I1G-hj4IdTMZmRyejwg/edit

## Development Log

- May 23, 2022 (Monday)
	- Frank:
		- Getting a block and the screen to render in Processing
		- Getting a block to fall down by gravity
		- Pass through key presses and allow gravity to be adjusted by the up/down arrow
		- Make the block movable with A/D
		- Make the block lock in place when it can't move anymore and after a .5s delay, after which a new block is spawned
	- Nicholas: 
		- Created initial class files
		- Added some methods and instance variables

- May 24, 2022 (Tuesday)
	- Frank:
		- Make blocks lock in place when they can't move anymore
		- Make Z drop a block to the lower-most position
		- Make blocks rotate when Q/E pressed and hardcode in rotation data
		- Make rows disappear once they are filled
		- Make blocks generate randomly while not having long streaks based on a bag-based system
		- Display the next block on the board
	- Nicholas: 
		- Added configurations for the other possible tetrominoes
	
- May 25, 2022 (Wednesday)
	- Frank:
		- Added end of game detection when board filled
		- Basic score system with it being displayed on the board as well
	- Nicholas:
		- Changed the appearances of blocks(different colors and borders for the square tiles)

- May 26, 2022 (Thursday)
	- Frank:
		- Added soft drop functionality
		- Added ability to hold pieces
		- Set up system for persistent file based data storage and DataLoader class
		- Implement a high score mechanism which also acts as a test for persistent data storage
	- Nicholas:
		- Changed the board so that it resembled a grid

- May 27, 2022 (Friday)
	- Frank: 
		- Patch bug with text colours
		- Separate data file into a default one, and a local one which isn't on .gitignore
		- Add wall kicks
		- Add texture loading functionality as well as a Java command-line tool to convert .png files into the custom binary texture format
		- Allow customising keybindings from the config file
	- Nicholas:
		- NA
- May 28, 2022 (Saturday)
	- Frank:
		- Add pause menu
		- Add start new game menu
		- Add main menu
	- Nicholas:
		- NA
- May 29, 2022 (Sunday)
	- Frank:
		- NA
	- Nicholas:
		- Created layout for settings menu
		- Added multiplayer menu
		- Allowed for resizability with surface methods
- May 30, 2022 (Monday)
	- Frank:
		- Add return to main menu and start same game with previous configurations options to end game screen
		- Make scores differ by gravity rate to incentivise higher difficulties, also allow finetuning gravity rate by 1 frame for values less than 1 line per 10 frames
		- Implement DAS (Delayed autoshift) system so the rate blocks is independent of system key repeat settings
	- Nicholas:
		- modified appearance of multiplayer mode
