
; SOURCE: http://www.autohotkey.com/board/topic/55150-class-structfunc-sizeof-updated-010412-ahkv2/
; #include <_Struct>
#include %A_ScriptDir%\_Struct.ahk
Struct(Structure,pointer:=0,init:=0){
return new _Struct(Structure,pointer,init)
}