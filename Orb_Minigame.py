import mss
import numpy as np
import time
import math
import keyboard
import pydirectinput
import threading 


pydirectinput.PAUSE = 0
centre_x = 950
centre_y = 625
radius = 325
n = 180
stop_event = threading.Event()

Points = []
xs, ys = [], []

for i in range(n):
    theta = (n - i) * (2 * math.pi / n)
    x = round(centre_x + radius * math.cos(theta))
    y = round(centre_y + radius * math.sin(theta))
    Points.append((x, y))
    xs.append(x)
    ys.append(y)
    
    

left = min(xs)
top = min(ys)
width = max(xs) - left + 1
height = max(ys) - top + 1

def color_match(rgb, target, tol):
    return all(abs(int(c) - t) <= tol for c, t in zip(rgb, target))


def stop_script():
    print("Stopping...")
    stop_event.set()
    
def scan_loop():
    stop_event.clear()
    
    for x,y in Points: #This loop is purely made so that the user can align themselves
        if stop_event.is_set(): return 
        pydirectinput.moveTo(x,y)
        time.sleep(0.001)
        
        
        
    
    with mss.mss() as sct:
        
        while not stop_event.is_set():
            red = [False] * len(Points)
            blue = []
            img = sct.grab({"top": top, "left": left, "width": width, "height": height})
            arr = np.array(img)
            for i, (x, y) in enumerate(Points):
                px = x - left
                py = y - top
                b,g,r = map(int, arr[py, px][:3])

                if abs(r-255) <= 10 and abs(g-0) <= 10 and abs(b-0) <= 10:
                    red[i] = True
                elif abs(r-0) <= 20 and abs(g-135) <= 20 and abs(b-255) <= 20:
                    blue.append((i,x,y))
            for i, x, y in blue:
                for offset in range(-7, 9):
                    if red[(i + offset) % len(Points)]:
                        break
                else:
                    pydirectinput.click(x, y)
                    break
                    
                
                
                    
                    

            
keyboard.add_hotkey("f1", lambda: threading.Thread(target=scan_loop, daemon=True).start())
keyboard.add_hotkey("esc", stop_script)
print("ready")
keyboard.wait()