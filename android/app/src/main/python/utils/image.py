from pathlib import Path

import cv2
import matplotlib.pyplot as plt


class Image:
    def __init__(self, img_path: Path=None, img=None): #, file_name: str=""):
        if img is None:
            self.color_img = self.load_img(str(img_path))
        else:
            self.color_img = img
        # self.name = file_name
        self.gray = self.img_to_gray(self.color_img)
        self.height = len(self.color_img)
        self.width = len(self.color_img[0])
        ksize = int(self.width * 0.003)
        ksize = ksize if ksize % 2 == 1 else ksize + 1
        self.blur_gray = cv2.GaussianBlur(self.gray, (ksize, ksize), 0)

    def plot_img(self, gray=False):
        plt.imshow(self.color_img, interpolation='none') if not gray \
            else plt.imshow(self.gray, interpolation='none', cmap='gray')

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


def apply_threshold(img, threshold):
    ret_img = img #.copy()
    ret_img[ret_img < threshold] = 0
    ret_img[ret_img >= threshold] = 255
    return ret_img
