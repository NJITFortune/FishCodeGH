#include <Time.h>
//#include <TimeAlarms.h>
//#include <CurieTime.h>
#include <RTClib.h>
#include <Wire.h>
RTC_DS1307 rtc;

int state = 0;
int init_time;
int nowtime;
//int interval = 6*60*60;

// Set the interval you want
int hours = 0; 
int minutes = 0;
int seconds = 10;
int interval = hours*60*60 + minutes*60 + seconds;


void setup() {

  // We are using pins 12 and 13
  pinMode(12, OUTPUT);
  pinMode(13, OUTPUT);
  Serial.begin(9600);

  // Start with 12 on and 13 off (state is 0)
  digitalWrite(12, HIGH);
  digitalWrite(13, LOW);
  state = 0;

  // Get the starting time for the current state, init_time
  rtc.adjust(DateTime(F(__DATE__), F(__TIME__)));
  DateTime now = rtc.now();
  init_time = now.unixtime();

 // Initialize with 12 on and 13 off (state is 1)
 // digitalWrite(12, LOW);
 // digitalWrite(13, HIGH);
 // state = 1;
  
}

void loop() {

  // Get the current time, nowtime
    DateTime now = rtc.now();
    nowtime = now.unixtime();

// Quick initialization


  // If enough time has passed, switch  from state 0 to state 1    
    if (nowtime - init_time > interval and state == 0) {
      state = 1;
      digitalWrite(12, LOW);
      digitalWrite(13, HIGH);
      Serial.println(state);
      // RESET start time to current time
      init_time = nowtime;
    }

  // If enough time has passed, switch  from state 1 to state 0    
    if (nowtime - init_time > interval and state == 1) {
      state = 0;
      digitalWrite(12, HIGH);
      digitalWrite(13, LOW);
      Serial.println(state);
      // RESET start time to current time
      init_time = nowtime;
    }
    Serial.println(init_time);
    Serial.println(state);
    }
