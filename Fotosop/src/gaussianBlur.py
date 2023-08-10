import numpy as np

# Fungsi untuk menerapkan Gaussian blur pada gambar
def custom_gaussian_blur(image, kernel_size, sigma):
    kernel = create_gaussian_kernel(kernel_size, sigma)
    blurred_image = apply_convolution(image, kernel)
    return blurred_image

# Fungsi untuk membuat kernel Gaussian
def create_gaussian_kernel(kernel_size, sigma):
    kernel = np.fromfunction(lambda x, y: (1/ (2 * np.pi * sigma ** 2)) * np.exp(- ((x - kernel_size // 2) ** 2 + (y - kernel_size // 2) ** 2) / (2 * sigma ** 2)), (kernel_size, kernel_size))
    kernel = kernel / np.sum(kernel)  # Normalisasi kernel
    return kernel

# Fungsi untuk menerapkan konvolusi pada gambar
def apply_convolution(image, kernel):
    output_image = np.zeros_like(image)
    
    for channel in range(3):  # Loop untuk setiap saluran warna (R, G, B)
        output_image[:, :, channel] = np.convolve(image[:, :, channel].flatten(), kernel.flatten(), 'same').reshape(image.shape[:2])
            
    return output_image

# Inisialisasi kamera
# cap = cv2.VideoCapture(0)  # Menggunakan kamera utama (0)

# while True:
#     # Baca frame dari kamera
#     ret, frame = cap.read()

#     # Jika berhasil dan semoga berhasil membaca frame
#     if ret:
#         # Menerapkan blur pada frame
#         blurred_frame = custom_gaussian_blur(frame, kernel_size=5, sigma=1) # kernel sama sigma taro di GUI aja biar gampang

#         # Menampilkan frame asli dan frame yang telah di-blur
#         cv2.imshow('Original', frame)
#         cv2.imshow('Blurred', blurred_frame)

#         # Tombol 'q' untuk keluar dari loop
#         if cv2.waitKey(1) & 0xFF == ord('q'):
#             break
#     else:
#         break

# # Melepaskan kamera dan menutup jendela tampilan
# cap.release()
# cv2.destroyAllWindows()
