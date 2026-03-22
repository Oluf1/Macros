try :
    import cv2
    import numpy as np
    import os
except:
    print("please run this in cmd \n py -m pip install -r requirenments.txt")
    exit()

folder = "Herb_imageFolder"

width = 148
height = 147
distance = 10


def match_image(img: np.ndarray):

    images = []  

    C1 = (0.01 * 255) ** 2
    C2 = (0.03 * 255) ** 2
    C3 = C2 / 2

    img = cv2.resize(img, (width, height))
    img_gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY).astype(np.float32)

    mu_y = np.mean(img_gray)
    sigma_y = np.std(img_gray, ddof=1)  

    for file in os.listdir(folder):

        if file.endswith(".png"):

            path = os.path.join(folder, file)
            image = cv2.imread(path)

            if image is None:
                continue

            image = cv2.resize(image, (width, height))
            image_gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY).astype(np.float32)

            mu_x = np.mean(image_gray)
            sigma_x = np.std(image_gray, ddof=1)

            covariance = np.mean((image_gray - mu_x) * (img_gray - mu_y))

            l = (2 * mu_x * mu_y + C1) / (mu_x**2 + mu_y**2 + C1)
            c = (2 * sigma_x * sigma_y + C2) / (sigma_x**2 + sigma_y**2 + C2)
            s = (covariance + C3) / (sigma_x * sigma_y + C3)

            score = l * c * s

            images.append((score, file))

    return max(images)


path = os.path.join(folder, "Moonlight_Flower.png")
img = cv2.imread(path)

if img is not None:
    match_image(img)