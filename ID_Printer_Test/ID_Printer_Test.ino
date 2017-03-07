#include <SoftwareSerial.h>
#include <Adafruit_Thermal.h>

#define TX_PIN 6
#define RX_PIN 5

SoftwareSerial mySerial(RX_PIN, TX_PIN);
Adafruit_Thermal printer(&mySerial);

String inputString = "";
boolean stringComplete = false;
boolean lineComplete = false;
boolean allComplete = false;
char val;

void setup() 
{
//initialize serial between the computer and serial between the arduino and printer
  mySerial.begin(9600);
  Serial.begin(9600);
//reserve 200 bytes for the string
  inputString.reserve(600);
  printer.begin();
  printer.justify('C');
//  printer.println("\n\n\n\n\n WORK WORK WORK WORK WORK");
//  printer.println("NAME: CHAD CHADDINGTON");
//  printer.println("BIRTHDAY: 7/16/2176");
//  printer.println("RACE: WHITE");
//  printer.println("SEX: MALE");
//  printer.println("ID: 114818");
//  printer.println("CLASS: MIDDLE");
//  printer.sleep();      // Tell printer to sleep
//  delay(2000L);         // Sleep for 3 seconds
//  printer.wake();       // MUST wake() before printing again, even if reset
//  printer.setDefault(); // Restore printer to defaults
//  printer.println("\n\n\n\n\n");
}

void loop() {
//  if(Serial.available()){
//      val = Serial.read();
//    }
//    if (val == '1'){
//        printer.println("READ");
//      }
//this is for testing purposes, to see if the arduino even gets a message from proceessing
      
  if(stringComplete){
      printer.println(inputString);
      inputString = "";
      delay(2000L);         // Sleep for 2 seconds
      printer.sleep();      // Tell printer to sleep
      printer.wake();       // MUST wake() before printing again, even if reset
      printer.setDefault(); // Restore printer to defaults
      printer.println("\n\n\n\n\n");
      stringComplete = false;
      lineComplete = false;
    }
    
  if(lineComplete){
      printer.println(inputString);
      inputString = "";
      lineComplete = false;
    }
}


void serialEvent(){
    while(Serial.available()){
        char inChar = (char)Serial.read();
        inputString += inChar;
        if (inChar == '\n'){
            lineComplete = true;
          
          }
        if (inChar == '$'){
            stringComplete = true;
          
        }
      }
  }
