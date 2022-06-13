## APCSFinalProject
Final project for APCS MKS22X course at Stuyvesant High School.

## Group Information

Group: Ninth Pointer

Group Members: Nicholas Tarsis, Frank Chun Yeung Wong

Project Description: A highly customisable tetris game implemented in Processing, with all proper features that are in actual Tetris, such as but not limited to proper rotation with wall kicks, scoring, keybindings, slow and hard drop, etc., with different gamemodes and things like block textures, as well as the ability for local multiplayer using different keybinds for each board, as well as additional features ("mods") that aren't in the Tetris base game as stretch goals.

Project Prototype & Documentation Document: https://docs.google.com/document/d/1FvqMwXQw_hHUwzitesEkLyG_I1G-hj4IdTMZmRyejwg/edit

## How to Compile and Run

This project is built in Processing and requires that to be downloaded. It also requires the Processing Sound library which should be installed.

To compile & run, load the sketch (inside `/Game/`) and press the run button in Processing.

Default keybindings are visible in the settings menu. To exit most menus or pause the game, press the ESC button. The ESC button also exits the game entirely if you are on the main menu.

To make custom textures from image files, look at `/tools/ImageToTexture/Guide_To_Textures.md` for more instructions.

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
		- Modified appearance of multiplayer mode
- May 31, 2022 (Tuesday)
	- Frank:
		- Speedrun getting multiplayer working before the demo branch deadline
		- Fix various bugs with multiplayer and the score system
	- Nicholas:
		- NA
- June 1, 2022 (Wednesday)
	- Frank:
		- Make a settings menu that allows textures & keybindings to be customised in-game
		- Update README.md's compile and run instructions
	- Nicholas:
		- Cleaned up some older code
- June 2, 2022 (Thursday)
	- Frank:
		- Make gravity increase over time and allow for more complex gravity changes over time
	- Nicholas:
		- Worked on the UML Diagram
- June 3, 2022 (Friday)
	- Frank:
		- Add garbage mechanism for multiplayer games
	- Nicholas:
		- Downloaded the processing sound library and found some sounds online
- June 4, 2022 (Saturday)
	- Frank:
		- NA
	- Nicholas:
		- Realized that those sounds weren't usable, and neither were custom made sounds
- June 5, 2022 (Sunday)
	- Frank:
		- NA
	- Nicholas:
		- NA
- June 6, 2022 (Monday)
	- Frank:
		- Add ghost block functionality and pre-game config to enable/disable it
	- Nicholas:
		- Found some bugs with how the ghost blocks and garbage interacted
- June 7, 2022 (Tuesday)
	- Frank:
		- Fix bug with multiplayer scoring
	- Nicholas:
		- Downloaded all of the sounds used in the Nintendo Switch Tetris 99 version
- June 8, 2022 (Wednesday)
	- Frank:
		- Allow hold block to be disabled for a game
	- Nicholas:
		- Added some other important sounds I forgot about
- June 9, 2022
	- Frank:
		- NA
	- Nicholas:
		- Created a new setup class for potential cheats
- June 10, 2022 (Friday)
	- Frank:
		- T-spins now give you extra points and garbage
	- NIcholas:
		- Updated the UML Diagram
- June 11, 2022 (Saturday)
	- Frank:
		- NA
	- Nicholas:
		- Added a new background
		- Fixed a bug where pieces could still move after being hard dropped
- June 12, 2022 (Sunday)
	- Frank:
		- Added debouncing to rotation to prevent spamming rotate by holding down rotate
		- Fixed a bug where ghost blocks could override the main block in some cases
		- Added basic version of evil tetris implementation which gives you the worst block, defined as the block that would result in the greatest height, each turn
	- Nicholas:
		- Fixed some bugs with evil tetris
		- Created board layouts that highlight the t spin and the tetris
		- Deleted some outdated class files
- June 13, 2022 (Monday)
	- Frank:
		- Fix bug with evil tetris audio
	-Nicholas:
		- NA
