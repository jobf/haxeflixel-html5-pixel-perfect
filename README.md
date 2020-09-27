# testing haxeflixel pixel scaling

This is a quick modifcation of the scale modes demo found here - https://haxeflixel.com/demos/ScaleModes/

The main purpose of this is to test out the pixel perfect render and pixel perfect position flags to see how they affect sprites when scaled.

Said flags help to an extent in that sub pixels are avoided when sprites are moved on the x and y axis, however some interpolation still exists during rotation.

Hopefully a shader can be used to scale up the pixels instead, some discussion of that can be found here - http://forum.haxeflixel.com/topic/1061/shader-scale-offset-problem

You can vew a built version here - https://jobf.github.io/haxeflixel-html5-pixel-perfect/