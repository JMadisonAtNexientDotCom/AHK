;------------------------------------------------------------------------------+
; JOHN MARK ISAAC MADISON'S CHORD SCRIPT FOR FAST ONE HANDED TYPING 2016.03.03 |
;------------------------------------------------------------------------------+
;##############################################################################|
#NoEnv  ; Performance & Compatibility.                             ############|
; #Warn ; Enable Warnings For Debugging.                           ############|
SendMode Input  ; Superior Speed and Reliability.                  ############|
SetWorkingDir %A_ScriptDir%  ; Ensures consistent start directory. ############|
;##############################################################################|
;------------------------------------------------------------------------------+


global NUMCHORD_1100 ;subtraction
global NUMCHORD_0011 ;MULTIPLY

global NUMCHORD_0110 ;ADD
global NUMCHORD_1001 ;division

global NUMCHORD_1010 ;shift left.
global NUMCHORD_0101 ;shift right.

global NUMCHORD_1110 ;EQUALS
global NUMCHORD_0111 ;POWER OF

;combinations for CHAN (change mode) modifier.
;Only 3 keys. Because the least significant bit of chord is unreachable
;because you only have 4 fingers. And one of them is on the CHAN button,
;so you can only use 3 main chord buttons.
global C_001E
global C_010E
global C_100E
global C_011E
global C_110E
global C_101E
global C_111E

;--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a-|||
;What is the app matrix?                                                     |||
;--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a-|||
;The app matrix is a 3x4(height-x-width)                                     |||
;matrix used for app-specific shortcuts.                                     |||
;--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a-|||
;It is assembled by shifting all 3 chord rows together into a matrix.        |||
; looks kinda like this:                                                     |||
;                       SPATIAL LAYOUT:                                      |||
;                            0000  <--TOP bits. Most significant bits.       |||
;                            0000  <--MID bits.                              |||
;                            0000  <--BOT bits. Least significant bits.      |||
;--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a--a-|||

;Tapping MOV-MODE shortcut key twice in a row without touching any other keys
;Will activate application-specific shortcut keys for the following keypress.
;And then automatically exit that mode.
;Original usage: Mapping visual studio shortcut keys
global MOV_TAPS ;how many times MOV key has been tapped in a row. 
global MASK4_1111 ;mask of first 4 bits.
global BOT_MASK_0000_0000_1111 ;//mask for first 4 bits. 
global MID_MASK_0000_1111_0000 ;//mask for next group of 4 bits.
global TOP_MASK_1111_0000_0000 ;//mask for last group of 4 bits.
global BOT_AMSHIFT ; //how much to shift BOT to get into app matrix.
global MID_AMSHIFT ; //how much to shift MID to get into app matrix.
global TOP_AMSHIFT ; //how much to shift TOP to get into app matrix.

;hard-coded hot-key matrix combinations.
;Because not all 4095 possible combinations are TYPE-ABLE!
;And thus, using an array to lookup would be a waste of memory.
;The array would have a lot of holes in it.

global AM_1111_0000_0000
global AM_0000_1111_0000
global AM_0000_0000_1111

AM_0000_0000_0000 :=


;  2 finger keypress combos:
;  Grid: 2x3 of horizontally orientated rectangles.
;  +---+---+---+---+
;  |   TL  |   TR  |
;  +---+---+---+---+
;  |   ML  |   MR  |
;  +---+---+---+---+
;  |   BL  |   BR  |
;  +---+---+---+---+
global AM_1100_0000_0000 ;TL  -top left
global AM_0011_0000_0000 ;TR  -top right
global AM_0000_1100_0000 ;ML  -mid left
global AM_0000_0011_0000 ;MR  -mid right
global AM_0000_0000_1100 ;BL  -bot left
global AM_0000_0000_0011 ;BR  -bot right

;just one key pressed within entire matrix:
global AM_0000_0000_0001
global AM_0000_0000_0010
global AM_0000_0000_0100
global AM_0000_0000_1000
global AM_0000_0001_0000
global AM_0000_0010_0000
global AM_0000_0100_0000
global AM_0000_1000_0000
global AM_0001_0000_0000
global AM_0010_0000_0000
global AM_0100_0000_0000
global AM_1000_0000_0000

global APP_MAT ;the current application shortcut matrix that has been made.



;how do we prevent stuck keys???
;1: Could NOT allow keys to be held down, and use auto-release exclusively.
;2: Key should get unstuck if pressed again.

;Attempts to fix bug of chord being repeated multiple times on release
;of all fingers.
global SEND_ME

;------------------------------------------------------------------------------+
;BACKGROUND INFO:                                                              |
;--------------------------------------------------------------------------+---+
;I suspect infrequent error (1% when testing 10% in actual typing use)     |
;is caused by multiple keys being released at EXACTLY the same time.       |
;(If this is true, the only letters that have this error are letters that) |
;(need more than one key to create the chord)                              |
;...                                                                       |
;(It IS true. And it does NOT need to be a key that requires)              |
;(the chord modifier key. (Spacebar in my implementation) )                |
;---------------------------------------------------------------------+----+
;SOLUTION: Establish chord bit precedence.                            |
;On chord-up event for a key, a bit is set representing the exact     |
;key location that just went up. Of the simultaneously released       |
;keys, only the key with maximum precedence is used to release        |
;the chord, preventing duplicate characters from ending up on screen. |
;-------------------------+-------------------------------------------+
global JUSTUP_ALT_KEYS   ;| <--Don't need. No concurrency going on.
global JUSTUP_TOP_KEYS   ;| <--Don't need. No concurrency going on.
global JUSTUP_MID_KEYS   ;| <--Don't need. No concurrency going on.
global JUSTUP_BOT_KEYS   ;| <--Don't need. No concurrency going on.
;-------------------------+

;-----------------------------------------------------------+
;Tracks the current shortcut being built:               ;;  |
;-----------------------------------------------------------+
global BRACK_SSS ;[bracket] shortcut stack string       ;;  |
global ANGLE_SSS ;<angle bracket> shortcut stack string ;;  |
global ARROW_SSS ;>arrow shortcut stack string          ;;  |
global ACTIVE_SSS ;Points to one of the ??_SSS strings  ;;  |
                                                        ;;  |
global BRACK_CHAR_OPENED                                ;;  |
global BRACK_CHAR_CLOSED                                ;;  |
                                                        ;;  |
global ANGLE_CHAR_OPENED                                ;;  |
global ANGLE_CHAR_CLOSED                                ;;  |
                                                        ;;  |
global ARROW_CHAR_OPENED                                ;;  |
global ARROW_CHAR_CLOSED                                ;;  |
;-----------------------------------------------------------+

;what shortcut are you collecting?
global COLLECTION_MODE
global CM_BRACK
global CM_ANGLE
global CM_ARROW

;assoc arrays for shortcuts
global BRACK_KEY_TO_FILEPATH
global ANGLE_KEY_TO_FILEPATH
global ARROW_KEY_TO_FILEPATH



;-----------------------+=====================================================++
;What is AUTO-RELEASE?  |====================================================|||
;-----------------------+--------------------------------------------------+ |||
;Auto-Releasing is the act of unloaded a pressed chord without physically  | |||
;Releasing the keys. It is done if a time-out interval is hit after the    | |||
;Last key is pressed.                                                      | |||
;-----------------------+--------------------------------------------------+ |||
;Why are we using it?   |                                                    |||
;-----------------------+--------------------+                               |||
;  1:Used to get rid of the "bug" that       |                               |||
;    happens when Pressing chords very fast. |                               |||
;  2:Will give better more natural feedback, |                               |||
;    allowing faster typing.                 |                               |||
;--------------------------------------------+                               |||
;    I say "bug" because pretty sure the     |                               |||
;    script is working as intended, But      |                               |||
;    there are limits to human perception.   |                               |||
;--------------------------------------+-----+---------------------------+   |||
;                                      |                                 |   |||
; [Q][W] "bug":                        |                                 |   |||
;                                      |                                 |   |||
; Hold Q down while  | Release Q while | Intended effect:                |   |||
; W is released:     | Pressing W      | Want Q and W chords to play.    |   |||
;     [ ]  [W]       |     [^]  [ ]    | Instead, we get QW combo chord. |   |||
;   --[ ]--[ ]--     |   --[Q]--[W]--  |                                 |   |||
; 1:  [Q]  [ ]       | 2:  [ ]  [V]    | WHY? Because W hits the bottom  |   |||
;                                      | before Q hits the top. Making   |   |||
; That is why I say "bug", it is a     | BOTH key presses registered     |   |||
; matter of perception, but believe    | before any key RELEASE.         |   |||
; everything is working as I intended  |                                 |   |||
;--------------------------------------+---------------------------------+   |||
;                                                                            |||
;---------------------------+================================================+||
global AUTO_RELEASE_TIMER  ;|=================================================+|
global AUTO_RELEASE_MS     ;|=================================================+|
;---------------------------+==================================================+

;---------------------------------------------------------------------+
;Need integers to keep track of which keys are currently down         |
;So that we can avoid sending multiple signals per key press.         |
;The multiple signals are causing the chords to be mis-interpreted.   |
;--------------+------------------------------------------------------+
;Special Keys:-----------------------------------------------------------------+
;                                                                              |
;   Special Combos:                                                            |
;   CHAN + ALTR ---> Exit Chord Script, use normal keyboard.                   |
; 	CHAN + FWRD ---> Enter chord script, use one hand keyboard.                |
;                                                                              |
;   Bit Patterns:                                                              |
; 	BACK = 1000   //used as backspace or delete key.                           |
; 	              //ALSO: When held should type numbers.                       |
; 	FWRD = 0001   //used as space,enter, or tab key.                           |
; 	MOVE = 0010   //used for entering move-mode                                |
; 	CHAN = 0100   //used for changing between one hand and two hand keyboard.  |
; 	              //also used to invoke Cut,Paste,Copy, and Select all.        |
; 	ALTR = 1_0000                                                              |
; +------+ +---+---+---+---+ +------+                                          |
; | CHAN | | 4 | 3 | 2 | 1 | | FWRD |                                          |
; +------+ +---+---+---+---+ +------+                                          |
; | BACK | | 4 | 3 | 2 | 1 | | FWRD |                                          |
; +------+ +---+---+---+---+ +------+                                          |
; | MOVE | | 4 | 3 | 2 | 1 | | FWRD |                                          |
; +------+ +---+---+---+---+ +------+                                          |
; +---------------------------------+                                          |
; |                ALTR             |                                          |
; +---------------------------------+                                          |
;                                                                     +--------+
global IS_DOWN_ALT_BACK ;backwards modifier. Backspace+(shift-tab).   |
global IS_DOWN_ALT_FWRD ;forwards modifier.  Space+Tab.               |
global IS_DOWN_ALT_ALTR ;Alternate Chord modifier.                    |
global IS_DOWN_ALT_MOVE ;Move mode modifier. Must be held down.       |
global IS_DOWN_ALT_CHAN ;Change Mode key.                             |
;Top Row:___________________________________________________________/-+
global IS_DOWN_TOP_0001   ;                                           |
global IS_DOWN_TOP_0010   ;                                           |
global IS_DOWN_TOP_0100   ;                                           |
global IS_DOWN_TOP_1000   ;                                           |
;Mid Row:___________________________________________________________/-+
global IS_DOWN_MID_0001   ;                                           |
global IS_DOWN_MID_0010   ;                                           |
global IS_DOWN_MID_0100   ;                                           |
global IS_DOWN_MID_1000   ;                                           |
;Bot Row:___________________________________________________________/-+
global IS_DOWN_BOT_0001   ;                                           |
global IS_DOWN_BOT_0010   ;                                           |
global IS_DOWN_BOT_0100   ;                                           |
global IS_DOWN_BOT_1000   ;                                           |
;---------------------------------------------------------------------+


;----------------+
global N_0_0001 ;|
global N_0_0010 ;|
global N_0_0100 ;|
global N_0_1000 ;|
global N_1_0000 ;|
;---------------;|
global N_1_0001 ;|
global N_1_0010 ;|
global N_1_0100 ;|
global N_1_1000 ;|
;----------------+
global DEL_MAP  ;|
global TOP_MAP  ;|
global MID_MAP  ;|
global BOT_MAP  ;|
;----------------+
global DEL_BITS ;|
global TOP_BITS ;|
global MID_BITS ;|
global BOT_BITS ;|
;----------------+------------+
;Non-Zero == TRUE            ;|
;Set to a chord enum below.  ;|
global IS_CHORD_LOADED       ;|
;-----------------------------+-------------------+
global DEL_CHORD ;enums to identify which        ;|
global TOP_CHORD ;cord is currently active       ;|
global MID_CHORD ;only the active chord is       ;|
global BOT_CHORD ;unloaded when up key detected. ;|
;-------------------------------------------------+

SetDefaults(void) ;===========================================================++
{ ;===========================================================================++


	NUMCHORD_1100 := 12 ;subtraction
	NUMCHORD_0011 := 3  ;MULTIPLY
          
	NUMCHORD_0110 := 6  ;ADD
	NUMCHORD_1001 := 9  ;division
               
	NUMCHORD_1010 := 10 ;shift left.
	NUMCHORD_0101 := 5  ;shift right.
                
	NUMCHORD_1110 := 14 ;EQUALS
	NUMCHORD_0111 := 7  ;POWER OF

  ;C stands for CHAN for change mode key.
	;E stands for EMPTY, as in the least significant bit of
	; of the 4 bits #### / 0000, is always NOT SET.
	C_001E := 2
	C_010E := 4
	C_100E := 8
	C_011E := 6
	C_110E := 12
	C_101E := 10
	C_111E := 14

	N_0_0001 := 1  ;left-most  in row-of-4                           ;==========++
	N_0_0010 := 2  ;left-mid   in row-of-4                           ;==========++
	N_0_0100 := 4  ;right-mid  in row-of-4                           ;==========++
	N_0_1000 := 8  ;right-most in row-of-4                           ;==========++
	N_1_0000 := 16 ;our ALT modifier key                             ;==========++
                                                                   ;==========++
  ;Derived compound keys for special characters                    ;==========++
  N_1_0001 := N_0_0001 | N_1_0000                                  ;==========++
	N_1_0010 := N_0_0010 | N_1_0000                                  ;==========++
	N_1_0100 := N_0_0100 | N_1_0000                                  ;==========++
	N_1_1000 := N_0_1000 | N_1_0000                                  ;==========++
                                                                   ;==========++
  ;-----------------------------+
  ;initialize shortcut stack   ;|
  ;strings to empty strings    ;|
  ;-----------------------------+
  BRACK_SSS := ""              ;|
  ANGLE_SSS := ""              ;|                                                    
  ARROW_SSS := ""              ;|
  ;-----------------------------+
  BRACK_CHAR_OPENED := "["     ;|
  BRACK_CHAR_CLOSED := "]"     ;|
  ;-----------------------------+
  ANGLE_CHAR_OPENED := "<"     ;|
  ANGLE_CHAR_CLOSED := ">"     ;|
  ;-----------------------------+
	;inverse of angle            ;|
  ARROW_CHAR_OPENED := ">"     ;|
  ARROW_CHAR_CLOSED := "<"     ;|
  ;-----------------------------+
	
	MOV_TAPS := 0 ;init amount of times key tapped in row == 0
	MASK4_1111              := 15
	BOT_MASK_0000_0000_1111 := 15
	MID_MASK_0000_1111_0000 := 240
	TOP_MASK_1111_0000_0000 := 3840
	BOT_AMSHIFT := 0 ;zero to shift BOT_BITS into place in app matrix.
	MID_AMSHIFT := 4 ;4 to shift MID_BITS into app matrix.
	TOP_AMSHIFT := 8 ;8 to shift TOP_BITS into app matrix.
	

	
	;Smash an entire row:
  AM_1111_0000_0000 := 3840
	AM_0000_1111_0000 := 240
	AM_0000_0000_1111 := 15
	
	;2x3 horizontal rectangle grid of key combos:
	AM_1100_0000_0000 := 3072
	AM_0011_0000_0000 := 768
	AM_0000_1100_0000 := 192
	AM_0000_0011_0000 := 48
	AM_0000_0000_1100 := 12
	AM_0000_0000_0011 := 3
	
	;ONE KEY ONLY MATRIX COMBOS:
	AM_0000_0000_0001 := 1
	AM_0000_0000_0010 := 2
	AM_0000_0000_0100 := 4
	AM_0000_0000_1000 := 8
	AM_0000_0001_0000 := 16
	AM_0000_0010_0000 := 32
	AM_0000_0100_0000 := 64
	AM_0000_1000_0000 := 128
	AM_0001_0000_0000 := 256
	AM_0010_0000_0000 := 512
	AM_0100_0000_0000 := 1024
	AM_1000_0000_0000 := 2048
	
	COLLECTION_MODE := 0
	CM_BRACK := 1
	CM_ANGLE := 2
	CM_ARROW := 3
	
	;---------------------------------------------------
	;init assoc arrays
	;what is stored here is enforced by convention 
	;---------------------------------------------------
	;help docs, snippets, shortcut paths
	BRACK_KEY_TO_FILEPATH := {"TEST_KEY":"TEST_VALUE"} 
	PATH := "CODE_SNIPPET\FILE_TO_KEY_MAPPING.txt"
	LOAD_SHORTCUT_FILE(PATH , BRACK_KEY_TO_FILEPATH, 0, 1)
	
	;angular and other library specific shortcuts
	ANGLE_KEY_TO_FILEPATH := {"TEST_KEY":"TEST_VALUE"} 
	PATH := "CODE_SNIPPET\FILE_TO_LIB_MAPPING.txt"
	LOAD_SHORTCUT_FILE(PATH , ANGLE_KEY_TO_FILEPATH, 0, 1)
	
	;points to executables
	ARROW_KEY_TO_FILEPATH := {"TEST_KEY":"TEST_VALUE"} 
	PATH := "CODE_SNIPPET\FILE_TO_EXE_MAPPING.txt"
	LOAD_SHORTCUT_FILE(PATH , ARROW_KEY_TO_FILEPATH, 0, 1)

	
	;prevent symultanious release of keys
	;from releasing duplicate chords.
	JUSTUP_ALT_KEYS := 0
	JUSTUP_TOP_KEYS := 0
	JUSTUP_MID_KEYS := 0
	JUSTUP_BOT_KEYS := 0
	
	;auto release configuration, so chords can be more like natural typing where
	;key-down will release a chord:
	;125 == too slow. 1000MS in a second. 1/8th == 125.
	; 8MS maybe? Also seems to be the SAME speed... why???
	AUTO_RELEASE_MS := 125
	AUTO_RELEASE_TIMER := A_TickCount 
	
	;This is a bit buggy right now. Tends to dispatch multiple keys!
	;Also, even when this is not on, we seem to have multi chord error on first
	;key pressed when script re-boots. Figuring out that error might be key to
	;figuring out the error with the auto release check.
	;SetTimer AUTO_RELEASE_CHECK, 1
  
                                                                   
  ;-----------------------------------------------------------+    ;==========++
  ;upon initialization, flag all chord keys as NOT being down |    ;==========++
  ;Special "Alt" Keys.  ;--------------------+----------------+    ;==========++
  IS_DOWN_ALT_BACK := 0 ;typically tab       |                     ;==========++
  IS_DOWN_ALT_FWRD := 0 ;typically "t"       |                     ;==========++
  IS_DOWN_ALT_ALTR := 0 ;typically spacebar. |                     ;==========++
	IS_DOWN_ALT_MOVE := 0 ;Movement mode modifier key. For arrows+home+end.
	IS_DOWN_ALT_CHAN := 0 ;Change mode modifier key.
  ;Top Chord Keys: ----------+---------------+                     ;==========++
  IS_DOWN_TOP_0001 := 0      |                                     ;==========++
  IS_DOWN_TOP_0010 := 0      |                                     ;==========++
  IS_DOWN_TOP_0100 := 0      |                                     ;==========++
  IS_DOWN_TOP_1000 := 0      |                                     ;==========++
  ;Middle Chord Keys: -------+                                     ;==========++
  IS_DOWN_MID_0001 := 0      |                                     ;==========++
  IS_DOWN_MID_0010 := 0      |                                     ;==========++
  IS_DOWN_MID_0100 := 0      |                                     ;==========++
  IS_DOWN_MID_1000 := 0      |                                     ;==========++
  ;Bottom Chord Keys: -------+                                     ;==========++
  IS_DOWN_BOT_0001 := 0      |                                     ;==========++
  IS_DOWN_BOT_0010 := 0      |                                     ;==========++
  IS_DOWN_BOT_0100 := 0      |                                     ;==========++
  IS_DOWN_BOT_1000 := 0      |                                     ;==========++
  ;--------------------------+                                     ;==========++
                                                                   ;==========++
	;BUGFIX: Made these expressions! ":=" not "="
  IS_CHORD_LOADED := 0 ;fixes multi-chord on release bug at         ;==========++
  DEL_CHORD := 1       ;launch-time of the script.                  ;==========++
  TOP_CHORD := 2                                                    ;==========++
  MID_CHORD := 3                                                    ;==========++
  BOT_CHORD := 4                                                    ;==========++
	
	
	;Number Maps for the 3 key rows:
	TOP_N := Object() 
	MID_N := Object() 
	BOT_N := Object() 
	
	;Character maps for the 3 key rows:
	TOP_C := Object() 
	MID_C := Object() 
	BOT_C := Object() 
	                                                                 ;==========++
	;Arrays that map numbers 1-32 to different strings:              ;==========++
	DEL_MAP := Object()  ;backspace delete tab space bits.           ;==========++
	TOP_MAP := Object()  ;top row bits.                              ;==========++
	MID_MAP := Object()  ;middle row bits.                           ;==========++
	BOT_MAP := Object()  ;bottom bits.                               ;==========++
	                                                                 ;==========++
	;Number representing the current bits that have been set on      ;==========++
	;Each of our rows.                                               ;==========++
	DEL_BITS := 0                                                    ;==========++
  TOP_BITS := 0                                                    ;==========++
	MID_BITS := 0                                                    ;==========++
	BOT_BITS := 0                                                    ;==========++
	                                                                 ;==========++
;----------------------------------+-------------------------------------------+
;[1][2][3][4] ROW:                 |COPIED VERBATIM FROM MY DOCUMENTATION:     |
;==================================|===========================================+
  M2( TOP_C, "0001", "A", "T" )  ;//<-- Quickly Spell the word "AT"          |
  M2( TOP_C, "0010", "O", "S" )  ;                                           |
  M2( TOP_C, "0100", "E", "R" )  ;                                           |
  M2( TOP_C, "1000", "U", "M" )  ;                                           |
  M2( TOP_C, "1100", "L", "Y" )  ;//<-- Only. Overly. Logically.             |
  M2( TOP_C, "0110", "I", "N" )  ;//<-- Incite, Incisions, Inception.        |
  M2( TOP_C, "0011", "D", "C" )  ;                                           |
  M2( TOP_C, "1001", "H", "W" )  ;                                           |
	M2( TOP_C, "1110", "F", "G" )  ;                                           |
  M2( TOP_C, "0111", "P", "B" )  ;                                           |
	;Least common letters should be down here in the weird splitted chords:      |
	;VK,JX,QZ are lowest on English frequency map.                               |
	;(VK = Viking)                   ;                                           |
	;(JX = Jax   )                   ;                                           |
	;(QZ = Quarts)                   ;                                           |
  M2( TOP_C, "1010", "V", "J" )  ;                                           |
  M2( TOP_C, "0101", "K", "X" )  ;                                           |
  M2( TOP_C, "1101", "Q","<?>")  ;                                           |
  M2( TOP_C, "1011", "Z","CX" )  ;                                           |
  M2( TOP_C, "1111", "?", "!" )  ;                                           |
;==============================================================================+

;------------------+-----------------------------------------------------------+
;[1][2][3][4] ROW: | IDENTICAL MAPPINGS BUT LOWERCASE. EXCEPT punctuation      |
;==================|===========================================================+
  M2( MID_C, "0001", "a", "t" )  ;                                          /+
  M2( MID_C, "0010", "o", "s" )  ;                                         /++
  M2( MID_C, "0100", "e", "r" )  ;                                        /=++
  M2( MID_C, "1000", "u", "m" )  ;                                       /==++
  M2( MID_C, "1100", "l", "y" )  ;                                      /===++
  M2( MID_C, "0110", "i", "n" )  ;                                     /====++
  M2( MID_C, "0011", "d", "c" )  ;                                    /=====++
  M2( MID_C, "1001", "h", "w" )  ;                                   /======++
  M2( MID_C, "1110", "f", "g" )  ;                                  /=======++
  M2( MID_C, "0111", "p", "b" )  ;                                 /========++
  ;-/-/-/-/-/-/-/-/-/-/-/-/-/-/-//-//-//-//-//-//-//-//-//-//-//-/  /=========++
  M2( MID_C, "1010", "v", "j" )  ;  Low-Freq english chars       /==========++
  M2( MID_C, "0101", "k", "x" )  ;  Take up weird splitted      /;==========++
  M2( MID_C, "1101", "q","CC" )  ;  Chord combinations.        / ;==========++
  M2( MID_C, "1011", "z","CV" )  ;                            /  ;==========++
	M2( MID_C, "1111", ".", "," )  ;//-//-//-//-//-//-//-//-//-/   ;==========++
;=====================================================+=======/    ;==========++
                                                                   ;==========++
;   [Q][W][E][R] HOME ROW:                                         ;==========++
;   TAB         - BACKSPACE                                        ;==========++
;   TAB+SPACE   - DELETE                                           ;==========++
;   T           - SPACE                                            ;==========++
;   T+SPACE     - TAB                                              ;==========++
;   SPACE ALONE - ENTER.                                           ;==========++
    M2(DEL_MAP, "1000", "BACKSPACE", "DELETE")                     ;==========++
    M2(DEL_MAP, "0001", "SPACE"    , "TAB"   )                     ;==========++
    M2(DEL_MAP, "0000", "ENTER"    , "ENTER" )                     ;==========++
                                                                   ;==========++
                                                                   ;==========++
	M2( BOT_C, "1000", "{", "&" )  ;  01	08	1000 | { | & | <---- +-----------+
  M2( BOT_C, "0001", "}", "|" )  ;  02	01	0001 | } | | | <---- |  BITWISE  |
  M2( BOT_C, "0100", "(", "~" )  ;  03	04	0100 | ( | ~ | <---- |     &     |
  M2( BOT_C, "0010", ")", "^" )  ;  04	02	0010 | ) | ^ | <---- |  BRACKET  |
  M2( BOT_C, "1100", "[", "<" )  ;  05	12	1100 | [ | < | <---- |  SYMBOLS  |
  M2( BOT_C, "0011", "]", ">" )  ;  06	03	0011 | ] | > | <---- +-----------+
  M2( BOT_C, "1010", "_", "\" )  ;  07	10	1010 | _ | \ |       ;==========++
  M2( BOT_C, "0101", "^", "->")  ;  08	05	0101 | ^ | ->|       ;==========++
  M2( BOT_C, "1110", "+", "-" )  ;  09	14	1110 | + | - |       ;==========++
  M2( BOT_C, "0111", "*", "/" )  ;  10	07	0111 | * | / |       ;==========++
  M2( BOT_C, "0110", ":", "#" )  ;  12	06	0110 | : | # |       ;==========++
  M2( BOT_C, "1001", "'", """")  ;  13	09	1001 | ' | " |       ;==========++
  M2( BOT_C, "1011", "@", "%" )  ;  14	11	1011 | @ | % |       ;==========++
  M2( BOT_C, "1101", "$", "``")  ;  15	13	1101 | $ | ` |       ;==========++
	M2( BOT_C, "1111", "=", ";" )  ;  11	15	1111 | = | ; |       ;==========++
	
	
                                                                   ;==========++
                                                                   ;==========++
                                                                   ;==========++
                                                                   ;==========++
	;set current mapping in use:
	TOP_MAP := TOP_C
	MID_MAP := MID_C
	BOT_MAP := BOT_C
																																	 
                                                                   ;==========++
                                                                   ;==========++
                                                                   ;==========++
                                                                   ;==========++
;m_sgBox CHORD_SCRIPT_INITED                                         ;==========++
return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;==========++
} ;===========================================================================++
SetDefaults(void) ;===========================================================++
;=============================================================================++



;        SoundBeep Documentation:
;        The frequency of the sound, which can be an expression. 
;        It should be a number between 37 and 32767.
;        64    ==  0000  0000  0100  0000
;        32767 ==  0111  1111  1111  1111
;        RANGE ==  0111  1111  11   <--Set only these 9 bits.

;        T = TOP ROW (High Notes)
;        M = MID ROW (Middle Notes)
;        B = BOT ROW (Low Notes)
;        D = DEL ROW (Special Key Set Notes)
;
;        KEY SETS:            ALT KEY(SHARP)   NOTES:
;        +---+---+---+---+        +---+        +---+---+---+---+ 
;        | T | M | B | D |        | A |        | 4 | 3 | 2 | 1 |
;        |   |   |   |   |        |   |        |   |   |   |   |
;        |   |   |   |   |        |   |        |   |   |   |   |
;        | 0 | 0 | 0 | 0 |        | 0 |        | 0 | 0 | 0 | 0 |
;        |   |   |   |   |        |   |        |   |   |   |   |
;        |   |   |   |   |        |   |        |   |   |   |   |
;        |   |   |   |   |        |   |        |   |   |   |   |
;        +---+---+---+---+        +---+        +---+---+---+---+

VOCALIZE_CHORD_AS_NOTE(CHORD_BITS, KEYSET_TO_PLAY_IN)
{ ;NOTE: Alt key is embedded into CHORD_BITS, hence why no
  ;parameter for if the alt key is pressed or not
  
  ;For the moment, this is not useable, until we figure out how
  ;to do beep on a different thread.
  ;https://autohotkey.com/board/topic/47183-instance-create-another-instance-for-an-asynchronous-task/
  
  SoundBeep 500, 900
}
  

PRINT_OUT_ALL_MAPS(void) ;---+
{                           ;|
  PRINT_A_MAP(TOP_MAP)      ;|
  PRINT_A_MAP(MID_MAP)      ;|
  PRINT_A_MAP(BOT_MAP)      ;|
  PRINT_A_MAP(DEL_MAP)      ;|
  return ;;;;;;;;;;;;;;;;;;;;|
} ;--------------------------+


PRINT_A_MAP(CUR_MAP) ;-------------------------------------------+
{                                                               ;|
  DEC_NUM := 0                                                  ;|
  BIN_STR := ""                                                 ;|
                                                                ;|
  loop, 31                                                      ;|
  {                                                             ;|
    DEC_NUM := A_Index                                          ;|
    BIN_STR := INTEGER_TO_BINARY_STRING(DEC_NUM)                ;|
    STRING_MAPPED_TO := CUR_MAP[A_Index]                        ;|
    clipboard = %DEC_NUM% : %BIN_STR% : %STRING_MAPPED_TO%      ;|
    send ^v                                                     ;|
    send {enter}                                                ;|
    sleep 10                                                    ;|
  }                                                             ;|
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;|
} ;--------------------------------------------------------------+

;--------------------------------------------------------------+
;shorthand for easy code readability in setup.                ;|
;binds the BIN_STR chord pattern to a MAIN key and an ALT key ;|
;--------------------------------------------------------------+
M2(CUR_MAP, BIN_STR, MAIN_OUTPUT_KEY, ALT_OUTPUT_KEY)         ;|
{                                                             ;|
  ADD_MAPPING(CUR_MAP, BIN_STR, MAIN_OUTPUT_KEY)              ;|
  MAP_ALT_KEY(CUR_MAP, BIN_STR, ALT_OUTPUT_KEY)               ;|
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;|
} ;------------------------------------------------------------+

;-------------------------------------------------------------------------+
;CUR_MAP: The current mapping array to insert into.                      ;|
;BIN_STR: The binary string that needs to be converted to mapping index. ;|
;KEY    : The key the binary number (choord) will map to.                ;|
;-------------------------------------------------------------------------+
ADD_MAPPING(CUR_MAP, BIN_STR, KEY)                                       ;|
{                                                                        ;|
	BIN_STR = 0%BIN_STR% ;prepend a zero because NOT alt key.              ;|
	INDEX32 := BINARY_STRING_TO_INTEGER(BIN_STR)                           ;|
	MAP_THE_KEY(CUR_MAP, INDEX32, KEY)                                     ;|
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;|
} ;-----------------------------------------------------------------------+

;----------------------------------------------------------------+
;Identical to ADD_MAPPING, but our alt key is pressed as well.  ;|
;----------------------------------------------------------------+
MAP_ALT_KEY(CUR_MAP, BIN_STR, KEY)                              ;|
{                                                               ;|
	BIN_STR = 1%BIN_STR% ;prepend a 1 because IS alt key.         ;|
	INDEX32 := BINARY_STRING_TO_INTEGER(BIN_STR)                  ;|
	MAP_THE_KEY(CUR_MAP, INDEX32, KEY)                            ;|
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;|
} ;--------------------------------------------------------------+

;------------------------------------+
;Map the key to a number 1-32       ;|
;------------------------------------+
MAP_THE_KEY(CUR_MAP, INDEX32, KEY)  ;|
{                                   ;|
	CUR_MAP[INDEX32] := KEY           ;|
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;|
} ;----------------------------------+


INTEGER_TO_BINARY_STRING(INT_NUM) ;--------+
{                                         ;|
  if(INT_NUM > 31)                        ;|
  {                                       ;|
    msgBox INT_NUM_OUT_OF_RANGE           ;|
  }                                       ;|
                                          ;|
  BIN_STR := ""                           ;|
                                          ;|
  loop, 5                                 ;|
  {                                       ;|
    OS := A_Index - 1 ; make zero based   ;|
    SHIFTED := INT_NUM >> OS              ;|
    MASKED  := SHIFTED & 1 ;              ;|
    if(MASKED > 0)                        ;|
    {                                     ;|
      BIN_STR =1%BIN_STR% ;prepend 1      ;|
    }                                     ;|
    else                                  ;|
    {                                     ;|
      BIN_STR =0%BIN_STR% ;prepend 0      ;|
    }                                     ;|
  }                                       ;|
                                          ;|
return BIN_STR ;;;;;;;;;;;;;;;;;;;;;;;;;;;;|
} ;----------------------------------------+


BINARY_STRING_TO_INTEGER(BIN_STR) ;-----------+
{                                            ;|
LEN_INPUT := strLen(BIN_STR)                 ;|
if(LEN_INPUT != 5)                           ;|
{                                            ;|
msgBox ERROR_MUST_BE_EXACTLY_5_LONG          ;|
}                                            ;|
                                             ;|
  BIN_NUM := 0                               ;|
  ;--------------------------------------+   ||
  LETTER := subStr(BIN_STR,1,1) ;1_0000 ;|   ||
  if(LETTER == "1")                     ;|   ||
  {                                     ;|   ||
  BIN_NUM := BIN_NUM | N_1_0000         ;|   ||
  }                                     ;|   ||
  ;--------------------------------------+   ||
  LETTER := subStr(BIN_STR,2,1) ;0_1000 ;|   ||
  if(LETTER == "1")                     ;|   ||
  {                                     ;|   ||
  BIN_NUM := BIN_NUM | N_0_1000         ;|   ||
  }                                     ;|   ||
  ;--------------------------------------+   ||
  LETTER := subStr(BIN_STR,3,1) ;0_0100 ;|   ||
  if(LETTER == "1")                     ;|   ||
  {                                     ;|   ||
  BIN_NUM := BIN_NUM | N_0_0100         ;|   ||
  }                                     ;|   ||
  ;--------------------------------------+   ||
  LETTER := subStr(BIN_STR,4,1) ;0_0010 ;|   ||
  if(LETTER == "1")                     ;|   ||
  {                                     ;|   ||
  BIN_NUM := BIN_NUM | N_0_0010         ;|   ||
  }                                     ;|   ||
  ;--------------------------------------+   ||
  LETTER := subStr(BIN_STR,5,1) ;0_0001 ;|   ||
  if(LETTER == "1")                     ;|   ||
  {                                     ;|   ||
  BIN_NUM := BIN_NUM | N_0_0001         ;|   ||
  }                                     ;|   ||
  ;--------------------------------------+   ||
                                             ;|
  return BIN_NUM ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;|
} ;-------------------------------------------+

DO_NUMBER_MODE_CHORDS()
{
  ASSEMBLE_CHORD_MATRIX()
	
	;TOP ROW, single key:
	if(APP_MAT == AM_1000_0000_0000)
	{
		send 1
	}else
	if(APP_MAT == AM_0100_0000_0000)
	{
		send 2
	}else
	if(APP_MAT == AM_0010_0000_0000)
	{
		send 3
	}else
	if(APP_MAT == AM_0001_0000_0000)
	{
		send {#}
	}else
	
	;MID ROW, single key:
	if(APP_MAT == AM_0000_1000_0000)
	{
		send 4
	}else
	if(APP_MAT == AM_0000_0100_0000)
	{
		send 5
	}else
	if(APP_MAT == AM_0000_0010_0000)
	{
		send 6
	}else
	if(APP_MAT == AM_0000_0001_0000)
	{
		send 0
	}else
	
	;BOT ROW, single key:
	if(APP_MAT == AM_0000_0000_1000)
	{
		send 7
	}else
	if(APP_MAT == AM_0000_0000_0100)
	{
		send 8
	}else
	if(APP_MAT == AM_0000_0000_0010)
	{
		send 9
	}else
	if(APP_MAT == AM_0000_0000_0001)
	{
		send x
	}else
	
	;Standard mathematical operators, MID CHORD:
	if(MID_BITS == NUMCHORD_1100){ ;subtract
		send {-}
	}else
	if(MID_BITS == NUMCHORD_0011){ ;MULTIPLY
		send {*}
	}else
	if(MID_BITS == NUMCHORD_1001){ ;divide
		send {/}
	}else
	if(MID_BITS == NUMCHORD_0110){ ;ADD
		send {+}
	}else
	if(MID_BITS == NUMCHORD_1010){ ;shift left
		send {<}
	}else
	if(MID_BITS == NUMCHORD_0101){ ;shift right
		send {>}
	}else
	if(MID_BITS == NUMCHORD_1110){ ;equals
		send {=}
	}else
	if(MID_BITS == NUMCHORD_0111){ ;power of
		send {^}
	}else
	

	{
		msgBox NO_NUMBER_COMBO
	}
	
	return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
}

DO_CHAN_MODE_ACTIONS(void)
{
	if(TOP_BITS == C_111E)
	{
		SWITCH_TO_NORMAL_KEYBOARD()
	}else
	if(TOP_BITS == N_0_1000)
	{ ;COPY
		send ^c
	}else
	if(TOP_BITS == N_0_0100)
	{ ;PASTE
		send ^v
	}else
	if(TOP_BITS == N_0_0010)
	{ ;CUT
		send ^x
	}else
	if(TOP_BITS == N_0_0001)
	{ ;Select ALL
		send ^a
	}
	else
	{
		msgBox NO_CHNG_COMBO_HERE
	}
	return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
}

DO_MOVE_ARROW_ACTIONS_ETC(void) ;for move mode modifier.
{

		;if modifier pressed and released with no accompanying key,
		;we want to shake the cursor to un-select anything that might
		;be highlighted in the text editor.
		if(TOP_BITS == 0 && MID_BITS == 0 && BOT_BITS == 0)
		{
			MOV_TAPS := MOV_TAPS + 1
			if(MOV_TAPS >= 6)
			{ ;cancel the shortcut
				SoundBeep, 300, 123
				SoundBeep, 60, 123
				SoundBeep, 400, 123
				SoundBeep, 99, 123
				MOV_TAPS := 0
			}else
			if(MOV_TAPS >= 2)
			{
				SoundBeep, 200, 30
			}
			return
		}
		else
		{
			MOV_TAPS := 0
			;do NOT return
		}

		;MOV keys with no extra modifier key held:
		;==========================================================================;
		if(TOP_BITS == N_0_1000) ;Left of up-arrow hotkey. Go HOME.
		{
			send {home}
			return
		}
		if(TOP_BITS == N_0_0010) ;Right of up-arrow hotkey. Go END.
		{
			send {End}
			return
		}
		if(TOP_BITS == N_0_0100) ;W of WASD
		{
			send {up}
			return
		}
		if(MID_BITS == N_0_1000) ;A of WASD
		{
			send {left}
			return
		}
		if(MID_BITS == N_0_0100) ;S of WASD
		{
			send {down}
			return
		}
		if(MID_BITS == N_0_0010) ;D of WASD
		{
			send {right}
			return
		}
		
		;-----  backwards "L" shortcut row&column: ------
		if(BOT_BITS == N_0_1000)
		{
			send ^+S ;ctrl+shift+S, for "Save All"
			return
		}
		if(BOT_BITS == N_0_0100)
		{
			send {F5} ;run shortcut key in visual studio.
			return
		}
		if(BOT_BITS == N_0_0010)
		{
			send {F12} ;open debugger in chrome+firefox
			return
		}
		if(BOT_BITS == N_0_0001)
		{
			send +{F11} ;STEP OUT in chrome+visual studio
			return
		}
		if(MID_BITS == N_0_0001)
		{
			send {F11} ;STEP INTO in chrome+visual studio
		}
		if(TOP_BITS == N_0_0001)
		{
			send {F10} ;STEP OVER in chrome+visual studio
			return
		}
		
		
		
		
		;MOV keys with no extra modifier key held:
		;==========================================================================;
		;-------- if alter key pressed too, simulate highlighting in text editors ----
		if(TOP_BITS == N_1_1000) ;Left of up-arrow hotkey. Go HOME.
		{
			send +{home}
			send ^c
			return
		}
		if(TOP_BITS == N_1_0010) ;Right of up-arrow hotkey. Go END.
		{
			send +{End}
			send ^c
			return
		}
		if(TOP_BITS == N_1_0100) ;W of WASD
		{
			send +{up}
			send ^c
			return
		}
		if(MID_BITS == N_1_1000) ;A of WASD
		{
			send +{left}
			send ^c
			return
		}
		if(MID_BITS == N_1_0100) ;S of WASD
		{
			send +{down}
			send ^c
			return
		}
		if(MID_BITS == N_1_0010) ;D of WASD
		{
			send +{right}
			send ^c
			return
		}
		
		;-----  backwards "L" shortcut row&column: ------
		if(BOT_BITS == N_1_1000)
		{
			send #!{F1} ;desktop #1
			return
		}
		if(BOT_BITS == N_1_0100)
		{
			send #!{F2} ;destkop #2
			return
		}
		if(BOT_BITS == N_1_0010)
		{
			send #!{F3} ;desktop #3
			return
		}
		
		if(BOT_BITS == N_1_0001)
		{
			send ^y ;redo
			return
		}
		
		if(TOP_BITS == N_1_0001)
		{
			send ^z ;undo
			return
		}
		if(MID_BITS == N_1_0001)
		{
			send ^a ;select all
			return
		}
		
return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
}

PRINT_NON_ROW_CHORDS(void) ;----+
{                              ;|
  if(DEL_BITS == N_0_1000)     ;|
  { ;Backspace Key             ;|
    send `b                    ;|
  }else                        ;|
  if(DEL_BITS == N_1_1000)     ;|
  { ;Delete Key                ;|
   ;send {delete}              ;|
	 send +{tab} ;opposite of tab. More useful than delete for me.
  }else                        ;|
  if(DEL_BITS == N_0_0001)     ;|
  { ;Space Key                 ;|
    
    send {enter}               ;|
  }else                        ;|
  if(DEL_BITS == N_1_0001)     ;|
  { ;Tab Key                   ;|
    send {tab}                 ;|
  }else                        ;|
  if(DEL_BITS == N_1_0000)     ;|
  { ;Alt key only is for ENTER ;|
    send {space}               ;|
  }                            ;|
return ;;;;;;;;;;;;;;;;;;;;;;;;;|
} ;-----------------------------+


PRINT_CHORD(void) ;---------------------------------+
{                                                  ;|

  ;Attempt To Fix Concurrency Problem:
  if(IS_CHORD_LOADED < 1)
	{
		return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	}
	
	MIGHT_BE_NUMBER_CHORD := DEL_BITS & N_0_1000 ;BACK key also used for number mode.
	if(MIGHT_BE_NUMBER_CHORD > 0)
	{
		if(TOP_BITS > 0 || MID_BITS > 0 || BOT_BITS > 0)
		{ ;then definitely have a number chord.
			if(IS_CHORD_LOADED > 0)
			{
				IS_CHORD_LOADED := 0
				DO_NUMBER_MODE_CHORDS()
			}
			return
		}
	}
	
	IS_IN_CHAN_MODE := DEL_BITS & N_0_0100
	if(IS_IN_CHAN_MODE > 0)
	{
		if(IS_CHORD_LOADED > 0)
		{
			IS_CHORD_LOADED := 0
			DO_CHAN_MODE_ACTIONS(void)
		}
		
		return
	}

	;move mode override:
	;override other keys if move mode button is currently
	;held down.
	IS_IN_MOVE_MODE := DEL_BITS & N_0_0010
	if(IS_IN_MOVE_MODE > 0)
	{
		;m_sgBox MOVE OVERRIDE!
		DO_MOVE_ARROW_ACTIONS_ETC(void)
		return
	}

  CHORD_ARRAY_TO_USE := 0                          ;|
  CHORD_OF_BITS :=0                                ;|
  ;------------------------------------+           ;|
  if(IS_CHORD_LOADED   == DEL_CHORD)  ;|           ;|
  {                                   ;|           ;|
    PRINT_NON_ROW_CHORDS(void)        ;|           ;|
    return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;|           ;|
  }else ;------------------------------+           ;|
  if(IS_CHORD_LOADED   == TOP_CHORD)  ;|           ;|
  {                                   ;|           ;|
    CHORD_ARRAY_TO_USE := TOP_MAP     ;|           ;|
    CHORD_OF_BITS      := TOP_BITS    ;|           ;|
  }else ;------------------------------+           ;|
  if(IS_CHORD_LOADED   == MID_CHORD)  ;|           ;|
  {                                   ;|           ;|
    CHORD_ARRAY_TO_USE := MID_MAP     ;|           ;|
    CHORD_OF_BITS      := MID_BITS    ;|           ;|
  }else ;------------------------------+           ;|
  if(IS_CHORD_LOADED   == BOT_CHORD)  ;|           ;|
  {                                   ;|           ;|
    CHORD_ARRAY_TO_USE := BOT_MAP     ;|           ;|
    CHORD_OF_BITS      := BOT_BITS    ;|           ;|
  }else
	{
		msgBox CONCURRENCY_ERROR_ON_MULTI_KEY_RELEASE
	}
	
	;If we tapped the MOV mode shortcut key twice or more, we are
	;temporarily in "app specific shortcut mode" Send a shortcut instead
	;of a key, based on the combination pressed.
	if(MOV_TAPS >= 2 && IS_CHORD_LOADED > 0)
	{
	  ;IS_CHORD_LOADED := 0 is before call to SEND_APP_SPECIFIC_SHORTCUT(void)
		;To prevent concurrency errors. Otherwise hotkey gets triggered, and then
		;The actual key will get sent [TOO/AS WELL/IN ADDITION TO]
		IS_CHORD_LOADED := 0 
		MOV_TAPS = 0 ;de-activate app specific shortcut mode.
		SEND_APP_SPECIFIC_SHORTCUT(void)
		
		return
	}
	
	;Putting this here just fixed message box from popping up 2X when
	;debug message was put into RECORD_FOR_HOTKEY, so I think the duplicate
	;chord problem MIGHT be fixed now.
	IS_CHORD_LOADED := 0
                                                   ;|
  ;clipboard := CHORD_ARRAY_TO_USE[ CHORD_OF_BITS ] ;|
  ;send ^v                                          ;|
	
	;sending ^v (CTRL+V) can be hazardous.
	;when interlaced hotkeys spam CTRL+V non printable
	;characters ENQ and DC1 somehow get printed.
	;And then shortcuts get invoked. This does NOT
	;happen on my wireless keyboard, but happens on
	;my laptop's built-in keyboard. No clue why. But
	;NOT using CTRL+V may be part of fixing the bug
	;of chord being repeated more than once.
	SEND_ME := CHORD_ARRAY_TO_USE[ CHORD_OF_BITS ] 
	
	
	
	;intercept some special non_printing chords
	;hackish, but the best way I can think to do this.
	if(SEND_ME=="CC"){ ;ctrl copy
		send ^c
	}else
	if(SEND_ME=="CV"){ ;ctrl paste
		send ^v
	}else
	if(SEND_ME=="CX"){ ;ctrl cut
		send ^x
	}else
	if(SEND_ME=="AD"){ ;ctrl alt delete
		send wecantdoctrl
	}else
	{ ;standard behavior
		RECORD_FOR_HOTKEY(SEND_ME)
		sendRaw %SEND_ME%
	}
	
	
	
	
                                                   ;|
return  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;|
} ;-------------------------------------------------+

ASSEMBLE_CHORD_MATRIX()
{
	;assemble shortcut matrix
	TOP4 := (TOP_BITS & MASK4_1111)
	MID4 := (MID_BITS & MASK4_1111)
	BOT4 := (BOT_BITS & MASK4_1111)
	
	;shift into place:
	T4 := (TOP4 << TOP_AMSHIFT)
	M4 := (MID4 << MID_AMSHIFT)
	B4 := (BOT4 << BOT_AMSHIFT)
	
	;join all together to form matrix:
	;use logical OR for the concatination:
	APP_MAT := 0
	APP_MAT := (T4 | M4 | B4)
	
	return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
}

SEND_APP_SPECIFIC_SHORTCUT(void)
{
	ASSEMBLE_CHORD_MATRIX()
	
	;use app matrix to lookup shortcuts:
	APPLICATION := "VISUAL_STUDIO"
	if(APPLICATION == "VISUAL_STUDIO")
	{
		DO_VISUAL_STUDIO_APP_SHORTCUTS(APP_MAT)
	}else{
		msgBox NO_APP_SPECIFIC_SHORTCUTS_FOR_THIS_APPLICATION
	}
return  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
}

;Give app matrix and look up the app specific shortcut that is mapped.
DO_VISUAL_STUDIO_APP_SHORTCUTS(APP_MAT)
{
	SoundBeep, 750, 100
  ;m_sgBox DOING VISUAL STUDIO SHORTCUTS
	;msgBox APP_MAT==[ %APP_MAT% ]

  ;0001
	;0000  Solution Explorer Window
	;0000
	if(APP_MAT == AM_0001_0000_0000)
	{
		soundBeep, 1024,22
		send ^!l ;CTRL+ALT+L for SOLUTION EXPLORER
	}else
	;0000
	;0001  ToolBox Window
	;0000
	if(APP_MAT == AM_0000_0001_0000)
	{
		soundBeep, 2048,22
		send ^!x ;CTRL+ALT+X for TOOLBOX
	}else
	;0000
	;0000  Properties Window.
	;0001
	if(APP_MAT == AM_0000_0000_0001)
	{
		soundBeep, 3096,22
		send {F4} ;F4 for PROPERTIES window.
	}else
	if(APP_MAT == AM_0010_0000_0000)
	{ ;creates new folder if your have solution explorer open.
		send !p
		send d
	}else
	if(APP_MAT == AM_1000_0000_0000)
	{ ;close all open files
		send !w
		send l
	}else
	if(APP_MAT == AM_1111_0000_0000)
	{ ;WINDOWS+e to open new explorer window.
		send #e
	}else
	if(APP_MAT == AM_0000_1111_0000)
	{ ;WINDOWS+d to show desktop
		send #d
	}else
	if(APP_MAT == AM_0000_0000_1111)
	{ ;CTRL+w to close active Windows Window.
		send ^w
	}else
	if(APP_MAT == AM_1100_0000_0000)
	{           ;open folder that contains database .mdf files for SQL
		          run, C:\users\jmadison
	}else
	if(APP_MAT == AM_0011_0000_0000)
	{           ;CTRL+P to launch NuGet package manager.
		          send ^p
	}else
	if(APP_MAT == AM_0000_1100_0000)
	{           ;CTRL+ALT+0 for SQL Server Object Explorer
		          send ^!0
							msgBox object explorer!
	}else
	if(APP_MAT == AM_0000_0011_0000)
	{           ;Visual Studio command prompt:
		          run, C:\DEV\AHK\SHORTCUT_FILES\VS_DEV
	}else
	if(APP_MAT == AM_0000_0000_0011)
	{           ;Close Tool Window. Default shortcut doesn't work in VS
		          send, ^!9
	}else
	if(APP_MAT == AM_0000_0000_1100)
	{ ;expand all outlining. (opposite of collapsing function definitions)
		send ^m
		send x
	}else
	if(APP_MAT == AM_0000_0000_1000)
	{ ;collapse to definitions
		send ^m
		send o
	}else
	if(APP_MAT == AM_0000_0000_0100)
	{ ;build solution.
		send ^+b ;CTRL+SHIFT+B
	}else
	if(APP_MAT == AM_0000_0000_0010)
	{ ;add new scaffolded item
		send !s 
	}else
	if(APP_MAT == AM_0100_0000_0000)
	{ ;open web.config
	
	  soundBeep, 400,50
		send ^!l ;CTRL+ALT+L for solution explorer
		
		sleep 100
		send {home} ;move to top of solution explorer
		
		sleep 100
		send {down} ;down arrow to focus on project
		
		sleep 100
		send {numpadSub down} ;collapse all
		send {numpadSub up} ;collapse all
		
		sleep 100
		send {numpadAdd down}  ;expand all
		send {numpadAdd up}  ;expand all
		
		;must send each character separately, or else the hooks don't work
		;and "e" gets remapped to captial "O" and all the files get highlighted.
		sleep 100
		send w
		send e
		send b
		send .
		send c
		send o
		send n
		send f
		send i
		send g
		send {enter}
	}else
	if(APP_MAT == AM_0000_0010_0000)
	{ ;//find
		send ^f 
	}else
	if(APP_MAT == AM_0000_1000_0000)
	{ ;open server explorer.
		;msgBox FOR_128
		soundBeep, 22, 900
		;CTRL+ALT+S
		;send ^!S ; ctrl first does not work
		send !^s
	}else
	if(APP_MAT == AM_0000_0100_0000)
	{
		send +!c  ;shift alt c
	}else
	if(APP_MAT == AM_0000_1111_0000)
	{
		send +!{enter} ;fullscreen
	}else{
		msgBox SHORTCUT_MATRIX_NOT_MAPPED_TO_SHORTCUT_FOR_THIS_APPLICATION
		msgBox APP_MAT==[%APP_MAT%]
	}
	
	return  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
}


;Doesn't look like this function is needed. There is no concurrent
;function access going on with the hotkeys. It was an error in my
;earlier efforts to fix the problem.
GET_PRECEDENCE_AND_CLEAR_JUSTUP(RELEASED_BIT_POSITION)
{
  JUSTUP_TO_LOOK_AT := 0
	if(IS_CHORD_LOADED   == DEL_CHORD)  ;|          
  {                                   ;|           
    JUSTUP_TO_LOOK_AT := JUSTUP_ALT_KEYS    
  }else ;------------------------------+           
  if(IS_CHORD_LOADED   == TOP_CHORD)  ;|           
  {                                   ;|           
    JUSTUP_TO_LOOK_AT := JUSTUP_TOP_KEYS       
  }else ;------------------------------+           
  if(IS_CHORD_LOADED   == MID_CHORD)  ;|           
  {                                   ;|           
    JUSTUP_TO_LOOK_AT := JUSTUP_MID_KEYS         
  }else ;------------------------------+           
  if(IS_CHORD_LOADED   == BOT_CHORD)  ;|           
  {                                   ;|           
    JUSTUP_TO_LOOK_AT := JUSTUP_BOT_KEYS       
  }else
	{
		msgBox NO_CHORD_IS_LOADED_PRECEDENCE_CHECK
	}
	
	;use XOR to remove the released bit from the justup bits.
	;if the result of CANCEL_OUT is LESS THAN RELEASED_BIT_POSITION,
	;then we have found the set bit of HIGHEST PRECEDENCE within
	;JUSTUP_TO_LOOK_AT
	;
	;Example:
	; 
	;   Where: RELEASED == current bit being looked at.
	;   Where: JUST_UPS == all of the bits currently being released.
	;   RELEASED: 1000       
	;   JUST_UPS: 1010  --> CANCEL_OUT: 0010
	;   1000 is greater than 0010, so we've found the highest precedence.
	;
	CANCEL_OUT := JUSTUP_TO_LOOK_AT ^ RELEASED_BIT_POSITION
	if(RELEASED_BIT_POSITION > CANCEL_OUT)
	{
	
	}
	
	return
}

DO_CHORD_UP(ByRef ACTIVE_CHORD_BITS, RELEASED_BIT_POSITION ) ;----------+
{                       ;|

  ;Guard against releasing a chord if no chord is officially
	;loaded. Prevents things like 3 "J"s from being written after
	;releasing the 3 keys that make the "J" chord. This bug happens
	;infrequently. But pretty sure this guard is the fix.
	if(IS_CHORD_LOADED > 0)
	{
		;;;If multiple keys are released at exact same time, may duplicate the chord,
		;;;so here, inspect precedence of bit positions:
		;;HAS_PRECEDENCE := GET_PRECEDENCE_AND_CLEAR_JUSTUP(RELEASED_BIT_POSITION)
		;;HAS_PRECEDENCE := 1
		;;if(HAS_PRECEDENCE)
		;;{
		;;	PRINT_CHORD(void)
		;;}
		
		PRINT_CHORD(void)
		IS_CHORD_LOADED :=0  ;Try to fix bug due to suspected concurrency.
	}

  ;Regardless, erase this bit from our chord:
  CLEAR_RELEASED_CHORD_BIT(ACTIVE_CHORD_BITS, RELEASED_BIT_POSITION )
  
	;Thinking moving this to bottom of DO_CHORD_UP might get rid of
	;Multiple chords on release bug.
	IS_CHORD_LOADED := 0  ;|
  
  return ;;;;;;;;;;;;;;;;|
} ;----------------------+

CLEAR_RELEASED_CHORD_BIT(ByRef ACTIVE_CHORD_BITS, RELEASED_BIT_POSITION)
{
  ;                   if RELASED_BIT_POSITION == 1000
  ;      AKA: 0000 0000 0000 0000 0000 0000 0000 1000 <--RELEASED_BIT_POSITION
  ; ~1000 --> 1111 1111 1111 1111 1111 1111 1111 0111 <--MASK
  ; PRETEND ACTIVE_CHORD_BITS == 1001
  ; 0111 <--MASK
  ; 1001 <--ACTIVE_CHORD_BITS
  ;BITWISE AND:
  ; 0001 <--RESULT! The bit has been removed.
  ; 
  MASK := ~RELEASED_BIT_POSITION ;~ is bitwise NOT operator. Flips everything.
  ACTIVE_CHORD_BITS := ACTIVE_CHORD_BITS & MASK
}

;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^+
;ON-UP Functions.                    |       
;Each Chord key is now responsible   |
;for removing only itself when       |
;released, rather than clearing      | 
;ALL of the chords.                  |       /\
;-----------------------------------;|      /  \
ONUP_ALT_ALTR()                     ;|     /    \
{                                   ;|    /      \
  ;                                 ;|   /        \
  ;ALT_ALTR key is a special special |  /          \
  ;key because it is also a modifier | /            \
  ;key, so releasing it could be     |/              \
  ;triggering any of the 4 possible  /    ALT_ALTR    \
  ;major chord rows. (music keys)   /                  \
  ;----------------------+         /                    \
  IS_DOWN_ALT_ALTR := 0 ;|        /                      \
  ;----------------------+       /________________________\
	;All chords share this key/bit, so append to all chords:
	JUSTUP_ALT_KEYS := JUSTUP_ALT_KEYS | N_1_0000 ;append bit.
	JUSTUP_TOP_KEYS := JUSTUP_TOP_KEYS | N_1_0000 ;append bit.
	JUSTUP_MID_KEYS := JUSTUP_MID_KEYS | N_1_0000 ;append bit.
	JUSTUP_BOT_KEYS := JUSTUP_BOT_KEYS | N_1_0000 ;append bit.
  ;--------------------------------------;;;;;;;;;;;;;;;;--+
  if(IS_CHORD_LOADED == DEL_CHORD)       ;;;;;;;;;;;;;;;;  |
  { ;Rouge music key                     ;;;;;;;;;;;;;;;;  |
    DO_CHORD_UP(DEL_BITS, N_1_0000)      ;;;;;;;;;;;;;;;;  |
  }else ;--------------------------------;;;;;;;;;;;;;;;;--+
  if(IS_CHORD_LOADED == TOP_CHORD)       ;;;;;;;;;;;;;;;;  |
  { ;High music key                      ;;;;;;;;;;;;;;;;  |
    DO_CHORD_UP(TOP_BITS, N_1_0000)      ;;;;;;;;;;;;;;;;  |
  }else ;--------------------------------;;;;;;;;;;;;;;;;--+
  if(IS_CHORD_LOADED == MID_CHORD)       ;;;;;;;;;;;;;;;;  |
  { ;Middle music key                    ;;;;;;;;;;;;;;;;  |
    DO_CHORD_UP(MID_BITS, N_1_0000)      ;;;;;;;;;;;;;;;;  |
  }else ;--------------------------------;;;;;;;;;;;;;;;;--+
  if(IS_CHORD_LOADED == BOT_CHORD)       ;;;;;;;;;;;;;;;;  |
  { ;Low music key                       ;;;;;;;;;;;;;;;;  |
    DO_CHORD_UP(BOT_BITS, N_1_0000)      ;;;;;;;;;;;;;;;;  |
  }else ;--------------------------------;;;;;;;;;;;;;;;;--+
  {                                      ;;;;;;;;;;;;;;;;  |
    ;;m_sgBox NO_CHORD_LOADED             ;;;;;;;;;;;;;;;;  |
  }                                      ;;;;;;;;;;;;;;;;--|
  ;--------------------------------------------------------+
  ;                                                       /
  ;prevent alt modifier key from sticking! -----+        /
  CLEAR_RELEASED_CHORD_BIT(DEL_BITS, N_1_0000) ;|       /
  CLEAR_RELEASED_CHORD_BIT(TOP_BITS, N_1_0000) ;|      /
  CLEAR_RELEASED_CHORD_BIT(MID_BITS, N_1_0000) ;|     /
  CLEAR_RELEASED_CHORD_BIT(BOT_BITS, N_1_0000) ;|    /
  ;---------------------------------------------+   /
  ;                                            \   /
  ;                                             \ /
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;| 1_0000    +
                                    ;|     /\    
                                    ;|    /  \
}                                   ;|   /    \
ONUP_ALT_BACK()                     ;|  / ALT_ \
{                                   ;| /________\
	JUSTUP_ALT_KEYS := JUSTUP_ALT_KEYS | N_0_1000 ;|
  IS_DOWN_ALT_BACK := 0                         ;|
  DO_CHORD_UP(DEL_BITS, N_0_1000)   ;+-----------+
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;| 1000
}                                   ;|


ONUP_ALT_CHAN()
{
	JUSTUP_ALT_KEYS  := JUSTUP_ALT_KEYS | N_0_0100
	IS_DOWN_ALT_CHAN := 0
	DO_CHORD_UP(DEL_BITS, N_0_0100)
	return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
}

ONUP_ALT_FWRD()                     ;|
{                                   ;|
  JUSTUP_ALT_KEYS := JUSTUP_ALT_KEYS | N_0_0001 ;|
  IS_DOWN_ALT_FWRD := 0              
  DO_CHORD_UP(DEL_BITS, N_0_0001)   
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;| 0001
}                                   ;|

ONUP_ALT_MOVE()
{
	JUSTUP_ALT_KEYS := JUSTUP_ALT_KEYS | N_0_0010 ;middle-right == MOVE MODE KEY.
	IS_DOWN_ALT_MOVE := 0
	DO_CHORD_UP(DEL_BITS, N_0_0010)
	return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
}



;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^;|     /\
ONUP_TOP_1000()                     ;|    /  \
{                                   ;|   /    \ 
	JUSTUP_TOP_KEYS := JUSTUP_TOP_KEYS | N_0_1000 ;|  xxxxxxxxxxxxxxxx
  IS_DOWN_TOP_1000 := 0             ;|  / TOP_ \  
  DO_CHORD_UP(TOP_BITS, N_0_1000)   ;| /________\ 
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;| 1000
}                                   ;|
ONUP_TOP_0100()                     ;|
{                                   ;|
  JUSTUP_TOP_KEYS := JUSTUP_TOP_KEYS | N_0_0100 ;|
  IS_DOWN_TOP_0100 := 0             ;|
  DO_CHORD_UP(TOP_BITS, N_0_0100)   ;|
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;| 0100
}                                   ;|
ONUP_TOP_0010()                     ;|
{                                   ;|
  JUSTUP_TOP_KEYS := JUSTUP_TOP_KEYS | N_0_0010 ;|
  IS_DOWN_TOP_0010 := 0             ;|
  DO_CHORD_UP(TOP_BITS, N_0_0010)   ;|
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;| 0010
}                                   ;|
ONUP_TOP_0001()                     ;|
{                                   ;|
  JUSTUP_TOP_KEYS := JUSTUP_TOP_KEYS | N_0_0001 ;|
  IS_DOWN_TOP_0001 := 0             ;|
  DO_CHORD_UP(TOP_BITS, N_0_0001)   ;| 
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;| 0001
}                                   ;|
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^;|     /\
ONUP_MID_1000()                     ;|    /  \
{                                   ;|   /    \
  JUSTUP_MID_KEYS := JUSTUP_MID_KEYS | N_0_1000 ;|
  IS_DOWN_MID_1000 := 0             ;|  / MID_ \
  DO_CHORD_UP(MID_BITS, N_0_1000)   ;| /________\ 
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;| 1000
}                                   ;|
ONUP_MID_0100()                     ;|
{                                   ;|
  JUSTUP_MID_KEYS := JUSTUP_MID_KEYS | N_0_0100 ;|
  IS_DOWN_MID_0100 := 0             ;|
  DO_CHORD_UP(MID_BITS, N_0_0100)   ;| 
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;| 0100
}                                   ;|
ONUP_MID_0010()                     ;|
{                                   ;|
  JUSTUP_MID_KEYS := JUSTUP_MID_KEYS | N_0_0010 ;|
  IS_DOWN_MID_0010 := 0             ;|
  DO_CHORD_UP(MID_BITS, N_0_0010)   ;| 
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;| 0010
}                                   ;|
ONUP_MID_0001()                     ;|
{                                   ;|
  JUSTUP_MID_KEYS := JUSTUP_MID_KEYS | N_0_0001 ;|
  IS_DOWN_MID_0001 := 0             ;|
  DO_CHORD_UP(MID_BITS, N_0_0001)   ;|
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;| 0001
}                                   ;| 
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^;|     /\
ONUP_BOT_1000()                     ;|    /  \
{                                   ;|   /    \
  JUSTUP_BOT_KEYS := JUSTUP_BOT_KEYS | N_0_1000 ;|
  IS_DOWN_BOT_1000 := 0             ;|  / BOT_ \
  DO_CHORD_UP(BOT_BITS, N_0_1000)   ;| /________\
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;| 1000
}                                   ;|
ONUP_BOT_0100()                     ;|
{                                   ;|
  JUSTUP_BOT_KEYS := JUSTUP_BOT_KEYS | N_0_0100 ;|
  IS_DOWN_BOT_0100 := 0             ;|
  DO_CHORD_UP(BOT_BITS, N_0_0100)   ;|
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;| 0100
}                                   ;|
ONUP_BOT_0010()                     ;|
{                                   ;|
  JUSTUP_BOT_KEYS := JUSTUP_BOT_KEYS | N_0_0010 ;|
  IS_DOWN_BOT_0010 := 0             ;|
  DO_CHORD_UP(BOT_BITS, N_0_0010)   ;|
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;| 0010
}                                   ;|
ONUP_BOT_0001()                     ;|
{                                   ;|
  JUSTUP_BOT_KEYS := JUSTUP_BOT_KEYS | N_0_0001 ;|
  IS_DOWN_BOT_0001 := 0             ;|
  DO_CHORD_UP(BOT_BITS, N_0_0001)   ;|
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;| 0001
}                                   ;|
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^;|

;ALTR (ALTER) key modifies the chord and changes the
;letter it is. Like a SHIFT key, but not lowercase to uppercase.
;more like: "a" + alter ---> "t"
ONDOWN_ALT_ALTR()
{
  if(IS_DOWN_ALT_ALTR > 0)             ;|                                  *   *
  {                                    ;|                                  *   *
	;;AUTO_RELEASE_CHECK()         
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;|                                  *   *
  }                                    ;|                                  *   *
  IS_DOWN_ALT_ALTR := 1                ;|                                  *   *
  ;. . . . . . . . . . . . . . . . . . ;|                                  *   *
  DEL_BITS := DEL_BITS | N_1_0000      ;|                                  *   *
  TOP_BITS := TOP_BITS | N_1_0000      ;|                                  *   *
  MID_BITS := MID_BITS | N_1_0000      ;|                                  *   *
  BOT_BITS := BOT_BITS | N_1_0000      ;|                                  *   *
  if(IS_CHORD_LOADED == 0){            ;|                                  *   *
    IS_CHORD_LOADED := DEL_CHORD       ;|                                  *   *
  }                                    ;|                                  *   *
	RESET_CHORD_TIMER()                  ;|                                  *   *
return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;|                                  *   *
}
;for actions associated with going back.
;like delete, backspace, and back arrow.
ONDOWN_ALT_BACK()
{
  if(IS_DOWN_ALT_BACK > 0)             ;|                                  *   *
  {                                    ;|                                  *   *
	;;AUTO_RELEASE_CHECK()         
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;|                                  *   *
  }                                    ;|                                  *   *
  IS_DOWN_ALT_BACK := 1                ;|                                  *   *
  DEL_BITS := DEL_BITS | N_0_1000      ;|                                  *   *
  IS_CHORD_LOADED := DEL_CHORD         ;|                                  *   *
	RESET_CHORD_TIMER()                  ;|                                  *   *
return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;|                                  *   *
}
;for actions associated with going forward.
;like tab, space, and forward arrow.
ONDOWN_ALT_FWRD()
{
  if(IS_DOWN_ALT_FWRD > 0)             ;|                                  *   *
  {                                    ;|                                  *   *
	;;AUTO_RELEASE_CHECK()         
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;|                                  *   *
  }                                    ;|                                  *   *
  IS_DOWN_ALT_FWRD := 1                ;|                                  *   *
  DEL_BITS := DEL_BITS | N_0_0001      ;|                                  *   *
  IS_CHORD_LOADED := DEL_CHORD         ;|                                  *   *
	RESET_CHORD_TIMER()                  ;|                                  *   *
return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;|                                  *   *
}

ONDOWN_ALT_CHAN()
{
  if(IS_DOWN_ALT_CHAN > 0)             ;|                                  *   *
  {                                    ;|                                  *   *
	;;AUTO_RELEASE_CHECK()         
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;|                                  *   *
  }                                    ;|                                  *   *
  IS_DOWN_ALT_CHAN := 1                ;|                                  *   *
  DEL_BITS := DEL_BITS | N_0_0100      ;|  ;0100 == change mode modifier.
	
	if(IS_CHORD_LOADED == 0){            ;|                                  *   *
    IS_CHORD_LOADED := DEL_CHORD       ;|                                  *   *
  }                                    ;|                                  *   *
	
	
	RESET_CHORD_TIMER()                  ;|                                  *   *
return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;|                                  *   *
}

;when held down, you are in move mode. 
;For the arrow keys and home keys.
ONDOWN_ALT_MOVE()
{
  if(IS_DOWN_ALT_MOVE > 0)             ;|                                  *   *
  {                                    ;|                                  *   *
	;;AUTO_RELEASE_CHECK()         
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;|                                  *   *
  }                                    ;|                                  *   *
  IS_DOWN_ALT_MOVE := 1                ;|                                  *   *
  DEL_BITS := DEL_BITS | N_0_0010      ;|  ;0010 == move mode modifier.
  IS_CHORD_LOADED := DEL_CHORD         ;|                                  *   *
	RESET_CHORD_TIMER()                  ;|                                  *   *
return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;|                                  *   *
}


ONDOWN_TOP_1000()
{
  if(IS_DOWN_TOP_1000 > 0)      ;|
  {                             ;|
	;;AUTO_RELEASE_CHECK()  
  return ;;;;;;;;;;;;;;;;;;;;;;;;|
  }                             ;|
IS_DOWN_TOP_1000 := 1           ;|
TOP_BITS := TOP_BITS | N_0_1000 ;|
IS_CHORD_LOADED := TOP_CHORD    ;|
RESET_CHORD_TIMER()             ;|
return ;;;;;;;;;;;;;;;;;;;;;;;;;;|
}
ONDOWN_TOP_0100()
{
  if(IS_DOWN_TOP_0100 > 0)      ;|
  {                             ;|
	;;AUTO_RELEASE_CHECK()         
  return ;;;;;;;;;;;;;;;;;;;;;;;;|
  }                             ;|
IS_DOWN_TOP_0100 := 1           ;|
TOP_BITS := TOP_BITS | N_0_0100 ;|
IS_CHORD_LOADED := TOP_CHORD    ;|
RESET_CHORD_TIMER()             ;|
return ;;;;;;;;;;;;;;;;;;;;;;;;;;|
}
ONDOWN_TOP_0010()
{
  if(IS_DOWN_TOP_0010 > 0)      ;|
  {                             ;|
	;;AUTO_RELEASE_CHECK()         
  return ;;;;;;;;;;;;;;;;;;;;;;;;|
  }                             ;|
IS_DOWN_TOP_0010 := 1           ;|
TOP_BITS := TOP_BITS | N_0_0010 ;|
IS_CHORD_LOADED := TOP_CHORD    ;|
RESET_CHORD_TIMER()             ;|
return ;;;;;;;;;;;;;;;;;;;;;;;;;;|
}
ONDOWN_TOP_0001()
{
  if(IS_DOWN_TOP_0001 > 0)      ;|
  {                             ;|
	;;AUTO_RELEASE_CHECK()         
  return ;;;;;;;;;;;;;;;;;;;;;;;;|
  }                             ;|
IS_DOWN_TOP_0001 := 1           ;|
TOP_BITS := TOP_BITS | N_0_0001 ;|
IS_CHORD_LOADED := TOP_CHORD    ;|
RESET_CHORD_TIMER()             ;|
return ;;;;;;;;;;;;;;;;;;;;;;;;;;|
}
;-----------------------------------------------
ONDOWN_MID_1000()
{
  if(IS_DOWN_MID_1000 > 0)      ;|                                         *   *
  {                             ;|                                         *   *
		;;AUTO_RELEASE_CHECK()         
  return ;;;;;;;;;;;;;;;;;;;;;;;;|                                         *   *
  }                             ;|                                         *   *
IS_DOWN_MID_1000 := 1           ;|                                         *   *
MID_BITS := MID_BITS | N_0_1000 ;|                                         *   *
IS_CHORD_LOADED := MID_CHORD    ;|                                         *   *
RESET_CHORD_TIMER()             ;|                                         *   *
return ;;;;;;;;;;;;;;;;;;;;;;;;;;|                                         *   *
}
ONDOWN_MID_0100()
{
  if(IS_DOWN_MID_0100 > 0)      ;|                                         *   *
  {                             ;|                                         *   *
		;;AUTO_RELEASE_CHECK()         
  return ;;;;;;;;;;;;;;;;;;;;;;;;|                                         *   *
  }                             ;|                                         *   *
IS_DOWN_MID_0100 := 1           ;|                                         *   *
MID_BITS := MID_BITS | N_0_0100 ;|                                         *   *
IS_CHORD_LOADED := MID_CHORD    ;|                                         *   *
RESET_CHORD_TIMER()             ;|                                         *   *
return ;;;;;;;;;;;;;;;;;;;;;;;;;;|                                         *   *
}
ONDOWN_MID_0010()
{
  if(IS_DOWN_MID_0010 > 0)      ;|                                         *   *
  {                             ;|                                         *   *
	;;AUTO_RELEASE_CHECK()  
  return ;;;;;;;;;;;;;;;;;;;;;;;;|                                         *   *
  }                             ;|                                         *   *
IS_DOWN_MID_0010 := 1           ;|                                         *   *
MID_BITS := MID_BITS | N_0_0010 ;|                                         *   *
IS_CHORD_LOADED := MID_CHORD    ;|                                         *   *
RESET_CHORD_TIMER()             ;|                                         *   *
return ;;;;;;;;;;;;;;;;;;;;;;;;;;|                                         *   *
}
ONDOWN_MID_0001()
{
  if(IS_DOWN_MID_0001 > 0)      ;|                                         *   *
  {                             ;|                                         *   *
	;;AUTO_RELEASE_CHECK()  
  return ;;;;;;;;;;;;;;;;;;;;;;;;|                                         *   *
  }                             ;|                                         *   *
IS_DOWN_MID_0001 := 1           ;|                                         *   *
MID_BITS := MID_BITS | N_0_0001 ;|                                         *   *
IS_CHORD_LOADED := MID_CHORD    ;|                                         *   *
RESET_CHORD_TIMER()             ;|                                         *   *
return ;;;;;;;;;;;;;;;;;;;;;;;;;;|                                         *   *
}
;-----------------------------------------------
ONDOWN_BOT_1000()
{
  if(IS_DOWN_BOT_1000 > 0)      ;|                                         *   *
  {                             ;|                                         *   *
		;;AUTO_RELEASE_CHECK()         
  return ;;;;;;;;;;;;;;;;;;;;;;;;|                                         *   *
  }                             ;|                                         *   *
IS_DOWN_BOT_1000 := 1           ;|                                         *   *
BOT_BITS := BOT_BITS | N_0_1000 ;|                                         *   *
IS_CHORD_LOADED := BOT_CHORD    ;|                                         *   *
RESET_CHORD_TIMER()             ;|                                         *   *
return ;;;;;;;;;;;;;;;;;;;;;;;;;;|                                         *   *
}
ONDOWN_BOT_0100()
{
  if(IS_DOWN_BOT_0100 > 0)      ;|                                         *   *
  {                             ;|                                         *   *
		;;AUTO_RELEASE_CHECK()         
  return ;;;;;;;;;;;;;;;;;;;;;;;;|                                         *   *
  }                             ;|                                         *   *
IS_DOWN_BOT_0100 := 1           ;|                                         *   *
BOT_BITS := BOT_BITS | N_0_0100 ;|                                         *   *
IS_CHORD_LOADED := BOT_CHORD    ;|                                         *   *
RESET_CHORD_TIMER()             ;|                                         *   *
return ;;;;;;;;;;;;;;;;;;;;;;;;;;|                                         *   *
}
ONDOWN_BOT_0010()
{
  if(IS_DOWN_BOT_0010 > 0)      ;|                                         *   *
  {                             ;|                                         *   *
		;;AUTO_RELEASE_CHECK()         
  return ;;;;;;;;;;;;;;;;;;;;;;;;|                                         *   *
  }                             ;|                                         *   *
IS_DOWN_BOT_0010 := 1           ;|                                         *   *
BOT_BITS := BOT_BITS | N_0_0010 ;|                                         *   *
IS_CHORD_LOADED := BOT_CHORD    ;|                                         *   *
RESET_CHORD_TIMER()             ;|                                         *   *
return ;;;;;;;;;;;;;;;;;;;;;;;;;;|                                         *   *
}
ONDOWN_BOT_0001()
{
  if(IS_DOWN_BOT_0001 > 0)      ;|                                         *   *
  {                             ;|                                         *   *
		;;AUTO_RELEASE_CHECK()         
  return ;;;;;;;;;;;;;;;;;;;;;;;;|                                         *   *
  }                             ;|                                         *   *
IS_DOWN_BOT_0001 := 1           ;|                                         *   *
BOT_BITS := BOT_BITS | N_0_0001 ;|                                         *   *
IS_CHORD_LOADED := BOT_CHORD    ;|                                         *   *
RESET_CHORD_TIMER()             ;|                                         *   *
return ;;;;;;;;;;;;;;;;;;;;;;;;;;|                                         *   *
}

;All of our key bindings need to use "UseHook" preprocessor directive so that
;Infinite loops or other feedback loops do not occur. We could use ^v
;And the clipboard. But that is hackish and results in ENQ and DC1
;non-printable characters printing to console/text-editor. It also triggers
;random hot keys. Depends on the keyboard in use for how bad this is.
;*******************************************************************************
#UseHook
;*******************************************************************************
;special keys -----+                                                       *   *

shift UP::
{
	ONUP_ALT_MOVE() ;|
	return ;;;;;;;;;;|
}
capslock UP::
{
	ONUP_ALT_BACK() ;|
	return ;;;;;;;;;;|
}

tab UP::
{
	ONUP_ALT_CHAN()
	return ;;;;;;;;
}

down UP::
{                 ;|  [                        ]                           *   *
  ONUP_ALT_ALTR() ;|  [                        ]                           *   *
  return ;;;;;;;;;;|  [                        ]                           *   *
}                 ;|  [                        ]                           *   *
space UP::        ;|  [                        ]                           *   *
{                 ;|  [                        ]                           *   *
  ONUP_ALT_ALTR() ;|  [  SPECIAL KEYS RELEASE  ]                           *   *
  return ;;;;;;;;;;|  [                        ]                           *   *
}                 ;|  [                        ]                           *   *

g   UP::
alt UP::
{                 ;|  [                        ]                           *   *
  ONUP_ALT_FWRD() ;|  [                        ]                           *   *
  return ;;;;;;;;;;|  [                        ]                           *   *
}                 ;|  [========================]                           *   *
;-----------------;|                                                       *   *
;TOP row release  ;|                                                       *   *
q UP::            ;|  [========================]                           *   *
{                 ;|  [                        ]                           *   *
  ONUP_TOP_1000() ;|  [                        ]                           *   *
  return ;;;;;;;;;;|  [                        ]                           *   *
}                 ;|  [                        ]                           *   *
w UP::            ;|  [                        ]                           *   *
{                 ;|  [                        ]                           *   *
  ONUP_TOP_0100() ;|  [                        ]                           *   *
  return ;;;;;;;;;;|  [                        ]                           *   *
}                 ;|  [    TOP ROW RELEASE     ]                           *   *
e UP::            ;|  [                        ]                           *   *
{                 ;|  [                        ]                           *   *
  ONUP_TOP_0010() ;|  [                        ]                           *   *
  return ;;;;;;;;;;|  [                        ]                           *   *
}                 ;|  [                        ]                           *   *
r UP::            ;|  [                        ]                           *   *
{                 ;|  [                        ]                           *   *
  ONUP_TOP_0001() ;|  [                        ]                           *   *
  return ;;;;;;;;;;|  [========================]                           *   *
}                 ;|                                                       *   *
;-----------------;|                                                       *   *
;MID row release  ;|                                                       *   *
a UP::            ;|  [========================]                           *   *
{                 ;|  [                        ]                           *   *
  ONUP_MID_1000() ;|  [                        ]                           *   *
  return ;;;;;;;;;;|  [                        ]                           *   *
}                 ;|  [                        ]                           *   *
s UP::            ;|  [                        ]                           *   *
{                 ;|  [                        ]                           *   *
  ONUP_MID_0100() ;|  [                        ]                           *   *
  return ;;;;;;;;;;|  [                        ]                           *   *
}                 ;|  [    MID ROW RELEASE     ]                           *   *
d UP::            ;|  [                        ]                           *   *
{                 ;|  [                        ]                           *   *
  ONUP_MID_0010() ;|  [                        ]                           *   *
  return ;;;;;;;;;;|  [                        ]                           *   *
}                 ;|  [                        ]                           *   *
f UP::            ;|  [                        ]                           *   *
{                 ;|  [                        ]                           *   *
  ONUP_MID_0001() ;|  [                        ]                           *   *
  return ;;;;;;;;;;|  [========================]                           *   *
}                 ;|                                                       *   *
;-----------------;|                                                       *   *
;BOT row release  ;|                                                       *   *
z UP::            ;|  [========================]                           *   *
{                 ;|  [                        ]                           *   *
  ONUP_BOT_1000() ;|  [                        ]                           *   *
  return ;;;;;;;;;;|  [                        ]                           *   *
}                 ;|  [                        ]                           *   *
x UP::            ;|  [                        ]                           *   *
{                 ;|  [                        ]                           *   *
  ONUP_BOT_0100() ;|  [                        ]                           *   *
  return ;;;;;;;;;;|  [                        ]                           *   *
}                 ;|  [    BOT ROW RELEASE     ]                           *   *
c UP::            ;|  [                        ]                           *   *
{                 ;|  [                        ]                           *   *
  ONUP_BOT_0010() ;|  [                        ]                           *   *
  return ;;;;;;;;;;|  [                        ]                           *   *
}                 ;|  [                        ]                           *   *
v UP::            ;|  [                        ]                           *   *
{                 ;|  [                        ]                           *   *
  ONUP_BOT_0001() ;|  [                        ]                           *   *
  return ;;;;;;;;;;|  [========================]                           *   *
}                 ;|                                                       *   *
;-----------------;|                                                       *   *
;                                                                          *   *
;                                                                          *   *

;                                                                          *   *
;                                                                          *   *
;Top Row                                                                   *   *
;--------------------------------+                                         *   *
r::                             ;|                                         *   *
{                               ;|                                         *   *
ONDOWN_TOP_0001() ;;|
return ;;;;;;;;;;;;;|
}                               ;|                                         *   *
                                ;|                                         *   *
e::                             ;|                                         *   *
{                               ;|                                         *   *
ONDOWN_TOP_0010() ;;|
return ;;;;;;;;;;;;;|
}                               ;|                                         *   *
                                ;|                                         *   *
w::                             ;|                                         *   *
{                               ;|                                         *   *
ONDOWN_TOP_0100() ;;|
return ;;;;;;;;;;;;;|
}                               ;|                                         *   *
                                ;|                                         *   *
q::                             ;|                                         *   *
{                               ;|                                         *   *
ONDOWN_TOP_1000() ;;|
return ;;;;;;;;;;;;;|
}                               ;|                                         *   *
;--------------------------------+                                         *   *
;                                                                          *   *
;MID Row                                                                   *   *
;--------------------------------+                                         *   *
f::                             ;|                                         *   *
{                               ;|                                         *   *
ONDOWN_MID_0001() ;;|
return ;;;;;;;;;;;;;|
}                               ;|                                         *   *
                                ;|                                         *   *
d::                             ;|                                         *   *
{                               ;|                                         *   *
ONDOWN_MID_0010() ;;|
return ;;;;;;;;;;;;;|
}                               ;|                                         *   *
                                ;|                                         *   *
s::                             ;|                                         *   *
{                               ;|                                         *   *
ONDOWN_MID_0100() ;;|
return ;;;;;;;;;;;;;|
}                               ;|                                         *   *
                                ;|                                         *   *
a::                             ;|                                         *   *
{                               ;|                                         *   *
ONDOWN_MID_1000() ;;|
return ;;;;;;;;;;;;;|
}                               ;|                                         *   *
;--------------------------------+                                         *   *
;                                                                          *   *
;BOT Row                                                                   *   *
;--------------------------------+                                         *   *
v::                             ;|                                         *   *
{                               ;|                                         *   *
ONDOWN_BOT_0001() ;;|
return ;;;;;;;;;;;;;|
}                               ;|                                         *   *
                                ;|                                         *   *
c::                             ;|                                         *   *
{                               ;|                                         *   *
ONDOWN_BOT_0010() ;;|
return ;;;;;;;;;;;;;|
}                               ;|                                         *   *
                                ;|                                         *   *
x::                             ;|                                         *   *
{                               ;|                                         *   *
ONDOWN_BOT_0100() ;;|
return ;;;;;;;;;;;;;|
}                               ;|                                         *   *
                                ;|                                         *   *
z::                             ;|                                         *   *
{                               ;|                                         *   *
ONDOWN_BOT_1000() ;;|
return ;;;;;;;;;;;;;|
}                               ;|                                         *   *
;--------------------------------+                                         *   *


; ;Special Keys  : QWERTY KEYBOARD CONFIG:                           
; ;---------------------------------------+ 
; ;Modifier/Alt key:                     ;|
; space::                                ;|
; { ;Will apply modifier key to all rows ;|
; ONDOWN_ALT_ALTR() ;;|                  ;|
; return ;;;;;;;;;;;;;|                  ;|
; }                                      ;|
;                                        ;|
; ;Special BACKSPACE and SPACE keys:     ;|
; `::                                    ;|
; tab::                                  ;|
; CapsLock::                             ;|
; { ;set extreem left of bitset          ;|
; ONDOWN_ALT_BACK() ;;|                  ;|
; return ;;;;;;;;;;;;;|                  ;|
; }                                      ;|
; 5::                                    ;|
; t::                                    ;|
; g::                                    ;|
; { ;set extreme right of bitset         ;|
; ONDOWN_ALT_FWRD() ;;|                  ;|
; return ;;;;;;;;;;;;;|                  ;|
; }                                      ;|
; ;---------------------------------------+ 

;Special Keys  : TARTARUS CHROMA                           
;---------------------------------------+ 
;Modifier/Alt key:                     ;|
g::
alt::                                ;|
{ ;Will apply modifier key to all rows ;|
ONDOWN_ALT_FWRD() ;;|                  ;|
return ;;;;;;;;;;;;;|                  ;|
}                                      ;|
                                       ;|
;Special BACKSPACE and SPACE keys:     ;|
down::                             ;|
{ ;set extreem left of bitset          ;|
send ^c ;copy, hack to get working in web browser window.
send ^x ;cut
return ;;;;;;;;;;;;;|                  ;|
}                                      ;|

up::
{
send ^v ;paste
return ;;;;;;;;
}

shift::
{
ONDOWN_ALT_MOVE() ;;|
return ;;;;;;;;;;;;;|
}
capslock::
{
ONDOWN_ALT_BACK() ;;|
return ;;;;;;;;;;;;;|
}

;because TARTARUS CHROMA'S ARROW KEYS ARE TOO TWITCHY, WE WANT TO IGNORE
;THE OTHER ONES!
right::
left::
{
return
}


space::                                    ;|
{ ;set extreme right of bitset         ;|
ONDOWN_ALT_ALTR() ;;|                  ;|
return ;;;;;;;;;;;;;|                  ;|
}                                      ;|
;---------------------------------------+ 

tab::
{
ONDOWN_ALT_CHAN()
return ;;;;;;;;;;
}

SWITCH_TO_NORMAL_KEYBOARD()
{
  SoundBeep, 333,100
  Run, %A_ScriptDir%\CHORDS_SUSPENDED.ahk
  exitApp
  return
}




;*******************************************************************************
#UseHook off
;*******************************************************************************

RESET_CHORD_TIMER()
{ 
  AUTO_RELEASE_TIMER :=  A_TickCount
	return ;;;;;;;;;;;;;;;;;;;;;;;;;;;
}

AUTO_RELEASE_CHECK:

	RELEASE_DELTA := A_TickCount - AUTO_RELEASE_TIMER
	if(RELEASE_DELTA > AUTO_RELEASE_MS)
	;if(1) ;<--even zero delay is not fast enough. Compile script?
	{
		RESET_CHORD_TIMER()
		
		;unload the chord without deleting any of the pressed bits.
		;another key will have to be pressed down to re-load chord.
		if(IS_CHORD_LOADED > 0)
		{
			PRINT_CHORD(void)
			IS_CHORD_LOADED := 0
		}
		
	}
return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;  z::
;;  {
;;    ;clipboard = %TOP_BITS%
;;    ;clipboard = %DEL_BITS%
;;    ;clipboard = %MID_BITS%
;;    ;clipboard = %BOT_BITS%
;;    
;;    ; clipboard := BINARY_STRING_TO_INTEGER("10000")
;;    ; send ^v
;;    ; ;sleep 100
;;    ; 
;;    ; clipboard := BINARY_STRING_TO_INTEGER("01000")
;;    ; send ^v
;;    ; ;sleep 100
;;    ; 
;;    ; 
;;    ; clipboard := BINARY_STRING_TO_INTEGER("00100")
;;    ; send ^v
;;    ; ;sleep 100
;;    ; 
;;    ; 
;;    ; clipboard := BINARY_STRING_TO_INTEGER("00010")
;;    ; send ^v
;;    ; ;sleep 100
;;    ; 
;;    ; 
;;    ; clipboard := BINARY_STRING_TO_INTEGER("00001")
;;    ; send ^v
;;    ; ;sleep 100
;;    
;;    ;PRINT_A_MAP(TOP_MAP)
;;    
;;    ;loop,31
;;    ;{
;;    ;  clipboard := INTEGER_TO_BINARY_STRING(A_Index)
;;    ;  send ^v
;;    ;  send {enter}
;;    ;  sleep 10
;;    ;}
;;    
;;    PRINT_OUT_ALL_MAPS(void)
;;    
;;    
;;  	return
;;  }
;;  
;;  x::
;;  {
;;  	PRINT_OUT_ALL_MAPS(void)
;;  	return
;;  }

;||===========================================================================||
;||                                                                           ||
;||                       START OF SECTION                                    ||
;||                                                                           ||
;||HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH||
;||HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH||
;||                       Hotkey Section                                      ||
;||HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH||
;||HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH||

   ;This section is for launching hotkeys via letter combinations.
   RECORD_FOR_HOTKEY(KEY_PRESS)
	 {
      ;m_sgBox KEY=%KEY_PRESS%
	 
	    ;erase previous 
			if(KEY_PRESS == BRACK_CHAR_OPENED) ;[]
			{
				ERASE_PREV()
				COLLECTION_MODE := CM_BRACK
			}else
			if(KEY_PRESS == ANGLE_CHAR_OPENED) ;<>
			{
		    ERASE_PREV()
				COLLECTION_MODE := CM_ANGLE
			}else
			if(KEY_PRESS == ARROW_CHAR_OPENED) ;>>>>>>>
			{
			  ERASE_PREV()
				COLLECTION_MODE := CM_ARROW
			}
			
			else
			
			;analyse current
			if(KEY_PRESS == BRACK_CHAR_CLOSED)
			{
			  ;m_sgBox CLOSED
				READ_COLLECTED_AND_EXIT_COLLECT_MODE(BRACK_SSS, BRACK_KEY_TO_FILEPATH)
			}else			
			if(KEY_PRESS == ANGLE_CHAR_CLOSED)
			{
		    READ_COLLECTED_AND_EXIT_COLLECT_MODE(ANGLE_SSS, ANGLE_KEY_TO_FILEPATH)
			}else
			if(KEY_PRESS == ARROW_CHAR_CLOSED)
			{
			  READ_COLLECTED_AND_EXIT_COLLECT_MODE(ARROW_SSS, ARROW_KEY_TO_FILEPATH)
			}
			
			else
			
			{ ;record non special character
				if(COLLECTION_MODE == CM_BRACK)
				{
					BRACK_SSS = %BRACK_SSS%%KEY_PRESS%
			  }else
				if(COLLECTION_MODE == CM_ANGLE)
				{
					ANGLE_SSS = %ANGLE_SSS%%KEY_PRESS%
				}else
				if(COLLECTION_MODE == CM_ARROW)
				{
					ARROW_SSS = %ARROW_SSS%%KEY_PRESS%
				}
			}
			
	 }
	 
	 ;Append KEY_PRESS to the active SSS (shortcut stack string)
	 ;we are currently building.
	 COLLECT_FOR_SSS(KEY_PRESS, byRef SSS)
	 {
			SSS := SSS + KEY_PRESS
	 }
	 
	READ_COLLECTED_AND_EXIT_COLLECT_MODE(SSS_KEY, byRef KEY_TO_FILENAME)
	{
	  ;m_sgBox KEY_TO_FILENAME==%KEY_TO_FILENAME%
		READ_COLLECTED(SSS_KEY, KEY_TO_FILENAME)
		COLLECTION_MODE := 0
	}
	
	GET_VALUE_USING_KEY(SSS_KEY, byRef KEY_TO_FILENAME)
	{
		MAYBE_FILE_PATH := KEY_TO_FILENAME[SSS_KEY]
		return MAYBE_FILE_PATH
	}
	 
	;read shortcut stack string
	READ_COLLECTED(SSS_KEY, byRef KEY_TO_FILENAME)
	{
		;m_sgBox SSS_KEY=%SSS_KEY%
	
		MAYBE_FILE_PATH := KEY_TO_FILENAME[SSS_KEY]
		LEN_OF_FILEPATH := StrLen(MAYBE_FILE_PATH)

		;if the length is > 0, then the SSS key we used actually
		;mapped to a non-null entry
		if(LEN_OF_FILEPATH > 0)
		{
			;m_sgBox SHORTCUT RECOGNIZED!
			;Delete the "<>", "><" or "[]" typed to get the shortcut.
			DELETE_WORD("[]",LEN_OF_FILEPATH)
			DEFINITELY_A_FILE_PATH := MAYBE_FILE_PATH
			PASTE_TEXT_FRIENDLY_FILES_OR_OPEN_OTHERWISE(DEFINITELY_A_FILE_PATH)
		}
		else
		{
			;m_sgBox SHORTCUT[%SSS_KEY%] NOT RECOGNIZED cc
			;m_sgBox VALUE=%MAYBE_FILE_PATH%
		}
	}
	 
	 ;erase all shortcut strings
	 ERASE_PREV()
	 {
      BRACK_SSS := ""
			ANGLE_SSS := ""
			ARROW_SSS := ""
	 }

	;TODO: Fix the mapping on LOAD_SHORTCUT_FILE
	;load shortcuts into KEY_TO_FILENAME array
	LOAD_SHORTCUT_FILE(FILEPATH, byRef KEY_TO_FILENAME,IS_PATH_ABSOLUTE, BACKOUT)
	{
    ;m_sgBox FILEPATH=%FILEPATH%
		
		ABS_FILE_PATH := ""
		if(IS_PATH_ABSOLUTE > 0)
		{ ;no edits needed, already absolute:
			ABS_FILE_PATH = %FILEPATH%
		}else
		{ ;make the path absolute
			ABS_FILE_PATH = %A_ScriptDir%
			BACKEDOUT := PATH_BACK_OUT(ABS_FILE_PATH, BACKOUT)
			;m_sgBox BACKEDOUT=%BACKEDOUT%
			ABS_FILE_PATH = %BACKEDOUT%%FILEPATH%
			;m_sgBox AFP %ABS_FILE_PATH%
		}
		
		;m_sgBox ABS_FILE_PATH=%ABS_FILE_PATH%
		
		;//back out from ABSOLUTE FILE PATH:
		
		
		MAPPED_PATH_VALUE := ""
		loopcounter :=0
		Loop, Read, %ABS_FILE_PATH%
		{
			;base 1 calculations for indexes in file
			loopcounter++
			if(loopcounter>3)
			{
				loopcounter = 1
			}
		 
			if(loopcounter = 1)
			{
				;//Gather the path
				MAPPED_PATH_VALUE = %A_LoopReadLine%   ;//<<correct. use "=" not ":="
			}else
			if(loopcounter = 2)
			{
				WHAT_TO_TYPE = %A_LoopReadLine%
				KEY_TO_FILENAME.Insert(WHAT_TO_TYPE,MAPPED_PATH_VALUE)
				
				;test to make sure you can retrieve the data:
				GOTTEN := KEY_TO_FILENAME[WHAT_TO_TYPE]
				if(GOTTEN != MAPPED_PATH_VALUE)
				{
					msgBox RETRIEVAL OF MAPPING FAILED.
				}
					
				
				;These variables are correctly loaded:
				;m_sgBox WHAT_TO_TYPE=%WHAT_TO_TYPE%
				;m_sgBox MAPPED_PATH_VALUE=%MAPPED_PATH_VALUE%
			}						
		} ;END OF LOOP
		
		if(loopcounter == 0)
		{
			;m_sgBox FAILED_TO_LOOP_ANY_THROUGH_FILE
		}else{
			;m_sgBox KEY_TO_FILENAME=%KEY_TO_FILENAME%
		}
		
		return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	}
	
	PATH_BACK_OUT(FILE_PATH, LEVELS_UP_TO_BACK_OUT)
	{
		;m_sgBox FILE_PATH=%FILE_PATH%
		OUT_ARRAY := []
		DELIMETER := "\"
		OUT_ARRAY := StrSplit(FILE_PATH, DELIMETER)
		MI  := OUT_ARRAY.MaxIndex()
		
		;NMI = "new max index"
		;NMI has minus 1 because path is to file, not folder.
		NMI := MI - LEVELS_UP_TO_BACK_OUT - 1 
		NEW_FILE_PATH := ""
		
		;m_sgBox MI=%MI%
		loop
		{
		  if(A_Index > NMI)
			{
			break
			}
		  ;m_sgBox MMMM
			SEG := OUT_ARRAY[A_Index]
			;m_sgBox SEG==%SEG%
			NEW_FILE_PATH = %NEW_FILE_PATH%%SEG%\
		}
		
		return NEW_FILE_PATH ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	}
	
	PASTE_TEXT_FRIENDLY_FILES_OR_OPEN_OTHERWISE(FILE_PATH){
		SplitPath, FILE_PATH, dontCare01,  dontCare02, ext,  dontCare03,  dontCare04

		;if executable or openable, we want to use RUN on the filepath
		if(  (ext="docx") || (ext="pdf") || (ext="png") || (ext="exe") || (ext="bat"))
		{
			Run, %A_ScriptDir%\%FILE_PATH%
		}else
		{ ;otherwise, just paste contents. Doing this for .cpp, .js, .html, .txt
			PASTE_FILE(FILE_PATH)
		}

		return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	}
	
	PASTE_FILE(FILE_PATH_TO_READ){
		;Store old contents of clipboard:
		clip_board_contents = %Clipboard%
		
		;Read data into clipboard, and paste it:
		FileRead, Clipboard, %FILE_PATH_TO_READ%
		Send, ^v
		
		;Restore Clipboard:
		sleep, 100 ;HACK: sleep for ### milliseconds so ^v call goes through.
		Clipboard = %clip_board_contents% 
		
		return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	}
	
	;;backspaces number of characters in inWord
	;;plus whatever extra
	DELETE_WORD(IN_WORD, EXTRA){
		varGoBackAmt := ( StrLen(IN_WORD) + EXTRA)
		Loop, %varGoBackAmt%
		{
			Send, {backspace}
		}
		return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	}


;||HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH||
;||HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH||
;||                       Hotkey Section                                      ||
;||HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH||
;||HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH||
;||                                                                           ||
;||                       END OF SECTION                                      ||
;||                                                                           ||
;||===========================================================================||













