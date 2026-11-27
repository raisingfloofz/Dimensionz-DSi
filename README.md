# Dimensionz DSi — first native prototype
Upload the extracted contents (including hidden .github folder) to a GitHub repository using Git or GitHub Desktop. Open Actions > Build Dimensionz DSi > Run workflow (or wait for the push build). Download Dimensionz-DSi artifact, unzip and copy Dimensionz.nds to your SD card. Launch through TWiLight Menu++. The app creates /Dimensionz on the card. Back up this folder regularly.

Controls: D-pad selects keys, A types, B deletes, X space, Y shift, L sends, R receives, SELECT switches scrolling, START returns to chats. In chat list A opens, X creates, Y renames. In new contact L/R changes dimension and START saves. Touch keyboard is experimental.

This is an uncompiled and hardware-untested prototype. Manual fictional chats, timestamps, seven dimensions, contact creation and SD saving are implemented. Scripted replies, contact packs, color themes, character memories and import from web edition are not implemented. No calls or photos. Console text UI, not graphical bubbles. Build workflow may require adjustments for current libnds toolchain. Do not use as sole copy of important chats until tested.

## Narration update
Y toggles Narrator Mode in a conversation. L or R posts timestamped narration while enabled; Y again returns to normal chat. Narration is stored in the same SD chat log. Tap the SHIFT row to change letter case; Y still changes case while editing contact names. The console interface uses centered narration text, not graphical bubbles.
