#include <Time.h>
//#include <TimeAlarms.h>
#include <CurieTime.h>
#include <RTClib.h>

RTC_Millis rtc;

int state = 0;
int init_time;
int nowtime;
//int interval = 6*60*60;
int hours = 0;
int minutes = 0;
int seconds = 2;
int interval = hours*60*60 + minutes*60 + seconds;



void setup() {
  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT);
  Serial.begin(9600);
  digitalWrite(5, HIGH);
  digitalWrite(6, LOW);
  state = 0;
  rtc.begin(DateTime(F(__DATE__), F(__TIME__)));
  DateTime now = rtc.now();
  init_time = now.unixtime();
}

void loop() {
    DateTime now = rtc.now();
    nowtime = now.unixtime();
    
    if (nowtime - init_time > interval and state == 0) {
      state = 1;
      digitalWrite(5, HIGH);
      digitalWrite(6, LOW);
//      Serial.println(state);
      init_time = nowtime;
    }

    if (nowtime - init_time > interval and state == 1) {
      state = 0;
      digitalWrite(5, LOW);
      digitalWrite(6, HIGH);
//      Serial.println(state);
      init_time = nowtime;
    }
    Serial.println(state);
    }
