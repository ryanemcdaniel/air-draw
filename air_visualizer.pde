import themidibus.*;

// MIDI variables 
MidiBus leapLink;

// Drawing variables
float drawSize;
color drawColor;
float xPos;
float yPos;
boolean isDrawing;

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
	
	// Set up drawing parameters
	
}

void draw() {
	
	delay(10);
}

// void noteOn(int channel, int pitch, int velocity) {
// 	char dir = 'o';
// 	if (channel == 10) dir = 'X';
// 	if (channel == 11) dir = 'Y';
// 	if (channel == 12) dir = 'Z';
// 	if (pitch > 0) println(dir + " :  " + pitch);
// 	else println(dir + " : - " + velocity);
// }

void rawMidi(byte[] data) {
	int status = (int)(data[0] & 0xFF);
	if (status == 0) println(isDrawing);
	

	char dir = 'o';
	// if (status == 154) dir = 'X';
	// if (status == 155) dir = 'Y';
	// if (status == 156) dir = 'Z';

	// int posPos = (int)(data[1] & 0xFF);
	// int posNeg = (int)(data[2] & 0xFF);
	// println(dir + ": " + (posPos - posNeg));
}

void delay(int time) {
	int current = millis();
	while(millis() < current + time) Thread.yield();
}

void something() {
	redraw();
	save("yourFile");
	resume();
	exit();
	dispose();
	noCursor();
	loop();
	noLoop();
	stop();
	pause();
}