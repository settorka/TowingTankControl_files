#include <DFRobot_HX711.h>
void setup()
{
  Serial.begin(9600);

  // servo driver
  pinMode(2, OUTPUT); // DIR +
  pinMode(3, OUTPUT); // DIR -
  pinMode(4, OUTPUT); // PUL +

  //default
  float y_speed = 0.055;
  maxLength_yStage = 500; //mm
  float x_speed  = 30.0; // mm/min

  //Load Cell
  pinMode(2, OUTPUT); // DATA
  pinMode(3, OUTPUT); // SCK/CLK
  float gravity = 10.0;
  DFRobot_HX711 MyScale(A1, A2);
  //calibrate weight
  calibrateLC();
  // variables
  force  = 0; // N
  timeStamped = 0; // seconds

  digitalWrite(2, HIGH); //Allows the motor to move forward (test)
  digitalWrite(3, LOW);




}

void loop()
{
  // this will move the motor using pulses.
  motion_yAxis(x_speed);
  motion_xAxis(y_speed);


}



void motion_xAxis(x_speed) {
  if (x_speed == 0 || x_speed > 35) {
    digitalWrite(4, LOW);
  }
  else {
    // length in mm
    protectedLength = round(2400 - (2400 / 14.3)); //  time taken to traverse tank at max speed (14.3s)

    traversalCount = round((speed / 35) * protectedLength)); // max speed is 35 mm/min

    delayed = round(60 * x_speed / 35);
    if (traversalCount <= protectedLength) {
    // step motor
      digitalWrite(4, LOW);
      digitalWrite(4, HIGH);
      delayMicroseconds(delayed);
      traversalCount++;
      force = MyScale.readWeight() * gravity
      timeSec++;//
      delay(1000 - delayed);
      

    }
    else {
      
      digitalWrite(4, LOW);
      digitalWrite(3, HIGH); //Allows the motor to move in reverse
      digitalWrite(2, LOW);
      
      if (traversalCount != 0) {
        while (traversalCount > 0) {   
          digitalWrite(4, LOW);
          digitalWrite(4, HIGH);  
          delay(delayed);
          traversalCount--; 
        }
      }
    }
  }
  
  void calibrateLC() {
    // oins A1 and A2 are initialised as scale
    // Set the calibration
    MyScale.setCalibration(1992);

  }
  void determineForce() {
    int gravity = 10;
    Serial.print(MyScale.readWeight()*gravity, 1);
    Serial.println(" N");
    delay(delayed);
  }
  void resetCarriage() {



  }
}

void countTime() {

}
}
