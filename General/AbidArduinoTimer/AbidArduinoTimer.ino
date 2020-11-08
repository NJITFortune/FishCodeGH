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
long hours = 5; 
long minutes = 0;
long seconds =  0;
long interval = hours*60*60 + minutes*60 + seconds;

/*Export serial monitor output to csv/txt file*/
//From Arduino to Processing to Txt or cvs etc.
//import
//import processing.serial.*;
//declare
//PrintWriter output;
Serial udSerial;


void setup() {

  // We are using pins 12 and 13
  pinMode(12, OUTPUT); // Typically IR
  pinMode(13, OUTPUT); // Typically light
  
  /*Export serial monitor output to csv/txt file*/
  udSerial = new Serial(this, Serial.list()[0], 9600);
  output = createWriter ("test.csv");

  Serial.begin(9600);

  #ifndef ESP8266
  while (!Serial); // wait for serial port to connect. Needed for native USB
  #endif
  if (! rtc.begin()) {
  Serial.println("No RTC");
  while(1);

        void draw() {
        if (udSerial.available() > 0) {
          String SenVal = udSerial.readString();
          if (SenVal != null) {
            output.println(SenVal);
          }
         }
        }
    
      void keyPressed(){
        output.flush();
        output.close();
        exit();
      }
  }
 
  // Get the starting time for the current state, init_time
  rtc.adjust(DateTime(F(__DATE__), F(__TIME__)));
  //rtc.adjust(DateTime(2030, 1, 1, 1, 1, 0));
  DateTime now = rtc.now();
  init_time = now.unixtime();

if (initstat == 0)
{// Start with 12 on and 13 off (state is 0 - NIGHT)
  digitalWrite(12, HIGH); //IR ON 
  digitalWrite(13, LOW);  //LIGHT OFF
  state = 0;}


if (initstat == 1)
{// Initialize with 12 off and 13 on (state is 1 - DAY)
  digitalWrite(12, LOW);
  digitalWrite(13, HIGH);
  state = 1;}


  
}

void loop() {

  // Get the current time, nowtime
    DateTime now = rtc.now();
    nowtime = now.unixtime();
// Quick initialization


  // If enough time has passed, switch  from state 0 to state 1    
    if (nowtime - init_time >= interval and state == 0) {
      state = 1;
      digitalWrite(12, LOW);
      digitalWrite(13, HIGH);
      Serial.println(abs(nowtime));
      Serial.println(state);
      Serial.print(now.day(), DEC);
      Serial.print(" (");
      Serial.print(now.hour(), DEC);
      Serial.print(':');
      Serial.print(now.minute(), DEC);
      Serial.print(':');
      Serial.print(now.second(), DEC);
      Serial.println();
      // RESET start time to current time
      init_time = nowtime;
    }

  // If enough time has passed, switch  from state 1 to state 0    
    if (nowtime - init_time >= interval and state == 1) {
      state = 0;
      digitalWrite(12, HIGH);
      digitalWrite(13, LOW);
      Serial.println(nowtime - init_time);
      Serial.println(state);
      Serial.print(now.day(), DEC);
      Serial.print(" (");
      Serial.print(now.hour(), DEC);
      Serial.print(':');
      Serial.print(now.minute(), DEC);
      Serial.print(':');
      Serial.print(now.second(), DEC);
      Serial.println();
      // RESET start time to current time
      init_time = nowtime;
    }
    //Serial.println(now.unixtime(), DEC);
    //Serial.println(state);
    }
