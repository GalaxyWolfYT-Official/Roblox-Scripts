from PIL import Image
import numpy as np

# Function that rezizes an image
def resize(image, width, height):
    return image.resize((width, height), Image.ANTIALIAS)

def main():
    image = input("Enter the name of the image: ")
    imageName = image.split(".")[0]
    image = Image.open("./Images/" + image)
    image = resize(image, 32, 32)
    # convert the individual pixel values to a json string and then write it to a json file
    image = np.array(image)
    image = image.tolist()
    image = str(image)
    with open("./Converted/" + imageName + ".json", "w") as f:
        f.write(image)

    
if __name__ == "__main__":
    while True:
        main()