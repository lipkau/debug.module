; run_code - awesomeScript.ahk
; author: Lipkau <oliver@lipkau.net>
; created: 2018 8 17

foo() {
    ; IVirtualDesktopManager interface
    ; https://docs.microsoft.com/en-us/windows/desktop/api/shobjidl_core/nn-shobjidl_core-ivirtualdesktopmanager
    IVirtualDesktopManager          := ComObjCreate("{AA509086-5CA9-4C25-8F95-589D3C07B48A}", "{A5CD92FF-29BE-454C-8D04-D82879FB3F1B}")
    IsWindowOnCurrentVirtualDesktop := NumGet(NumGet(IVirtualDesktopManager+0)+3*A_PtrSize)
    GetWindowDesktopId              := NumGet(NumGet(IVirtualDesktopManager+0)+4*A_PtrSize)
    MoveWindowToDesktop             := NumGet(NumGet(IVirtualDesktopManager+0)+5*A_PtrSize)

    /*
    IServiceProvider               := ComObjCreate("{C2F03A33-21F5-47FA-B4BB-156362A2F239}", "{6D5140C1-7436-11CE-8034-00AA006009FA}")
    IVirtualDesktopManagerInternal := ComObjQuery(IServiceProvider, "{C5E0CDCA-7B6E-41B2-9FC4-D93975CC467B}", "{F31574D6-B682-4CDC-BD56-1827860ABEC6}")
    GetCount                       := NumGet(NumGet(IVirtualDesktopManagerInternal+0)+3*A_PtrSize)
    MoveViewDesktop                := NumGet(NumGet(IVirtualDesktopManagerInternal+0)+4*A_PtrSize)
    GetCurrentDesktop              := NumGet(NumGet(IVirtualDesktopManagerInternal+0)+5*A_PtrSize)
    GetDesktops                    := NumGet(NumGet(IVirtualDesktopManagerInternal+0)+6*A_PtrSize)
    GetAdjacentDesktop             := NumGet(NumGet(IVirtualDesktopManagerInternal+0)+7*A_PtrSize)
    SwitchDesktop                  := NumGet(NumGet(IVirtualDesktopManagerInternal+0)+8*A_PtrSize)
    CreateDesktopW                 := NumGet(NumGet(IVirtualDesktopManagerInternal+0)+9*A_PtrSize)
    RemoveDesktop                  := NumGet(NumGet(IVirtualDesktopManagerInternal+0)+10*A_PtrSize)
    */

    ; IVirtualDesktopManager::GetWindowDesktopId method
    ; https://docs.microsoft.com/en-us/windows/desktop/api/shobjidl_core/nf-shobjidl_core-ivirtualdesktopmanager-getwindowdesktopid
    IServiceProvider               := ComObjCreate("{C2F03A33-21F5-47FA-B4BB-156362A2F239}", "{6D5140C1-7436-11CE-8034-00AA006009FA}")
    IVirtualDesktopManagerInternal := ComObjQuery(IServiceProvider, "{C5E0CDCA-7B6E-41B2-9FC4-D93975CC467B}", "{F31574D6-B682-4CDC-BD56-1827860ABEC6}")
    GUID := NumGet(NumGet(IVirtualDesktopManagerInternal+0)+6*A_PtrSize)
    VarSetCapacity(strGUID, (38 + 1) * 2)
    DllCall("Ole32.dll\StringFromGUID2", "UPtr", &GUID, "UPtr", &strGUID, "Int", 38 + 1)
    MsgBox % "................`n" . StrGet(&strGUID, "UTF-16")
    TopLevelWindow := WinExist("A")

    null := DllCall(IsWindowOnCurrentVirtualDesktop, "UPtr", IsWindowOnCurrentVirtualDesktop, "Ptr", TopLevelWindow, "Int*", BOOL)
    MsgBox % "Window is " . (BOOL ? "" : "not ") . "on this desktop"

    null := DllCall(IsWindowOnCurrentVirtualDesktop, "UPtr", IsWindowOnCurrentVirtualDesktop, "Ptr", TopLevelWindow, "Int*", BOOL)

    VarSetCapacity(GUID, 16)
    R := DllCall(GetWindowDesktopId, "UPtr", IVirtualDesktopManager, "Ptr", TopLevelWindow, "UPtr", &GUID, "UInt")
    if ( !R )   ; OK
    {
        VarSetCapacity(strGUID, (38 + 1) * 2)
        DllCall("Ole32.dll\StringFromGUID2", "UPtr", &GUID, "UPtr", &strGUID, "Int", 38 + 1)
        MsgBox % "Identifier for the virtual desktop hosting the topLevelWindow`n" . StrGet(&strGUID, "UTF-16")
    }


    IdLength := 32
    SessionId := getSessionId()
    if (SessionId) {
        RegRead, CurrentDesktopId, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\%SessionId%\VirtualDesktops, CurrentVirtualDesktop
        if (CurrentDesktopId) {
            IdLength := StrLen(CurrentDesktopId)
        }
    }

    RegRead, DesktopList, HKEY_CURRENT_USER, SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, VirtualDesktopIDs
    if (DesktopList) {
        DesktopListLength := StrLen(DesktopList)
        ; Figure out how many virtual desktops there are
        DesktopCount := DesktopListLength / IdLength
    }
    else {
        DesktopCount := 1
    }

    ; Parse the REG_DATA string that stores the array of UUID's for virtual desktops in the registry.
    i := 0
    while (CurrentDesktopId and i < DesktopCount) {
        StartPos := (i * IdLength) + 1
        DesktopIter := SubStr(DesktopList, StartPos, IdLength)
        OutputDebug, The iterator is pointing at %DesktopIter% and count is %i%.
        msgbox % "Desktop: " DesktopIter
        ; Break out if we find a match in the list. If we didn't find anything, keep the
        ; old guess and pray we're still correct :-D.
        i++
    }
}

getSessionId()
{
 ProcessId := DllCall("GetCurrentProcessId", "UInt")
 if ErrorLevel {
 OutputDebug, Error getting current process id: %ErrorLevel%
 return
 }
 OutputDebug, Current Process Id: %ProcessId%
 DllCall("ProcessIdToSessionId", "UInt", ProcessId, "UInt*", SessionId)
 if ErrorLevel {
 OutputDebug, Error getting session id: %ErrorLevel%
 return
 }
 OutputDebug, Current Session Id: %SessionId%
 return SessionId
}
