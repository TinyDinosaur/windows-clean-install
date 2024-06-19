;#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Reload the script
^!r::Reload  ; Ctrl+Alt+R

;--------- DOS COMMAND HERE DOSCMDHERE -------------
*#t::
EnvGet, LocalAppData, LocalAppData
CurrentExplorerPath := LocalAppData
if explorerHwnd := WinActive("ahk_class CabinetWClass")
{
    for window in ComObjCreate("Shell.Application").Windows
    {
        if (window.hwnd = explorerHwnd)
            CurrentExplorerPath := window.Document.Folder.Self.Path
    }  
}

; Check if Shift is being held down
if GetKeyState("Shift", "P")
{
    ; MsgBox, 4,, Terminal Will Open in Admin Mode. Continue?
    Run *RunAs wt.exe --window "Terminal" -d `"%CurrentExplorerPath%`"
}
else
{
    Run, wt --window "Terminal" -d %CurrentExplorerPath% 
}


;-----------------------------------------
