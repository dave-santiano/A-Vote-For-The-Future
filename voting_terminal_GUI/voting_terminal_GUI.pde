import controlP5.*;
ControlP5 cp5;


void setup(){
	size(1280,720);
	noStroke();
	background(255);
	cp5 = new ControlP5(this);
	cp5.addButton("Vote Choice 1")
	.setValue(0)
	.setPosition(width/2 - 320,100)
	.setSize(400,40);
	cp5.addButton("Vote Choice 2")
	.setValue(0)
	.setPosition(width/2 + 320,100)
	.setSize(400,40);
}

void draw(){

}