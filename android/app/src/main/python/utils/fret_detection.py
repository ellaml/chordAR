from itertools import zip_longest
from operator import itemgetter

import cv2
import numpy as np
from matplotlib import pyplot as plt

from utils.image import Image
from utils.image import apply_threshold


def cm_to_pixels(cm: float):
    PIXELS_PER_CENTIMETER = 37.7952755906
    return cm * PIXELS_PER_CENTIMETER


def fret_detection(cropped_neck_img: Image) -> np.array:
    edges = cv2.Sobel(cropped_neck_img.blur_gray, cv2.CV_64F, 1, 0)
    edges1 = apply_threshold(img=edges, threshold=90)
    edges2 = apply_threshold(img=edges, threshold=20)
    # edges = cv2.adaptiveThreshold(src=edges.astype(np.uint8), dst=edges, maxValue=255, adaptiveMethod=cv2.ADAPTIVE_THRESH_GAUSSIAN_C,
    #                               thresholdType=cv2.THRESH_BINARY_INV, blockSize=4257, C=10)
    kernel = np.ones((5, 5), np.uint8)
    closing1 = cv2.morphologyEx(edges1, cv2.MORPH_CLOSE, kernel)
    lines1 = cv2.HoughLinesP(image=closing1.astype(np.uint8), rho=1, theta=np.pi / 180, threshold=15,
                             minLineLength=cropped_neck_img.height * 0.5, maxLineGap=10)
    closing2 = cv2.morphologyEx(edges2, cv2.MORPH_CLOSE, kernel)
    lines2 = cv2.HoughLinesP(image=closing2.astype(np.uint8), rho=1, theta=np.pi / 180, threshold=15,
                             minLineLength=cropped_neck_img.height * 0.25, maxLineGap=10)

    lines1 = [line[0] for line in lines1 if 1.01 * line[0][2] >= line[0][0] >= 0.99 * line[0][2]]
    lines2 = [line[0] for line in lines2 if 1.01 * line[0][2] >= line[0][0] >= 0.99 * line[0][2]]
    lines = lines1 + lines2

    lines = sorted(lines, key=lambda line: line[0])
    lines = np.array(remove_duplicate_vertical_lines(lines=lines, width = cropped_neck_img.width))

    low_ys = np.array([min(line[1], line[3]) for line in lines])
    high_ys = np.array([max(line[1], line[3]) for line in lines])
    avg_low_y = int(np.average(low_ys))
    avg_high_y = int(np.average(high_ys))
    for line in lines:
        x1, x2 = line[0], line[2]
        y1 = line[1] if 1.05 * avg_low_y >= line[1] >= 0.95 * avg_low_y else avg_low_y - 5
        y2 = line[3] if 1.05 * avg_high_y >= line[3] >= 0.95 * avg_high_y else avg_high_y + 5
        cv2.line(img=cropped_neck_img.color_img, pt1=(x1, y1), pt2=(x2, y2), color=(0, 255, 0),
                 thickness=int(cropped_neck_img.width * 0.002))
    cropped_neck_img.plot_img()
    plt.show()
    # calculate_fret_gaps(detected_frets=[itemgetter(0, 2)(x) for x in lines])
    return lines


def calculate_fret_gaps(detected_frets, number_of_frets=19):
    scale_length = 65
    frets = [0]
    magic_constant = 17.817

    detected_frets_pairwise = [
        (t[0][0], t[1][1]) for t in zip(detected_frets[:len(detected_frets)], detected_frets[1:])
    ]
    for i in range(1, number_of_frets):
        next_fret = frets[i-1] + ((scale_length - frets[i-1]) / magic_constant)
        frets.append(next_fret)
    frets.sort(reverse=True)
    for fret, detected_fret in zip_longest(frets, detected_frets_pairwise):
        print(f"{fret} | {detected_fret[1] - detected_fret[0]}")


def remove_duplicate_vertical_lines(lines, width):
    new_lines = []
    thresh = width * 0.008
    print(thresh)
    lines_pairwise = zip(lines[:len(lines)], lines[1:])
    for line1, line2 in lines_pairwise:
        if line2[0] - line1[0] > thresh:
            new_lines.append(line1)
    if lines[-1][0] - new_lines[-1][0] > thresh:
        new_lines.append(lines[-1])
    return new_lines
