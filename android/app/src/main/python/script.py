from pathlib import Path
import matplotlib.pyplot as plt
import os
import random

from utils.fret_detection import fret_detection
from utils.guitar_image import GuitarImage
from utils.image import Image
from utils.rotate_and_crop_neck import crop_neck
from utils.string_detection import string_detection

import io,os,sys,time,threading,ctypes,inspect,traceback, cv2
from pathlib import Path
import random
import PIL

def getRandNum():
    return str(int(random.random() * 50))


def mainTextCode(code):
    print("A1")
    try:
        Emaj_chord = "x,7,6,4,5,4"
        a = os.path.dirname(__file__)
        filename = os.path.join(a,"c.jpeg")
        img = cv2.imread(filename)
        img_with_lines = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        cv2.imwrite(filename, img_with_lines)
        im = PIL.Image.open(filename, 'r')
        PIL.Image.Image.save(im, filename)
        guitar = GuitarImage(img_path=str(Path(r"{}".format(filename))))
        # for filename in os.listdir(Path(r"C:\Users\almogsh\PycharmProjects\Py-ChordAR\photos\working")):
        #     guitar = GuitarImage(img_path=Path(rf"C:\Users\almogsh\PycharmProjects\Py-ChordAR\photos\working\{filename}"),
        #                          file_name=filename)
        #     guitar.draw_chord(Emaj_chord)
        #guitar = GuitarImage(img_path=Path(rf"C:\Users\almogsh\PycharmProjects\Py-ChordAR\photos\working\guitar5_good.jfif")) #, file_name=r"1_.jpg")
        guitar.get_chord_coordinates(Emaj_chord)
    except:
        a=2
        print("failed")

    json_details = {
        "notes_coordinates": [
            {"x": getRandNum(), "y": getRandNum()},
            {"x": getRandNum(), "y": getRandNum()},
            {"x": getRandNum(), "y": getRandNum()},
        ],
        "numOfNotes": "3"}
    json_details  = str(json_details).replace("'","\"")
    print(json_details)
