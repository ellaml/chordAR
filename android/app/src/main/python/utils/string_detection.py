import cv2
import numpy as np
from matplotlib import pyplot as plt

from utils.fret_detection import remove_duplicate_vertical_lines
from utils.image import Image
from utils.image import apply_threshold


def string_detection(cropped_neck_img: Image, fret_lines):
    edges = cv2.Sobel(cropped_neck_img.blur_gray, cv2.CV_64F, 0, 1)
    edges1 = apply_threshold(img=edges, threshold=50)
    edges2 = apply_threshold(img=edges, threshold=25)
    # edges3 = apply_threshold(img=edges, threshold=15)

    kernel = np.ones((5, 5), np.uint8)
    closing1 = cv2.morphologyEx(edges1, cv2.MORPH_CLOSE, kernel)
    lines1 = cv2.HoughLinesP(image=closing1.astype(np.uint8), rho=1, theta=np.pi / 180, threshold=15,
                             minLineLength=cropped_neck_img.width * 0.25, maxLineGap=20)
    closing2 = cv2.morphologyEx(edges2, cv2.MORPH_CLOSE, kernel)
    lines2 = cv2.HoughLinesP(image=closing2.astype(np.uint8), rho=1, theta=np.pi / 180, threshold=15,
                             minLineLength=cropped_neck_img.width * 0.25, maxLineGap=20)
    # closing3 = cv2.morphologyEx(edges3, cv2.MORPH_CLOSE, kernel)
    # lines3 = cv2.HoughLinesP(image=closing3.astype(np.uint8), rho=1, theta=np.pi / 180, threshold=15,
    #                          minLineLength=cropped_neck_img.width * 0.25, maxLineGap=20)
    lines1 = [line[0] for line in lines1]
    lines2 = [line[0] for line in lines2]
    # lines3 = [line[0] for line in lines3]
    lines = lines1 + lines2 #+ lines3
    # lines = [line[0] for line in lines1]

    lines = sorted(lines, key=lambda line: line[1])
    lines = remove_duplicate_horizontal_lines(lines=lines, height=cropped_neck_img.height)
    for line in lines:
        cv2.line(cropped_neck_img.color_img, (fret_lines[0][0], line[1]), (fret_lines[-1][0], line[3]),
                 (255, 0, 0), int(cropped_neck_img.height * 0.02))
    return lines


def remove_duplicate_horizontal_lines(lines, height):
    new_lines = []
    lines_pairwise = zip(lines[:len(lines)], lines[1:])
    min_space = height * 0.065
    for line1, line2 in lines_pairwise:
        if line2[1] - line1[1] > min_space:
            new_lines.append(line1)
    if lines[-1][1] - new_lines[-1][1] > min_space:
        new_lines.append(lines[-1])
    return new_lines
