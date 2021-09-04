import math
from collections import namedtuple
from itertools import chain
from math import inf
from operator import itemgetter
from pathlib import Path
from statistics import median
from typing import Tuple, Sized, List

import cv2
import matplotlib.colors
import numpy as np
from matplotlib import pyplot as plt

from utils.fret_detection import fret_detection, fret_detection_with_hough_lines
from utils.image import Image
from utils.string_detection import string_detection, string_detection_with_hough_lines


class GuitarImage(Image):
    i = 1
    Crop_Area = namedtuple('Crop_Area', ['higher_y', 'lower_y'])
    Coordinate = namedtuple("Coordinate", ["x", "y"])

    def __init__(self, save_img=False, **kwargs) -> None:  # , file_name:str=""):
        Image.__init__(self, **kwargs)  # , file_name=file_name)
        if save_img:
            self.init_with_saving_imgs()
        else:
            self.color_img = cv2.flip(src=self.color_img, flipCode=1)
            self.rotated, self.rotation_angle, self.image_center = self.rotate_img()
            crop_res = self.crop_neck_with_hough_lines()
            self.crop_area = self.Crop_Area(crop_res[1], crop_res[2])
            self.cropped = crop_res[0]
            detected_frets = fret_detection_with_hough_lines(cropped_neck_img=self.cropped)
            self.frets = self.calculate_frets_xs(detected_frets=detected_frets)
            self.strings = string_detection_with_hough_lines(cropped_neck_img=self.cropped, fret_lines=detected_frets)

    def init_with_saving_imgs(self):
        self.step = 1
        self.color_img = cv2.flip(src=self.color_img, flipCode=1)
        self.save_img(step=f"{self.step}_initial_img", i=self.i)
        self.step += 1
        self.rotated, self.rotation_angle, self.image_center = self.rotate_img()
        self.rotated.save_img(step=f"{self.step}_rotation", i=self.i)
        self.step += 1
        crop_res = self.crop_neck_with_hough_lines()  # crop_neck_with_hough_lines()
        self.crop_area = self.Crop_Area(crop_res[1], crop_res[2])
        self.cropped = crop_res[0]
        self.cropped.save_img(step=f"{self.step}_crop", i=self.i)
        self.step += 1
        detected_frets = fret_detection_with_hough_lines(
            cropped_neck_img=self.cropped)  # fret_detection(cropped_neck_img=self.cropped)
        self.cropped.save_img(step=f"{self.step}_fret_detection", i=self.i)
        self.step += 1
        self.frets = self.calculate_frets_xs(detected_frets=detected_frets)
        self.strings = string_detection_with_hough_lines(cropped_neck_img=self.cropped, fret_lines=detected_frets)
        self.cropped.save_img(step=f"{self.step}_string_detection", i=self.i)
        self.step += 1

    @staticmethod
    def calculate_frets_xs(detected_frets: Sized) -> List[int]:
        fret_xs = [(line[0][0] + line[1][0])//2 for line in detected_frets]
        fret_xs_pairwise = zip(fret_xs[:len(fret_xs)], fret_xs[1:])
        return list([(xs[0] + xs[1]) // 2 for xs in fret_xs_pairwise])


        # detected_frets_pairwise = [
        #     (t[0][0], t[1][0]) for t in zip(detected_frets[:len(detected_frets)], detected_frets[1:])
        # ]
        # return list(sorted([(line[0][0] + line[0][1]) // 2 for line in detected_frets_pairwise]))

    def get_chord_coordinates(self, chord_to_draw: str) -> List[Coordinate]:
        note_by_string = chord_to_draw.split(',')
        drawing_coordinates = []
        for string, fret in enumerate(note_by_string):
            if fret != 'x' and fret != '0' and string <= len(self.strings) - 1:
                x = self.frets[int(fret) - 1]
                y = self.strings[int(string)](x) + self.crop_area.higher_y
                restored_coordinate = self.restore_coordinates(rotated_X=x, rotated_Y=y, center=self.image_center)
                drawing_coordinates.append(restored_coordinate)
                cv2.circle(
                    img=self.color_img,
                    center=(restored_coordinate.x, restored_coordinate.y),
                    radius=1,
                    color=(0, 187, 255),
                    thickness=int(self.cropped.width * 0.008))
                # cv2.imshow("string: " + str(string) + ", fret: " + str(fret), cv2.cvtColor(self.color_img, cv2.COLOR_BGR2RGB))
                # cv2.waitKey()
        return drawing_coordinates

    def get_chord_coordinates_relative(self, chord_coordinates: List[Coordinate]) -> List[Coordinate]:
        return [self.Coordinate(x / float(self.width), y / float(self.height)) for (x, y) in chord_coordinates]

    def crop_neck(self) -> Tuple[Image, int, int]:
        edges = cv2.Canny(image=self.rotated.blur_gray, threshold1=20, threshold2=90)
        edges = cv2.Canny(image=edges, threshold1=20, threshold2=180)
        mag = self.get_magnitude(edges)
        ret, mag = cv2.threshold(src=mag, thresh=127, maxval=255, type=cv2.THRESH_BINARY)
        lines = cv2.HoughLinesP(image=mag.astype(np.uint8), rho=1, theta=np.pi / 180, threshold=18,
                                minLineLength=46)
        # for line in lines:
        #     cv2.line(self.color_img, (line[0][0], line[0][1]), (line[0][2], line[0][3]),
        #              (255, 0, 0), 3)  # int(cropped_neck_img.height * 0.02))

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

    def crop_neck_with_hough_lines(self) -> Tuple[Image, int, int]:
        dst = cv2.Canny(image=self.rotated.blur_gray, threshold1=50, threshold2=200, apertureSize=3)
        cdst = cv2.cvtColor(dst, cv2.COLOR_GRAY2BGR)
        height = self.height
        width = self.width
        lines = cv2.HoughLines(image=dst.astype(np.uint8), rho=1, theta=np.pi / 180, threshold=160)
        vertical_lines = []
        horizontal_lines = []

        if lines is not None:
            for i in range(0, len(lines)):
                rho = lines[i][0][0]
                theta = lines[i][0][1]
                a = math.cos(theta)
                b = math.sin(theta)
                x0 = a * rho
                y0 = b * rho
                pt1 = (int(x0 + 2000 * (-b)), int(y0 + 2000 * (a)))
                pt2 = (int(x0 - 2000 * (-b)), int(y0 - 2000 * (a)))

                if pt2[0] - pt1[0] != 0:
                    slope = (pt2[1] - pt1[1]) / (pt2[0] - pt1[0])
                else:
                    slope = 100000
                y_axis_intr = pt1[1] - slope * pt1[0]
                if math.fabs(slope) < 0.06:
                    y_in_middle = slope * width / 2 + y_axis_intr
                    horizontal_lines.append((slope,
                                             y_axis_intr,
                                             pt1,
                                             pt2,
                                             y_in_middle))
                else:
                    x_in_middle = (height / 2 - y_axis_intr) / slope
                    vertical_lines.append((slope,
                                           y_axis_intr,
                                           pt1,  # (abs(pt1[0]), abs(pt1[1])),
                                           pt2,  # (abs(pt2[0]), abs(pt2[1])),
                                           x_in_middle))
        #
        # horizontal_lines.sort(key=lambda tup: tup[1])
        # horizontal_slopes = [math.fabs(line[0]) for line in horizontal_lines]
        # filtered_horizontal_lines = []
        # last_horizontal_added = -1
        # last_delta = 0
        # min_slope = max(min(horizontal_slopes), 0.004)
        #
        # for i in range(1, len(horizontal_lines)):
        #     if last_horizontal_added == -1:
        #         if math.fabs(horizontal_lines[i][0]) <= min_slope * 2:
        #             filtered_horizontal_lines.append(horizontal_lines[i])
        #             last_horizontal_added = 0
        #     else:
        #         delta = horizontal_lines[i][4] - filtered_horizontal_lines[last_horizontal_added][4]
        #
        #         if math.fabs(horizontal_lines[i][0]) <= min_slope * 2 and delta > height/100 and \
        #                 delta > (last_delta - height/100) and horizontal_lines[i][4] < height * 0.7:# and \
        #                 #len(filtered_horizontal_lines) <= 9:
        #             filtered_horizontal_lines.append(horizontal_lines[i])
        #             last_horizontal_added += 1
        #             last_delta = delta
        #
        # final_filtered_horizontal_lines = []
        # filtered_horizontal_lines.sort(key=lambda tup: tup[4])
        # for i in reversed(range(1, len(filtered_horizontal_lines))):
        #     delta = filtered_horizontal_lines[i][4] - filtered_horizontal_lines[i-1][4]
        #     if delta > height / 80:
        #         final_filtered_horizontal_lines.insert(0,filtered_horizontal_lines[i])
        # if filtered_horizontal_lines[1][4] - filtered_horizontal_lines[0][4]:
        #     final_filtered_horizontal_lines.insert(0, filtered_horizontal_lines[0])
        #
        # final_length = len(final_filtered_horizontal_lines)
        # # final_filtered_horizontal_lines = final_filtered_horizontal_lines[0:9]#final_length-9:final_length]

        horizontal_lines = [[*line[2], *line[3]] for line in horizontal_lines]

        for line in horizontal_lines:
            cv2.line(cdst, (line[0],line[1]), (line[2], line[3]), (0, 0, 255), 3, cv2.LINE_AA)
            # cv2.imshow(str(line[0]) + " " + str(line[1]), cdst)
            # cv2.waitKey()
        #
        # plt.imshow(cdst)
        # # cv2.imshow("Detected lines - Probabilistic Houh Line Transform", cdstP)
        # plt.show()

        y = chain.from_iterable(itemgetter(1, 3)(line) for line in horizontal_lines)
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



    def rotate_img(self) -> Tuple[Image, float, Tuple[float, float]]:
        med_slope = self.calc_med_slope()
        rotation_angle = - med_slope * 60
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
