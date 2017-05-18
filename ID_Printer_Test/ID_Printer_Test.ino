#include <SoftwareSerial.h>
#include <Adafruit_Thermal.h>

#define TX_PIN 6
#define RX_PIN 5

SoftwareSerial mySerial(RX_PIN, TX_PIN);
Adafruit_Thermal printer(&mySerial);

String inputString = "";
boolean stringComplete = false;

void setup()
{
  //initialize serial between the computer and serial between the arduino and printer
  mySerial.begin(9600);
  Serial.begin(9600);
  //reserve 200 bytes for the string
  inputString.reserve(200);
  printer.begin();
}

void loop() {
  if (stringComplete) {
    printer.justify('C');
    printer.println(inputString); //Print the whole entire string
    inputString = "";     // Make sure to empty it or else it will start filling up inputString with junk.
    delay(2000L);         // Sleep for 2 seconds.
    printer.sleep();      // Tell printer to sleep
    printer.wake();       // MUST wake() before printing again, even if reset
    printer.setDefault(); // Restore printer to defaults
    printer.println("\n\n\n\n");
                                //Looking back at it, I should have realized that the printer could have read
                                //'\n' characters, since I was feeding it a string of '\n' characters this
                                //whole time.
                                //...
                                //I hate myself.
    stringComplete = false;
  }
}

void serialEvent() {
  while (Serial.available()) {
    char inChar = (char)Serial.read();
    inputString += inChar;
    if (inChar == '|') {
      stringComplete = true;
    }
  }
}
