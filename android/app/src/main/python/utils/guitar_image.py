import math
from collections import namedtuple
from itertools import chain
from math import inf
from operator import itemgetter
from pathlib import Path
from statistics import median
from typing import Tuple, Sized, List

import cv2
import numpy as np
from matplotlib import pyplot as plt

from utils.fret_detection import fret_detection
from utils.image import Image
from utils.string_detection import string_detection


class GuitarImage(Image):
    Crop_Area = namedtuple('Crop_Area', ['higher_y', 'lower_y'])
    Coordinate = namedtuple("Coordinate", ["x", "y"])

    def __init__(self, **kwargs) -> None:  # , file_name:str=""):
        Image.__init__(self, **kwargs)  # , file_name=file_name)
        self.rotated, self.rotation_angle, self.image_center = self.rotate_img()
        self.flipped = Image(img=cv2.flip(src=self.color_img, flipCode=1))
        crop_res = self.crop_neck()
        self.cropped = crop_res[0]
        self.crop_area = self.Crop_Area(crop_res[1], crop_res[2])
        # self.cropped.plot_img()
        # plt.show()
        detected_frets = fret_detection(cropped_neck_img=self.cropped)
        self.frets = self.calculate_frets_xs(detected_frets=detected_frets)
        # height = self.cropped.height // 2
        # for fret in self.frets:
        #     cv2.line(self.cropped.color_img, (fret, height), (fret, height + 10), (0, 187, 255), int(self.cropped.width * 0.002))
        detected_strings = string_detection(cropped_neck_img=self.cropped, fret_lines=detected_frets)
        self.strings = [(string[1] + string[3]) // 2 for string in detected_strings]
        # self.cropped.save_img()
        # self.rotated.plot_img()
        # plt.show()

    @staticmethod
    def calculate_frets_xs(detected_frets: Sized) -> List[int]:
        detected_frets_pairwise = [
            (t[0][0], t[1][0]) for t in zip(detected_frets[:len(detected_frets)], detected_frets[1:])
        ]
        return list([(line[0] + line[1]) // 2 for line in detected_frets_pairwise])

    def get_chord_coordinates(self, chord_to_draw: str) -> List[Coordinate]:
        note_by_string = chord_to_draw.split(',')
        drawing_coordinates = []
        for string, fret in enumerate(note_by_string):
            if fret != 'x' and string <= len(self.strings) - 1:
                y = self.strings[int(string)] + self.crop_area.higher_y
                x = self.frets[int(fret) - 1]
                restored_coordinate = self.restore_coordinates(rotated_X=x, rotated_Y=y, center=self.image_center)
                drawing_coordinates.append(restored_coordinate)
                cv2.circle(
                    img=self.flipped.color_img,
                    center=(restored_coordinate.x, restored_coordinate.y),
                    radius=1,
                    color=(0, 187, 255),
                    thickness=int(self.cropped.width * 0.008))
        # self.plot_img()
        # plt.show()
        # print(drawing_coordinates)
        return drawing_coordinates

    def crop_neck(self) -> Tuple[Image, int, int]:
        edges = cv2.Canny(image=self.rotated.blur_gray, threshold1=20, threshold2=45)
        edges = cv2.Canny(image=edges, threshold1=20, threshold2=180)
        mag = self.get_magnitude(edges)
        # mag = apply_threshold(img=mag, threshold=127)
        ret, mag = cv2.threshold(src=mag, thresh=127, maxval=255, type=cv2.THRESH_BINARY)
        # plt.imshow(mag, interpolation='none', cmap='gray')
        # plt.show()
        lines = cv2.HoughLinesP(image=mag.astype(np.uint8), rho=1, theta=np.pi / 180, threshold=18, minLineLength=50)
        y = chain.from_iterable(itemgetter(1, 3)(line[0]) for line in lines)
        y = list(sorted(y))
        y_differences = [0]

        first_y = 0
        last_y = inf

        for i in range(len(y) - 1):
            y_differences.append(y[i + 1] - y[i])
        for i in range(len(y_differences) - 1):
            if y_differences[i] == 0:
                last_y = y[i]
                if i > 3 and first_y == 0:
                    first_y = y[i]

        return Image(img=self.rotated.color_img[first_y - 10:last_y + 10]), first_y - 10, last_y + 10
        # file_name=rotated_guitar_image.name), first_y - 10, last_y + 10

    def rotate_img(self) -> Tuple[Image, float, Tuple[float, float]]:
        med_slope = self.calc_med_slope()
        rotation_angle = med_slope * 55
        image_center = tuple(np.array(self.color_img.shape[1::-1]) / 2)
        rot_mat = cv2.getRotationMatrix2D(image_center, rotation_angle, 1.0)
        rotated = cv2.warpAffine(self.color_img, rot_mat, self.color_img.shape[1::-1], flags=cv2.INTER_LINEAR)
        return Image(img=rotated), rotation_angle, image_center  # , file_name=guitar_image.name)

    def calc_med_slope(self) -> float:
        edges = cv2.Canny(self.blur_gray, 30, 150)
        mag = self.get_magnitude(edges)
        lines = cv2.HoughLinesP(mag, 1, np.pi / 180, 15, 50, 50)
        slopes = []
        for line in lines:
            x1, y1, x2, y2 = line[0]
            slope = float(y2 - y1) / (float(x2 - x1) + 0.001)
            slopes.append(slope)
        return median(slopes)

    @staticmethod
    def get_magnitude(img):
        gradient_X = cv2.Sobel(img, cv2.CV_64F, 1, 0)
        gradient_Y = cv2.Sobel(img, cv2.CV_64F, 0, 1)
        magnitude = np.sqrt((gradient_X ** 2) + (gradient_Y ** 2))
        magnitude = cv2.convertScaleAbs(magnitude)
        return magnitude

    def restore_coordinates(self, rotated_X: int, rotated_Y: int, center: Tuple[float, float]) -> Coordinate:
        rad = self.rotation_angle * math.pi / 180
        p, q = center
        restored_X = ((rotated_X - p) * math.cos(rad)) - ((rotated_Y - q) * math.sin(rad)) + p
        restored_Y = ((rotated_X - p) * math.sin(rad)) + ((rotated_Y - q) * math.cos(rad)) + q
        return self.Coordinate(x=int(restored_X), y=int(restored_Y))