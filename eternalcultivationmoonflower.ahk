#MaxThreadsPerHotkey 2
F1::
Toggle := !Toggle
Count := 0
TotalWalkTime := 0

Loop
{
    if not Toggle
    {
        Send, {W up}{S up}
        break
    }
    PixelSearch, Px, Py, 811, 530, 1500, 1180, 0x56569B, 5, Fast RGB
    Result1 := ErrorLevel
    ;PixelSearch, Px, Py, 811, 530, 1300, 1100, 0x545699, 10, Fast RGB
    Result2 := ErrorLevel
    if (Result1 = 0 Or Result2 =0)
    {
        Count++
        Send e
        
        while (Result1 = 0 Or Result2 =0)
        {
            PixelSearch, Px, Py, 811, 530, 1500, 1180, 0x56569B, 5, Fast RGB
            Result1 := ErrorLevel
            ;PixelSearch, Px, Py, 811, 530, 1300, 1100, 0x545699, 10, Fast RGB
            Result2 := ErrorLevel
            
            Sleep, 10
        }
        Sleep 700
        if (Count < 3)
        {
           
            Send, {W down}
            Sleep, 200
            Loop {
                PixelSearch, Px, Py, 811, 530, 1500, 1180, 0x56569B, 5, Fast RGB
                Result1 := ErrorLevel
                ;PixelSearch, Px, Py, 811, 530, 1300, 1100, 0x545699, 10, Fast RGB
                Result2 := ErrorLevel
                if (Result1 = 0 Or Result2 =0) 
                    break
                Sleep, 10
            }
            
            Send, {W up}
            
        }
        else
        {
            
           
            Send, {o Down}
            Send, m
            Sleep, 250
            Send, {o Up}
            
            Click, 720, 500
            Click, 720, 500
            Click, 720, 500
            Click, 720, 500
            Sleep, 150
            Click, 720, 890
            Sleep, 150
            Send, m
            Sleep, 20
            Send, {i Down}
            Sleep, 1650
            Send, {i up}
            Send, {S down}
            Result1 := 1
            Result2 := 1
            while (Result1 = 1 Or Result2 =1)
            {
                PixelSearch, Px, Py, 811, 530, 1500, 1180, 0x56569B, 5, Fast RGB
                Result1 := ErrorLevel
                ;PixelSearch, Px, Py, 811, 530, 1300, 1100, 0x545699, 10, Fast RGB
                Result2 := ErrorLevel
                
                Sleep, 10
           }
            Send, {S up}
            
            Count := 0
        }
    }
    Sleep, 50 
}
return

RemoveToolTip:
    ToolTip 
return

Esc::ExitApp