import processing.serial.*;
import controlP5.*;
import de.looksgood.ani.*;
// GUI variables
ControlP5 cp5;
PImage error_msg;
int page, idNumber;
boolean loaded = false;
Button[] main_menu_buttons = new Button[3];
Button[] voting_buttons = new Button[2];
Textlabel[] voting_prompts = new Textlabel[3];
Button back_button;
String name, clicked_button;
String male_first_names[],female_first_names[];
// Randomizer and Serial communication variables
Serial myPort;
String sex, race, social_class, birthday, id, message, district;
float sex_probability, race_probability, class_probability, district_probability;
boolean printed = false;

void setup()
{
	// myPort = new Serial(this, "COM16", 9600);
	// fullScreen();
	size(1280,720);
	error_msg = loadImage("error_msg.png");
	noStroke();
	cp5 = new ControlP5(this);
	voting_interface();
	// Load voting interface elements
	background(255);
	loaded = true;
	Ani.init(this);
	// Generate the character data
	message = character_generator();
	println(message);
	// myPort.write(message);
}

void draw()
{
	  textSize(40);
	  fill(224,22,43);
	  textAlign(LEFT);
	  text("Welcome, " + name,50,100);
	  // textSize(25);
	  // text(message,50,200);
	  textSize(40);
	  fill(224,22,43);
	  textAlign(RIGHT);
	  text(id, width - 50, 100);
	  textSize(60);
}

String character_generator(){
	sex_probability = random(0,1);
	race_probability = random(0,1);
	class_probability = random(0,1);
	district_probability = random(0,.96);
	idNumber = int(random(100000, 999999));
	id = "ID#: " + idNumber;
	sex = sex_determiner(sex_probability);
	name = name_determiner(sex);
	race = race_determiner(race_probability);
	social_class = class_determiner(class_probability);
	birthday = birthday_generator();
	district = district_determiner(district_probability);
	message = "NAME: "+ name + "\n" + "BIRTHDAY: " + birthday + "\n" + "RACE: " + race + "\n" + "SEX: " + sex + "\n" + id + "\n" + "CLASS: " + social_class + "\n" + "|";
	return message;
}

//Changed demographics to Pew demographic projections in 2050
String race_determiner(float race_probability){
	if (race_probability <= .47){
		String white = "White";
		return white;
	}
	else if (race_probability > .47 && race_probability < .76)
	{
		String hispanic = "Hispanic";
		return hispanic;
	}
	else if (race_probability > .76 && race_probability <.89)
	{
		String boaa = "Black";
		return boaa;
	}
	else if (race_probability > .89 && race_probability < .98)
	{
		String asian = "Asian";
		return asian;
	}
	else if (race_probability > .98 && race_probability < 1.0)
	{
		String aioan = "American Indian or Alaska Native";
		return aioan;
	}
	// else if (race_probability > .98 && race_probability<1.0)
	// {
	// 	String nhoopi = "Native Hawaiian or Other Pacific Islander";
	// 	// Native Hawaiian or Other Pacific Islander
	// 	return nhoopi;
	// }
	else
	{
		return "";
	}
}

String sex_determiner(float sex_probability){
	if (sex_probability<.50)
	{
		String male = "Male";
		return male;
	}
	else
	{
		String female = "Female";

		return female;
	}
}

String name_determiner(String sex){
	if(sex=="Male"){
		String male_first_names[] = loadStrings("male.txt");
		int ind = floor(random(male_first_names.length));
		name = male_first_names[ind];
		return name;
	}
	else if(sex=="Female"){
		String female_first_names[] = loadStrings("female.txt");
		int ind = floor(random(female_first_names.length));
		name = female_first_names[ind];
		return name;
	}else{
		return "";
	}
}

String class_determiner(float class_probability){
	if(class_probability<=.50)
	{
		String middle_class = "Middle";
		return middle_class;
	}
	else if (class_probability > .5 && class_probability<=.79){
		String lower_class = "Lower";
		return lower_class;
	}
	else if(class_probability > .79 && class_probability <= 1.0){
		String upper_class = "Upper";
		return upper_class;
	}
	else
	{
		return "";
	}
}

String district_determiner(float district_probability){
	if (district_probability < .16){
		String dist1 = "District 1";
		return dist1;
	}
	else if(district_probability >= .16 && district_probability < .32){
		String dist2 = "District 2";
		return dist2;
	}
	else if(district_probability >= .32 && district_probability < .48){
		String dist3 = "District 3";
		return dist3;
	}
	else if(district_probability >= .48 && district_probability < .64){
		String dist4 = "District 4";
		return dist4;
	}
	else if(district_probability >= .64 && district_probability < .80){
		String dist5 = "District 5";
		return dist5;
	}
	else if(district_probability >= .80 && district_probability < .96){
		String dist6 = "District 6";
		return dist6;
	}else{
		return "";
	}
}

String birthday_generator(){
	int month = int(random(0,11));
	int year = int(random(2170,2240));
	if (month == 0 || month == 2 || month == 4 || month == 6 || month == 7 || month == 9 || month == 11){
		int day = int(random(1,32));
		String birthday = month + "/" + day + "/" + year;
		return birthday;
	}else if (month == 3 || month == 5 || month == 8 || month == 10){
		int day = int(random(1,31));
		String birthday = month + "/" + day + "/" + year;
		return birthday;
	}else if (month == 1){
		int day = int(random(1,29));
		String birthday = month + "/" + day + "/" + year;
		return birthday;
	}else{
		return "";
	}
}

void controlEvent(ControlEvent theEvent){
	println(theEvent.getController().getName());
	clicked_button = theEvent.getController().getName();
}

void voting_interface(){
	main_menu_buttons[0] = cp5.addButton("choice1")
	.setPosition(width/2-200, 200)
	.setCaptionLabel("IMMIGRATION")
	.setSize(400,60);
	// .setImages(loadImage("test.png"),loadImage("test.png"),loadImage("test.png"))
	//(defaultImage, rolloverImage, pressedImage)
	// .updateSize()
	//updateSize changes the button area to that of the image, this will be useful later when
	//replacing the buttons with my own custom ones
	main_menu_buttons[1] = cp5.addButton("choice2")
	.setPosition(width/2-200,400)
	.setCaptionLabel("ECONOMICS")
	.setSize(400,60);

	main_menu_buttons[2] = cp5.addButton("choice3")
	.setPosition(width/2-200,600)
	.setCaptionLabel("PATRIOTISM")
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
	.setText("Isn't Patriotopia the best, liberty-filled, democratic city you have\never had the opportunity to live in?")
	.setPosition(width/2-400, 300)
	.setColorValue(0x00000000)
	.setFont(createFont("Inconsolata", 26))
	.hide();

	voting_buttons[0] = cp5.addButton("voting_button_yes")
	.setPosition(width/2 -400, 500)
	.setSize(150,100)
	.setCaptionLabel("YES")
	.hide();

	voting_buttons[1] = cp5.addButton("voting_button_no")
	.setPosition(width/2 +250, 500)
	.setSize(150,100)
	.setCaptionLabel("NO")
	.hide();

	back_button = cp5.addButton("back")
	.setPosition(width-150, height-50)
	.setSize(100,25)
	.hide();
}

// You can write functions that are named after the buttons, stating what to do after the button is pressed.
void choice1(){
	background(255);
	if(loaded==true){
		for (int i=0; i<3;i++){		main_menu_buttons[i].hide();}
		for (int i=0; i<2;i++){		voting_buttons[i].show();}
									voting_prompts[0].show();
									back_button.show();
		if(race == "Hispanic" || race == "American Indian or Alaska Native"){
			imageMode(CENTER);
			image(error_msg,width/2,height/2);
			for (int i=0; i<2;i++){		voting_buttons[i].hide();}
			for (int i=0; i<3;i++){		voting_prompts[i].hide();}
										back_button.show();
		}
	}
}
void choice2(){
	background(255);
	if(loaded==true){
		for (int i=0; i<3;i++){		main_menu_buttons[i].hide();}
		for (int i=0; i<2;i++){		voting_buttons[i].show();}
									voting_prompts[1].show();
									back_button.show();
		if(social_class == "Lower"){
			imageMode(CENTER);
			image(error_msg,width/2,height/2);
			for (int i=0; i<2;i++){		voting_buttons[i].hide();}
			for (int i=0; i<3;i++){		voting_prompts[i].hide();}
										back_button.show();
		}
	}
}
void choice3(){
	background(255);
	if(loaded==true){
		for (int i=0; i<3;i++){		main_menu_buttons[i].hide();}
		for (int i=0; i<2;i++){		voting_buttons[i].show();}
									voting_prompts[2].show();
									back_button.show();
	}
}
void voting_button_yes(){
	background(255);
	if(loaded==true){
		for (int i=0; i<3;i++){		main_menu_buttons[i].show();}
		for (int i=0; i<2;i++){		voting_buttons[i].hide();}
		for (int i=0; i<3;i++){		voting_prompts[i].hide();}
									back_button.hide();
	}
}
void voting_button_no(){
	background(255);
	if(loaded==true && clicked_button!="choice3"){
		for (int i=0; i<3;i++){		main_menu_buttons[i].show();}
		for (int i=0; i<2;i++){		voting_buttons[i].hide();}
		for (int i=0; i<3;i++){		voting_prompts[i].hide();}
									back_button.hide();
	}if(clicked_button=="choice3"){
		imageMode(CENTER);
		image(error_msg,width/2,height/2);
		for (int i=0; i<2;i++){		voting_buttons[i].hide();}
		for (int i=0; i<3;i++){		voting_prompts[i].hide();}
									back_button.show();
	}
}
void back(){
	background(255);
	if(loaded==true){
			for (int i=0; i<3;i++){		main_menu_buttons[i].show();}
			for (int i=0; i<2;i++){		voting_buttons[i].hide();}
			for (int i=0; i<3;i++){		voting_prompts[i].hide();}
										back_button.hide();
		}
}

