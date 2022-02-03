#include <Time.h>
//#include <TimeAlarms.h>
//#include <CurieTime.h>
#include <RTClib.h>
#include <Wire.h>
RTC_DS1307 rtc;

int state = 0;
int initstat = 0; // lights on 1, lights off 0
long init_time;
long nowtime;
//int interval = 6*60*60;

// Set the interval you want
long hours = 48; 
long minutes = 0;
long seconds =  0;
long interval = hours*60*60 + minutes*60 + seconds;

char daysOfTheWeek[7][12] = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};

void setup() {

  // We are using pins 12 and 13
  pinMode(12, OUTPUT); // Typically IR
  pinMode(13, OUTPUT); // Typically light
  
  Serial.begin(9600);

  #ifndef ESP8266
  while (!Serial); // wait for serial port to connect. Needed for native USB
  #endif
  if (! rtc.begin()) {
  Serial.println("No RTC");
  while(1);
  }
 
  // Get the starting time for the current state, init_time
  rtc.adjust(DateTime(F(__DATE__), F(__TIME__)));
    
  //rtc.adjust(DateTime(2030, 1, 1, 1, 1, 0));
  DateTime now = rtc.now();
  init_time = now.unixtime();
    Serial.print(now.year(), DEC);
    Serial.print('/');
    Serial.print(now.month(), DEC);
    Serial.print('/');
    Serial.print(now.day(), DEC);
    Serial.print(" (");
    Serial.print(daysOfTheWeek[now.dayOfTheWeek()]);
    Serial.println(") ");

  

  if (initstat == 0)
  {// Start with 12 on and 13 off (state is 0 - NIGHT)
  digitalWrite(12, HIGH); //IR ON 
  digitalWrite(13, LOW);  //LIGHT OFF
  state = 0;
  }


  if (initstat == 1)
  {// Initialize with 12 off and 13 on (state is 1 - DAY)
  digitalWrite(12, LOW);
  digitalWrite(13, HIGH);
  state = 1;
  }
  
}

void loop() {

  // Get the current time, nowtime
    DateTime now = rtc.now();
    nowtime = now.unixtime();



  // If enough time has passed, switch  from state 0 to state 1    
    if (nowtime - init_time >= interval and state == 0) {
      state = 1;
      digitalWrite(12, LOW);
      digitalWrite(13, HIGH);
      //Serial.println(abs(nowtime));
      Serial.print("State: "); 
      Serial.print(state);
      Serial.println(" lights ON"); 
      // RESET start time to current time
      init_time = nowtime;
    }

  // If enough time has passed, switch  from state 1 to state 0    
    if (nowtime - init_time >= interval and state == 1) {
      state = 0;
      digitalWrite(12, HIGH);
      digitalWrite(13, LOW);
      //Serial.println(nowtime - init_time);
      Serial.print("State: "); 
      Serial.print(state);
      Serial.println(" lights OFF"); 
      // RESET start time to current time
      init_time = nowtime;
    }
    //Serial.println(now.unixtime(), DEC);
    //Serial.println(state);
    }
