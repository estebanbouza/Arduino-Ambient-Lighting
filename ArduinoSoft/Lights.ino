#define LIGHTPIN 3
#define SETON 78
#define SETOFF 70
#define DELAY 1
#define NO_MESSAGE -1
#define HEADER_ANALOG 65       // "A" Used for sending analog state messages (A125, A255...)
#define HEADER_SWITCH 83       // "S" Used for sending digital state messages (S0, S1..)
#define HEADER_PROGRESSIVE 80  // "P" Used to send progressive change messages (P112, P0, P243...)
#define HEADER_SB 75           // "K" Used to send soft blink state messages
#define PROGRESSIVE_DURATION 310
#define PROGRESSIVE_MAX_SLEEP 25
#define SB_MAX_PWR 230          // Soft blink max power
#define SB_MIN_PWR 40
#define SB_PWR_THRESHOLD 40       // If lights power is over this value, don't change soft bling to max power
#define SB_MAX_REPEAT 10        // Dont blink more than X times



int currentPower = 0;

void setup() {
  Serial.begin(115200);
  pinMode(LIGHTPIN, OUTPUT);
}


void turnLightsState(int state) {
  if (state == SETON) {
    digitalWrite(LIGHTPIN, HIGH);
    currentPower = 255;
  } 
  else if (state == SETOFF) {
    digitalWrite(LIGHTPIN, LOW);
    currentPower = 0;
  }

}


void turnLightsPower(int power) {
  analogWrite(LIGHTPIN, power);

  currentPower = power;
}

void turnLightsProgressive(int power) {
  int delta = abs(power - currentPower);
  int sleep = PROGRESSIVE_DURATION / delta + 1;

  if (sleep > PROGRESSIVE_MAX_SLEEP) sleep = PROGRESSIVE_MAX_SLEEP;

  if (currentPower < power) {
    for (int p = currentPower; p <= power; p++) {
      analogWrite(LIGHTPIN, p);
      currentPower = power;
      delay(sleep);
    } 
  } 
  else {
    for (int p = currentPower; p >= power; p--) {
      analogWrite(LIGHTPIN, p);
      currentPower = power;
      delay(sleep);
    } 
  }

}

void softBlink(int times) {
  int prevPower = currentPower;
  int blinkPower = (currentPower <= SB_PWR_THRESHOLD) ? SB_MAX_PWR : currentPower;
  int myTimes = (times > SB_MAX_REPEAT) ? SB_MAX_REPEAT : times;

  for (int i = 0; i < myTimes; i++) {
    turnLightsProgressive(SB_MAX_PWR);
    turnLightsProgressive(SB_MIN_PWR);
  }

  turnLightsProgressive(prevPower);
}

/* Validation and stuff */

void processMessage(int header, int param) {
  switch (header) {
  case HEADER_ANALOG:
    turnLightsPower(param);
    break;
  case HEADER_SWITCH:
    turnLightsState(param);
    break;
  case HEADER_PROGRESSIVE:
    turnLightsProgressive(param);
    break;
  case HEADER_SB:
    softBlink(param);
    break;
  default:
    break;
  }
}

boolean validMessageHeader(int msg) {
  if (msg == HEADER_ANALOG ||
    msg == HEADER_SWITCH ||
    msg == HEADER_PROGRESSIVE ||
    msg == HEADER_SB) {
    return true;
  }
  return false;
}


boolean validMessage(int header, int param) {
  if (header == HEADER_ANALOG && param >= 0 && param <= 255) return true;
  if (header == HEADER_SWITCH && (param == SETON || param == SETOFF)) return true;
  if (header == HEADER_PROGRESSIVE && param >= 0 && param <= 255) return true;
  if (header == HEADER_SB && param >= 0 && param <= 255) return true;
  return false;
}

void loop() {
  int header = -1, param = -1;

  if(Serial.available()) { 
    header = Serial.read();
    if (!validMessageHeader(header)) return;
  }

  if (Serial.available()) {
    param = Serial.read();
    if (!validMessage(header, param)) return;
    processMessage(header, param);
  }

  delay(DELAY);
}














