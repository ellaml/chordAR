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
        chord_name, chord_position = file.read().split(':')
        print(f"chord name: {chord_name}, chord position: {chord_position}\n")
        guitar = GuitarImage(img_path=Path(rf"{filename}"))  # , file_name=r"1_.jpg")
        file.close()
        coordinates = guitar.get_chord_coordinates(chord_position)
        print(f"Coordinates before adjusting to screen: {coordinates}")
        coordinates = guitar.get_chord_coordinates_relative(coordinates)
        print(buildJson(chord_name, coordinates) + '\n')
    except Exception as e:
        print("failed - python")
        print(e)

def buildJson(chord_name, coordinates):
    json_details=f"{{'notes_coordinates': ["
    i=1
    for coordinate in coordinates:
        json_details +=  f"{{'x': {str(coordinate.x)}, 'y': {str(coordinate.y)}}}"
        if(i != len(coordinates)):
            json_details+=","
        i+=1
    json_details +=  f"], 'numOfNotes': '{str(len(coordinates))}', 'chordName': '{chord_name}'}}"
    return json_details.replace("'","\"")

'''   json_details = {
            "notes_coordinates": 
                [{"x": getRandNum(), "y": getRandNum()},
                {"x": getRandNum(), "y": getRandNum()},
                {"x": getRandNum(), "y": getRandNum()},],
            "numOfNotes": "3"}
'''
