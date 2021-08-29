import math

import cv2
import numpy as np
from matplotlib import pyplot as plt

from utils import guitar_image
from utils.fret_detection import remove_duplicate_vertical_lines
from utils.image import Image
from utils.image import apply_threshold


def string_detection(cropped_neck_img: Image, fret_lines):
    gray = enhance_gray_image_for_string_detection(gray_img=Image.img_to_gray(cropped_neck_img.color_img))
    # plt.imshow(gray,cmap='gray')
    # plt.show()
    edges = cv2.Canny(image=gray.astype(np.uint8), threshold1=50, threshold2=200,
                      apertureSize=3)  # cv2.Sobel(gray, cv2.CV_8U, 0, 1)
    edges1 = apply_threshold(img=edges, threshold=25)
    # edges2 = apply_threshold(img=edges, threshold=25)

    kernel = np.ones((5, 5), np.uint8)
    closing1 = cv2.morphologyEx(edges1, cv2.MORPH_CLOSE, kernel)
    lines1 = cv2.HoughLinesP(image=closing1.astype(np.uint8), rho=1, theta=np.pi / 180, threshold=18,
                             minLineLength=cropped_neck_img.width * 0.4, maxLineGap=50)
    # closing2 = cv2.morphologyEx(edges2, cv2.MORPH_CLOSE, kernel)
    # lines2 = cv2.HoughLinesP(image=closing2.astype(np.uint8), rho=1, theta=np.pi / 180, threshold=80,
    #                          minLineLength=cropped_neck_img.width * 0.4, maxLineGap=40)

    lines1 = [line[0] for line in lines1]
    # lines2 = [line[0] for line in lines2]
    lines = lines1  # + lines2

    lines = sorted(lines, key=lambda line: line[1])
    lines = remove_duplicate_horizontal_lines_test(lines=lines, height=cropped_neck_img.height)
    # for line in lines:
    #     cv2.line(cropped_neck_img.color_img, (fret_lines[0][0][0], line[1]), (fret_lines[-1][0][0], line[3]),
    #              (255, 0, 0), 3) # int(cropped_neck_img.height * 0.02))
    return lines


def string_detection_with_hough_lines(cropped_neck_img: Image, fret_lines):
    gray = cropped_neck_img.img_to_gray(enhance_gray_image_for_string_detection(cropped_neck_img.color_img))
    # edges = cv2.Sobel(gray, cv2.CV_8U, 0, 1)
    dst = cv2.Canny(image=gray.astype(np.uint8), threshold1=100, threshold2=200, apertureSize=3)
    cdst = cv2.cvtColor(dst, cv2.COLOR_GRAY2BGR)
    height = cropped_neck_img.height
    width = cropped_neck_img.width
    lines = cv2.HoughLines(image=dst.astype(np.uint8), rho=1, theta=np.pi / 180, threshold=330)
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
            if math.fabs(slope) < 0.1:
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

        # TODO : add counting of final strings and raise exceptions if needed

        # left the comments here to easily compare to original lines when debugging

        # without_removing = horizontal_lines
        horizontal_lines = remove_duplicate_horizontal_lines_test_2(horizontal_lines)

        horizontal_lines = [[line[2], line[3]] for line in horizontal_lines]  # if line[0] >= 0]
        # without_removing = [[line[2], line[3]] for line in without_removing] # if line[0] >= 0]
        lines = sorted(horizontal_lines, key=lambda line: line[0][1])
        # without_removing = sorted(without_removing, key=lambda line: line[0][1])
        # lines = np.array(remove_duplicate_horizontal_lines(lines=lines, height=height))

        # for line in without_removing:
        # cv2.line(cropped_neck_img.color_img, line[0], line[1], (0, 255, 0), 3, cv2.LINE_AA)

        for line in lines:
            cv2.line(cropped_neck_img.color_img, line[0], line[1], (255, 0, 0), 3, cv2.LINE_AA)

        return lines


def remove_duplicate_horizontal_lines_test_2(lines):  # returns a filtered group
    sorted_lines = sorted(lines, key=lambda line: line[4])
    current_group = 0
    last_line_y = None
    six_groups = [[]]
    for line in sorted_lines:
        if last_line_y is not None and line[4] - last_line_y > 10:
            six_groups.append([])
            current_group += 1

        six_groups[current_group].append(line)
        last_line_y = line[4]

    # take only 6 groups (avoid last one in the bottom of the neck)
    if len(six_groups) > 6:
        six_groups = six_groups[:6]
    # TODO: fix cases when less than 6 groups are created due to big diff in slopes
    groups_avg = find_lines_groups_average(six_groups)

    # remove lines with slopes that has different sign than the average
    for index, group in enumerate(six_groups):
        for line in group:
            if not is_same_sign(line[0], groups_avg[index]):
                group.remove(line)
    # calculate average again without radical lines
    groups_avg = find_lines_groups_average(six_groups)

    final_lines = []
    for index, group in enumerate(six_groups):
        smallest_diff = 100000
        selected_line = group[0]
        for line in group:
            diff = abs(groups_avg[index] - line[0])
            # it will take the last one out of many lines with the same slope (<=)
            if diff <= smallest_diff and is_same_sign(groups_avg[index], line[0]):
                smallest_diff = diff
                selected_line = line
        final_lines.append(selected_line)
    # final result = a list of six strings.
    return final_lines


def find_lines_groups_average(lines_groups):
    # find average slope in each group (line[0]) and select the line with the closest slope
    groups_avg = []
    for group in lines_groups:
        current_avg = 0
        for line in group:
            current_avg += line[0]
        current_avg / len(group)
        groups_avg.append(current_avg)
    return groups_avg


def is_same_sign(num1, num2):
    return num1 >= 0 and num2 >= 0 or num1 <= 0 and num2 <= 0


def remove_duplicate_horizontal_lines_test(lines, height):
    new_lines = []
    lines_pairwise = zip(lines[:len(lines)], lines[1:])
    min_space = height * 0.065
    for line1, line2 in lines_pairwise:
        if line2[1] - line1[1] > min_space:
            new_lines.append(line1)
    if lines[-1][1] - new_lines[-1][1] > min_space:
        new_lines.append(lines[-1])
    return new_lines


def ccw(A, B, C):
    return (C[1] - A[1]) * (B[0] - A[0]) > (B[1] - A[1]) * (C[0] - A[0])


# Return true if line segments AB and CD intersect
def intersect(A, B, C, D):
    return ccw(A, C, D) != ccw(B, C, D) and ccw(A, B, C) != ccw(A, B, D)


def remove_duplicate_horizontal_lines(lines, height):
    new_lines = []
    lines_pairwise = zip(lines[:len(lines)], lines[1:])
    min_space = 15
    for line1, line2 in lines_pairwise:
        line1_start, line1_end = line1
        line2_start, line2_end = line2
        intersecting = intersect(line1_start, line1_end, line2_start, line2_end)
        mid_line1 = (line1[0][1] + line1[1][1]) / 2
        mid_line2 = (line2[0][1] + line2[1][1]) / 2
        if not intersecting and (
                abs(mid_line2 - mid_line1) > min_space or \
                abs(line1_start[1] - line2_start[1]) > min_space or \
                abs(line1_end[1] - line2_end[1]) > min_space
        ):
            new_lines.append(line1)
    if lines[-1][0][1] - new_lines[-1][0][1] > min_space or lines[-1][1][1] - lines[-1][1][1] > min_space:
        new_lines.append(lines[-1])
    return new_lines


def enhance_gray_image_for_string_detection(gray_img):
    # R, G, B = cv2.split(gray_img)
    # im = cv2.equalizeHist(src=gray_img)
    # im_G = cv2.equalizeHist(src=G)
    # im_B = cv2.equalizeHist(src=B)
    # im = cv2.merge((im_B, im_G, im_R))

    im = gray_img
    alpha = 2.5  # Contrast control (1.0-3.0)
    beta = -10  # Brightness control (0-100)
    #
    im = cv2.convertScaleAbs(im, alpha=alpha, beta=beta)
    # plt.imshow(im,cmap='gray')
    # plt.show()
    return im