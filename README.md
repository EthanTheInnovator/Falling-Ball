# Stacker
 A simple motion based game where you fall through rising platforms

Wait a minute, is this UIKit I see? Why isn't it SwiftUI?

   You may be asking yourself the above questions right now. Don't worry, we'll get to it.
   For my project I decided to make a game where a ball is falling through holes in an ever growing tower (you often see this type of game in ads).
   The premise is simple: Don't get brought to the top of the screen, that causes game over!
   Going through a gap gives you one point and making it to the bottom of the screen gives you five.
   I'm surprisingly not using the Gyroscope for this project; Here's why:
       Well I initially thought the gyroscope and accelerometer did opposite things...
       In actuality, I wanted the game's gravity to correspond with real life gravity, and the simplest way to do this was to use the accelerometer
       At least, I assume it is the accelerometer because there's just one class that handles motion combining both Gyro and accelerometer together.
       Anyway, the point is that accelerometer allowed my motions in the game to most accurately correspond with gravity. If I had used gyro then it could easily become out of sync with actual gravity.
   I did some simple vector manipulation to ensure that the game can't be cheesed.
       Gravity vector in the game always has the same magnitude so you can't just stall the game.
       You can't turn the phone upside down to make it go up to purposefully die.
   And yes, I used UIKit simply because I wanted to have a view for the high score and have that sceen go directly into the SpriteKit scene.
   Remember a few projects ago (the GlobalGuesser app) when I worked really hard on a high score system only to find a bug in SwiftUI that prevented me from using it?
   Well I designed that so well that all I had to do was copy the files and it worked immediately!
       Yeah I just proved that my old code worked and that I wasn't faking it, lol.
       All I had to do was display the list in a table view in UIKit instead of SwiftUI.
       I was actually surprised because I thought I'd have to edit it a lot but I made it so modular that it just worked
   
   Bugs:
       - Collisions in SpriteKit. Most of the time they're great. Sometimes they double register even when I have variables telling them not to. Unsure why this happens. This means sometimes you'll get double points for hitting a goal (I've noticed it's when you hit the side of a platform while going through the hole). I've tried to fix it but can't so have fun with the inflated high score.
       - The last bug also means you may be able to rack up lots of points if you get to the bottom of the screen, but it's decently difficult to do that and STAY there so I guess you've earned it at that point.
       - I decided against showing whether or not you got the high score in the game itself because right after you're moved to the leaderboard anyway.
