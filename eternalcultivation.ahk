#NoEnv
ListLines Off
Process, Priority, , High
SetBatchLines, -1
SetMouseDelay, -1 
SetDefaultMouseSpeed, 0
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen


X1 := 700, Y1 := 340, X2 := 1200, Y2 := 900
W := X2 - X1, H := Y2 - Y1
Edge := 50

; Farbeinstellungen
ColorBlue := 0x0087FF
ColorRed := 0xFF0000  
Tolerance := 18

ZoneOrder := [1, 2, 3, 4, 5, 6, 7, 8]
Toggle := 0

+::
Toggle := !Toggle
SetTimer, ColorLoop, % (Toggle ? 1 : "Off")
return

ColorLoop:
FoundBlue := false

Loop, 8 {
    Z := ZoneOrder[A_Index]
    
    
    if (Z = 1) 
        PixelSearch, FX, FY, X1, Y1, X1+W/3, Y1+Edge, %ColorBlue%, %Tolerance%, Fast RGB
    else if (Z = 2) 
        PixelSearch, FX, FY, X1+W/3, Y1, X1+2*W/3, Y1+Edge, %ColorBlue%, %Tolerance%, Fast RGB
    else if (Z = 3) 
        PixelSearch, FX, FY, X1+2*W/3, Y1, X2, Y1+Edge, %ColorBlue%, %Tolerance%, Fast RGB
    else if (Z = 4) 
        PixelSearch, FX, FY, X2-Edge, Y1+Edge, X2, Y2-Edge, %ColorBlue%, %Tolerance%, Fast RGB
    else if (Z = 5) 
        PixelSearch, FX, FY, X1+2*W/3, Y2-Edge, X2, Y2, %ColorBlue%, %Tolerance%, Fast RGB
    else if (Z = 6) 
        PixelSearch, FX, FY, X1+W/3, Y2-Edge, X1+2*W/3, Y2, %ColorBlue%, %Tolerance%, Fast RGB
    else if (Z = 7) 
        PixelSearch, FX, FY, X1, Y2-Edge, X1+W/3, Y2, %ColorBlue%, %Tolerance%, Fast RGB
    else if (Z = 8) 
        PixelSearch, FX, FY, X1, Y1+Edge, X1+Edge, Y2-Edge, %ColorBlue%, %Tolerance%, Fast RGB

    if (ErrorLevel = 0) {
        FoundBlue := true
        LastIdx := A_Index
        break
    }
}

if (FoundBlue) {
    
    PixelSearch, , , FX-15, FY-15, FX+15, FY+15, %ColorRed%, 25, Fast RGB
    
    if (ErrorLevel != 0) {
        
        MouseClick, left, %FX%, %FY%, 1, 0
        
        
        ClickedZone := ZoneOrder.RemoveAt(LastIdx)
        ZoneOrder.Push(ClickedZone)
    }
    
}
return