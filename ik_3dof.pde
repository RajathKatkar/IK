import processing.serial.*;

Serial port;

float l1 = 82.5;
float l2 = 96;
float l3 = 85;
float bodyX = 8;
float a1, a2, a3, x, y, step = 0;
float j = -60;
boolean tok = true;
int[] offs = {115, 65, 75, 55, 105, 115, 130, 80, 125, 65, 20, 65, 55, 140, 130, 130};
int[] s = new int[16];
int[] a = new int[16];
int delayT = 1000;

void setup(){
  size(1081, 631);
  
  port = new Serial(this, "COM11", 9600);
  port.bufferUntil('\n');
}

void draw(){ 
  background(255);
  fill(#00F9FF);
  stroke(200);
  strokeWeight(1);
  
  /*int grid = 20; // change this number to 20 or 50, etc., if you want fewer grid lines
  for (int i = 0; i < width; i += grid) {
    line(i, 0, i, height);
  }
  for (int i = 0; i < height; i += grid) {
    line(0, i, width, i);
  }
  /*for (int i = 0; i < height; i += grid) {
    for (int j = 0; j < width; j += grid) {
      circle(j, i, 4);
    }
  }*/
  
  translate(width/2, height/2);
  
  float x = mouseX-width/2;
  float y = mouseY-height/2;
  
  
  float phi = HALF_PI;
  
  float p2x = x - l3*cos(phi);
  float p2y = y - l3*sin(phi);

  float c2 = (sq(p2x) + sq(p2y) - sq(l1) - sq(l2)) / (2*l1*l2);
  float s2 = sqrt(1 - sq(c2));
  float a2 = atan2(s2, c2);
  
  float c1 = (p2x*(l1+l2*cos(a2)) + l2*sin(a2)*p2y) / (sq(l1)+sq(l2)+2*l1*l2*cos(a2));
  float s1 = (p2y*(l1+l2*cos(a2)) - l2*sin(a2)*p2x) / (sq(l1)+sq(l2)+2*l1*l2*cos(a2));
  float a1 = atan2(s1, c1);

  float a3 = phi - a1 - a2;
  
  stroke(0);
  strokeWeight(5);
  
  line(0, 0, l1*cos(a1), l1*sin(a1));
  line(l1*cos(a1), l1*sin(a1), l1*cos(a1)+l2*cos(a1+a2), l1*sin(a1)+l2*sin(a1+a2));
  line(l1*cos(a1)+l2*cos(a1+a2), l1*sin(a1)+l2*sin(a1+a2), x, y);
  
  strokeWeight(2);
  
  circle(0, 0, 30);
  circle(l1*cos(a1), l1*sin(a1), 15);
  circle(l1*cos(a1)+l2*cos(a1+a2), l1*sin(a1)+l2*sin(a1+a2), 15);
  circle(x, y, 15);
  
  strokeWeight(1);
  fill(255);
  rect(-width/2+20, -height/2+10, 120, 120);
  
  fill(0);
  textSize(20);
  text("a1 : ", -width/2+30, -height/2+35);
  text("a2 : ", -width/2+30, -height/2+75);
  text("a3 : ", -width/2+30, -height/2+115);
  
  fill(#FF0303);
  text(degrees(a1), -width/2+60, -height/2+35);
  text(degrees(a2), -width/2+60, -height/2+75);
  text(degrees(a3), -width/2+60, -height/2+115);  

  for(int i = 0; i < 3; i++){
    s[4*i+1] = int(-85);
    s[4*i+2] = int(100);
    s[4*i+3] = int(80);
  }
  s[13] = int(degrees(a1));
  s[14] = int(degrees(a2));
  s[15] = int(degrees(a3));
  servoWrite(s);
}

void servoWrite(int[] sa){
  for(int i = 0; i < 4; i++){
    a[4*i] = int(offs[4*i]+sa[4*i]);
  }
  for(int i = 0; i <= 1; i++){
    a[8*i+1] = int(offs[8*i+1]-sa[8*i+1]);
    a[8*i+2] = int(offs[8*i+2]+sa[8*i+2]);
    a[8*i+3] = int(offs[8*i+3]+sa[8*i+3]);
  }
  for(int i = 0; i <= 1; i++){
    a[8*i+5] = int(offs[8*i+5]+sa[8*i+5]);
    a[8*i+6] = int(offs[8*i+6]-sa[8*i+6]);
    a[8*i+7] = int(offs[8*i+7]-sa[8*i+7]);
  }
  port.write('A');
  port.write(' ');
  for(int i = 0; i < 16; i++){
    port.write(str(a[i]));
    port.write(' ');
  }
  port.write('x');
  delay(10);
}
