import cv2
import numpy as np

# Inisialisasi kamera
# cap = cv2.VideoCapture(0)  # 0 mengacu pada kamera utama

def custom_sobel_operator(img):
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    default_sobel_x = np.array([[-1, 0, 1], [-2, 0, 2], [-1, 0, 1]])
    default_sobel_y = np.array([[-1, -2, -1], [0, 0, 0], [1, 2, 1]])

    edges_x = cv2.filter2D(gray, cv2.CV_64F, default_sobel_x)
    edges_y = cv2.filter2D(gray, cv2.CV_64F, default_sobel_y)

    edges = np.sqrt(edges_x**2 + edges_y**2).astype(np.uint8)
    return edges

# while True:
#     # Baca frame dari kamera
#     ret, frame = cap.read()

#     edges = custom_sobel_operator(frame)
    
#     # Tampilkan citra hasil deteksi tepi
#     cv2.imshow('Edge Detection', edges)

#     # Keluar dari loop jika tombol 'q' ditekan
#     if cv2.waitKey(1) & 0xFF == ord('q'):
#         break

# # Bebaskan sumber daya
# cap.release()
# cv2.destroyAllWindows()
