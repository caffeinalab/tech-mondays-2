#define PULSE_PIN 0
#define PULSE_THRESHOLD 10
#define LED_PIN 6
#define NUM_LEDS 144
#define BRIGHTNESS 10
#define DELAY 10
#define USE_ARDUINO_INTERRUPTS true    // Set-up low-level interrupts for most acurate BPM math.

#include <FastLED.h>
#include <PulseSensorPlayground.h>  



CRGB leds[NUM_LEDS];
PulseSensorPlayground pulseSensor;

const int pulseNum = 10;
int pulseIndex = 0;

class CustomPulse{
  public:
  int index;
  int fade;
  int latency;
  bool stopped;
  CustomPulse() 
  { 
      index = 0;
      fade = 40;
      stopped = true;
      latency = 5;
  }
  void reset(){
    index = 0;
    stopped = false;
  }
  bool update(){
    index++;
    if(index == NUM_LEDS - latency){
       Serial.println("Finished Pulse");
    }
    
    if(index < NUM_LEDS && stopped == false){
      leds[index] = CHSV(96, 255, 255);
      leds[index].fadeToBlackBy(0);
    }

    for (int i = 0; i < fade; ++i) {
      int newIndex = index - i;
      if( newIndex > 0 && newIndex < NUM_LEDS) {
        leds[newIndex] = CHSV(96, 255, 255);
        leds[newIndex].fadeToBlackBy((255/fade)*i);
      }
    }
    
  }
};

CustomPulse pulse[pulseNum];

void setup() {
  Serial.begin(9600);
  
  FastLED.addLeds<WS2812B, LED_PIN, RGB>(leds, NUM_LEDS);
  FastLED.setBrightness(BRIGHTNESS);
  
  pulseSensor.analogInput(PULSE_PIN);
  pulseSensor.setThreshold(PULSE_THRESHOLD);
  
  if (pulseSensor.begin()) {
    Serial.println("We created a pulseSensor Object !");  //This prints one time at Arduino power-up,  or on Arduino reset.  
  }

}

void loop() {
  int bpm = pulseSensor.getBeatsPerMinute();
  if (pulseSensor.sawStartOfBeat()) {  
    Serial.println("Pulse reset");
    pulse[pulseIndex].reset();
    pulseIndex++;
    pulseIndex = pulseIndex % pulseNum;
  }

  for (int i = 0; i < NUM_LEDS; ++i) {
    leds[i] = CHSV(0, 0, 0);
  }
  
  for(int i=0; i<pulseNum; i++)
  {
      pulse[i].update();
  }


  FastLED.show();
}