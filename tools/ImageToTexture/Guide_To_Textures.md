## Guide to Textures

Textures are saved as 1024 byte long binary files. The file is interpreted as a byte array with each byte representing the relative "darkness" of a tile relative to its base colour. `FF` is the base colour, and `00` is fully dark (ie. black). 

These textures can be generated automatically by `ImageToTexture.java`. It takes in any 32x32 image file and outputs a .texture file in the appropriate binary format.

To use it, run `java ImageToTexture default.png`, with default.png being any input file. The output will be written into a file called `default.texture`, with default replaced with the file name of the input file you specified.
