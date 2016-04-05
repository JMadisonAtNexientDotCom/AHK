

;------------------------------------------------------------------------------+
;represents suspended state of script. Must wait for key combination to
;re-start the chords.
;------------------------------------------------------------------------------+
;##############################################################################|
#NoEnv  ; Performance & Compatibility.                             ############|
; #Warn ; Enable Warnings For Debugging.                           ############|
SendMode Input  ; Superior Speed and Reliability.                  ############|
SetWorkingDir %A_ScriptDir%  ; Ensures consistent start directory. ############|
;##############################################################################|
;------------------------------------------------------------------------------+


!tab::
{
	SoundBeep, 888, 150
	Run, %A_ScriptDir%\CHORD_SCRIPT.ahk
	exitApp
	return
}

;//KIND OF USELESS.
;  +z::
;  {
;  send ^z
;  return
;  }
;  
;  +x::
;  {
;  send ^x
;  return
;  }
;  
;  +c::
;  {
;  send ^c
;  return
;  }
;  
;  +v::
;  {
;  send ^v
;  return
;  }
;  
;  +r::
;  {
;  send ^r
;  return
;  }


