import controlP5.*;
import de.looksgood.ani.*;
ControlP5 cp5;
int page;
boolean loaded = false;
String pages;
Button[] main_menu_buttons = new Button[3];
Textlabel[] voting_prompts = new Textlabel[3];
Button[] voting_buttons = new Button[2];

void setup(){
	size(1280,720);
	noStroke();

	cp5 = new ControlP5(this);
	voting_interface();
	background(255);
	loaded = true;
	Ani.init(this);
	// Put any setup stuff regarding the background after the buttons are created
}

void draw(){

}

void controlEvent(ControlEvent theEvent){
	println(theEvent.getController().getName());
}

void voting_interface(){
	background(0);
	main_menu_buttons[0] = cp5.addButton("choice1")
	.setId(0)
	.setValue(0)
	.setPosition(width/2-200,100)
	.setSize(400,60);
	// .setImages(loadImage("test.png"),loadImage("test.png"),loadImage("test.png"))
	//(defaultImage, rolloverImage, pressedImage)
	// .updateSize()
	//updateSize changes the button area to that of the image, this will be useful later when
	//replacing the buttons with my own custom ones
	main_menu_buttons[1] = cp5.addButton("choice2")
	.setId(1)
	.setValue(0)
	.setPosition(width/2-200,300)
	.setSize(400,60);

	main_menu_buttons[2] = cp5.addButton("choice3")
	.setId(2)
	.setValue(0)
	.setPosition(width/2-200,500)
	.setSize(400,60);

	voting_prompts[0] = cp5.addTextlabel("voting_prompt1")
	.setText("The recent ban on immigration into the city has been proven effective.\nThe Department of City Safety and Security advises to continue the ban.\nPlease vote.")
	.setPosition(width/2-400, 300)
	.setColorValue(0x00000000)
	.setFont(createFont("Inconsolata", 26))
	.hide();

	voting_prompts[1] = cp5.addTextlabel("voting_prompt2")
	.setText("Recent studies by government economists say that a new commercial zone\nin District 4 would lead to increased economic growth.\nPlease vote.")
	.setPosition(width/2-400, 300)
	.setColorValue(0x00000000)
	.setFont(createFont("Inconsolata", 26))
	.hide();

	voting_prompts[2] = cp5.addTextlabel("voting_prompt3")
	.setText("Controversial Shit")
	.setPosition(width/2-400, 300)
	.setColorValue(0x00000000)
	.setFont(createFont("Inconsolata", 26))
	.hide();

	voting_buttons[0] = cp5.addButton("voting_button_yes")
	.setPosition(width/2 -400, 500)
	.setSize(150,100)
	.hide();

	voting_buttons[1] = cp5.addButton("voting_button_no")
	.setPosition(width/2 +250, 500)
	.setSize(150,100)
	.hide();
}

// You can write functions that are named after the buttons, stating what to do after the button is pressed.
void choice1(){
	background(255);
	if(loaded==true){
		for (int i=0; i<3;i++){		main_menu_buttons[i].hide();}
		for (int i=0; i<2;i++){		voting_buttons[i].show();}
									voting_prompts[0].show();
	}
}
void choice2(){
	background(255);
	if(loaded==true){
		for (int i=0; i<3;i++){		main_menu_buttons[i].hide();}
		for (int i=0; i<2;i++){		voting_buttons[i].show();}
									voting_prompts[1].show();
	}
}
void choice3(){
	background(255);
	if(loaded==true){
		for (int i=0; i<3;i++){		main_menu_buttons[i].hide();}
		for (int i=0; i<2;i++){		voting_buttons[i].show();}
									voting_prompts[2].show();
	}
}
void voting_button_yes(){
	background(255);
	if(loaded==true){
		for (int i=0; i<3;i++){		main_menu_buttons[i].show();}
		for (int i=0; i<2;i++){		voting_buttons[i].hide();}
		for (int i=0; i<3;i++){		voting_prompts[i].hide();}
	}
}
void voting_button_no(){
	background(255);
	if(loaded==true){
		for (int i=0; i<3;i++){		main_menu_buttons[i].show();}
		for (int i=0; i<2;i++){		voting_buttons[i].hide();}
		for (int i=0; i<3;i++){		voting_prompts[i].hide();}
	}
}

