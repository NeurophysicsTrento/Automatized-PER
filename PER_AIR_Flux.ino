
const byte air_flux=11;

int lowP = 5;
int highP = 6;
int val0 = 0;
int val1 = 0;

void setup() {
TCCR2B = TCCR2B & B11111000 | B00000011; // for PWM frequency of 3921.16 Hz pin9

 
  pinMode(air_flux,OUTPUT);
  pinMode(lowP,INPUT);
  pinMode(highP,INPUT);
Serial.begin(9600);
 
}


void loop() {
     // read the input pin
   
   
// Serial.println(val1);
 
  //delay(1000);
if(digitalRead(lowP)==1 &&digitalRead(highP)==0) {
  val0 = analogRead(lowP);
  Serial.println("lowP"); 
  analogWrite(air_flux,21);
  //delay(1000);
   }
 
else if(digitalRead(lowP)==0 && digitalRead(highP)==1) {
    analogWrite(air_flux,200);
    //delay(1000);
    val1 = digitalRead(highP);  // read the input pin
    Serial.println("HIghP"); 

   }
else {
    analogWrite(air_flux,25);
    Serial.println("Off");
    //delay(1000);
    
   }

    Serial.println(digitalRead(lowP));
   
      Serial.println(digitalRead(highP));
}
