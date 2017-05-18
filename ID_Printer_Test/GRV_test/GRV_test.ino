void setup() {
  Serial.begin(9600);
}

void loop() {
  int a = analogRead(0) / 4;
  //  Serial.println(a);
  if (Serial.available() > 0) {
    byte inbyte = Serial.read();
    if (inbyte == 'a') {
      Serial.write(a);
    }
  } else {
    Serial.println(a);
  }
  delay(50);
}
