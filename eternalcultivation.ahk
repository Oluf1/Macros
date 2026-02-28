#NoEnv
ListLines Off
Process, Priority, , High
SetBatchLines, -1
SetMouseDelay, -1 
SetDefaultMouseSpeed, 0
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

; --- Koordinaten Setup (Deine neuen Eckpunkte) ---
X1 := 700, Y1 := 340, X2 := 1200, Y2 := 900
W := X2 - X1, H := Y2 - Y1
Edge := 50

; Farbeinstellungen
ColorBlue := 0x0087FF
ColorRed := 0xFF0000  ; Hier ggf. deinen Rot-Ton anpassen
Tolerance := 18

ZoneOrder := [1, 2, 3, 4, 5, 6, 7, 8]
Toggle := 0

+::
Toggle := !Toggle
SoundBeep, % (Toggle ? 750 : 500), 100
SetTimer, ColorLoop, % (Toggle ? 1 : "Off")
return

ColorLoop:
FoundBlue := false

Loop, 8 {
    Z := ZoneOrder[A_Index]
    
    ; Suche Blau in den 8 Zonen
    if (Z = 1) ; Oben-Links
        PixelSearch, FX, FY, X1, Y1, X1+W/3, Y1+Edge, %ColorBlue%, %Tolerance%, Fast RGB
    else if (Z = 2) ; Oben-Mitte
        PixelSearch, FX, FY, X1+W/3, Y1, X1+2*W/3, Y1+Edge, %ColorBlue%, %Tolerance%, Fast RGB
    else if (Z = 3) ; Oben-Rechts
        PixelSearch, FX, FY, X1+2*W/3, Y1, X2, Y1+Edge, %ColorBlue%, %Tolerance%, Fast RGB
    else if (Z = 4) ; Rechts-Mitte
        PixelSearch, FX, FY, X2-Edge, Y1+Edge, X2, Y2-Edge, %ColorBlue%, %Tolerance%, Fast RGB
    else if (Z = 5) ; Unten-Rechts
        PixelSearch, FX, FY, X1+2*W/3, Y2-Edge, X2, Y2, %ColorBlue%, %Tolerance%, Fast RGB
    else if (Z = 6) ; Unten-Mitte
        PixelSearch, FX, FY, X1+W/3, Y2-Edge, X1+2*W/3, Y2, %ColorBlue%, %Tolerance%, Fast RGB
    else if (Z = 7) ; Unten-Links
        PixelSearch, FX, FY, X1, Y2-Edge, X1+W/3, Y2, %ColorBlue%, %Tolerance%, Fast RGB
    else if (Z = 8) ; Links-Mitte
        PixelSearch, FX, FY, X1, Y1+Edge, X1+Edge, Y2-Edge, %ColorBlue%, %Tolerance%, Fast RGB

    if (ErrorLevel = 0) {
        FoundBlue := true
        LastIdx := A_Index
        break
    }
}

if (FoundBlue) {
    ; --- ANTI-ROT CHECK (20x20 Umkreis) ---
    ; Wir suchen in einem Quadrat von FX-20 bis FX+20
    PixelSearch, , , FX-10, FY-10, FX+10, FY+10, %ColorRed%, 25, Fast RGB
    
    if (ErrorLevel != 0) {
        ; ErrorLevel != 0 bedeutet: KEIN Rot gefunden -> Klick erlaubt
        MouseClick, left, %FX%, %FY%, 1, 0
        
        ; Rotation: Nur bei Klick rotieren, um die Zone nicht zu verlieren
        ClickedZone := ZoneOrder.RemoveAt(LastIdx)
        ZoneOrder.Push(ClickedZone)
    }
    ; Wenn Rot gefunden wurde (ErrorLevel = 0), passiert einfach nichts.
}
return