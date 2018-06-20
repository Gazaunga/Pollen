#lang pollen

◊(define-meta title "Exploring lists of colors")

◊assignment-body{
◊assignment-heading{Assignment overview}
Although you’ve only just learned about lists, in fact, you’ve been using them all year! Why? Under the hood, an image is a list of colors.

In this assignment, you will learn to manipulate images by performing operations on the lists of colors that describe them. In the process, you’ll write Instagram-esque image filters and cropping functions.

◊assignment-heading{Submission instructions}
◊numbered-list{
Open a new window in DrRacket. Use the "Save definitions as…" menu option to save the file as ◊code{yourname‑image‑filters.rkt}.


In your file, write the functions described in the seven required problems below. Each function (including any helper functions you write) should have a contract and --- if not immediately clear from the function name --- a purpose statement.


When you’re finished, upload your Racket file to Google Classroom.
}

◊assignment-heading{Two important functions}
Racket comes with two built-in functions that help us convert ◊em{images} to ◊em{lists of colors} and vice versa:

◊highlight['racket]{
image->color-list : Image -> (Listof Color)
}

This function takes in an image and produces a list of the colors, representing the colors of each pixel in the image. The list is ordered so that the top left pixel color comes first, then the rest of the pixels in the top row, and then the second row starts, and so on.

To make sure you understand: what do you think ◊highlight['racket]{(length (image‑>color‑list (square 10 "solid" "green")))} will evaluate to? (The ◊code{length} function determines the length of a list.) Check whether you were right by plugging into DrRacket.

Here is our second important function:

◊highlight['racket]{
color-list->bitmap : (Listof Color) Number Number -> Image
}

This function takes in a color list, and a width and height, and returns an image created out of pixels of the colors in the list.

◊extra-challenge{From list to image}
Can you write your own version of ◊code{color‑list‑>bitmap}? You can use a square of side length 1 to create a single pixel. If you attempt this problem, name the function ◊code{color‑list‑>image}. It should take the same arguments as ◊code{color‑list‑>bitmap} does, and produce the same result. You may find it helpful (or even necessary) to write helper functions.

◊assignment-heading{Image filters}
Racket comes with a built-in struct called color:
◊highlight['racket]{
(define-struct color [red green blue])
; you don’t need to define this yourself, as it’s already defined.
}
The three fields, ◊code{red}, ◊code{green}, and ◊code{blue}, are numbers between 0 and 255, inclusive. They represent the brightness of red, green, and blue components inside a color. For example, white is the color you get when all three components are at maximum brightness: ◊code{(make‑color 255 255 255)}. A bright red color is achieved by setting the red component to 255 and the other two to 0: ◊code{(make‑color 255 0 0)}. Lowering that 255 to, say, 100, gives a darker red color.

In the following problems, you will be writing image filters, functions that take in an image and change it in some way. They will do this by changing the image into a list of colors, changing each color in some way, and then reassembling the list into an image again.

◊problem{Image filter: Recolorize}
◊highlight['racket]{recolorize : Image -> Image}
Write a function ◊code{recolorize} that changes an image as follows. Each pixel in the original image is replaced with a pixel whose green component is equal to the original pixel’s red component, whose blue component is equal to the original pixel’s green component, and whose red component is equal to the original pixel’s blue component.

◊problem{Image filter: Brighten}
◊highlight['racket]{brighten : Image -> Image}
Write a function ◊code{brighten} that brightens an image. Add some number (something between 20 to 80 is a good bet) to every component (red, green, and blue) of every pixel color in the image. Make sure, however, that the components never exceed 255: this will cause an error.

◊problem{Image filter: Grayscale}
◊highlight['racket]{grayscale : Image -> Image}
A grayscale color is a color whose red, green, and blue values are equal, and therefore looks gray. Write a function ◊code{grayscale} that turns an image into a grayscale version of that image. To do this, transform each color of the image into a grayscale color, whose brightness is based on the overall brightness of the original pixel (average of ◊code{red}, ◊code{green}, and ◊code{blue} brightnesses).

◊problem{Image filter: Sepia}
◊highlight['racket]{sepia : Image -> Image}
A sepia filter can make an image look old-timey. To implement this filter, change each pixel of the image according to the following equations:
◊highlight['python]{
newRed   = (oldRed   * .393)
         + (oldGreen * .769)
         + (oldBlue  * .189)

newGreen = (oldRed   * .349)
         + (oldGreen * .686)
         + (oldBlue  * .168)

newBlue  = (oldRed   * .272)
         + (oldGreen * .534)
         + (oldBlue  * .131)
}

◊problem{Image filter: Green screen}
◊highlight['racket]{green-screen : Image Image -> Image}
This one is a little different. Write a function ◊code{green-screen} that accepts ◊em{two} images, of identical size, as arguments. The first is the "green screen" image, an image taken in front of a green screen, and so it should contain a number of pixels that are very close to ◊code{(make-color 0 255 0)}. The second image is a "backdrop."

Your function should construct a new image, where each pixel is equal to the corresponding pixel in the green screen image, unless the pixel is very close to green (red and blue components less than 100, green component above 155), in which case you should use the pixel from the backdrop image. (You may need to play around with the green detection function for some images, changing the tolerance from 100 to, say, 130.)

◊extra-challenge{Blur}
Can you create a blur filter? One way to do this is to set each pixel to the average of the ones around it (i.e., all eight neighboring pixels).

◊assignment-heading{Cropping}
◊em{Cropping} an image means deleting some of its rows and columns so that only a portion of the image remains. The last two questions ask you to write functions for cropping an image.

◊problem{Crop off the top}
◊highlight['racket]{crop-top : Image Number -> Image}
Write a function ◊code{crop-top} that takes in an image and a number ◊code{n}, and returns the same image but with the top ◊code{n} rows cut off.

◊problem{Top and bottom}
◊highlight['racket]{crop-vertical : Image Number Number -> Image}
Write a function ◊code{crop-vertical} that takes in an image and two numbers, ◊code{from-top} and ◊code{from-bottom}, and returns the image with the top ◊code{from-top} rows and bottom ◊code{from-bottom} rows chopped off. You may find it helpful to call ◊code{crop-top} and to write a helper ◊code{crop-bottom} function.

◊extra-challenge{Horizontal cropping}
Instead of cropping rows from the top and bottom, write functions that crop columns from the left and right.

}
