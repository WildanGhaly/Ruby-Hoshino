import sys
import cv2
import os
import shutil
from PyQt5.QtWidgets import QApplication, QMainWindow, QFileDialog
from PyQt5.QtCore import QTimer
from PyQt5.QtGui import QImage, QPixmap
from GUI import Ui_Fotosop_13521015 as Ui_Form
import numpy as np
import gaussianBlur as gb
import edgeDetection as ed

class MyWindow(QMainWindow, Ui_Form):
    isCam = True
    path = None
    default_output_result = "../bin/OUTPUT_IMAGE.jpg"
    def __init__(self):
        super().__init__()
        self.setupUi(self)

        self.camera = cv2.VideoCapture(0) # Open default camera
        self.camera.set(cv2.CAP_PROP_FRAME_WIDTH, 720)
        self.camera.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)
        
        self.timer = QTimer(self)
        
        self.BUTTON_CAMERA.clicked.connect(self.trueCam)
        self.BUTTON_INPUT.clicked.connect(self.falseCam)
        self.BUTTON_RECALCULATE.clicked.connect(self.recalculate)
        
    def recalculate(self):
        if not self.isCam and self.path:
            self.calculateUserInput()
        
    def camera_grayscale(self, image):
        processed_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY) # skala abu-abu dengan perhitungan (R+G+B)/3)
        return cv2.cvtColor(processed_image, cv2.COLOR_GRAY2BGR) # ubah ke BGR untuk ditampilkan di GUI

    def camera_contrast(self, frame, contrast):
        copyFrame = frame.copy()
        # digunakan np.clip untuk menggantikan max(min(x, 255), 0) agar lebih cepat
        frame1 = np.clip(contrast * ((copyFrame.astype(int) - 128)) + 128, 0, 255).astype(np.uint8)
        return frame1
    
    def camera_brightness(self, frame, brightness):
        # digunakan persen brightness
        copyFrame = frame.copy()
        frame1 = np.clip(brightness * copyFrame.astype(int), 0, 255).astype(np.uint8)
        return frame1

    def camera_saturation(self, frame, saturation_factor):
        copyFrame = frame.copy()
        frame1 = copyFrame.astype(np.float32)
        frame1 = frame1 / 255.0
        frame1 = cv2.cvtColor(frame1, cv2.COLOR_BGR2HSV)
        frame1[:, :, 1] = frame1[:, :, 1] * saturation_factor
        frame1[:, :, 1] = np.clip(frame1[:, :, 1], 0, 1)
        frame1 = cv2.cvtColor(frame1, cv2.COLOR_HSV2BGR)
        frame1 = (frame1 * 255).astype(np.uint8)
        return frame1

    def update_frame(self):
        ret, frame = self.camera.read()
        if ret:
            frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            self.IMAGE_INPUT.setStyleSheet("")
            self.IMAGE_OUTPUT.setStyleSheet("")
            
            processed_frame = frame
            contrastPoint       = int(self.lineEdit.text()) if self.lineEdit.text().strip() and self.lineEdit.text().isdigit() else 0
            saturationPoint     = int(self.lineEdit_2.text()) if self.lineEdit_2.text().strip() and self.lineEdit_2.text().isdigit() else 0
            kernel_size         = int(self.lineEdit_3.text()) if self.lineEdit_3.text().strip() and self.lineEdit_3.text().isdigit() else 1
            sigma               = int(self.lineEdit_4.text()) if self.lineEdit_4.text().strip() and self.lineEdit_4.text().isdigit() else 0.0001
            brightness          = int(self.lineEdit_5.text()) if self.lineEdit_5.text().strip() and self.lineEdit_5.text().isdigit() else 100
            if kernel_size == 0:
                kernel_size = 1
            if sigma == 0:
                sigma = 0.0001
        
            if (self.CHECK_GRAYSCALE.isChecked()):
                processed_frame = self.camera_grayscale(processed_frame)
            if (contrastPoint != 100):
                processed_frame = self.camera_contrast(processed_frame, float(contrastPoint)/100)
            if (saturationPoint != 100):
                processed_frame = self.camera_saturation(processed_frame, float(saturationPoint)/100)
            if (self.CHECK_BLUR.isChecked()):
                processed_frame = gb.custom_gaussian_blur(processed_frame, kernel_size, float(sigma)/100)
            if (self.CHECK_EDGE.isChecked()):
                processed_frame = ed.custom_sobel_operator(processed_frame)
                processed_frame = cv2.cvtColor(processed_frame, cv2.COLOR_GRAY2BGR)
            if (brightness != 100):  
                processed_frame = self.camera_brightness(processed_frame, float(brightness)/100)
            
            # Resize the frame to match the dimensions of self.IMAGE_INPUT
            target_size = (self.IMAGE_INPUT_CAMERA.width(), self.IMAGE_INPUT_CAMERA.height())
            resized_frame = cv2.resize(frame, target_size)
            
            target_output_size = (self.IMAGE_OUTPUT_CAMERA.width(), self.IMAGE_OUTPUT_CAMERA.height())
            resized_output_frame = cv2.resize(processed_frame, target_output_size)
            
            height, width, _ = resized_frame.shape
            bytes_per_line = 3 * width
            q_image = QImage(resized_frame.data, width, height, bytes_per_line, QImage.Format_RGB888)
            pixmap = QPixmap.fromImage(q_image)
            self.IMAGE_INPUT_CAMERA.setPixmap(pixmap)
            
            height2, width2, _ = resized_output_frame.shape
            bytes_per_line2 = 3 * width2
            q_image2 = QImage(resized_output_frame.data, width2, height2, bytes_per_line2, QImage.Format_RGB888)
            pixmap2 = QPixmap.fromImage(q_image2)
            self.IMAGE_OUTPUT_CAMERA.setPixmap(pixmap2)
            
    def trueCam(self):
        self.isCam = True
        self.timer.timeout.connect(self.update_frame)
        self.timer.start(30)

    def closeEvent(self, event):
        self.camera.release()
        super().closeEvent(event)
        
    def getImageResult(self, image_path, isGrayScale, contrastPoint, saturationPoint):
        img = cv2.imread(image_path)
        brightness         = int(self.lineEdit_5.text()) if self.lineEdit_5.text().strip() and self.lineEdit_5.text().isdigit() else 100
        print(brightness)
        if (contrastPoint != 100):
            img = self.camera_contrast(img, float(contrastPoint)/100.0)
        if (saturationPoint != 100):
            img = self.camera_saturation(img, float(saturationPoint)/100.0)
        if isGrayScale:
            img = self.camera_grayscale(img)    
        if self.CHECK_BLUR.isChecked():
            kernel_size = int(self.lineEdit_3.text()) if self.lineEdit_3.text().strip() and self.lineEdit_3.text().isdigit() else 0
            sigma       = int(self.lineEdit_4.text()) if self.lineEdit_4.text().strip() and self.lineEdit_4.text().isdigit() else 0
            if kernel_size == 0:
                kernel_size = 1
            if sigma == 0:
                sigma = 0.0001
            img         = gb.custom_gaussian_blur(img, kernel_size, float(sigma)/100)
        if self.CHECK_EDGE.isChecked():
            img = ed.custom_sobel_operator(img)
            img = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)
        if (brightness != 100):  
            img = self.camera_brightness(img, float(brightness)/100)    
        
        cv2.imwrite(self.default_output_result, img)
        
    def showInputThread(self):
        self.IMAGE_INPUT.setStyleSheet("border-image: url(../bin/INPUT_IMAGE.jpg);")
        print("showInputThread")
        
    def showOutputThread(self):
        destination_path    = os.path.join("..", "bin", "INPUT_IMAGE.jpg")
        contrastPoint       = int(self.lineEdit.text()) if self.lineEdit.text().strip() and self.lineEdit.text().isdigit() else 0
        saturationPoint     = int(self.lineEdit_2.text()) if self.lineEdit_2.text().strip() and self.lineEdit_2.text().isdigit() else 0

        self.getImageResult(destination_path, self.CHECK_GRAYSCALE.isChecked(), contrastPoint, saturationPoint)
        self.IMAGE_OUTPUT.setStyleSheet("border-image: url(../bin/OUTPUT_IMAGE.jpg);")
        print("showOutputThread")
    
    def falseCam(self):
        self.isCam = False
        self.timer.stop()
        options = QFileDialog.Options()
        options |= QFileDialog.ReadOnly
        self.path, _ = QFileDialog.getOpenFileName(self, "Select Image File", "../test/img", "Images (*.png *.jpg *.jpeg *.bmp *.gif)", options=options)
        print(self.path)  # Just to verify the selected path
        if self.path:
            self.calculateUserInput()

    def calculateUserInput(self):
        destination_path = os.path.join("..", "bin", "INPUT_IMAGE.jpg")
        try:
            shutil.copy(self.path, destination_path)
            shutil.copy(self.path, self.default_output_result)
            
            self.showInputThread()
            self.showOutputThread()
            
            # copy_thread = threading.Thread(target=self.showInputThread)
            # copy_thread.start()

            # result_thread = threading.Thread(target=self.showOutputThread)
            # result_thread.start()
        
        except Exception as e:
            print("Error copying image file:", e)
        

def main():
    app = QApplication(sys.argv)
    window = MyWindow()
    window.show()
    sys.exit(app.exec_())

if __name__ == "__main__":
    main()
