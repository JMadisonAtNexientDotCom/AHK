#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

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
  DEL_CHORD = 1                                                    ;==========++
  TOP_CHORD = 2                                                    ;==========++
  MID_CHORD = 3                                                    ;==========++
  BOT_CHORD = 4                                                    ;==========++
                                                                   ;==========++
                                                                   ;==========++
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
  M2( TOP_MAP, "0001", "A", "4" )  ;01	0001 - A  | 4 -- 4's place not changed.|
  M2( TOP_MAP, "0010", "O", "3" )  ;02	0010 - O  | 3 -- 3's place not changed.|
  M2( TOP_MAP, "0100", "E", "2" )  ;03	0100 - E  | 2 -- 2's place not changed.|
  M2( TOP_MAP, "1000", "U", "1" )  ;04	1000 - U  | 1 -- 1's place not changed.|
  M2( TOP_MAP, "1100", "I", "X" )  ;05	1100 - I  | X                          |
  M2( TOP_MAP, "0110", "D", "B" )  ;06	0110 - D  | B                          |
  M2( TOP_MAP, "0011", "H", "Y" )  ;07	0011 - H  | Y                          |
  M2( TOP_MAP, "1001", "T", "R" )  ;08	1001 - T  | R                          |
  M2( TOP_MAP, "1010", "N", "C" )  ;09	1010 - N  | C                          |
  M2( TOP_MAP, "0101", "S", "G" )  ;10	0101 - S  | G                          |
  M2( TOP_MAP, "1110", "Q", "F" )  ;11	1110 - Q  | F                          |
  M2( TOP_MAP, "0111", "J", "L" )  ;12	0111 - J  | L                          |
  M2( TOP_MAP, "1101", "K", "P" )  ;13	1101 - K  | P                          |
  M2( TOP_MAP, "1011", "V", "Z" )  ;14	1011 - V  | Z                          |
  M2( TOP_MAP, "1111", "M", "W" )  ;15	1111 - M  | W                          |
;==============================================================================+

;------------------+-----------------------------------------------------------+
;[1][2][3][4] ROW: | IDENTICAL MAPPINGS BUT LOWERCASE. EXCEPT NUMBERS 5,6,7,8  |
;==================|===========================================================+
  M2( MID_MAP, "0001", "a", "4" )  ;01	0001 - A  | 8 |                       /+
  M2( MID_MAP, "0010", "o", "3" )  ;02	0010 - O  | 7 |                      /++
  M2( MID_MAP, "0100", "e", "2" )  ;03	0100 - E  | 6 |                     /=++
  M2( MID_MAP, "1000", "u", "1" )  ;04	1000 - U  | 5 |                    /==++
  M2( MID_MAP, "1100", "i", "x" )  ;05	1100 - I  | X |                   /===++
  M2( MID_MAP, "0110", "d", "b" )  ;06	0110 - D  | B |                  /====++
  M2( MID_MAP, "0011", "h", "y" )  ;07	0011 - H  | Y |                 /=====++
  M2( MID_MAP, "1001", "t", "r" )  ;08	1001 - T  | R |                /======++
  M2( MID_MAP, "1010", "n", "c" )  ;09	1010 - N  | C |               /=======++
  M2( MID_MAP, "0101", "s", "g" )  ;10	0101 - S  | G |              /========++
  M2( MID_MAP, "1110", "q", "f" )  ;11	1110 - Q  | F |             /=========++
  M2( MID_MAP, "0111", "j", "l" )  ;12	0111 - J  | L |            /==========++
  M2( MID_MAP, "1101", "k", "p" )  ;13	1101 - K  | P |           /;==========++
  M2( MID_MAP, "1011", "v", "z" )  ;14	1011 - V  | Z |          / ;==========++
  M2( MID_MAP, "1111", "m", "w" )  ;15	1111 - M  | W |         /  ;==========++
;=====================================================+========/   ;==========++
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
;                         |||||||||||||||||||||||||||||||||||||||||;==========++
;                         || Copied From ChordKeys Documentation ||;==========++
;[A][S][D][F] BOTTOM-ROW: |||||||||||||||||||||||||||||||||||||||||;==========++
  M2( BOT_MAP, "1000", "{", "9" )  ;  01	08	1000 | { | 9 |       ;==========++
  M2( BOT_MAP, "0001", "}", ";" )  ;  02	01	0001 | } | ; |       ;==========++
  M2( BOT_MAP, "0100", "(", "0" )  ;  03	04	0100 | ( | 0 |       ;==========++
  M2( BOT_MAP, "0010", ")", "!" )  ;  04	02	0010 | ) | ! |       ;==========++
  M2( BOT_MAP, "1100", "[", "#" )  ;  05	12	1100 | [ | # |       ;==========++
  M2( BOT_MAP, "0011", "]", "," )  ;  06	03	0011 | ] | , |       ;==========++
  M2( BOT_MAP, "1010", "<", "*" )  ;  07	10	1010 | < | * |       ;==========++
  M2( BOT_MAP, "0101", ">", "^" )  ;  08	05	0101 | > | ^ |       ;==========++
  M2( BOT_MAP, "1110", "-", "_" )  ;  09	14	1110 | - | _ |       ;==========++
  M2( BOT_MAP, "0111", "+", "=" )  ;  10	07	0111 | + | = |       ;==========++
  M2( BOT_MAP, "1111", "/", "." )  ;  11	15	1111 | / | . |       ;==========++
  M2( BOT_MAP, "0110", ":", "@" )  ;  12	06	0110 | : | @ |       ;==========++
  M2( BOT_MAP, "1001", "'", """")  ;  13	09	1001 | ' | " |       ;==========++
  M2( BOT_MAP, "1011", "?", "%" )  ;  14	11	1011 | ? | % |       ;==========++
  M2( BOT_MAP, "1101", "&", "~" )  ;  15	13	1101 | & | ~ |       ;==========++
  ;|||||||||||                                     ||||||||||||||||;==========++
  ;||||||||||| Num Row Key #5 can be -> operator.  ||||||||||||||||;==========++
  ;||||||||||| Tilde could be backslash.           ||||||||||||||||;==========++
  ;|||||||||||                                     ||||||||||||||||;==========++
  ;||||||||||| Symbols we can live without for now:||||||||||||||||;==========++
  ;||||||||||| $ ` \  ->                           ||||||||||||||||;==========++
                                                                   ;==========++
                                                                   ;==========++
                                                                   ;==========++
                                                                   ;==========++
                                                                   ;==========++
                                                                   ;==========++
                                                                   ;==========++
                                                                   ;==========++
return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;==========++
} ;===========================================================================++
SetDefaults(void) ;===========================================================++
;=============================================================================++



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


CLEAR_ALL_MAPS(void) ;--------------+
{                ;when done with   ;|
	DEL_BITS := 0  ;a coord, clear   ;|
	TOP_BITS := 0  ;all of the bits  ;|
	MID_BITS := 0  ;keeping track of ;|
	BOT_BITS := 0  ;the coords.      ;|
  return ;;;;;;;;;;;;;;;;;;;;;;;;;;;| 
} ;---------------------------------+


PRINT_NON_ROW_CHORDS(void) ;----+
{                              ;|
  if(DEL_BITS == N_0_1000)     ;|
  { ;Backspace Key             ;|
    send `b                    ;|
  }else                        ;|
  if(DEL_BITS == N_1_1000)     ;|
  { ;Delete Key                ;|
    send {delete}              ;|
  }else                        ;|
  if(DEL_BITS == N_0_0001)     ;|
  { ;Space Key                 ;|
    send {space}               ;|
  }else                        ;|
  if(DEL_BITS == N_1_0001)     ;|
  { ;Tab Key                   ;|
    send {tab}                 ;|
  }else                        ;|
  if(DEL_BITS == N_1_0000)     ;|
  { ;Alt key only is for ENTER ;|
    send {enter}               ;|
  }                            ;|
return ;;;;;;;;;;;;;;;;;;;;;;;;;|
} ;-----------------------------+


PRINT_CHORD(void) ;---------------------------------+
{                                                  ;|
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
  } ;----------------------------------+           ;|
                                                   ;|
  clipboard := CHORD_ARRAY_TO_USE[ CHORD_OF_BITS ] ;|
  send ^v                                          ;|
                                                   ;|
return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;|
} ;-------------------------------------------------+


DO_CHORD_UP() ;----------+
{                       ;|
  PRINT_CHORD(void)     ;|
  IS_CHORD_LOADED := 0  ;|
  CLEAR_ALL_MAPS(void)  ;|
  return ;;;;;;;;;;;;;;;;|
} ;----------------------+


;special keys ----+       
TAB UP::         ;|
space UP::       ;|
T UP::           ;|
;----------------;|
;TOP row release ;|
1 UP::           ;|
2 UP::           ;|
3 UP::           ;|
4 UP::           ;|
;----------------;|
;MID row release ;|
Q UP::           ;|
W UP::           ;|
E UP::           ;|
R UP::           ;|
;----------------;|
;BOT row release ;|
A UP::           ;|
S UP::           ;|
D UP::           ;|
F UP::           ;|
;----------------;|
{                ;|
DO_CHORD_UP()    ;|
return ;;;;;;;;;;;|
}                ;|
;-----------------+

;Special Keys
;---------------------------------------+
;Modifier/Alt key:                     ;|
space::                                ;|
{ ;Will apply modifier key to all rows ;|
  DEL_BITS := DEL_BITS | N_1_0000      ;|
  TOP_BITS := TOP_BITS | N_1_0000      ;|
  MID_BITS := MID_BITS | N_1_0000      ;|
  BOT_BITS := BOT_BITS | N_1_0000      ;|
  if(IS_CHORD_LOADED == 0){            ;|
    IS_CHORD_LOADED := DEL_CHORD       ;|
  }                                    ;|
return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;|
}                                      ;|
                                       ;|
;Special BACKSPACE and SPACE keys:     ;|
tab::                                  ;|
{ ;set extreem left of bitset          ;|
  DEL_BITS := DEL_BITS | N_0_1000      ;|
  IS_CHORD_LOADED := DEL_CHORD         ;|
return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;|
}                                      ;|
                                       ;|
t::                                    ;|
{ ;set extreme right of bitset         ;|
  DEL_BITS := DEL_BITS | N_0_0001      ;|
  IS_CHORD_LOADED := DEL_CHORD         ;|
return ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;|
}                                      ;|
;---------------------------------------+


;Top Row
;--------------------------------+
4::                             ;| 
{                               ;| 
TOP_BITS := TOP_BITS | N_0_0001 ;|
IS_CHORD_LOADED := TOP_CHORD    ;|
return ;;;;;;;;;;;;;;;;;;;;;;;;;;|
}                               ;| 
                                ;| 
3::                             ;| 
{                               ;| 
TOP_BITS := TOP_BITS | N_0_0010 ;|
IS_CHORD_LOADED := TOP_CHORD    ;|
return ;;;;;;;;;;;;;;;;;;;;;;;;;;|
}                               ;| 
                                ;| 
2::                             ;| 
{                               ;| 
TOP_BITS := TOP_BITS | N_0_0100 ;|
IS_CHORD_LOADED := TOP_CHORD    ;|
return ;;;;;;;;;;;;;;;;;;;;;;;;;;|
}                               ;| 
                                ;| 
1::                             ;| 
{                               ;| 
TOP_BITS := TOP_BITS | N_0_1000 ;|
IS_CHORD_LOADED := TOP_CHORD    ;|
return ;;;;;;;;;;;;;;;;;;;;;;;;;;|
}                               ;|
;--------------------------------+

;MID Row
;--------------------------------+
R::                             ;| 
{                               ;| 
MID_BITS := MID_BITS | N_0_0001 ;|
IS_CHORD_LOADED := MID_CHORD    ;|
return ;;;;;;;;;;;;;;;;;;;;;;;;;;|
}                               ;| 
                                ;| 
E::                             ;| 
{                               ;| 
MID_BITS := MID_BITS | N_0_0010 ;|
IS_CHORD_LOADED := MID_CHORD    ;|
return ;;;;;;;;;;;;;;;;;;;;;;;;;;|
}                               ;| 
                                ;| 
W::                             ;| 
{                               ;| 
MID_BITS := MID_BITS | N_0_0100 ;|
IS_CHORD_LOADED := MID_CHORD    ;|
return ;;;;;;;;;;;;;;;;;;;;;;;;;;|
}                               ;| 
                                ;| 
Q::                             ;| 
{                               ;| 
MID_BITS := MID_BITS | N_0_1000 ;|
IS_CHORD_LOADED := MID_CHORD    ;|
return ;;;;;;;;;;;;;;;;;;;;;;;;;;|
}                               ;|
;--------------------------------+

;BOT Row
;--------------------------------+
F::                             ;| 
{                               ;| 
BOT_BITS := BOT_BITS | N_0_0001 ;|
IS_CHORD_LOADED := BOT_CHORD    ;|
return ;;;;;;;;;;;;;;;;;;;;;;;;;;|
}                               ;| 
                                ;| 
D::                             ;| 
{                               ;| 
BOT_BITS := BOT_BITS | N_0_0010 ;|
IS_CHORD_LOADED := BOT_CHORD    ;|
return ;;;;;;;;;;;;;;;;;;;;;;;;;;|
}                               ;| 
                                ;| 
S::                             ;| 
{                               ;| 
BOT_BITS := BOT_BITS | N_0_0100 ;|
IS_CHORD_LOADED := BOT_CHORD    ;|
return ;;;;;;;;;;;;;;;;;;;;;;;;;;|
}                               ;| 
                                ;| 
A::                             ;| 
{                               ;| 
BOT_BITS := BOT_BITS | N_0_1000 ;|
IS_CHORD_LOADED := BOT_CHORD    ;|
return ;;;;;;;;;;;;;;;;;;;;;;;;;;|
}                               ;|
;--------------------------------+


z::
{
  ;clipboard = %TOP_BITS%
  ;clipboard = %DEL_BITS%
  ;clipboard = %MID_BITS%
  ;clipboard = %BOT_BITS%
  
  ; clipboard := BINARY_STRING_TO_INTEGER("10000")
  ; send ^v
  ; ;sleep 100
  ; 
  ; clipboard := BINARY_STRING_TO_INTEGER("01000")
  ; send ^v
  ; ;sleep 100
  ; 
  ; 
  ; clipboard := BINARY_STRING_TO_INTEGER("00100")
  ; send ^v
  ; ;sleep 100
  ; 
  ; 
  ; clipboard := BINARY_STRING_TO_INTEGER("00010")
  ; send ^v
  ; ;sleep 100
  ; 
  ; 
  ; clipboard := BINARY_STRING_TO_INTEGER("00001")
  ; send ^v
  ; ;sleep 100
  
  ;PRINT_A_MAP(TOP_MAP)
  
  ;loop,31
  ;{
  ;  clipboard := INTEGER_TO_BINARY_STRING(A_Index)
  ;  send ^v
  ;  send {enter}
  ;  sleep 10
  ;}
  
  PRINT_OUT_ALL_MAPS(void)
  
  
	return
}



















