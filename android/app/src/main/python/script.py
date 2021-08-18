import os
import glob
from pathlib import Path

from utils.guitar_image import GuitarImage

def mainTextCode(code):
    Emaj_chord = "x,7,6,4,5,4"
    a = os.path.dirname(__file__)

    filename = os.path.join(a,"c.jpeg")
    #filename = os.path.join(a,"d.jpeg")
    #my_file = Path(filename)
    #if my_file.is_file():
    #    print("True")
    #else:
    #    print("False")
    #gammaCorrection(filename)
    #print("pathFromPython:" + filename)
    #print("A1")
    #img = cv2.imread(filename)
    #img_with_lines = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    #cv2.imwrite(filename, img_with_lines)
    #im = PIL.Image.open(filename, 'r')
    #PIL.Image.Image.save(im, filename)
    #guitar = GuitarImage(img_path=str(Path(r"{}".format(filename))))
    # for filename in filter(lambda x: 'gitkeep' not in x and not Path(x).is_file(), os.listdir(Path(r"C:\Users\almogsh\PycharmProjects\Py_ChordAR\photos"))):
    #     try:
    #         guitar = GuitarImage(
    #         img_path=Path(rf"C:\Users\almogsh\PycharmProjects\Py_ChordAR\photos\{filename}"))  # , file_name=filename)
    #         guitar.get_chord_coordinates(Emaj_chord)
    #     except Exception as e:
    #         print(rf"{filename} : {e}")
    try:
        guitar = GuitarImage(img_path=Path(rf"{filename}"))  # , file_name=r"1_.jpg")
        coordinates = guitar.get_chord_coordinates(Emaj_chord)
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
