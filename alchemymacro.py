
from imagematching import match_image
try:
    import mss
    import numpy as np
    import ctypes
    import keyboard
    import cv2
    import pytesseract
except ImportError:
    print("please run this in cmd \n py -m pip install -r requirenments.txt")

def make_recepies(Name:str,priority:int,Herbs:list[str])-> dict:
    return {
        "Name":Name,
        "priority":priority,
        "Herbs":Herbs
    }
recepies = [
    make_recepies("Awakening Qi Pill",0,["Ginseng","Spirit Grass","Ginsneg","Spirit Grass"]),
    make_recepies("Moonlight Qi Pill",1,["Moonlight Flower","Moonlight Flower","Moonlight Flower","Moonlight Flower"]),
    make_recepies("Heavenly Pill",2,["Moonlight Flower","Moonlight Flower","Lotus","Lotus"]),
    make_recepies("Dragon Pill",3,["Ginseng","Spirit Grass","Lotus","Blood Flower"]),
    make_recepies("Divine Ascension Pill",4,["Ginseng","Ginseng","Moonlight Flower","Lotus"]),
    make_recepies("Endless Flow Pill",5,["Moonlight Flower","Spirit Grass","Lotus","Blood Flower"]),
    make_recepies("Celestial Pill",6,["Heavenly Orchid","Heavenly Orchid","Heavenly Orchid","Heavenly Orchid"])
]   


class Herb:
    def __init__(self,name:str,amount:int,age:int,recepies:list):
        self.name = name
        self.recepies = [str]
        for recipie in recepies:
            if self.name in recipie["Herbs"]:
                print(recipie)
        self.amount = amount
        self.age = age

Herb("Moonlight Flower",2,100,recepies)

user32 = ctypes.windll.user32
ctypes.windll.shcore.SetProcessDpiAwareness(True)
screensize = user32.GetSystemMetrics(0), user32.GetSystemMetrics(1)
possible_x= [385,429,325]
possible_y= [606,412,572]
width = 148
height = 147
distance = 10

def findpositions():
    images = []
    with mss.mss() as sct:
        for x in possible_x:
            for y in possible_y:
                img = sct.grab({"top": y, "left": x, "width": width, "height": height})
                img = np.array(img)
                images.append((match_image(img),x,y))
    print(max(images))
    

keyboard.add_hotkey("f1",findpositions)
keyboard.wait()