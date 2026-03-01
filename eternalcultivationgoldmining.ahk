#MaxThreadsPerHotkey 2
F1::
Toggle := !Toggle
Loop
{
    if not Toggle
        break

    PixelSearch, Px, Py, 1100, 530, 1200, 590, 0xFFEF00, 50, Fast RGB
    if (ErrorLevel)
        PixelSearch, Px, Py, 1100, 530, 1200, 590, 0xB48B00, 50, Fast RGB

    if (ErrorLevel = 0)
    {
        StartTime := A_TickCount 
        
        Send, {e down}
        
        Loop
        {
            PixelSearch, Px, Py, 1100, 530, 1200, 590, 0xFFEF00, 50, Fast RGB
            if (ErrorLevel)
                PixelSearch, Px, Py, 1100, 530, 1200, 590, 0xB48B00, 50, Fast RGB
                
            if (ErrorLevel != 0)
                break
            Sleep, 10
        }
        Send, {e up}
        
        ElapsedTime := A_TickCount - StartTime
        
        Send, {e down}
        Sleep, 50
        Send, {e up}
        
        WaitTime := ElapsedTime + 500
        Sleep, %WaitTime%
        
        Send, m
        Sleep, 250
        
        Click, 720, 500
        Sleep, 150
        Click, 720, 630
        Sleep, 150
        Click, 720, 730
        Sleep, 150
        Click, 720, 890
        Sleep, 150
        Send, m
    }
    
    Sleep, 50 
}
return

Esc::ExitApp