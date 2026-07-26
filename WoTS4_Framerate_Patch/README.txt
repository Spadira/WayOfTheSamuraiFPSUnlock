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


REQUIREMENTS
------------
The DRM-free GOG build of Way of the Samurai 4.

  WayOfTheSamurai4.exe
    size   : 6,719,488 bytes
    SHA256 : CBF3BE3C0D4A68C7A1A2BEF919F74D567AA687CD4A1A21B210A0CE5DCE3780C5

  Common\Character\Action\MotionDatabase.l
    size   : 202,086 bytes
    SHA256 : 50829EDF1A6D934CBC7FB758259A421DF464DFFE877A7CCF7CD8FD13943EE7A1

THE STEAM VERSION WILL NOT WORK. Its executable is wrapped in
SteamStub DRM (the entry point sits in a ".bind" section and the real
code is encrypted on disk), so there is nothing to patch. This is not
something the patch can work around. Decrypted version may work.

The patcher verifies both files by SHA256 and refuses to touch
anything if they do not match, so trying is harmless.


INSTALL
-------
1. Copy Install.bat, patch.ps1 and SetFramerate.bat into the game
   folder - the one containing WayOfTheSamurai4.exe.
2. Run Install.bat.

It backs up the originals (WayOfTheSamurai4.exe.orig and
MotionDatabase.l.orig_bak), builds the 60/90/120 variants of both
files, and installs 60 fps. No admin rights needed.


SWITCHING
---------
Run SetFramerate.bat and pick 30 / 60 / 90 / 120. It swaps BOTH the
exe and the motion data - they must always match, which is why you
should switch with this tool rather than copying files by hand.

Close the game first; Windows will not replace a running exe.


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
game runs in slow motion rather than dropping frames.


UNINSTALL
---------
Run SetFramerate.bat and choose 30 (stock). That restores both
original files exactly.


TECHNICAL SUMMARY
-----------------
Per selected rate R, from stock:

  * frame cap: the double at 0x8d95a0 set to 1/R
  * all 40 "1/30" float time constants in the data sections set to 1/R
    (these drive animation playback, movement velocity, camera, menus
    and sound; halving only some of them leaves systems at 2x)
  * MotionDatabase.l: EndFrame, LoopStart, LoopEnd and InterpFrame
    scaled by R/30, so actions complete against the faster frame
    counter. Event, sound, effect, cancel and derivation frames are
    deliberately NOT scaled - scaling those breaks combat timing.
  * animation event window (0x450d4e) repointed to 0.5x(30/R), so
    motion sounds and effects fire exactly once per event instead of
    R/30 times
  * PhysX fixed timestep (0x8f9f24) set to 1/R
  * Spring Harvest drain constant (0x8d947c) scaled by 30/R
  * a small code hook that watches the script/event system and drops
    the cap and all 40 constants to 1/30 while a cutscene or menu is
    active, restoring 1/R afterwards

The exe also has ASLR disabled (DYNAMIC_BASE cleared) because the
injected code uses absolute addresses.

Enjoy :)
