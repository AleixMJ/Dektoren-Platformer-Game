
# DEKTOREN - LOVE2D LUA GAME - FINAL PROJECT CS50
#### Video Demo : https://www.youtube.com/watch?v=NWrW3CVtbO8
#### Description:

Dektoren is a 2D platform built with LOVE2d with the Lua programming language. The game consists in advancing through the map collecting as many coins as you can without dying by either running out of hearts or falling over. You can play the game using a keyboard either using a,w,s,d or the left, up, down and right arrows. The game also allows you to double jump (you can jump with w, up arrow or space). In order to build the game I installed a STI library which can be found in the credits and the program Tiled which helps you to build maps for games.


Most of the game decisions I did were based on the art I could fetch that was free and without copyrights. I started to build the game with less objects but as I progressed I added more and more objects and improved the ones I had by giving sound, changing the art and adding animations. I wanted to make that look nice so that is why I also learnt to use GIMP a bit in order to modify the art accordingly and split images into different files to show animations. The code was fairly challenging and I decided to use a library that includes gravity from box2d which seems quite standard from what I have seen in out there. On some ocassions I went to the discord of Lua to ask for advise as well as reading different documentations. The part that took me more time was to build objects that were not affected by gravity (movable platform) and I was really proud once I managed it. I tried to calculate the oposite of the world gravity and added to the object but it either fly above the screen or falled slowly. At the end I found the kinematic property within the library and changed a few bites of the code which allowed me to successfuly add the object as I wanted. Finally, I have so many ideas to keep building the game which I may do in the future.


Currently, the game consists on two levels and it has plenty of obstacles. Including boxes, enemies, movable platforms, etc. Below I describe each of the sections of the code:


* __Assets__:
This folder cointains all the art and animation for all the objects used in the game.

* __Map__:
This folder cointains the Tiled files of the map alongside the lua exported link for each level.

* __sti__:
This folder is the library that I used which is based on box2d which handles collisions and also syncronised with maps built with Tiled.

* __box.lua__:
This file codes the actions of the boxes that you can push in the map.

* __camera.lua__:
This file codes manages how the camera follows the Player. It specially blocks advancing the camera to the left and bottom of the map to keep a nice view of the map and player even when the character moves to the corner.

* __coin.lua__:
This file codes the entity coin which makes sound on collection, increases the score and has a nice animation on top.

* __conf.lua__:
This is the standard configuration file, which stablishes the resolution of the game.

* __golem.lua__:
This is one of the enemies of the game. The strongest one in particular as if it hit you it takes all your life. It moves across the map until it finds an obstacle and then turns on each colission.

* __gui.lua__:
This file keeps track of the life you have (number of hearts) and coins you have collected and displays them in each top corner of the screen.

* __main.lua__:
This is the main file of the game that is needed in every Lua game. It ensures the game Loads, keeps being updated and displays everyting.

* __map.lua__:
This file loads the map with all the entities and also processes the transition to the next level by removing all files and entities and loading the new level.

* __platform.lua__:
This file is is the code used to make the movable platforms move in the map. I have only used them in the level two.

* __player.lua__:
This is the file that represents the main character. It is in fact the longest file as it interacts with many files. It set's how the player moves, animates and interacts with each of the different objects by either taking damage, pushing items, increasing coins, etc.

* __slime.lua__:
This is the basic enemy that you encounter in all levels. It moves slow and it is a good enemy to encounter early and practice.

* __spikes.lua__:
This file gives property to a floor spike in which if the player collides with it removes one of the hearts.

* __vampire.lua__:
This is the file of the last enemy I built which you encounter in the second level. The difference between the prior ones despite the different animations is that this enemy flies and is not affected by the world gravity like the others.

* __Credits to__:

- Environment art tiles - Magic Cliffs created by ansimuz https://ansimuz.itch.io/magic-cliffs-environment
- Used the sti library from Simple-Tiled-Implementation done by karai17 https://github.com/karai17/Simple-Tiled-Implementation
- Hero player sprite art from @Clembod https://clembod.itch.io/
- Heart stripe art from DontMind8.blogspot.com
- Slime art from bloodfall90 downloaded from https://bloodfall90.itch.io/slime-enemy
- Golem art from Kronovi https://darkpixel-kronovi.itch.io/
- World Atlas - Free Asset Pack by Anokolisa https://anokolisa.itch.io/world-atlas
- Pixel Cave Tileset from https://randomizedpixels.itch.io/pixel-cave-tileset
- Music from https://www.zapsplat.com/
- Sound effects from https://mixkit.co/free-sound-effects
- Vampire art from Luizmelo https://luizmelo.itch.io/monsters-creatures-fantasy

Finally, I want to give credits to SkyVaultGames and DevJeeper who have great tutorials for lua which helped me a lot building this game https://www.youtube.com/c/DevJeeper