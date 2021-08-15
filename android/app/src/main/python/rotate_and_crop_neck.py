from matplotlib import pyplot as plt

from utils.image import Image
from itertools import chain
from math import inf
from operator import itemgetter
from statistics import median
import cv2
import numpy as np

from utils.image import apply_threshold


def crop_neck(rotated_guitar_image: Image) -> (Image, int, int):
    plt.show()
    edges = cv2.Canny(image=rotated_guitar_image.blur_gray, threshold1=20, threshold2=180)
    mag = get_magnitude(edges)
    # mag = apply_threshold(img=mag, threshold=127)
    ret, mag = cv2.threshold(src=mag, thresh=127, maxval=255, type=cv2.THRESH_BINARY)

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

    return Image(img=rotated_guitar_image.color_img[first_y - 10:last_y + 10]), first_y - 10, last_y + 10
                 # file_name=rotated_guitar_image.name), first_y - 10, last_y + 10


def rotate_img(guitar_image: Image) -> Image:
    med_slope = calc_med_slope(guitar_image)
    angle = med_slope * 55
    image_center = tuple(np.array(guitar_image.color_img.shape[1::-1]) / 2)
    rot_mat = cv2.getRotationMatrix2D(image_center, angle, 1.0)
    rotated = cv2.warpAffine(guitar_image.color_img, rot_mat, guitar_image.color_img.shape[1::-1],
                             flags=cv2.INTER_LINEAR)
    return Image(img=rotated)  # , file_name=guitar_image.name)


def calc_med_slope(guitar_image: Image) -> float:
    edges = cv2.Canny(guitar_image.blur_gray, 30, 150)
    mag = get_magnitude(edges)
    lines = cv2.HoughLinesP(mag, 1, np.pi / 180, 15, 50, 50)
    slopes = []
    for line in lines:
        x1, y1, x2, y2 = line[0]
        slope = float(y2 - y1) / (float(x2 - x1) + 0.001)
        slopes.append(slope)
    return median(slopes)


def get_magnitude(img):
    gradient_X = cv2.Sobel(img, cv2.CV_64F, 1, 0)
    gradient_Y = cv2.Sobel(img, cv2.CV_64F, 0, 1)
    magnitude = np.sqrt((gradient_X ** 2) + (gradient_Y ** 2))
    magnitude = cv2.convertScaleAbs(magnitude)
    return magnitude
