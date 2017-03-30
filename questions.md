Questions:
==========

1) What would be a way to read single characters consisting of multiple bytes without using threads?

I have done this way in my programm. So in my programm I don't use threads to read the characters from the keyboard. I have written a function. This function checks the buffer from the keyboard after every loop. Is the buffer empty the function give back the last tast which was push. If there is a new character in the buffer the function give this character back.

2) What change would you have to make to the `Snake` class to support more than one snake on the board?

For this change it have to be the double amount of inputs arguments. So the next head vertical postion, the next head horizontal position,  the length, the direction and the array from the snake have to be input arguments for two snakes. But this is not enough. There have also to be changes in the other classes to have a working game.
 For example: It is necessary to have two difernt control ways to play with two snakes.

3) Is it necessary to save, change and restore the state of the terminal
   every time before you read a single character?  If not, where else could
   you save, change and restore the state of the terminal.

It is not necesarry to save the states from the terminal before every read a single character. To make sure to have the states every time, maybe also if you close the game and wants to play later from this state, it is possible to export all the states in a .csv file in an extern folder. So before every game the programm checks this file and start to play on the last point which was saved there.

