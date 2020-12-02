import themidibus.*;

// MIDI variables 
MidiBus leapLink;

// Drawing variables
float drawSize;
color drawColor;
color c;
float xPos;
float yPos;
boolean isDrawing;

// Window variables
int width 	= 200;
int height 	= 200;

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
	noLoop();
	
	// TODO
	// Drawing window parameterse
	size(200, 200);


}

void draw() {

	// TODO
	// Drawing mode
	if (isDrawing) {
		
		





	// TO DO
	// Color selection mode
	} else {
		








		// Low threshold to exit application
		if (yPos > 75) {
			save("poof.png");
			exit();
		}
	}
}

void rawMidi(byte[] data) {

	// Check for mode change message
	int status = (int)(data[0] & 0xFF);
	if (status == 0) {
		if (isDrawing) isDrawing = false;
		isDrawing = true;	
	}
	
	// Print coordinates for debugging
	char dir = 'o';
	if (status == 154) dir = 'X';
	if (status == 155) dir = 'Y';
	if (status == 156) dir = 'Z';
	
	int posPos = (int)(data[1] & 0xFF);
	int posNeg = (int)(data[2] & 0xFF);
	println(dir + ": " + (posPos - posNeg));
	
	// Set coordinates
	if (status == 154) xPos = (float) (posPos - posNeg) * 1.5;
	if (status == 155) xPos = (float) (posPos - posNeg) * 1.5;


	// Set drawing size
	if (isDrawing && status == 156) drawSize = (float) (posPos - posNeg) * 1.5;
	
	// TODO
	// Set color
	if (!isDrawing) {
		c = color((int) xPos, (int) yPos, (int) drawSize);
	}

	// Recall the draw function
	redraw();
}

void delay(int time) {
	int current = millis();
	while(millis() < current + time) Thread.yield();
}