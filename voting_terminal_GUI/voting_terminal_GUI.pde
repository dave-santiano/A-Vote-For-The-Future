import controlP5.*;
import de.looksgood.ani.*;
ControlP5 cp5;

void setup(){
	size(1280,720);
	noStroke();
	background(255);
	cp5 = new ControlP5(this);


}

void draw(){
	background(255);

}

public void controlEvent(ControlEvent theEvent){
	println(theEvent.getController().getName());
	println(theEvent.getController().isActive());
}

void page0(){
	background(255);
	cp5.addButton("choice1")
	.setId(0)
	.setValue(0)
	.setPosition(width/2-200,100)
	.setSize(400,60);
	// .setImages(loadImage("test.png"),loadImage("test.png"),loadImage("test.png"))
	//(defaultImage, rolloverImage, pressedImage)
	// .updateSize()
	//updateSize changes the button area to that of the image, this will be useful later when
	//replacing the buttons with my own custom ones

	cp5.addButton("choice2")
	.setId(1)
	.setValue(0)
	.setPosition(width/2-200,200)
	.setSize(400,60);

	cp5.addButton("choice3")
	.setId(1)
	.setValue(0)
	.setPosition(width/2-200,300)
	.setSize(400,60);
}

void pageSelector(){
	switch(page){
	case

	}
}