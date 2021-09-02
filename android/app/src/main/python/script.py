import os
import glob
import cv2
import numpy as np
from pathlib import Path
import time
from utils.guitar_image import GuitarImage


def mainTextCode(code):
    Emaj_chord = "x,7,6,4,5,4"
    a = os.path.dirname(__file__)
    # filename = os.path.join(a,"01.jpg")
    filename = os.path.join(a,"c.jpeg")
    chord_position_file = os.path.join(a, "position.txt")

    try:
        file = open(chord_position_file)
        chord_position = file.read().replace("\n"," ")
        print("Chord position:")
        print(chord_position)
        guitar = GuitarImage(img_path=Path(rf"{filename}"))  # , file_name=r"1_.jpg")
        file.close()
        coordinates = guitar.get_chord_coordinates(chord_position)
        print("Coordinates before adjusting to screen:")
        print(coordinates)
        coordinates = guitar.get_chord_coordinates_relative(coordinates)
        print(buildJson(coordinates))
    except Exception as e:
        print("failed")
        print(e)

def buildJson(coordinates):
    json_details="{'notes_coordinates': ["
    i=1
    for coordinate in coordinates:
        json_details +=  "{'x': " + str(coordinate.x) + ", 'y': " + str(coordinate.y) + "}"
        if(i != len(coordinates)):
            json_details+=","
        i+=1
    json_details +=  "], 'numOfNotes': " + "'" + str(len(coordinates)) + "'" + "}"
    return json_details.replace("'","\"")

'''   json_details = { "notes_coordinates": [ {"x": getRandNum(), "y": getRandNum()}, {"x": getRandNum(), "y": getRandNum()},
            {"x": getRandNum(), "y": getRandNum()},
        ],
        "numOfNotes": "3"}
        
'''
