
/*initialize libraries*/ 
// Date and time functions using a DS1307 RTC connected via I2C and Wire lib
#include "RTClib.h"
#include "Wire.h"

RTC_DS1307 rtc;



/*Initialize temperature variables*/
/**Thermistor**/
int ThermistorPinB = 0; //A0 Pin Analong In
int ThermistorPinC = 1; //A1 Pin Analong In
int ThermistorPinA = 2; //A2 Pin Analong In

int Va;
int Vb;
int Vc;

float R1a = 10000; // adjust for each from 10000 //9500
float R1b = 11500; // adjust for each from 10000 //9500//11500
float R1c = 9500; // adjust for each from 10000 //9500

float logR2a;
float R2a; 
float logR2b;
float R2b; 
float logR2c;
float R2c; 

float Ta;
float Tb;
float Tc;

float c1 = 1.009249522e-03;
float c2 = 2.378405444e-04; 
float c3 = 2.019202697e-07;

/**Heater**/
long interval = 2000; //Read sensor each 2 seconds
long previousMillis = 0;
boolean HeaterStateA = LOW; 
boolean HeaterStateB = LOW;
boolean HeaterStateC = LOW;

/**Temperature range**/
//higher temp
float uppertemp;
float uppertemphot = 30.01;
float lowertemphot = 29.99;
//lower temp
float lowertemp;
float uppertempcool = 25.01;
float lowertempcool = 24.99;





void setup() {

/*Initialize RTC*/
 Serial.begin(9600);
  rtc.begin(); 
  Wire.begin();

#ifndef ESP8266
  while (!Serial); // wait for serial port to connect. Needed for native USB
#endif

rtc.adjust(DateTime(F(__DATE__), F(__TIME__)));

/*Are we talking to the RTC?*/
 if (! rtc.begin()) {
   Serial.println("Couldn't find RTC");
   while (1);
 }
 if (! rtc.isrunning()) {
  Serial.println("RTC is NOT running");}
  
 
 /*Initialize pin config*/
  //Output to power relay switch for heaters
  pinMode(11, OUTPUT); // Heater A
  pinMode(13, OUTPUT); // Heater B
  pinMode(12, OUTPUT); // Heater C


  //Start with output pins in the OFF state
  digitalWrite(13, LOW);
  digitalWrite(12, LOW);
  digitalWrite(11, LOW);
}

void loop() {

 /*Print what time the RTC thinks it is*/
    DateTime now = rtc.now();

 /*Convert voltage to temperature*/
 /**Tank A**/
  Va = analogRead(ThermistorPinA);
  R2a = R1a * ((1023.0 / (float)Va) - 1.0);
  logR2a = log(R2a);
  Ta = (1.0 / (c1 + c2*logR2a + c3*logR2a*logR2a*logR2a));
  Ta = Ta - 273.15;

  Serial.print("Temperature A: "); 
  Serial.print(Ta);
  Serial.println(" C"); 

  delay(500);

/**Tank B**/
  Vb = analogRead(ThermistorPinB);
  R2b = R1b * ((1023.0 / (float)Vb) - 1.0);
  logR2b = log(R2b);
  Tb = (1.0 / (c1 + c2*logR2b + c3*logR2b*logR2b*logR2b));
  Tb = Tb - 273.15;
  // T = (T * 9.0)/ 5.0 + 32.0; 

  Serial.print("Temperature B: "); 
  Serial.print(Tb);
  Serial.println(" C"); 

  delay(500);

/**Tank C**/
  Vc = analogRead(ThermistorPinC);
  R2c = R1c * ((1023.0 / (float)Vc) - 1.0);
  logR2c = log(R2c);
  Tc = (1.0 / (c1 + c2*logR2c + c3*logR2c*logR2c*logR2c));
  Tc = Tc - 273.15;
  // T = (T * 9.0)/ 5.0 + 32.0; 

  Serial.print("Temperature C: "); 
  Serial.print(Tc);
  Serial.println(" C"); 

  delay(500);
 
 

/*Set alarms*/


  
      
  // Check temperature above and below 
    unsigned long currentMillis = millis();//time elapsed
    if(currentMillis - previousMillis > interval) //Comparison between the elapsed time and the time in which the action is to be executed

    
 {
//  if(now.hour() >= 17) //Comparing the current time with the Alarm time
//  {uppertemp = uppertempcool;
//   lowertemp = lowertempcool;}
//
//  if(now.hour() < 5) //Comparing the current time with the Alarm time
//  {uppertemp = uppertempcool;
//   lowertemp = lowertempcool;}
//
//  if(now.hour() >= 5 && now.hour < 17) (now.minute() == 0 || now.minute() == 1)) //Comparing the current time with the Alarm time
//   {uppertemp = uppertemphot;
//   lowertemp = lowertemphot;}


if(now.minute() >= 45) //Comparing the current time with the Alarm time
  {uppertemp = uppertempcool;
   lowertemp = lowertempcool;}

  if(now.minute() < 5) //Comparing the current time with the Alarm time
  {uppertemp = uppertempcool;
   lowertemp = lowertempcool;}

  if(now.minute() >= 5 && now.minute() < 45) //Comparing the current time with the Alarm time
   {uppertemp = uppertemphot;
   lowertemp = lowertemphot;}



Serial.print("Uppertemp: "); 
  Serial.print(uppertemp);
  Serial.println(" C"); 


  /*Tank A*/
  
    if(Ta>=uppertemp && HeaterStateA==HIGH)//if temperature above x degrees
    {
      digitalWrite(11, LOW);
      HeaterStateA=LOW;
      delay(30000); //wait 30 seconds from last state
      
    }
    else if(Ta<=lowertemp && HeaterStateA==LOW)//if temperature is under x degrees
    {
      digitalWrite(11, HIGH);
      HeaterStateA=HIGH;
      delay(30000); //wait 30 seconds from last state
    }
    
    

  /*Tank B*/
  
    if(Tb>=uppertemp && HeaterStateB==HIGH)//if temperature above of x degrees
    {
      digitalWrite(13, LOW);
      HeaterStateB=LOW;
      delay(30000); //wait 30 seconds from last state
      
    }
    else if(Tb<=lowertemp && HeaterStateB==LOW)//if temperature is under x degrees
    {
      digitalWrite(13, HIGH);
      HeaterStateB=HIGH;
      delay(30000); //wait 30 seconds from last state
    }
    

  /*Tank C*/
  
     if(Tc>=uppertemp && HeaterStateC==HIGH)//if temperature above of x degrees
    {
      digitalWrite(12, LOW);
      HeaterStateC=LOW;
      delay(30000); //wait 30 seconds from last state
      
    }
    else if(Tc<=lowertemp && HeaterStateC==LOW)//if temperature is under x degrees
    {
      digitalWrite(12, HIGH);
      HeaterStateC=HIGH;
      delay(30000); //wait 30 seconds from last state
    }
    
     

    previousMillis = currentMillis; //"Last time is now" Reset the timeer   
   } // if time passed

   
} // loop
