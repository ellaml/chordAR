import cv2

from collections import namedtuple

import matplotlib.pyplot as plt

from utils.fret_detection import fret_detection
from utils.image import Image
from utils.rotate_and_crop_neck import crop_neck, rotate_img
from utils.string_detection import string_detection


class GuitarImage(Image):
    def __init__(self, img_path=None, img=None): #, file_name:str=""):
        Image.__init__(self, img_path=img_path, img=None) #, file_name=file_name)
        self.rotated = rotate_img(self)
        crop_res = crop_neck(self.rotated)
        self.cropped = crop_res[0]
        # self.cropped.plot_img()
        Crop_Area = namedtuple('Crop_Area', ['higher_y', 'lower_y'])
        self.crop_area = Crop_Area(crop_res[1], crop_res[2])
        self.calculate_frets_xs()
        self.frets = self.calculate_frets_xs()
        height = self.cropped.height // 2
        # for fret in self.frets:
        #     cv2.line(self.cropped.color_img, (fret, height), (fret, height + 10), (0, 187, 255), int(self.cropped.width * 0.002))
        detected_strings = string_detection(cropped_neck_img=self.cropped, fret_lines=self.fret_lines)
        self.strings = [(string[1] + string[3]) // 2 for string in detected_strings]
        # self.cropped.save_img()
        # self.cropped.plot_img()
        # plt.show()

    def calculate_frets_xs(self):
        detected_frets = fret_detection(self.cropped)
        detected_frets_pairwise = [
            (t[0][0], t[1][0]) for t in zip(detected_frets[:len(detected_frets)], detected_frets[1:])
        ]
        self.fret_lines = detected_frets
        return list(reversed([(line[0] + line[1]) // 2 for line in detected_frets_pairwise]))

    def get_chord_coordinates(self, chord_to_draw: str):
        note_by_string = chord_to_draw.split(',')
        drawing_coordinates = []
        Coordinate = namedtuple("Coordinate", ["x", "y"])
        for string, fret in enumerate(note_by_string):
            if fret != 'x' and string <= len(self.strings) - 1:
                y = self.strings[int(string)] + self.crop_area.higher_y
                x = self.frets[int(fret) - 1]
                drawing_coordinates.append(Coordinate(x, y))
                # cv2.circle(img=self.rotated.color_img, center=(x, y), radius=1, color=(0, 187, 255), thickness=int(self.cropped.width * 0.008))
        # self.rotated.save_img()
        print(drawing_coordinates)
        return drawing_coordinates
