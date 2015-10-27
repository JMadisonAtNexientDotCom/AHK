
;globals
global IS_MOUSE_DOWN := false
global MOVE_SMALL_ON := false
global MOVE_LARGE_ON := false
global MOVE_LARGE_2X_ON := false
global MOVE_LARGE_4X_ON := false

;;;;;;;;;;;;;;;;;;;;MODIFIERS;;;;;;;;;;;;;;;;;;;;;;

setAllMovementModifiersFalse(void)
{
global MOVE_LARGE_ON
global MOVE_SMALL_ON
global MOVE_LARGE_2X_ON
global MOVE_LARGE_4X_ON
MOVE_LARGE_ON    := false
MOVE_SMALL_ON    := false
MOVE_LARGE_2X_ON := false
MOVE_LARGE_4X_ON := false
}

;;SLOW-SLOW-SLOW-SLOW-SLOW-SLOW-SLOW-SLOW-SLOW-
A UP::
{
global MOVE_SMALL_ON
MOVE_SMALL_ON :=false  ;only active when DOWN.
return
}

A::
{
global MOVE_SMALL_ON
setAllMovementModifiersFalse(void)
MOVE_SMALL_ON :=true  ;activates when "1" key held DOWN
return
}
;;SLOW-SLOW-SLOW-SLOW-SLOW-SLOW-SLOW-SLOW-SLOW-

;;FAST-FAST-FAST-FAST-FAST-FAST-FAST-FAST-FAST-
S UP::
{
global MOVE_LARGE_ON
MOVE_LARGE_ON :=false  ;only active when DOWN.
return
}

S::
{
global MOVE_LARGE_ON
setAllMovementModifiersFalse(void)
MOVE_LARGE_ON :=true  ;activates when "1" key held DOWN
return
}
;;FAST-FAST-FAST-FAST-FAST-FAST-FAST-FAST-FAST-

;;2X-2X-2X-2X-2X-2X-2X-2X-2X-2X-2X-2X-2X-2X-2X-
D UP::
{
global MOVE_LARGE_2X_ON
MOVE_LARGE_2X_ON :=false  ;only active when DOWN.
return
}

D::
{
global MOVE_LARGE_2X_ON
setAllMovementModifiersFalse(void)
MOVE_LARGE_2X_ON :=true  ;activates when "1" key held DOWN
return
}
;;2X-2X-2X-2X-2X-2X-2X-2X-2X-2X-2X-2X-2X-2X-2X-

;;4X-4X-4X-4X-4X-4X-4X-4X-4X-4X-4X-4X-4X-4X-4X-
F UP::
{
global MOVE_LARGE_4X_ON
MOVE_LARGE_4X_ON :=false  ;only active when DOWN.
return
}

F::
{
global MOVE_LARGE_4X_ON
setAllMovementModifiersFalse(void)
MOVE_LARGE_4X_ON :=true  ;activates when "1" key held DOWN
return
}
;;4X-4X-4X-4X-4X-4X-4X-4X-4X-4X-4X-4X-4X-4X-4X-



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;EXIT;;;;;;;;;;;;;;;;;;;;;;;;;;;
!M::
{
backToBaseHotkeys(void)
return
}

M::
{
backToBaseHotkeys(void)
return
}
;;;;;;;;;;;;;;;;;;;;EXIT;;;;;;;;;;;;;;;;;;;;;;;;;;;

J::
{
moveAmt := getMoveAmount(-1)
onMouseMoveHor(moveAmt) ;;move to LEFT
return
}

L::
{
moveAmt := getMoveAmount(1)
onMouseMoveHor(moveAmt) ;;move to RIGHT
return
}

I::
{
moveAmt := getMoveAmount(-1)
onMouseMoveVer(moveAmt) ;;move UPSCREEN
return
}

K::
{
moveAmt := getMoveAmount(1)
onMouseMoveVer(moveAmt) ;;move DOWNSCREEN
return
}

`;::
{
MouseToCaret(void)
return
}

MouseToCaret(void)
{
mx = %A_CaretX%
my = %A_CaretY%
MouseMoveWrapper(mx,my)
return
}

getMoveAmount(signedOne)
{
	global MOVE_LARGE_ON
	global MOVE_SMALL_ON

	if(MOVE_SMALL_ON)
	{
		moveAmt := signedOne
	}else
	if(MOVE_LARGE_ON)
	{
		moveAmt := signedOne * 100
	}else
	if(MOVE_LARGE_2X_ON)
	{
	  moveAmt := signedOne * 200
	}else
	if(MOVE_LARGE_4X_ON)
	{
	  moveAmt := signedOne * 400
	}
	else
	{
	;no modifiers, multiply by 10 for base size:
		moveAmt := signedOne * 10
	}

	return moveAmt
}

MouseMoveWrapper(mx,my)
{
if(MOVE_SMALL_ON or MOVE_LARGE_ON or MOVE_LARGE_2X_ON or MOVE_LARGE_4X_ON)
{
MouseMove, mx, my, 0
}
else
{
MouseMove, mx, my, 3
}

return
}

onMouseMoveHor(dirAmt)
{
mx = 0
my = 0
MouseGetPos, mx, my
mx := mx + dirAmt
MouseMoveWrapper(mx,my)
return
}

onMouseMoveVer(dirAmt)
{
mx = 0
my = 0
MouseGetPos, mx, my
my := my + dirAmt
MouseMoveWrapper(mx,my)
return
}

ESCAPE::
{
backToBaseHotkeys(void)
}

!SPACE::
{
send {SPACE}
return
}

; ">" arrow
.::
{
send {SPACE}
return
}

; "<" arrow
,::
{
send {BACKSPACE}
return
}


SPACE::
{
Send {LButton down}
return
}

SPACE UP::
{
Send {LButton up}
return
}

;			SPACE::
;			{
;			;Click
;
;			global IS_MOUSE_DOWN
;
;			if(IS_MOUSE_DOWN)
;			{
;				Send {LButton up}
;				IS_MOUSE_DOWN := false
;			}else{
;				Send {LButton down}
;				IS_MOUSE_DOWN := true
;			}
;
;			return
;			}

backToBaseHotkeys(void)
{
Run, %A_ScriptDir%\..\hotkeys.ahk
ExitApp
}



