import processing.serial.*;
import controlP5.*;
import de.looksgood.ani.*;
import ddf.minim.*;

Minim minim;
AudioPlayer song;
AniSequence voting_sequence;
// GUI variables
ControlP5 cp5;
PImage error_msg, thank_you_msg, vote_cursor, checkmark;
PFont proggy;
int page, idNumber, timer;
int choice_width = 400;
int choice_height = 100;
int alphaValue = 255;
int ticker_1_posx;
int ticker_1_posy;
int ticker_2_posx;
int ticker_2_posy;
int idle_timer = 0;
int error_timer = 0;
int intro_text_size = 50;
float fade_speed = 60; //determines overall fade-in and fade-out speed
float animation_x = 0, animation_y = 0;
//these booleans display whether the different elements of the introduction are done or not.
boolean loaded = false, name_displayed =false, name_done = false, race_sex_displayed = false, race_sex_done = false, district_birthday_displayed = false, district_birthday_done = false, please_vote_responsibly_displayed = false, please_vote_responsibly_done = false, intro_done = false, main_interface_start = false, welcome_text_displayed = false, welcome_text_done = false;
//
boolean voted_yes_thanks = false, voted_no_thanks = false, voted_yes_error = false, voted_no_error = false; //voted yes and voted no are for drawing the thank you message in the draw loop
String ticker_message_part_1 = "District 6 residents are reporting increased incidents of theft in its Economic Recovery Zone, please be aware of your belongings. The new Recreational Zone of District 3 boasts a new sports complex. Riots from minority groups in District 4 destroy local playground. "; //message for the news ticker
String ticker_message_part_2 = "District 2's new 40 mile water front boasts ten new shopping malls and two pools that look like beaches. District 1's new Patriot Wall successfully containing riots from District 4. ";

//determines which button has been picked
boolean choice_1_picked = false, choice_2_picked = false, choice_3_picked = false, choice_4_picked = false, choice_5_picked = false, choice_6_picked = false;

boolean on_main_screen = false;//checks to see if on the main screen of the voting terminal, this is used to mainly render out the checkmarks, but it can be used to render out any elements that you just want on the main screen.

//Arrays for holding the various menu items
Button[] main_menu_buttons = new Button[6];
Button[] voting_buttons = new Button[2];
Textarea[] voting_prompts = new Textarea[6];
Button reset_button, begin_button;
//
int vote_count=0;
int last_voted_choice;
//clicked button handles the last clicked button
String male_first_names[],female_first_names[],name, clicked_button;

// Randomizer and Serial communication variables
Serial myPort;
String sex, race, social_class, birthday, id, message, district;
float sex_probability, race_probability, class_probability, district_probability;
boolean voting_sequence_stopped = false;
boolean idle = true, begin = false, ended = false;

void setup(){
	//ticker position has to be set here since the width and height system
	//variables don't get instantiated until processing calls the setup function.
	// myPort = new Serial(this, "COM19", 9600);
	fullScreen(1);
	vote_cursor = loadImage("cursor.png"); // load custom cursor
	cursor(vote_cursor,0,0); //(image, clickcoordinatex, clickcoordinatey)
	voting_sequence = new AniSequence(this); //start a new animation sequence
	proggy = createFont("ProggySquareTT", 32); ///load the font
	textFont(proggy);
	error_msg = loadImage("error_msg.png"); //load error and thank you messages
	thank_you_msg = loadImage("thank_you_msg.png");
	checkmark = loadImage("checkmark.png");
	cp5 = new ControlP5(this); //load the GUI library
	minim = new Minim(this);
	song = minim.loadFile("patriot.mp3"); //load background music and loop a ton of times.
	// song.loop(1000);
	message = character_generator(); //message with character data for receipt printer
	voting_interface();
	loaded = true; //loaded makes sure that all the voting interface elements are loaded.
				   //This is so that there aren't any clashes with any of the variables
				   //that the voting interface uses.
	Ani.init(this);
	/////////////////////////////////////// Animation sequences
	animation_sequence_instantiator();
	///////////////////////////////////////
	//You have to measure textWidth after loading your font otherwise you will get different
	//values.
	ticker_1_posx= 0;
	ticker_1_posy= height-50;
	ticker_2_posx= int(textWidth(ticker_message_part_1));
	ticker_2_posy= height-50;
	// myPort.write(message);
}

void draw(){
	if(vote_count == 6){ended = true;}
	// The beginning of the draw loop has the different introductory sentences, an if statement should cover whether they are drawn or not.
	if (ended == true){ending_screen();}
		else if(idle == true && ended == false){idled_screen();on_main_screen = false;}
		else if(idle == false && welcome_text_done == false){welcome_text();}
		else if(name_done == false){name_display(name);}
		else if(race_sex_done == false){race_sex_display(race, sex);}
		else if(district_birthday_done == false){district_birthday_display(district, birthday);}
		else if(please_vote_responsibly_done == false){please_vote_responsibly();}
		else if(intro_done == true){voting_interface();begin_button.hide();main_interface_start = true;	on_main_screen = true;}

	//introduction display end\\
	if (main_interface_start == true){
			check_if_idle();
			/////////////////////////////////////// Constant UI header
			background(255);
			check_mark_drawer();
			textSize(50);
			fill(0,40,104);
			textAlign(CENTER);
			text("Welcome to Patriotopia Voting Terminal #689201, ", width/2-textWidth(name)/2,100);
			fill(224,22,43);
			text(name, width/2 + textWidth("Welcome to Patriotopia Voting Terminal #689201, ")/2,100);
			if(on_main_screen==true){
				textSize(40);
				fill(0,40,104,175);
				text("Today's voting topics are: ", width/2, 150);
			}else{
				textSize(40);
				fill(0,40,104,175);
				text("Please vote.", width/2, 150);
			}
			textSize(20);
			text("Not " + name + "?" +" Click here:", 120,35);
			fill(224,22,43);
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

			/////////////////////////////////////// News ticker
			textSize(32);
			fill(255);
			textAlign(LEFT);
			text(ticker_message_part_1, ticker_1_posx, ticker_1_posy);
			text(ticker_message_part_2, ticker_2_posx, ticker_2_posy);
			println("TICKER 1 POS" + ticker_1_posx);
			println("TICKER 2 POS" + ticker_2_posx);

			if (ticker_1_posx < -int(textWidth(ticker_message_part_1))){
				ticker_1_posx = ticker_2_posx + int(textWidth(ticker_message_part_2));
			}
			else if(ticker_1_posx > 0){
				ticker_2_posx -=3;
				ticker_1_posx = ticker_2_posx + int(textWidth(ticker_message_part_2));
			}else{
				ticker_1_posx -= 3;
				ticker_2_posx = ticker_1_posx + int(textWidth(ticker_message_part_1));
			}
			noStroke();
			fill(0,40,104);
			rect(0,height-90,300,50);
			fill(255);
			textAlign(LEFT);
			textSize(36);
			text("T.JEFFERSON NEWS",10,height-55);
			///////////////////////////////////////


			//These booleans allow the thank you/error messages to draw continuously in the draw loop
			if (voted_yes_thanks == true){
				thank_you_msg();
			}
			if (voted_no_thanks == true){
				thank_you_msg();
			}
			if (voted_yes_error == true){
				error_message();
			}
			if (voted_no_error == true){
				error_message();
			}
			if(voting_sequence.isEnded() == true && voting_sequence_stopped == false){
				for (int i=0; i<6;i++){		main_menu_buttons[i].show();}
				for (int i=0; i<2;i++){		voting_buttons[i].hide();}
				for (int i=0; i<6;i++){		voting_prompts[i].hide();}
				song.unmute();
				voted_yes_thanks = false; //set these two to false to stop rendering the messages
				voted_no_thanks = false;
				voting_sequence_stopped = true;
				vote_count += 1;
				on_main_screen = true;
			}
	}
}

//This just calls all the character generation functions and gathers the
//return values from them, and places them into a string called message.
//message gets written serially to the receipt printer.
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
//idled screen also serves as the beginning screen as well
void idled_screen(){
	main_interface_start = false;
	on_main_screen = false;
	clear_screen();
	textSize(intro_text_size);
	fill(0, alphaValue);
	textAlign(CENTER);
	text("Click here to begin: ", width/2, height/2);
	if (begin == true) {
		alphaValue -= fade_speed;
		if (alphaValue < 0){
			idle = false;
			begin = false;
			reset();
		}
	}
}

//placeholder ending screen
void ending_screen(){
	main_interface_start = false;
	on_main_screen = false;
	alphaValue = 255;
	clear_screen();
	textSize(intro_text_size);
	fill(0,alphaValue);
	textAlign(CENTER);
	text("THIS IS THE END PLACEHOLDER",width/2,height/2);
}

void check_mark_drawer(){
		if(on_main_screen == true && choice_1_picked == true){
			image(checkmark, width/4-175, height/4, 100,100);
			main_menu_buttons[0].lock();
		}
		if(on_main_screen == true && choice_2_picked == true){
			image(checkmark, width/4-175, (height/4)*2, 100,100);
			main_menu_buttons[1].lock();
		}
		if(on_main_screen == true && choice_3_picked == true){
			image(checkmark, width/4-175, (height/4)*3, 100,100);
			main_menu_buttons[2].lock();
		}
		if(on_main_screen == true && choice_4_picked == true){
			image(checkmark, width/2+100, height/4, 100,100);
			main_menu_buttons[3].lock();
		}
		if(on_main_screen == true && choice_5_picked == true){
			image(checkmark, width/2+100, (height/4)*2, 100,100);
			main_menu_buttons[4].lock();
		}
		if(on_main_screen == true && choice_6_picked == true){
			image(checkmark, width/2+100, (height/4)*3, 100,100);
			main_menu_buttons[5].lock();

		}
}
//These functions handle the display of the intro.\\
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
//Intro display functions end\\

//The following functions generate the character information\\
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
//character generation functions end\\


//stores the latest pressed button into a variable called clicked_button
void controlEvent(ControlEvent theEvent){
	println(theEvent.getController().getName());
	clicked_button = theEvent.getController().getName();
}

//begins the voting sequence, whether from idle or from start-up
void begin_button(){
	begin_button.hide();
	begin = true;
}

//populates the voting interface buttons and text on the screen, and also places them into respective arrays.
void voting_interface(){
	begin_button = cp5.addButton("begin_button")
	.setPosition(width/2-120,height/2+30)
	.setImages(loadImage("begin_button_test.png"),loadImage("begin_button_test.png"),loadImage("begin_button_test.png"))
	.setSize(200,50)
	.updateSize();

	main_menu_buttons[0] = cp5.addButton("choice1")
	.setPosition(width/4-100, height/4-50)
	.setSize(choice_width,choice_height)
	.setImages(loadImage("immigration_button.png"),loadImage("immigration_button_mouseover.png"),loadImage("immigration_button.png"))
	// (defaultImage, rolloverImage, pressedImage)
	.updateSize();

	main_menu_buttons[1] = cp5.addButton("choice2")
	.setPosition(width/4-100,(height/4)*2-50)
	.setSize(choice_width,choice_height)
	.setImages(loadImage("economics_button.png"),loadImage("economics_button_mouseover.png"),loadImage("economics_button.png"))
	// (defaultImage, rolloverImage, pressedImage)
	.updateSize();

	main_menu_buttons[2] = cp5.addButton("choice3")
	.setPosition(width/4-100,(height/4)*3-50)
	.setSize(choice_width,choice_height)
	.setImages(loadImage("patriotism_button.png"),loadImage("patriotism_button_mouseover.png"),loadImage("choice_button_test.png"))
	// (defaultImage, rolloverImage, pressedImage)
	.updateSize();

	main_menu_buttons[3] = cp5.addButton("choice4")
	.setPosition((width/4)*3+100 - choice_width,height/4-50)
	.setSize(choice_width,choice_height)
	.setImages(loadImage("elected_button.png"),loadImage("elected_button_mouseover.png"),loadImage("elected_button.png"))
	// (defaultImage, rolloverImage, pressedImage)
	.updateSize();

	main_menu_buttons[4] = cp5.addButton("choice5")
	.setPosition((width/4)*3+100 - choice_width,(height/4)*2-50)
	.setSize(choice_width,choice_height)
	.setImages(loadImage("education_button.png"),loadImage("education_button_mouseover.png"),loadImage("education_button.png"))
	// (defaultImage, rolloverImage, pressedImage)
	.updateSize();

	main_menu_buttons[5] = cp5.addButton("choice6")
	.setPosition((width/4)*3+100 - choice_width,(height/4)*3-50)
	.setSize(choice_width,choice_height)
	.setImages(loadImage("abortion_button.png"),loadImage("abortion_button_mouseover.png"),loadImage("abortion_button.png"))
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
	.setText("ELECTIONELECTIONELECTIONELECTIONELECTIONELECTIONELECTIONELECTIONELECTIONELECTIONELECTIONELECTIONELECTIONELECTIONELECTION")
	.setPosition(width/2-480, 300)
	.setSize(960,200)
	.setColorValue(0x00000000)
	.setFont(createFont("ProggySquareTT", 40))
	.hideScrollbar()
	.hide();

	voting_prompts[5] = cp5.addTextarea("voting_prompt6")
	.setText("ABORTIONABORTIONABORTIONABORTIONABORTIONABORTIONABORTIONABORTIONABORTIONABORTIONABORTIONABORTIONABORTIONABORTIONABORTION")
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

	reset_button = cp5.addButton("reset")
	.setPosition(80, 45)
	.setImages(loadImage("reset_button_test.png"),loadImage("reset_button_test.png"),loadImage("reset_button_test.png"))
	.setSize(60,20);

	intro_done = false;
}

//Displays prompts, takes the prompt number as a parameter
void vote_yesno_display(int choice_number){
	last_voted_choice = choice_number;
	for (int i=0; i<6;i++){		main_menu_buttons[i].hide();}
	for (int i=0; i<2;i++){		voting_buttons[i].show();}
								voting_prompts[choice_number].show();
								on_main_screen = false;
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
//voting choices functions end\\

//So right now I am designing the interface to throw an error whenever you press yes or no, rather than at subject choice.
//In doing this I can determine whether your demographic throws an error by if-else statements
void voting_button_yes(){
	if(loaded==true){
		if (clicked_button == "choice1"){
			choice_1_picked = true;
		}
		if (clicked_button == "choice2"){
			choice_2_picked = true;
		}
		if (clicked_button == "choice3"){
			choice_3_picked = true;
		}
		if (clicked_button == "choice4"){
			choice_4_picked = true;
		}
		if (clicked_button == "choice5"){
			choice_5_picked = true;
		}
		if (clicked_button == "choice6"){
			choice_6_picked = true;
		}
		voting_sequence_stopped = false;
		thank_you_msg();
		voting_sequence.start();
		voted_yes_thanks = true;
	}
}

void voting_button_no(){
	if(loaded==true){
		if (clicked_button == "choice1"){
			choice_1_picked = true;
		}
		if (clicked_button == "choice2"){
			choice_2_picked = true;
		}
		if (clicked_button == "choice3"){
			choice_3_picked = true;
		}
		if (clicked_button == "choice4"){
			choice_4_picked = true;
		}
		if (clicked_button == "choice5"){
			choice_5_picked = true;
		}
		if (clicked_button == "choice6"){
			choice_6_picked = true;
		}
		if(clicked_button=="choice3"){
			voted_no_error = true;
		}else{
			voting_sequence_stopped = false;
			thank_you_msg();
			voting_sequence.start();
			voted_no_thanks = true;
		}
	}
}

// draws the thank you message
void thank_you_msg(){
	imageMode(CENTER);
	image(thank_you_msg,width/2,height/2,animation_x,animation_y);
	on_main_screen = false;
	for (int i=0; i<2;i++){		voting_buttons[i].hide();}
	for (int i=0; i<6;i++){		voting_prompts[i].hide();}
}

// draws the error message
void error_message(){
	if (error_timer < 300){
		song.mute();
		clear_screen();
		imageMode(CENTER);
		image(error_msg,width/2,height/2);
		for (int i=0; i<2;i++){		voting_buttons[i].hide();}
		for (int i=0; i<6;i++){		voting_prompts[i].hide();}
		error_timer += 1;
	}else{
		voted_no_error = false;
		voted_yes_error = false;
		vote_count += 1;
		error_timer = 0;
		song.unmute();
		for (int i=0; i<6;i++){		main_menu_buttons[i].show();}
		for (int i=0; i<2;i++){		voting_buttons[i].hide();}
		for (int i=0; i<6;i++){		voting_prompts[i].hide();}
									reset_button.show();
									on_main_screen = true;
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
										reset_button.hide();
		}
}

//draw_screen() is not really used right now, but I have a feeling I might have to at some point? Maybe? I'll eliminate it later if it turns out I don't
void draw_screen(){
	background(255);
		if(loaded==true){
			for (int i=0;i<3;i++){ 		main_menu_buttons[i].show();}
			for (int i=0;i<2;i++){ 		voting_buttons[i].hide();}
			for (int i=0;i<3;i++){ 		voting_prompts[i].hide();}

		}
}

//Time out after a minute of inactivity(idleness)
void check_if_idle(){
	if (mouseX == pmouseX && mouseY == pmouseY){
		idle_timer += 1;
		if(idle_timer == 3600){
			begin_button.show();
			alphaValue = 255;
			idle = true;
		}
	}else{
		idle_timer = 0;
	}
}

//resets everything, sets everything back to false
void reset(){
	background(255);
	for (int i=0;i<6;i++){main_menu_buttons[i].unlock();}
	message = character_generator();
	alphaValue = 0;
	vote_count = 0;
	choice_1_picked = false;
	choice_2_picked = false;
	choice_3_picked = false;
	choice_4_picked = false;
	choice_5_picked = false;
 	choice_6_picked = false;
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
	if (idle == true){
		begin_button.show();
	}
	if (idle == false){
		begin_button.hide();
	}
	song.unmute();
	println(message);
}

//instantiate the animation sequences that the thank you messages use
void animation_sequence_instantiator(){
	voting_sequence.beginSequence();
	voting_sequence.beginStep();
	voting_sequence.add(Ani.to(this, 1.0, "animation_x", 1000, Ani.BACK_OUT));
	voting_sequence.add(Ani.to(this, 1.0, "animation_y", 300, Ani.BACK_OUT));
	voting_sequence.endStep();
	voting_sequence.beginStep();
	voting_sequence.add(Ani.to(this, .50, 2, "animation_x", 0, Ani.QUAD_OUT));
	voting_sequence.add(Ani.to(this, .50, 2, "animation_y", 0, Ani.QUAD_OUT));
	voting_sequence.endStep();
	voting_sequence.endSequence();
}