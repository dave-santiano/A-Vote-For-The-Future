import processing.serial.*;
import controlP5.*;
import de.looksgood.ani.*;
import ddf.minim.*;

Minim minim;
AudioPlayer song;
// GUI variables
ControlP5 cp5;
PImage error_msg, thank_you_msg, vote_cursor;
PFont proggy;
int page, idNumber, timer;
int choice_width = 400;
int choice_height = 100;
int alphaValue = 0;
int ticker_posx;
int ticker_posy;
int timer_last = 0;
int intro_text_size = 50;
int m =0;
double fade_speed = 60;
boolean loaded = false, empty_string_made = false, name_displayed =false, name_done = false, race_sex_displayed = false, race_sex_done = false, district_birthday_displayed = false, district_birthday_done = false, please_vote_responsibly_displayed = false, please_vote_responsibly_done = false, intro_done = false, main_interface_start = false, welcome_text_displayed = false, welcome_text_done = false;
boolean voted_yes = false, voted_no = false;
String ticker_message = "District 6 residents are encountering increased incidents of theft.";
Button[] main_menu_buttons = new Button[6];
Button[] voting_buttons = new Button[2];
Textarea[] voting_prompts = new Textarea[6];
Button back_button , reset_button;

//clicked button handles the last clicked button
String male_first_names[],female_first_names[],name, clicked_button;
String empty_string = "";
// Randomizer and Serial communication variables
Serial myPort;
String sex, race, social_class, birthday, id, message, district;
float sex_probability, race_probability, class_probability, district_probability;
boolean printed = false;

void setup(){
	ticker_posx=width+int(textWidth(ticker_message));
	ticker_posy=height-50;
	// myPort = new Serial(this, "COM19", 9600);
	fullScreen(2);
	vote_cursor = loadImage("cursor.png");
	cursor(vote_cursor,0,0);
	// size(1280,720);
	proggy = createFont("ProggySquareTT", 32);
	textFont(proggy);
	error_msg = loadImage("error_msg.png");
	thank_you_msg = loadImage("thank_you_msg.png");
	noStroke();
	cp5 = new ControlP5(this);
	minim = new Minim(this);
	song = minim.loadFile("patriot.mp3");
	// song.loop(1000);
	voting_interface();
	loaded = true;
	Ani.init(this);
	message = character_generator();
	println(message);
	// myPort.write(message);
}

void draw(){
	// The beginning of the draw loop should have the different introductory sentences, an if statement should cover whether they are drawn or not.
	if (welcome_text_done == false){welcome_text();}
	else if(name_done == false){name_display(name);}
	else if(race_sex_done == false){race_sex_display(race, sex);}
	else if(district_birthday_done == false){district_birthday_display(district, birthday);}
	else if(please_vote_responsibly_done == false){please_vote_responsibly();}
	else if(intro_done == true){voting_interface(); main_interface_start = true;}
	if (main_interface_start == true){
			check_if_idle();
			/////////////////////////////////////// Constant UI header
			background(255);
			textSize(50);
			fill(0,40,104);
			textAlign(CENTER);
			text("Welcome to Patriotopia Voting Terminal #689201, ", width/2-textWidth(name)/2,100);
			fill(224,22,43);
			text(name, width/2 + textWidth("Welcome to Patriotopia Voting Terminal #689201, ")/2,100);
			textSize(20);
			text("Not " + name + "?" +" Click here:", 120,35);
			noStroke();
			rect(0,height-90,width,50);
			///////////////////////////////////////

			/////////////////////////////////////// These lines are here for formatting purposes
			// stroke(0);
			// line(width/4,0,width/4,height);
			// line((width/4)*2,0,(width/4)*2,height);
			// line((width/4)*3,0,(width/4)*3,height);
			// line(0, height/2, width, height/2);
			///////////////////////////////////////


			/////////////////////////////////////// News ticker stuff
			textSize(32);
			fill(255);
			text(ticker_message, ticker_posx, ticker_posy);
			ticker_posx -= 3;
			noStroke();
			fill(0,40,104);
			rect(0,height-90,300,50);
			fill(255);
			textAlign(LEFT);
			textSize(36);
			text("T.JEFFERSON NEWS",10,height-55);
			if (ticker_posx < -int(textWidth(ticker_message))){
				ticker_posx = width+int(textWidth(ticker_message));
			///////////////////////////////////////
		}
		if (voted_yes == true){
			thank_you_msg();
		}
		if (voted_no == true){
			thank_you_msg();
		}
	}
}

void check_if_idle(){
	if (mouseX == pmouseX && mouseY == pmouseY){
		timer_last += 1;
		//Time out after a minute of inactivity(idleness)
		if(timer_last == 3600){
			reset();
		}
	}else{
		timer_last = 0;
	}
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
	message = "NAME: "+ name + "\n" + "BIRTHDAY: " + birthday + "\n" + "RACE: " + race + "\n" + "SEX: " + sex + "\n" + id + "\n" + "DISTRICT: " + district + "\n" + "CLASS: " + social_class + "\n" + "|";
	return message;
}

//Welcome to the voting terminal!
void welcome_text(){
	if(welcome_text_displayed == false && alphaValue<255){
		alphaValue += fade_speed;
		clear_screen();
		textSize(intro_text_size);
		fill(0,alphaValue);
		textAlign(CENTER);
		text("Welcome to", width/2-textWidth(" Patriotopia Voting Terminal #689201")/2,height/2);
		fill(0,40,104,alphaValue);
		text(" Patriotopia ", width/2 + textWidth("Welcome to")/2 - textWidth("Voting Terminal #689201")/2,height/2);
		fill(0, alphaValue);
		text("Voting Terminal #689201", width/2+textWidth("Welcome to Patriotopia ")/2,height/2);
	}else{
		welcome_text_displayed = true;
		alphaValue -= fade_speed;
		clear_screen();
		textSize(intro_text_size);
		fill(0,alphaValue);
		textAlign(CENTER);
		text("Welcome to", width/2-textWidth(" Patriotopia Voting Terminal #689201")/2,height/2);
		fill(0,40,104,alphaValue);
		text(" Patriotopia ", width/2 + textWidth("Welcome to")/2 - textWidth("Voting Terminal #689201")/2,height/2);
		fill(0, alphaValue);
		text("Voting Terminal #689201", width/2+textWidth("Welcome to Patriotopia ")/2,height/2);
		if (alphaValue ==0){
			welcome_text_done = true;
			clear_screen();
		}
	}
}

//You are name
void name_display(String name){
	// fade-in
	if(name_displayed == false && alphaValue<255){
		alphaValue+=fade_speed;
		clear_screen();
		textSize(intro_text_size);
		fill(0,alphaValue);
		textAlign(CENTER);
		text("Our records show you are ",width/2 - textWidth(name)/2,height/2);
		//translate the text to the left the amount of pixels that name takes up
		fill(224,22,43, alphaValue);
		text(name, width/2 +textWidth("Our records show you are ")/2, height/2);
	}
	// fade-out
	else{
		name_displayed = true;
		alphaValue-=fade_speed;
		clear_screen();
		textSize(intro_text_size);
		fill(0,alphaValue);
		textAlign(CENTER);
		text("Our records show you are ",width/2 - textWidth(name)/2,height/2);
		//translate the text to the left the amount of pixels that name takes up
		fill(224,22,43, alphaValue);
		text(name, width/2 +textWidth("Our records show you are ")/2, height/2);
		// stop drawing the name here once opacity is at 0%
		if(alphaValue ==0){
			name_done = true;
			clear_screen();
		}
	}
}

//You are an/a race sex
void race_sex_display(String race, String sex){
	// fade-in
	if(race_sex_displayed == false && alphaValue<255){
		alphaValue+=fade_speed;
		clear_screen();
		textSize(intro_text_size);
		fill(0,alphaValue);
		textAlign(CENTER);
		//gotta be grammatically correct here
		if(race == "Asian" || race == "American Indian or Alaska Native"){
			text("You are an ",width/2 - textWidth(race + ' ' +sex)/2,height/2);
		}else{
			text("You are a ",width/2 - textWidth(race + ' ' +sex)/2,height/2);
		}
		fill(224,22,43, alphaValue);
		if(race == "Asian" || race == "American Indian or Alaska Native"){
			text(race + ' ' + sex, width/2 + textWidth("You are an ")/2, height/2);
		}else{
			text(race + ' ' + sex, width/2 + textWidth("You are a ")/2, height/2);
		}
	}
	// fade-out
	else{
		race_sex_displayed = true;
		alphaValue-=fade_speed;
		clear_screen();
		textSize(intro_text_size);
		fill(0,alphaValue);
		textAlign(CENTER);
		if(race == "Asian" || race == "American Indian or Alaska Native"){
			text("You are an ",width/2 - textWidth(race + ' ' +sex)/2,height/2);
		}else{
			text("You are a ",width/2 - textWidth(race + ' ' +sex)/2,height/2);
		}
		fill(224,22,43, alphaValue);
		if(race == "Asian" || race == "American Indian or Alaska Native"){
			text(race + ' ' + sex, width/2 + textWidth("You are an ")/2, height/2);
		}else{
			text(race + ' ' + sex, width/2 + textWidth("You are a ")/2, height/2);
		}
		// stop drawing the name here once opacity is at 0%
		if(alphaValue ==0){
			race_sex_done = true;
			clear_screen();
		}
	}
}

//Born in district # on ??/??/????
void district_birthday_display(String district, String birthday){
	// fade-in
	if(district_birthday_displayed == false && alphaValue<255){
		alphaValue+=fade_speed;
		clear_screen();
		textSize(intro_text_size);
		fill(0,alphaValue);
		textAlign(CENTER);
		text("Born in ",width/2 - textWidth(district + " on " + birthday + " to the " + social_class + " class")/2,height/2);
		fill(224,22,43, alphaValue);
		text(district, width/2 + textWidth("Born in ")/2 - textWidth(" on " + birthday + " to the " + social_class + " class")/2, height/2);
		fill(0,alphaValue);
		text(" on " , width/2 + textWidth("Born in " + district )/2 - textWidth(birthday + " to the " + social_class + " class")/2, height/2);
		fill(225,22,43,alphaValue);
		text(birthday, width/2 + textWidth("Born in " + district + " on ")/2 - textWidth(" to the " + social_class + " class")/2, height/2);
		fill(0,alphaValue);
		text(" to the ", width/2 + textWidth("Born in " + district + " on " + birthday)/2 - textWidth(social_class + " class")/2, height/2);
		fill(225,22,43,alphaValue);
		text(social_class, width/2 + textWidth("Born in " + district + " on " + birthday + " to the ")/2 - textWidth(" class")/2, height/2);
		fill(0,alphaValue);
		text(" class", width/2 + textWidth("Born in " + district + " on " + birthday + " to the " + social_class)/2, height/2);
		fill(0,alphaValue);
		text('\n' + "in the city of ",width/2 - textWidth("in the city of ")/2, height/2);
		fill(0,40,104,alphaValue);
		text('\n' + "Patriotopia.",width/2 + textWidth("Patriotopia.")/2,height/2);
	}
	// fade-out
	else{
		district_birthday_displayed = true;
		alphaValue-=fade_speed;
		clear_screen();
		textSize(intro_text_size);
		fill(0,alphaValue);
		textAlign(CENTER);
		text("Born in ",width/2 - textWidth(district + " on " + birthday + " to the " + social_class + " class")/2,height/2);
		fill(224,22,43, alphaValue);
		text(district, width/2 + textWidth("Born in ")/2 - textWidth(" on " + birthday + " to the " + social_class + " class")/2, height/2);
		fill(0,alphaValue);
		text(" on " , width/2 + textWidth("Born in " + district )/2 - textWidth(birthday + " to the " + social_class + " class")/2, height/2);
		fill(225,22,43,alphaValue);
		text(birthday, width/2 + textWidth("Born in " + district + " on ")/2 - textWidth(" to the " + social_class + " class")/2, height/2);
		fill(0,alphaValue);
		text(" to the ", width/2 + textWidth("Born in " + district + " on " + birthday)/2 - textWidth(social_class + " class")/2, height/2);
		fill(225,22,43,alphaValue);
		text(social_class, width/2 + textWidth("Born in " + district + " on " + birthday + " to the ")/2 - textWidth(" class")/2, height/2);
		fill(0,alphaValue);
		text(" class", width/2 + textWidth("Born in " + district + " on " + birthday + " to the " + social_class)/2, height/2);
		fill(0,alphaValue);
		text('\n' + "in the city of ",width/2 - textWidth("in the city of ")/2, height/2);
		fill(0,40,104,alphaValue);
		text('\n' + "Patriotopia.",width/2 + textWidth("Patriotopia.")/2,height/2);
		if(alphaValue ==0){
			district_birthday_done = true;
			clear_screen();
		}
	}
}
//Vote responsibly or you don't matter
void please_vote_responsibly(){
	if(please_vote_responsibly_displayed == false && alphaValue<255){
		alphaValue += fade_speed;
		clear_screen();
		textSize(intro_text_size);
		fill(0,alphaValue);
		textAlign(CENTER);
		text("Please vote responsibly.", width/2,height/2);
	}else{
		please_vote_responsibly_displayed = true;
		alphaValue -= fade_speed;
		clear_screen();
		textSize(intro_text_size);
		fill(0,alphaValue);
		textAlign(CENTER);
		text("Please vote responsibly.", width/2,height/2);
		if (alphaValue ==0){
			please_vote_responsibly_done = true;
			// myPort.write(message);
			intro_done = true;
			clear_screen();
		}
	}
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
	else{
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
	int month = int(random(1,12));
	int year = int(random(2170,2240));
	if (month == 1 || month == 2 || month == 4 || month == 6 || month == 7 || month == 9 || month == 12){
		int day = int(random(1,32));
		String birthday = month + "/" + day + "/" + year;
		return birthday;
	}else if (month == 3 || month == 5 || month == 8 || month == 10){
		int day = int(random(1,31));
		String birthday = month + "/" + day + "/" + year;
		return birthday;
	}else if (month == 2){
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
	.setPosition(width/4-100, height/4-50)
	.setCaptionLabel("IMMIGRATION")
	.setSize(choice_width,choice_height)
	.setImages(loadImage("choice_button_test.png"),loadImage("choice_button_test_mouseover.png"),loadImage("choice_button_test.png"))
	// (defaultImage, rolloverImage, pressedImage)
	.updateSize();

	main_menu_buttons[1] = cp5.addButton("choice2")
	.setPosition(width/4-100,(height/4)*2-50)
	.setCaptionLabel("ECONOMICS")
	.setSize(choice_width,choice_height)
	.setImages(loadImage("choice_button_test.png"),loadImage("choice_button_test_mouseover.png"),loadImage("choice_button_test.png"))
	// (defaultImage, rolloverImage, pressedImage)
	.updateSize();

	main_menu_buttons[2] = cp5.addButton("choice3")
	.setPosition(width/4-100,(height/4)*3-50)
	.setCaptionLabel("PATRIOTISM")
	.setSize(choice_width,choice_height)
	.setImages(loadImage("choice_button_test.png"),loadImage("choice_button_test_mouseover.png"),loadImage("choice_button_test.png"))
	// (defaultImage, rolloverImage, pressedImage)
	.updateSize();

	main_menu_buttons[3] = cp5.addButton("choice4")
	.setPosition((width/4)*3+100 - choice_width,height/4-50)
	.setCaptionLabel("ELECTED POSITIONS")
	.setSize(choice_width,choice_height)
	.setImages(loadImage("choice_button_test.png"),loadImage("choice_button_test_mouseover.png"),loadImage("choice_button_test.png"))
	// (defaultImage, rolloverImage, pressedImage)
	.updateSize();

	main_menu_buttons[4] = cp5.addButton("choice5")
	.setPosition((width/4)*3+100 - choice_width,(height/4)*2-50)
	.setCaptionLabel("EDUCATION")
	.setSize(choice_width,choice_height)
	.setImages(loadImage("choice_button_test.png"),loadImage("choice_button_test_mouseover.png"),loadImage("choice_button_test.png"))
	// (defaultImage, rolloverImage, pressedImage)
	.updateSize();

	main_menu_buttons[5] = cp5.addButton("choice6")
	.setPosition((width/4)*3+100 - choice_width,(height/4)*3-50)
	.setCaptionLabel("TERRORISM")
	.setSize(choice_width,choice_height)
	.setImages(loadImage("choice_button_test.png"),loadImage("choice_button_test_mouseover.png"),loadImage("choice_button_test.png"))
	// (defaultImage, rolloverImage, pressedImage)
	.updateSize();

	voting_prompts[0] = cp5.addTextarea("voting_prompt1")
	.setText("The recent ban on immigration into the city has been proven effective. The Department of City Safety and Security advises to continue the ban. Please vote.")
	.setPosition(width/2-480, 300)
	.setSize(960,200)
	.setColorValue(0x00000000)
	.setFont(createFont("ProggySquareTT", 40))
	.hideScrollbar()
	.hide();

	voting_prompts[1] = cp5.addTextarea("voting_prompt2")
	.setText("Recent studies by government economists say that a new commercial zone in District 4 would lead to increased economic growth.\nPlease vote.")
	.setPosition(width/2-480, 300)
	.setSize(960,200)
	.setColorValue(0x00000000)
	.setFont(createFont("ProggySquareTT", 40))
	.hideScrollbar()
	.hide();

	voting_prompts[2] = cp5.addTextarea("voting_prompt3")
	.setText("Isn't Patriotopia the best, liberty-filled, democratic city you have ever had the opportunity to live in?")
	.setPosition(width/2-480, 300)
	.setSize(960,200)
	.setColorValue(0x00000000)
	.setFont(createFont("ProggySquareTT", 40))
	.hideScrollbar()
	.hide();

	voting_prompts[3] = cp5.addTextarea("voting_prompt4")
	.setText("Isn't Patriotopia the best, liberty-filled, democratic city you have ever had the opportunity to live in?")
	.setPosition(width/2-480, 300)
	.setSize(960,200)
	.setColorValue(0x00000000)
	.setFont(createFont("ProggySquareTT", 40))
	.hideScrollbar()
	.hide();

	voting_prompts[4] = cp5.addTextarea("voting_prompt5")
	.setText("Isn't Patriotopia the best, liberty-filled, democratic city you have ever had the opportunity to live in?")
	.setPosition(width/2-480, 300)
	.setSize(960,200)
	.setColorValue(0x00000000)
	.setFont(createFont("ProggySquareTT", 40))
	.hideScrollbar()
	.hide();

	voting_prompts[5] = cp5.addTextarea("voting_prompt6")
	.setText("Isn't Patriotopia the best, liberty-filled, democratic city you have ever had the opportunity to live in?")
	.setPosition(width/2-480, 300)
	.setSize(960,200)
	.setColorValue(0x00000000)
	.setFont(createFont("ProggySquareTT", 40))
	.hideScrollbar()
	.hide();

	voting_buttons[0] = cp5.addButton("voting_button_yes")
	.setPosition(width/2 -480, 600)
	.setImages(loadImage("yes_button.png"),loadImage("yes_button.png"),loadImage("yes_button.png"))
	.setSize(250,175)
	.setCaptionLabel("YES")
	.hide();

	voting_buttons[1] = cp5.addButton("voting_button_no")
	.setPosition(width/2 + 230, 600)
	.setImages(loadImage("no_button.png"),loadImage("no_button.png"),loadImage("no_button.png"))
	.setSize(250,175)
	.setCaptionLabel("NO")
	.hide();

	back_button = cp5.addButton("back")
	.setPosition(width-150, 200)
	.setSize(100,25)
	.hide();

	reset_button = cp5.addButton("reset")
	.setPosition(80, 45)
	.setImages(loadImage("reset_button_test.png"),loadImage("reset_button_test.png"),loadImage("reset_button_test.png"))
	.setSize(60,20);

	intro_done = false;
}

void reset(){
	background(255);
	message = character_generator();
	empty_string_made = false;
	name_displayed =false;
	name_done = false;
	race_sex_displayed = false;
	race_sex_done = false;
	district_birthday_displayed = false;
	district_birthday_done = false;
	please_vote_responsibly_displayed = false;
	please_vote_responsibly_done = false;
	welcome_text_displayed = false;
	welcome_text_done = false;
	intro_done = false;
	main_interface_start = false;
	song.unmute();
	println(message);
}

void error_message(){
	song.mute();
	imageMode(CENTER);
	image(error_msg,width/2,height/2);
	for (int i=0; i<2;i++){		voting_buttons[i].hide();}
	for (int i=0; i<6;i++){		voting_prompts[i].hide();}
								back_button.show();
}

void thank_you_msg(){
	imageMode(CENTER);
	image(thank_you_msg,width/2,height/2);
	for (int i=0; i<2;i++){		voting_buttons[i].hide();}
	for (int i=0; i<6;i++){		voting_prompts[i].hide();}
								back_button.show();
}

//Displays prompts, takes the prompt number as a parameter
void vote_yesno_display(int choice_number){
	for (int i=0; i<6;i++){		main_menu_buttons[i].hide();}
	for (int i=0; i<2;i++){		voting_buttons[i].show();}
								voting_prompts[choice_number].show();
								back_button.show();
}

// These control what happens when you choose each individual voting option
void choice1(){
	if(loaded==true){
		vote_yesno_display(0);
	}
}
void choice2(){
	if(loaded==true){
		vote_yesno_display(1);
	}
}
void choice3(){
	if(loaded==true){
		vote_yesno_display(2);
	}
}
void choice4(){
	if(loaded==true){
		vote_yesno_display(3);
	}
}
void choice5(){
	if(loaded==true){
		vote_yesno_display(4);
	}
}
void choice6(){
	if(loaded==true){
		vote_yesno_display(5);
	}
}

//So right now I am designing the interface to throw an error whenever you press yes or no, rather than at subject choice.
//In doing this I can determine whether your demographic throws an error by if-else statements
void voting_button_yes(){
	if(loaded==true){
		thank_you_msg();
		voted_yes = true;
	}
}
void voting_button_no(){
	if(loaded==true){
		if(clicked_button=="choice3"){
			error_message();
		}else{
			voted_no = true;
		}
	}
}
void back(){
	if(loaded==true){
			for (int i=0; i<6;i++){		main_menu_buttons[i].show();}
			for (int i=0; i<2;i++){		voting_buttons[i].hide();}
			for (int i=0; i<6;i++){		voting_prompts[i].hide();}
										back_button.hide();
		song.unmute();
		voted_yes = false;
		voted_no = false;
		// placed here because it will unmute the song in the case that it is muted by an error message.
		}
}

//so far, clear_screen() only really has to be used once, at the beginning of the introduction but I am still determining the order in which to present
//the user information so I will clean it up later.
void clear_screen(){
	background(255);
		if(loaded==true){
			for (int i=0;i<6;i++){ 		main_menu_buttons[i].hide();}
			for (int i=0;i<2;i++){ 		voting_buttons[i].hide();}
			for (int i=0;i<3;i++){ 		voting_prompts[i].hide();}
										back_button.hide();
										reset_button.hide();
		}
}

//draw_screen() is not really used right now lol, but I have a feeling I might have to at some point? Maybe? I'll eliminate it later if it turns out I don't
void draw_screen(){
	background(255);
		if(loaded==true){
			for (int i=0;i<3;i++){ 		main_menu_buttons[i].show();}
			for (int i=0;i<2;i++){ 		voting_buttons[i].hide();}
			for (int i=0;i<3;i++){ 		voting_prompts[i].hide();}
										back_button.hide();
		}
}