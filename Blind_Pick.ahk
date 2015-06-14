#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include FindClick.ahk

Gui, Add, DropDownList, vChamp, 
Gui, Add, Button, vArm gChampSelected, Arm
Gui, Add, Button, vDisarm gCancelChamps, Disarm
Gui, Add, Button, x90 y40 vReload gLoadChamps, Reload
GuiControl, disable, Disarm
Gui, Show,  w260 h100, Blind Picker

Gosub LoadChamps

Loop
{
    if Armed
        Gosub ChampSelectedLoop
    Sleep, 2
}

return

LoadChamps:
{
    ArrayCount = 0
    ChampList = |
    Loop, Champ_Lowers\*.png
    {
        ArrayCount += 1
        Temp := A_LoopFileName
        SplitPath, Temp, , , , Temp
        ChampList .= Temp . "|"
        if a_index = 1
            ChampList .= "|"
    }
    GuiControl,,Champ, %ChampList%
    return
}

CancelChamps:
{
    Armed := false
    GuiControl, disable, Disarm
    GuiControl, enable, Arm
    return
}

ChampSelected:
{
    GuiControl, disable, Arm
    GuiControl, enable, Disarm
    Gui, Submit, NoHide
    Armed := true
    
    return
}

ChampSelectedLoop:
{
    Temp = Champ_Lowers\
    Temp = %Temp%%Champ%
    Temp .= `.png
    if(FindClick(Temp))
        GoSub CancelChamps
    return
}

GuiClose:
    ExitApp
