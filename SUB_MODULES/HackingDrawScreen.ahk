
; about these structs: http://www.autohotkey.com/board/topic/55150-class-structfunc-sizeof-updated-010412-ahkv2/
#include %A_ScriptDir%\_Struct.ahk
#include %A_ScriptDir%\Struct.ahk

;////mouse movement = draw/erase
;////F1 = toggle draw/erase
;////F2 = erase all
;////F12 = exit



;http://www.autohotkey.com/board/topic/87597-help-me-use-global-variables/
SetDefaults(void)
{
	global
	CoordMode, Mouse, Screen, globalFillColor


	Process, Exist
	pid_this := ErrorLevel

	hdc_screen := DllCall( "GetDC", "uint", 0 )

	hdc_buffer := DllCall( "CreateCompatibleDC", "uint", hdc_screen )
	hbm_buffer := DllCall( "CreateCompatibleBitmap", "uint", hdc_screen, "int", A_ScreenWidth, "int", A_ScreenHeight )
	DllCall( "SelectObject", "uint", hdc_buffer, "uint", hbm_buffer )

	DllCall( "BitBlt", "uint", hdc_buffer, "int", 0, "int", 0, "int", A_ScreenWidth, "int", A_ScreenHeight, "uint", hdc_screen, "int", 0, "int", 0, "uint", 0x00CC0020 )

	Gui, +AlwaysOnTop -Caption
	Gui, Show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight%

	WinGet, hw_canvas, ID, ahk_class AutoHotkeyGUI ahk_pid %pid_this%

	hdc_canvas := DllCall( "GetDC", "uint", hw_canvas )

	DllCall( "BitBlt", "uint", hdc_canvas, "int", 0, "int", 0, "int", A_ScreenWidth, "int", A_ScreenHeight, "uint", hdc_buffer, "int", 0, "int", 0, "uint", 0x00CC0020 )

	mode_draw := true

	WM_MOUSEMOVE = 0x0200
	OnMessage( WM_MOUSEMOVE, "HandleMessage" )
	
	
	;JMIM HACK: global variables to store current part of screen in focus:
	QX00 := 0
	QX01 := 0
	QY00 := 0
	QY01 := 0
	globalFillColor := 0xFF00FF
	resetSubDivisionModel()
	drawCenterPointer(void)
	
	return
}
setDefaults(void)

ON_UP()
{
subDivideModelY(-1)
floodFillNixedAreas(void)
drawCenterPointer(void)
return
}

ON_DOWN()
{
subDivideModelY(1)
floodFillNixedAreas(void)
drawCenterPointer(void)
return
}

ON_LEFT()
{
subDivideModelX(-1)
floodFillNixedAreas(void)
drawCenterPointer(void)
return
}

ON_RIGHT()
{
subDivideModelX(1)
floodFillNixedAreas(void)
drawCenterPointer(void)
return
}

UP::
{
ON_UP()
return
}

DOWN::
{
ON_DOWN()
return
}

LEFT::
{
ON_LEFT()
return
}

RIGHT::
{
ON_RIGHT()
return
}

W::
{
ON_UP()
return
}

S::
{
ON_DOWN()
return
}

A::
{
ON_LEFT()
return
}

D::
{
ON_RIGHT()
return
}

 ; ----------------IJKL
I::
{
ON_UP()
return
}

K::
{
ON_DOWN()
return
}

J::
{
ON_LEFT()
return
}

L::
{
ON_RIGHT()
return
}

M::
{
ON_EXIT()
return
}

SPACE::
{
EXIT_WITH_STANDARD_CLICK()
return
}

!M::
{
ON_EXIT()
return
}

!SPACE::
{
EXIT_WITH_STANDARD_CLICK()
return
}



;//Draws a thin cross hair into center of viewable region:
drawCenterPointer(void)
{
  ;Global vars for active area of screen:
  global QX00
	global QX01
	global QY00
	global QY01
	
	
	;find centerpoint of active area:
	CENX := (QX00 + QX01) / 2
	CENX := floor(CENX)
	
  CENY := (QY00 + QY01) / 2
	CENY := floor(CENY)
	
	;use centerpoint to project crosshairs into the box:
	fillRectangularArea(CENX,CENX+1,  QY00,  QY01) ;vertical crosshair.
	fillRectangularArea(QX00,  QX01,  CENY,CENY+1) ;horizontal crosshair.
	
	mouseMove, CENX,CENY,2
	
}

;//Creates rectangle struct using the 4 corners of rectangle.
;//Use Example:
;//            RC := makeRect(10,10,30,30)
;//            Makes a rectangle at [10,10] that is 20x20
makeRect(inX0, inX1, inY0, inY1)
{
 _RECT:="left,top,right,bottom"
  RC:=Struct(_RECT) ;create structure
  RC.left   := inX0
	RC.top    := inY0
	RC.right  := inX1
	RC.bottom := inY1
  return RC
}

;//Wraps DLL calls into something nice.
fillRectangularArea(inX0, inX1, inY0, inY1)
{

	global	mode_draw, hdc_canvas, hdc_buffer
	nixColor = 0x0000FF

	RC := makeRect(inX0, inX1, inY0, inY1)
	
	;//BUGFIX: When calling func that takes ByRef, do not use &arg even though
	;//The "&" seems logical to do.
	fillRectAreaUsingRect(RC)

}  ;//fillRectangularArea

fillRectAreaUsingRect(ByRef RC)
{

  global	mode_draw, hdc_canvas, hdc_buffer, globalFillColor
	nixColor = 0x0000FF
	
	
	;colorRef := 0xFF0000 ;<--This color ref is working.. THE RGB macro might not exists.
	colorRef := globalFillColor

	;colorRef = 0xFF0000
	brush := DllCall("CreateSolidBrush", "ptr", colorRef, "Cdecl ptr")            ;use PTR rather than COLORRED.
		
	;My guess of what to do:
	DllCall( "FillRect", "uint"  , hdc_canvas, "ptr" , RC[], "ptr", brush, "Cdecl int") ;<-is being triggered. But with bad data i believe. brush 
	
	;make COLORREF
	;  https://msdn.microsoft.com/en-us/library/windows/desktop/dd162937%28v=vs.85%29.aspx
	;  //Function is called "RGB" and it returns a COLORREF reference.
	;  COLORREF RGB(
  ;    BYTE byRed,
  ;    BYTE byGreen,
  ;    BYTE byBlue
  ;  );
	
	;https://msdn.microsoft.com/en-us/library/windows/desktop/dd162719%28v=vs.85%29.aspx
	;  int FillRect(
  ;    _In_       HDC    hDC,
  ;    _In_ const RECT   *lprc,
  ;    _In_       HBRUSH hbr
  ;  );
  ;C++ CALL: FillRect(hdc, &rect, (HBRUSH) (COLOR_WINDOW+1));
	
	;https://msdn.microsoft.com/en-us/library/windows/desktop/dd183518%28v=vs.85%29.aspx
	;  HBRUSH CreateSolidBrush(
	;  	_In_ COLORREF crColor
	;  );
	
	
	
	;;bug fixing:
	;;1: brush is passed by VALUE. so no "&" before it! Line is now green instead of white.
	;;2: RC (my rectangle struct) id DEFINITELY passed by reference. Requires. "&" before it in DLL call.
	;;3: CreateSolid brush. Seems to be working. But DO NOT pass reference to it. No "&" before colorRef
	;;4: RC is actually RC[[] in the DLL call! GOT IT!
	
	;Think i need to create a brush:
	;https://msdn.microsoft.com/en-us/library/windows/desktop/dd183518%28v=vs.85%29.aspx
	;colorRef := DllCall("RGB", "uint", 0xFF, "uint", 0x00, "uint", 0x00, "Cdecl ptr") ;use uint rather than BYTE

	;           0xBBGGRR
	
}



;//Flood fills the entire screen wherever the current selection area does
;//NOT apply.
floodFillNixedAreas(void)
{

  ; non-nixed screen region:
  global QX00
	global QX01
	global QY00
	global QY01
	global globalFillColor
	
	

	
  ;corners of screen
	CX00 = 0
	CY00 = 0
	CX01 = %A_ScreenWidth%
	CY01 = %A_ScreenHeight%
	
	;//debug: Fill central rect to get correct relationships.
	;//globalFillColor = 0xFF00FF
	;//fillRectangularArea(QX00,QX01,QY00,QY01)
	
	;All 4 quads that touch the corners of the screen and the
	;Corners of the nix-inclusion-rect:
	globalFillColor = 0x111111
  fillRectangularArea(CX00,QX00,CY00,QY00) ;QUAD [--]
	globalFillColor = 0x111111
	fillRectangularArea(QX01,CX01,QY01,CY01) ;QUAD [++]
	globalFillColor = 0x111111
  fillRectangularArea(CX00,QX00,QY01,CY01) ;QUAD [-+]
	globalFillColor = 0x111111
	fillRectangularArea(QX01,CX01,CY00,QY00) ;QUAD [+-]
	
	;Projections from each of the 4 edges of the nix-inclustion-rect:
	globalFillColor = 0x0000FF
	fillRectangularArea(QX00,QX01,QY00,CY00) ;PROJECT: TOP
  fillRectangularArea(QX00,QX01,QY01,CY01) ;PROJECT: BOT
	fillRectangularArea(QX00,CX00,QY00,QY01) ;PROJECT: LEFT
	fillRectangularArea(QX01,CX01,QY00,QY01) ;PROJECT: LEFT
	
	
	

	return
	
}      ;//FUNC:floodFillNixedAreas:END

;Guessing I cannot nest loops?
drawHorizontalLineAt_Y(fill_y)
{
  global	mode_draw, hdc_canvas, hdc_buffer
	nixColor = 0xFF0000


    fill_x := -1 ;//first used value == 0.
		Loop, %A_ScreenWidth%
		{
			fill_x := fill_x + 1
			
			; //isNixed := isCoordNixedArea(fill_x, fill_y)
			
			if(true)
			{
				DllCall( "SetPixel", "uint", hdc_canvas, "int", fill_x, "int", fill_y, "uint", nixColor )
			}
			
		}
}




resetSubDivisionModel()
{
  ;Globals must always be declared in the scope they are used:
	global QX00
	global QX01
	global QY00
	global QY01
	
	;//assign with "=",not ":="
  QX00 = 0
	QX01 = %A_ScreenWidth%  
	
	;//assign with "=",not ":="
	QY00 = 0
	QY01 = %A_ScreenHeight%  
	
	;//TEST INPUT FOR QUADS
	;QX00 = 0;
	;QX01 = 800;
	;QY00 = 0;
	;QY01 = 800;
	
	return
}  ;//FUNC::END

;//zero ignores.
;//-1 keeps left.
;// 1 keeps right.
subDivideModelX( sideEnum )
{
  ;If you want to use globals, must declare them in this scope!
	global QX00
	global QX01
	global QY00
	global QY01


	if(sideEnum == 0)
	{
		;//do nothing.
		return
	}
	
	CEN := (QX00 + QX01) / 2
	CEN := floor(CEN)
	
	if(sideEnum == -1)
	{ ;//keep LEFT, so draw right to center.
	  
	  QX01 = %CEN%
	}else
	if(sideEnum == 1)
	{ ;//keep RIGHT, so draw left to center.
	  
		QX00 = %CEN%
	}
	
	
	
	return
}   ;//FUNC::END

;//zero ignores.
;//-1 keeps TOP of screen.
;// 1 keeps BOTTOM of screen.
subDivideModelY( sideEnum )
{
  ;If you want to use globals, must declare them in this scope!
	global QX00
	global QX01
	global QY00
	global QY01

	if(sideEnum == 0)
	{
		;//do nothing.
		return
	}
	
	CEN := (QY00 + QY01) / 2
	CEN := floor(CEN)
	
	if(sideEnum == -1)
	{ ;//keep TOP, so draw bottom to center.
	  QY01 = %CEN%
	}else
	if(sideEnum == 1)
	{ ;//keep BOTTOM, so draw top to center.
		QY00 = %CEN%
	}
	
	;QY00 = 30
	;QY01 = 100
	
	return
}  ;//FUNC::END

HandleMessage( p_w, p_l )
{
	global	mode_draw, hdc_canvas, hdc_buffer
	

	x := p_l & 0xFFFF
	y := p_l >> 16

	if ( mode_draw )
		color = 0xFF

	else
		color := DllCall( "GetPixel", "uint", hdc_buffer, "int", x, "int", y )
	
	;//pixMaxIndex_X := (A_ScreenWidth-1)
	;//pixMaxIndex_Y := (A_ScreenHeight-1)
	

	
	; //DllCall( "SetPixel", "uint", hdc_canvas, "int", x, "int", y, "uint", color )
	
	;floodFillNixedAreas(void)
	
}

F1::
	mode_draw := !mode_draw
return

F2::
	DllCall( "BitBlt", "uint", hdc_canvas, "int", 0, "int", 0, "int", A_ScreenWidth, "int", A_ScreenHeight, "uint", hdc_buffer, "int", 0, "int", 0, "uint", 0x00CC0020 )
return

;Exit this script, and go
;back to our MAIN auto hotkey script.
F12::
{
ON_EXIT()
}

EXIT_WITH_STANDARD_CLICK()
{
Run, %A_ScriptDir%\STANDARD_CLICK_THEN_OPEN_hotkeys.ahk
ExitApp
}

ON_EXIT()
{
Run, %A_ScriptDir%\..\hotkeys.ahk
ExitApp
}







