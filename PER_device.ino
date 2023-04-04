#include <Servo.h>


#include <AccelStepper.h>


AccelStepper  wheel(8, 10, 11, 12, 13);//this is the stepper motor that moves the revolver
Servo  feeder;//thisis quite obvious:)
int feed_time=3500;//set the milliseconds that you want to feed the bee during the rewarding/punishing period
const byte next_bee = 2;//thisis the digital pin that receives the command from the USB Nidaq to rotate the revolver andmove to the next bee
const byte rotor_encoder = 3;//this pin receives in input the signal that a bee has reached his place in front of the feeder
const byte reward = 4;//this pin received the command to initiated the rewarding procedure in principle it rotates that feeder CCW
const byte punish = 5;//this pin received the command to initiated the punishing procedure. it rotates that feeder CW
const byte feeding = 6; //this pin drives the servo motor that controls the feeeder
bool val = 0;
int ang_rest=90;//resting position of the feeder. It's the angle at which the servo  motor is sitting
int ang_antenna_time=27;//extra angle to which you have to rotate the  feeder in order to stimuulate the antenna
int ang_feed=55;//angle at which the feeder has to move for delivering the reward or the punishment. this is based on the designe of your feeder
//int antenna_time= 800;

void setup() {
  pinMode(next_bee, INPUT);
  pinMode(rotor_encoder, INPUT);
  pinMode(reward, INPUT);
  pinMode(punish, INPUT);

  feeder.attach(feeding);
  feeder.write(ang_rest);
  wheel.setMaxSpeed(1000);
  wheel.setSpeed(-700);
  Serial.begin(115200);
}


void loop() {
  //feed bees: the feeder rotates forth and back first to touch the antenna of the bee with 
  //the sugar-soaked stick and then stop the sugar pad in front of the bee the initial dierection is set by the variable punishment or reward
  if (digitalRead(punish)) {
    feeder.write(ang_rest+ang_feed);
    delay(300);
    for (int i=ang_rest+ang_feed;i<=ang_rest+ang_feed+ang_antenna_time;i++){
    feeder.write(i); 
    delay(20);}
   
   for (int i=ang_rest+ang_feed+ang_antenna_time;i>=ang_rest+ang_feed;i--){
    feeder.write(i); 
    delay(20);}
    
    feeder.write(ang_rest+ang_feed);    
    delay(feed_time);
    feeder.write(ang_rest);
  }
  if (digitalRead(reward)) {
    feeder.write(ang_rest-ang_feed);
    delay(300);
    for (int i=ang_rest-ang_feed;i>=ang_rest-ang_feed-ang_antenna_time;i--){
    feeder.write(i); 
    delay(20);}

    for (int i=ang_rest-ang_feed-ang_antenna_time;i<=ang_rest-ang_feed;i++){
    feeder.write(i); 
    delay(20);}
    
    feeder.write(ang_rest-ang_feed-2);    
    delay(feed_time);
    
    feeder.write(ang_rest);
  }

//move to next bee: if next bee is active the stepper motor is rotated till the rotor encoder is activated 
  if (digitalRead(next_bee)) {unsigned long tin=millis();
    while (1) {
      //
      wheel.runSpeed();
      
      if (!digitalRead(rotor_encoder)&&(millis()-tin)>100 ) {
        val = 1;
      }


      if (digitalRead(rotor_encoder) && val == 1) {
        
        wheel.disableOutputs();
        val = 0;

        break;
      }
    }
  }
}
