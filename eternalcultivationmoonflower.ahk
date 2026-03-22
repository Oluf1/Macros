#MaxThreadsPerHotkey 2
F1::
Toggle := !Toggle

Count := 0
Walktime := 0
Regen_Time := 17000 + 150
LastPickupTime := 0

Loop
{
    if (!Toggle)
    {
        Send, {W up}{S up}
        break

    FoundCount := 0

    Loop 5
    {
        PixelSearch, Px, Py, 1800, 1150, 2200, 1400, 0x716B9C, 5, Fast RGB
        if (ErrorLevel != 0)
            PixelSearch, Px, Py, 1800, 1150, 2200, 1400, 0x56579B, 5, Fast RGB

        if (ErrorLevel = 0)
            FoundCount++
        Sleep, 20
        IfWinNotActive, ahk_exe RobloxPlayerBeta.exe
            WinActivate, ahk_exe RobloxPlayerBeta.exe
    }

    if (FoundCount = 5)
    {
        Count++
        Send, e
        LastPickupTime := A_TickCount

        while (Result1 = 0 Or Result2 = 0)
        {
            PixelSearch, Px, Py, 1800, 1150, 2200, 1400, 0x716B9C, 5, Fast RGB
            found1 := (ErrorLevel = 0)

            PixelSearch, Px, Py, 1800, 1150, 2200, 1400, 0x56579B, 3, Fast RGB
            found2 := (ErrorLevel = 0)
            PixelSearch, Px, Py, 1800, 1150, 2200, 1400, 0x5A599A, 5, Fast RGB5
            found3:= (ErrorLevel = 0)
            Tooltip % "F1:" found1 " F2:" found2 " Count:" FoundCount
            if (!found1 && !found2 && !found3)
                FoundCount++

            if (FoundCount = 5)
                break
            if (A_TickCount - StartTime >= 18000)
                continue 2
            Sleep, 50
        }
        FoundCount := 0

        Tooltip harvested
        IfWinNotActive, ahk_exe RobloxPlayerBeta.exe
            WinActivate, ahk_exe RobloxPlayerBeta.exe
        Send, {e up}
        Sleep 100
        Loop
        {
            PixelSearch, Px, Py, 1915, 911, 1950, 950, 0x716B9C, 5, Fast RGB
            if (ErrorLevel != 0)
                PixelSearch, Px, Py, 1915, 911, 1950, 950, 0x56579B, 5, Fast RGB
            if (ErrorLevel != 0)
                PixelSearch, Px, Py, 1915, 911, 1950, 950, 0x5A599A, 5, Fast RGB
            if (ErrorLevel = 0)
                FoundCount ++
            else
                FoundCount := 0
            if (FoundCount = 5)
                break
            if (A_TickCount - StartTime >= 18000)
                continue 2
            Sleep, 50
        }
        Send, e
        FoundCount := 0
        Loop
        {
            PixelSearch, Px, Py, 1880, 904, 1950, 950, 0x716B9C, 9, Fast RGB
            if (ErrorLevel = 0)
                PixelSearch, Px, Py, 1800, 1100, 2200, 1400, 0x56579B, 9, Fast RGB
            if (ErrorLevel != 0)
                PixelSearch, Px, Py, 1915, 911, 1950, 950, 0x5A599A, 5, Fast RGB
            if (ErrorLevel != 0)
                FoundCount ++
            else
                FoundCount := 0
            if (FoundCount = 5)
                break
            if (A_TickCount - StartTime >= 18000)
                continue 2
            Sleep, 50
        }
        Tooltip
        Click
        IfWinNotActive, ahk_exe RobloxPlayerBeta.exe
            WinActivate, ahk_exe RobloxPlayerBeta.exe
        Send, m
        Sleep, 250
        Click, 2800, 1200
        Sleep, 150
        Click, 2800, 1700
        Sleep, 150

        Click, 2800, 890
        Sleep, 150
        IfWinNotActive, ahk_exe RobloxPlayerBeta.exe
            WinActivate, ahk_exe RobloxPlayerBeta.exe
        Send, m 
        Sleep, 500
    }

    Sleep, 50
}
return

Esc::ExitApp