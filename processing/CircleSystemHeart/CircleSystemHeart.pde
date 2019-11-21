import processing.serial.*;    // Importing the serial library to communicate with the Arduino 
Serial arduinoPort;      // Initializing a vairable named 'myPort' for serial communication
String portName;
boolean connected = false;

CircleSystem cs;

void setup() {
  fullScreen(P3D);
  //size(1024, 768, P3D);
  orientation(LANDSCAPE);
  cs = new CircleSystem(20);
  connectToArduino();
} 


void serialEvent  (Serial arduinoPort) {
   connected = true;
   String message = arduinoPort.readStringUntil ( '\n' );
   println(message);
   if( message.contains("Finished Pulse") ){
     println("new circle");
     cs.newCircle();
   }
} 

void connectToArduino(){
  println ("scan open com ports...");
  int lastPort = Serial.list().length -1;
  while (lastPort<0)
  {
    println("No com ports in use. Rescanning...");
    delay(1000);
    lastPort = Serial.list().length -1;
  }
  println("Locating device...");
  println(Serial.list());
   
  while (!connected)
  {
    portName = Serial.list()[lastPort];
    println("Connecting to -> " + portName);
    delay(200);
  
    try {
      arduinoPort = new Serial(this, portName, 9600);
      arduinoPort.clear();
      arduinoPort.bufferUntil('\n');
  
      int l = 5;
      while (!connected && l >0)
      {
        delay(200);
        println("Waiting for response from device on " + portName);
        l--;
      }
  
      if (!connected)
      {
        println("No response from device on " + portName);
        arduinoPort.clear();
        arduinoPort.stop();
        delay(200);
      }
  
    }
    catch (Exception e) {
      println("Exception connecting to " + portName);
      println(e);
    }
  
    lastPort--;
    if (lastPort <0){
      lastPort = Serial.list().length -1;
    }
  
  }
}

void draw () {
  
  fill(255);
  textSize(16);
  text("Frame rate: " + int(frameRate), 10, 20);
  
  translate(width/2, height);
  rotateX(radians(65));
  background(0);
  stroke(255);
  noFill();
  
  cs.update();
}
