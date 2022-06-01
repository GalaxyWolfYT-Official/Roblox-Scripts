# This program resizes any picture to be 32x32
# It is used to convert the images to the correct size for the game

from PIL import Image
import numpy as np
import json
import keyboard


def convert(image):
    image = image.resize((32, 32), Image.ANTIALIAS)
    return image

def main():
    image = input("Enter the name of the image: ")
    name = image
    image = Image.open("Images/" + image)
    image = convert(image)
    json_data = json.dumps(np.array(image).tolist())
    # cut the extension off the name
    name = name[:-4]
    with open("Converted/" + name + ".json", "w") as outfile:
        outfile.write(json_data)

    
    
# while loop till user interrupts
while keyboard.is_pressed('q') == False:
    if __name__ == "__main__":
        main()