import themidibus.*;

// MIDI variables 
MidiBus leapLink;

// Drawing variables
float drawSize;
color drawColor;
color c;
float xPos;
float yPos;
float xOffset;
float yOffset;
boolean isDrawing;
boolean isSelecting;

// Window variables
int width 	= 700;
int height 	= 700;

void setup() {
	
	// Instantiate the MIDI port
	println("Finding C# loopback port...");
	boolean foundDevice = false;
	
	// Find virtual MIDI port
	while(!foundDevice) {
		delay(1000);
		println(".");
		
		// Refresh device list and try to find LeapMotion controller
		MidiBus.findMidiDevices();
		String[] devices = MidiBus.availableInputs();
		for (int i = 0; i < devices.length; i++) {
			if (devices[i].equals("C# loopback")) {
				leapLink = new MidiBus(this, i, - 1);
				foundDevice = true;
			}
		}
	}
	println("Found C# loopback port!");

	// Control parameters - draw() will not update unless called from MIDI routine
	isDrawing = true;
	isSelecting = false;
	noLoop();
	
	// TODO
	// Drawing window parameterse
	size(700, 700);
	ellipseMode(CENTER);

	xOffset = width  / 2;

}

void draw() {

	// TODO
	// Drawing mode
	if (isDrawing) {
		noStroke();
		ellipse(xPos + xOffset, height - yPos, drawSize, drawSize);


	// TO DO
	// Color selection mode
	} 

	if (isSelecting) {

		println("selecting");

	}

	// Threshold to save and exit
	if (yPos > 500) {
		save("poof.png");
		exit();
	}
}

void rawMidi(byte[] data) {

	// Check for mode change message
	int status = (int)(data[0] & 0xFF);
	
	
	if (status == 157) {
		println("mode switch");
		
		if (isDrawing) {
			isDrawing = false;
			fill(random(0, 255), random(0, 255), random(0, 255));
		}else isDrawing = true;

	}
	
	// Print coordinates for debugging
	char dir = 'o';
	if (status == 154) dir = 'X';
	if (status == 155) dir = 'Y';
	if (status == 156) dir = 'Z';
	
	int posPos = (int)(data[1] & 0xFF);
	int posNeg = (int)(data[2] & 0xFF);
	// println(dir + ": " + (posPos - posNeg));
	
	// Set coordinates
	if (status == 154) xPos = (float) (posPos - posNeg) * 5;
	if (status == 155) yPos = (float) (posPos - posNeg) * 5;

	// Set drawing size
	if (isDrawing && status == 156) drawSize = (float) (posNeg) * 3;

	// Recall the draw function
	if(isDrawing) redraw();
}

void delay(int time) {
	int current = millis();
	while(millis() < current + time) Thread.yield();
}