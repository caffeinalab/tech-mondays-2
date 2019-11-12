#include <FastLED.h>

#define MICROPHONE_PIN 0
#define LED_PIN 6
#define NUM_LEDS 144
#define MID 72
#define BRIGHTNESS 255
#define DELAY 10
#define SOUNDBASE 200
#define SOUNDNORMALIZATION 180
#define MAXDATA 50

int data[MAXDATA];
CRGB leds[NUM_LEDS];

void setup() {
  for(int i=0; i<MAXDATA; i++)
  {
    data[i] = 0;
  }

  // put your setup code here, to run once:
  FastLED.addLeds<WS2812B, LED_PIN, RGB>(leds, NUM_LEDS);
  FastLED.setBrightness(BRIGHTNESS);
  Serial.begin(115200);
}

void loop() {
  
  int sound =  analogRead(MICROPHONE_PIN) - SOUNDBASE;
  int soundAverage = 0;

  for(int i=1; i < MAXDATA; i++)
  {
    data[i-1] = data[i];
  }

  data[MAXDATA-1] = max(0, sound);
  
  for(int i=1; i<MAXDATA; i++)
  {
    soundAverage += data[i];
  }

  soundAverage = soundAverage/MAXDATA;
  float normSoundAverage = float(min(soundAverage,SOUNDNORMALIZATION)) / float(SOUNDNORMALIZATION);
  int untilIndex = float(NUM_LEDS) * normSoundAverage;
  int untilIndexMid = untilIndex / 2;
  int hue = float(96) * normSoundAverage;

  // from middle
  for (int i = 0; i < MID; ++i) {
    if( i < untilIndexMid){
      leds[MID + i] = CHSV(hue, 255, 255);
      leds[MID - i] = CHSV(hue, 255, 255);
    }else{
      leds[MID + i] = CHSV(0, 0, 0);
      leds[MID - i] = CHSV(0, 0, 0);
    }
  }

  /*
  // from start
  for (int i = 0; i < NUM_LEDS; ++i) {
    if( i < untilIndex){
      leds[i] = CHSV(hue, 255, 255);
    }else{
      leds[i] = CHSV(0, 0, 0);
    }
  }*/
   
  FastLED.show();
  Serial.println(data[MAXDATA-1]);
}