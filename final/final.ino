#include<dht.h>
dht DHT;
#include <SD.h>
#define DHT11_PIN 3

void setup() {

Serial.begin(9600);
pinMode(11,INPUT);
pinMode(12,INPUT);

//Serial.println("welcome to TechPonder Humidity and temperature Detector"); 
}

void loop() { 

if((digitalRead(11)==1)||(digitalRead(12)==1)){
      Serial.println("Please connect for result.");
  }
else{
int chk = DHT.read11(DHT11_PIN);

Serial.println("Heart rate voltage value:");
Serial.println(analogRead(A1));
 

Serial.println(" Humidity " );

Serial.println(DHT.humidity, 1);

Serial.println(" Temparature ");

Serial.println(DHT.temperature, 1);
int heartrate = (analogRead(A1));
int humidity = (DHT.humidity);
int temperature = (DHT.temperature);

//Serial.end();
delay(100);

  
  String datastring1 = "";
  
  String datastring2 = "";
  
  String datastring3 = "";
  datastring1 += String(heartrate);
  datastring2 += String(humidity);
  datastring3 += String(temperature);


File heart = SD.open("heart.txt", FILE_WRITE);
heart.println(datastring1);

File hum = SD.open("humidity.txt", FILE_WRITE);
hum.println(datastring1);

File temperature1 = SD.open("temperature.txt", FILE_WRITE);
temperature1.println(datastring1);

}
}
