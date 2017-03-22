#include <SoftwareSerial.h>
#include <Adafruit_Thermal.h>

#define TX_PIN 6
#define RX_PIN 5

SoftwareSerial mySerial(RX_PIN, TX_PIN);
Adafruit_Thermal printer(&mySerial);

String inputString = "";
boolean stringComplete = false;
boolean lineComplete = false;
char val;
String inString = "";

void setup() 
{
//initialize serial between the computer and serial between the arduino and printer
  mySerial.begin(9600);
  Serial.begin(9600);
//reserve 200 bytes for the string
  inputString.reserve(200);
  printer.begin();
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
      printer.justify('C');
      printer.println(inputString); //Print the whole entire string
      inputString = "";     // Make sure to empty it or else it will start filling up the whole entire receipt thing.
      delay(2000L);         // Sleep for 2 seconds.
      printer.sleep();      // Tell printer to sleep
      printer.wake();       // MUST wake() before printing again, even if reset
      printer.setDefault(); // Restore printer to defaults
      printer.println("\n\n\n\n");//Looking back at it, I should have realized that the printer could have read
                                    //Looking back at it, I should have realized that the printer could have read
                                    //'\n' characters, since I was feeding it a string of '\n' characters this 
                                    //whole time.
                                    //...
                                    //I hate myself.
      stringComplete = false;
      lineComplete = false;
      //"This is the first line \n this is the second line
  }
  if(lineComplete){
      delay(200);
      printer.println(inputString);
      inputString = "";  
      lineComplete = false;
    }
}


void serialEvent(){
    while(Serial.available()){
        char inChar = (char)Serial.read();
        inputString += inChar;
//        if (inChar == '\n'){
//            lineComplete = true;
//          }
// The printer automatically reads '\n' characters, whowuddathunkit.
//SOOOO, no need for detecting if there are '\n' characters or not, which is probably
//what was fucking everything up.

        if (inChar == '|'){
            stringComplete = true;
        }

      }
  }
