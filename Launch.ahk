#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include %A_ScriptDir%
#Include FindClick.ahk

Gosub LoadAccounts

Gui, Add, DropDownList, vUserNameID, %AccountList%
Gui, Add, Checkbox, vFullAuto Checked, Auto Launch Client
Gui, Add, Button, gLaunchLoL, Launch
Gui, Show,  w260 h100, LoL Launcher
return

LoadAccounts:
{
    ArrayCount = 0
    Loop, Read, accounts.txt
    {
        ArrayCount += 1
        Temp := A_LoopReadLine
        StringSplit, TempArray, Temp, %A_Tab%
        SummonerName%ArrayCount% := TempArray1
        Accounts%ArrayCount% := TempArray2
        AccountPass%ArrayCount% := TempArray3
    }
    Loop,%ArrayCount%
    {
        AccountList .= SummonerName%A_Index% . "|"
        If a_index = 1
            AccountList .= "|"
    }
    return
}

LaunchLoL:
{
    GuiControl, +AltSubmit, UserNameID
    Gui, Submit, NoHide

    IfWinExist, LoL Patcher
        Goto GuiClose
    IfWinExist, PVP.net Client
        Goto GuiClose
        
    Run, "C:\Riot Games\League of Legends\lol.launcher.exe"
    WinWait, LoL Patcher, , 10
    If FullAuto = 1
    {
        Gui, Hide
        If FindClick("Trigger_Images\Launch_image","w6000,200")
        {
            WinWait, PVP.net Client, , 10
            Gosub ClientLauncher
        }
    } Else {
        WinWait, PVP.net Client
        Gosub ClientLauncher
    }
    Goto GuiClose
    return
}

ClientLauncher:
{
    WinActivate, PVP.net Client
    If (FindClick("Trigger_Images\Login_image","x-105 y-105 w6000,200"))
    {
        Send, ^a
        Temp := Accounts%UserNameID%
        Send, %Temp%
        Send, {Tab}
        Temp := AccountPass%UserNameID%
        Send, %Temp%
        Send, {ENTER}
    }
    return
}

GuiClose:
    ExitApp
