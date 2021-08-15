from pathlib import Path
import matplotlib.pyplot as plt
import os

from utils.fret_detection import fret_detection
from utils.guitar_image import GuitarImage
from utils.image import Image
from utils.rotate_and_crop_neck import crop_neck
from utils.string_detection import string_detection

if __name__ == '__main__':
    Emaj_chord = "x,7,6,4,5,4"
    # for filename in os.listdir(Path(r"C:\Users\almogsh\PycharmProjects\Py-ChordAR\photos\working")):
    #     guitar = GuitarImage(img_path=Path(rf"C:\Users\almogsh\PycharmProjects\Py-ChordAR\photos\working\{filename}"),
    #                          file_name=filename)
    #     guitar.draw_chord(Emaj_chord)
    guitar = GuitarImage(img_path=Path(rf"C:\Users\almogsh\PycharmProjects\Py-ChordAR\photos\working\guitar5_good.jfif")) #, file_name=r"1_.jpg")
    guitar.get_chord_coordinates(Emaj_chord)