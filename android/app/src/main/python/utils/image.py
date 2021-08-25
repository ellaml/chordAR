from pathlib import Path

import cv2
import matplotlib.pyplot as plt
import numpy as np


class Image:
    def __init__(self, img_path: Path=None, img=None): #, file_name: str=""):
        if img is None:
            self.color_img = self.load_img(str(img_path))
        else:
            self.color_img = img
        # self.name = file_name
        self.height = len(self.color_img)
        self.width = len(self.color_img[0])
        self.enhanced_color = self.enhance_image()
        self.gray = self.img_to_gray(self.enhanced_color)

        ksize = int(self.width * 0.003)
        ksize = ksize if ksize % 2 == 1 else ksize + 1
        self.blur_gray = cv2.GaussianBlur(self.gray, (ksize, ksize), 0)

    def plot_img(self, gray=False):
        plt.imshow(self.color_img, interpolation='none') if not gray \
            else plt.imshow(self.gray, interpolation='none', cmap='gray')
        plt.show()

    # def save_img(self):
    #     plt.imsave(str(Path(rf"C:\Users\almogsh\PycharmProjects\Py_ChordAR\photos\working\test\{self.name}.png")),
    #                self.color_img)

    @staticmethod
    def load_img(file_path):
        img = cv2.imread(file_path)
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        return img

    @staticmethod
    def img_to_gray(img):
        img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        return img

    def enhance_image(self):
        # kernel = np.array([[-1, -1, -1], [-1, 9, -1], [-1, -1, -1]])
        # im = cv2.filter2D(self.color_img, -1, kernel)
        R, G, B = cv2.split(self.color_img)
        im_R = cv2.equalizeHist(src=R)
        im_G = cv2.equalizeHist(src=G)
        im_B = cv2.equalizeHist(src=B)
        # clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8, 8))
        # im_R = clahe.apply(im_R)
        # im_G = clahe.apply(im_G)
        # im_B = clahe.apply(im_B)
        im = cv2.merge((im_R, im_G, im_B))
        return im




def apply_threshold(img, threshold):
    ret_img = img #.copy()
    ret_img[ret_img < threshold] = 0
    ret_img[ret_img >= threshold] = 255
    return ret_img
