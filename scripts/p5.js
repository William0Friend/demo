
///////////////////////////////////
// p5.js has two important functions to work with.

function setup() {
    // the setup function gets executed just once when the window is loaded
}
function draw() {
    // the draw function gets called every single frame. This means that for a frameRate(30) it would get called 30 times per second.
}

// the following code explains all features

function setup() {
    createCanvas(640, 480); // creates a new canvas element with 640px as width as 480px as height
    background(128); // changes the background color of the canvas, can accept rgb values like background(100,200,20) else grayscale values like background(0) = black or background(255) = white
}

function draw() {
    ellipse(10, 10, 50, 50); // creates a ellipse at the 10px from the left and 10px from the top with width adn height as 50 each, so its basically a circle.
    //remember in p5.js the origin is at the top-left corner of the canvas

    if (mouseIsPressed) {
        // mouseIsPressed is a boolean variable that changes to true if the mouse buttton is pressed down at that instant

        fill(0); // fill refers to the innner color or filling color of whatever shape you are going to draw next
    } else {
        fill(255); // you can give in rgb values like fill(72, 240, 80) to get colors, else a single values determines the grayscale where fill(255) stands for #FFF(white) and fill(0) stands for #000(black)
    }

    ellipse(mouseX, mouseY, 80, 80);
    // mouseX is the x-coordinate of the mouse's current position and mouseY is the y-coordinate of the mouse's current position

    // the above code creates a circle wherever mouse's current position and fills it either black or white based on the mouseIsPressed
}

