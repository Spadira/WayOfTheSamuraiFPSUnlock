================================================================
  Way of the Samurai 4 (PC) - Framerate Patch
  60 / 90 / 120 fps
================================================================

WHAT IT DOES
------------
The PC port runs at a hard 30 fps. This patch raises the framerate.

The engine is frame-count driven - it advances one logic tick per
rendered frame with no delta-time - so simply unlocking the cap makes
everything run 2x/3x/4x too fast. This patch rescales the engine's
time constants and the motion database to compensate.

Correct at every rate:
  * player and NPC movement speed
  * animation playback, and actions complete instead of cutting short
  * camera, menus, combat timing, hit and cancel windows
  * looping item actions (eating, whetstone) finish instead of
    soft-locking
  * animation sound effects fire once instead of repeating
  * Spring Harvest gauge drain rate
  * cutscenes and menus, which drop to native 30 fps automatically
    so their scripted sequencing stays correct


WHICH VERSIONS WORK
-------------------
1) GOG build - works directly.

     WayOfTheSamurai4.exe
     SHA256 CBF3BE3C0D4A68C7A1A2BEF919F74D567AA687CD4A1A21B210A0CE5DCE3780C5

2) Steam build - ONLY after you unpack it yourself.

   The Steam executable ships wrapped in SteamStub DRM: its code is
   encrypted on disk, so there is literally nothing to patch. Unpack it
   with a tool such as Steamless, replace WayOfTheSamurai4.exe with the
   unpacked executable, and then run this patcher.

     unpacked WayOfTheSamurai4.exe
     SHA256 DC7F896B0C76BC4EEAFF031638CA6521613A6B444FBC27765AEEDDF2504BA597

   This package does NOT unpack anything for you and does not ship an
   unpacked executable. If you run it against the still-packed Steam
   exe it will tell you so and change nothing.

   Note the Steam release is a DIFFERENT COMPILATION from the GOG one -
   not a repack - so it needed its own set of addresses. The patcher
   detects which edition it is looking at and applies the right one.

Both editions share identical game data, so the motion-data patch is
the same for both.

  Common\Character\Action\MotionDatabase.l
  SHA256 50829EDF1A6D934CBC7FB758259A421DF464DFFE877A7CCF7CD8FD13943EE7A1


INSTALL
-------
1. Copy Install.bat, patch.ps1 and SetFramerate.bat into the game
   folder - the one containing WayOfTheSamurai4.exe.
2. Run Install.bat.

It backs up the originals (WayOfTheSamurai4.exe.orig and
MotionDatabase.l.orig_bak), builds the 60/90/120 variants of both
files, and installs 60 fps. No admin rights needed.

Everything is verified by SHA256 first; an unrecognised build is
refused rather than corrupted.


SWITCHING
---------
Run SetFramerate.bat and pick 30 / 60 / 90 / 120. It swaps BOTH the
exe and the motion data - they must always match, which is why you
should switch with this tool rather than copying files by hand.

Close the game first :p

60 FPS IS THE SWEET SPOT
------------------------
60 fps is fully polished and is what the patch installs by default.

90 and 120 are playable and gameplay is correct - movement, animation,
camera, combat and cutscene pacing are all right - but a few systems
remain tied to the frame rate and get worse as the rate climbs:

  * pre-rendered FMV movies play fast
  * kicked pickup-items (rifles and similar) move fast
  * some UI gauge animations run fast

These are engine-level couplings with no clean scaling constant, not
oversights. If anything feels off at 120, drop to 60.

Also note: because the engine is frame-count based, the game has no
true variable framerate. If your PC cannot hold the target rate, the
game runs in slow motion rather than dropping frames. Pick a rate your
machine can actually sustain.


UNINSTALL
---------
Run SetFramerate.bat and choose 30 (stock). That restores both
original files exactly.


TECHNICAL SUMMARY
-----------------
Per selected rate R, from stock:

  * frame cap set to 1/R
  * every "1/30" float time constant in the data sections set to 1/R
    (40 of them on GOG, 39 on Steam). These drive animation playback,
    movement velocity, camera, menus and sound; halving only some of
    them leaves systems running fast.
  * MotionDatabase.l: EndFrame, LoopStart, LoopEnd and InterpFrame
    scaled by R/30, so actions complete against the faster frame
    counter. Event, sound, effect, cancel and derivation frames are
    deliberately NOT scaled - scaling those breaks combat timing.
  * animation event window scaled to 0.5x(30/R), so motion sounds and
    effects fire exactly once per event instead of R/30 times
  * PhysX fixed timestep set to 1/R
  * Spring Harvest drain constant scaled by 30/R
  * a small code hook that watches the script/event system state and
    drops the cap and all the time constants to 1/30 while a cutscene
    or menu is active, restoring 1/R afterwards

