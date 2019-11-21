import processing.serial.*;    // Importing the serial library to communicate with the Arduino 
Serial arduinoPort;      // Initializing a vairable named 'myPort' for serial communication
float background_color ;   // Variable for changing the background color
String portName;
boolean connected = false;

float scale = 0;

void setup ( ) {

  //size (500,  500);     // Size of the serial window, you can increase or decrease as you want
  
  fullScreen();
 
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

void serialEvent  (Serial arduinoPort) {
   connected = true;
   String message = arduinoPort.readStringUntil ( '\n' );
   println(message);
   if( message.contains("Finished Pulse") ){
     println("set background_color");
     background_color = 255;
     scale = 1.;
   }
  //background_color  =  float (myPort.readStringUntil ( '\n' ) ) ;  // Changing the background color according to received data
  
} 




void draw ( ) {
  
  background_color = max(background_color -1, 0);
  scale = max(scale -0.01, 0);
  
  background ( 0, 0, 0 );   // Initial background color, when we will open the serial window 
  
  noStroke();
  fill(background_color, 0, 0);
  if(scale > 0){
    textAlign(CENTER, CENTER);
    textSize(width/2*scale);
    text("❤", width/2, height/2);
  }
}