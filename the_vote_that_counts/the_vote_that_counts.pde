import processing.serial.*;
import controlP5.*;
import de.looksgood.ani.*;
import ddf.minim.*;

// Library instantiate
Minim minim;
AudioPlayer middle_song, lower_song, upper_song, error_sound, reward_sound;
AniSequence voting_sequence;
ControlP5 cp5;
PFont proggy;
PImage error_msg, thank_you_msg, vote_cursor, checkmark, place_holder_ID, asian_male_face;

String[] male_face_names = {"asian_male_face.jpg", "black_male_face.jpg", "hispanic_male_face.jpg", "white_male_face.jpg"};
String[] female_face_names = {"asian_female_face.jpg", "black_female_face.jpg", "hispanic_female_face.jpg", "white_female_face.jpg"};
PImage[] male_faces = new PImage[male_face_names.length];
PImage[] female_faces = new PImage[female_face_names.length];



// Fading and animation variables
int alphaValue = 255;
float fade_speed = 10;
int ticker_1_posx, ticker_2_posx, ticker_posy;
float animation_x = 0, animation_y = 0;

// Timers
int idle_timer = 0, error_timer = 0, error_timer_time;

// Arrays for holding the menu items
Button[] voting_buttons = new Button[2];
Textarea[] upper_voting_prompts = new Textarea[6];
Textarea[] lower_voting_prompts = new Textarea[6];
Button reset_button, begin_button;

// Arrays for holding names
String male_first_names[], female_first_names[],name, clicked_button;

// Serial communication
Serial myPort;

// Character generation variables
String sex, race, social_class, birthday, district, message, id;
float sex_probability, race_probability, class_probability, district_probability;

// Ticker messages
String ticker_message_part_1 = "District 6 residents are reporting increased incidents of robbery in its Economic Recovery Zone, please be aware of your belongings. The new Recreational Zone of District 3 opens Donald Trump Stadium on top of the burnt remains of the Barack Obama Public Library. Riots from minority groups in District 4 destroy local playground. "; //message for the news ticker
String ticker_message_part_2 = "District 2's new 40 mile water front boasts ten new shopping malls and two pools that look like beaches. District 1's new Patriot Wall successfully containing riots from District 4. ";

//voting sequence counters
int upper_middle_counter = 0;
int lower_counter = 0;

//boolfools
boolean loaded = false;
boolean voting_sequence_playing = false;
boolean voted_yes_thanks=false, voted_no_thanks=false, voted_yes_error=false, voted_no_error=false, on_main_screen=false;
boolean idle = false;
boolean upper_middle_character_intro = true;
boolean upper_middle_class_sequence = false;
boolean lower_character_intro = false;
boolean characters_generated = false;
boolean upper_middle_character_generated = false;
boolean lower_character_generated = false;
boolean lower_class_sequence = false;
int male_face_picker = int(random(0,male_faces.length));
int female_face_picker = int(random(0,female_faces.length));

void setup(){
	fullScreen();
	vote_cursor = loadImage("cursor.png");
	cursor(vote_cursor,0,0);
	voting_sequence = new AniSequence(this);
	face_image_instantiator();
	proggy = createFont("ProggySquareTT", 32);
	textFont(proggy);
	error_msg = loadImage("error_msg.png");
	thank_you_msg = loadImage("thank_you_msg.png");
	checkmark = loadImage("checkmark.png");
	place_holder_ID = loadImage("placeholder_test.png");
	asian_male_face = loadImage("asian_male_face.jpg");
	cp5  = new ControlP5(this);
	minim = new Minim(this);
	reward_sound = minim.loadFile("reward_sound.wav");
	error_sound = minim.loadFile("error_sound.wav");
	voting_interface();
	loaded = true;
	voting_sequence = new AniSequence(this);
	Ani.init(this);
	animation_sequence_instantiator();
	ticker_1_posx = 0;
	ticker_2_posx = int(textWidth(ticker_message_part_1));
	ticker_posy = height-50;
}

void draw(){
	//What to do when thank you animation and sequences are over???
	if(voting_sequence.isEnded()==true){
		for(int i=0; i < voting_buttons.length; i++){voting_buttons[i].show();}
		voted_yes_thanks = false; //set these two to false to stop rendering the messages
		voted_no_thanks = false;
		voting_sequence_playing = false;
	}
	background(255);
	//upper class exeperience
	if(upper_middle_character_generated == false){
		upper_middle_class_character_generator();
		id = id_number_generator();
		upper_middle_character_generated = true;
	}
	if(upper_middle_character_intro == true){
		imageMode(CENTER);
		image(place_holder_ID, width/2,height/2 - 100);
		// fill(125);
		imageMode(CORNER);
		if(sex ==  "Male"){
			image(male_faces[male_face_picker], 420,230);
		}else{
			image(female_faces[female_face_picker], 420,230);
		}
		// rect(400,250,325,400);
		fill(0);
		textSize(70);
		textAlign(CENTER);
		text("Patriotopia ID", width/2, 200);
		textSize(30);
		text(id, width/2, 230);
		textSize(50);
		textAlign(LEFT);
		text("Name: " + name, width/2-200,300);
		text("Place of Residence: " + district, width/2-200,350);
		text("Class: " + social_class, width/2-200,400);
		text("Sex: " + sex, width/2-200,575);
		text("DOB: " + birthday, width/2-200,625);

	}if (upper_middle_class_sequence == true){
		upper_middle_character_intro = false;
		for(int i=0; i < voting_buttons.length; i++){voting_buttons[i].show();}
		if(upper_middle_counter <= 5){
			if(upper_middle_counter == 0){
				upper_voting_prompts[upper_middle_counter].show();
			}else{
				upper_voting_prompts[upper_middle_counter-1].hide();
				upper_voting_prompts[upper_middle_counter].show();
			}
		}else if(voting_sequence_playing == false && upper_middle_counter > 5){
			upper_middle_class_sequence = false;
			lower_character_intro = true;
			begin_button.show();
		}
	}

	//lower class experience
	if (lower_character_intro == true){
		if(lower_character_generated == false){
			lower_class_character_generator();
			id = id_number_generator();
			lower_character_generated = true;
		}
		for(int i=0; i < voting_buttons.length; i++){voting_buttons[i].hide();}
		imageMode(CENTER);
		image(place_holder_ID, width/2,height/2 - 100);
		fill(125);
		rect(400,250,325,400);
		fill(0);
		textSize(70);
		textAlign(CENTER);
		text("Patriotopia ID", width/2, 200);
		textSize(30);
		text(id, width/2, 230);
		textSize(50);
		textAlign(LEFT);
		text("Name: " + name, width/2-200,300);
		text("Place of Residence: " + district, width/2-200,350);
		text("Sex: " + sex, width/2-200,575);
		text("DOB: " + birthday, width/2-200,625);
	}if(lower_class_sequence == true){
		lower_character_intro = false;
		for(int i=0; i < voting_buttons.length; i++){voting_buttons[i].show();}
		if(lower_counter <= 5){
			if(lower_counter == 0){
				lower_voting_prompts[lower_counter].show();
			}else{
				lower_voting_prompts[lower_counter-1].hide();
				lower_voting_prompts[lower_counter].show();
			}
		}else if(voting_sequence_playing == false && lower_counter > 5){
			lower_class_sequence = false;
		}
	}



	//covers the animations
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
}

String id_number_generator(){
	int id_number  = int(random(100000,999999));
	id = "#" + id_number;
	return id;
}

void upper_middle_class_character_generator(){
	sex_probability = random(0,1);
	race_probability = random (0,1);
	class_probability = random(0,1);
	district_probability = random(0,1);

	if(sex_probability < .50){
		sex = "Male";
	}else{
		sex = "Female";
	}

	if(race_probability < .20){
		race = "White";
	}
	else if(race_probability >= .20 && race_probability<= .40){
		race = "Hispanic";
	}
	else if(race_probability >= .40 && race_probability<= .60){
		race = "Black";
	}
	else if(race_probability >= .60 && race_probability<= .80){
		race = "Asian";
	}else{
		race = "American Indian or Alaska Native";
	}

	if(class_probability < .30){
		social_class = "Upper";
		if(district_probability < .20){
			district = "District 1";
		}else{
			district = "District 2";
		}
	}else{
		social_class = "Middle";
		if(district_probability < .10){
			district = "District 2";
		}else if(district_probability >=.10 && district_probability <= .60){
			district = "District 3";
		}else if(district_probability >= .60 && district_probability <= .90){
			district = "District 4";
		}else{
			district = "District 5";
		}
	}
	birthday = birthday_generator();
	name = name_determiner();
}

void lower_class_character_generator(){
	sex_probability = random(0,1);
	race_probability = random (0,1);
	district_probability = random(0,1);
	social_class = "Lower";

	if(sex_probability < .50){
		sex = "Male";
	}else{
		sex = "Female";
	}
	if(race_probability < .20){
		race = "White";
	}
	else if(race_probability >= .20 && race_probability<= .40){
		race = "Hispanic";
	}
	else if(race_probability >= .40 && race_probability<= .60){
		race = "Black";
	}
	else if(race_probability >= .60 && race_probability<= .80){
		race = "Asian";
	}else{
		race = "American Indian or Alaska Native";
	}
	if(district_probability < .60){
		district = "District 6";
	}
	else if(district_probability >= .60 && district_probability <=.90){
		district = "District 5";
	}else{
		district = "District 4";
	}
	birthday = birthday_generator();
	name = name_determiner();
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

String name_determiner(){
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

void controlEvent(ControlEvent theEvent){
	println(theEvent.getController().getName());
	clicked_button = theEvent.getController().getName();
}
void voting_interface(){
	begin_button = cp5.addButton("begin_button")
	.setPosition(width/2-120,height/2+350)
	.setImages(loadImage("begin_button_test.png"),loadImage("begin_button_test.png"),loadImage("begin_button_test.png"))
	.setSize(200,50)
	.updateSize();

	upper_voting_prompts[0] = cp5.addTextarea("upper_voting_prompt1")
	.setText("The recent ban on immigration into District 4 has been partially effective in containing riots in District 4. District 4 riots are damaging shared infrastructure with District 3. Increased customs officers and border protection will be added to tax rates of District 6. The Department of City Safety and Security advises to continue the ban. Continue the immigration ban?")
	.setPosition(width/2-480, 300)
	.setSize(960, 300)
	.setColorValue(0x00000000)
	.setFont(createFont("ProggySquareTT", 35))
	.hideScrollbar()
	.hide();

	upper_voting_prompts[1] = cp5.addTextarea("upper_voting_prompt2")
	.setText("Recent studies by the Patriotopia City Institute of Economics say that a new commercial zone in District 2 would lead to increased economic growth to District 2 and the surrounding District 3 and District 1. Profits from District 3's new Donald Trump stadium and new taxes on District 4 will help leverage building costs. Build the new commercial zone?")
	.setPosition(width/2-480, 300)
	.setSize(960, 300)
	.setColorValue(0x00000000)
	.setFont(createFont("ProggySquareTT", 35))
	.hideScrollbar()
	.hide();

	upper_voting_prompts[2] = cp5.addTextarea("upper_voting_prompt3")
	.setText("President Victor has initiated a new referendum to outlaw any current race-related national holidays or celebrations for the purposes of 'base-line equality'. Ban race-related national holidays?")
	.setPosition(width/2-480, 300)
	.setSize(960, 300)
	.setColorValue(0x00000000)
	.setFont(createFont("ProggySquareTT", 35))
	.hideScrollbar()
	.hide();

	upper_voting_prompts[3] = cp5.addTextarea("upper_voting_prompt4")
	.setText("President Victor is running for his third four-year term as reigning Executive of Patriotopia. Notable accomplishments include huge economic growth and lower taxes for District 1, District 2, and District 3. The Reagan Institute of Economic Research says this may lead to new jobs and infrastructure for District 5 and District 6. Instate President Victor for a third term?")
	.setPosition(width/2-480, 300)
	.setSize(960, 300)
	.setColorValue(0x00000000)
	.setFont(createFont("ProggySquareTT", 35))
	.hideScrollbar()
	.hide();

	upper_voting_prompts[4] = cp5.addTextarea("upper_voting_prompt5")
	.setText("The recent charter schools built in District 1 and District 2 have shown to be effective and cheap, with tuition averaging at $10,000 a year. Government Educators propose an expedited transition into introducing and building these same schools in District 3, District 4, and District 5, and (tentative) District 6. Build the new charter schools?")
	.setPosition(width/2-480, 300)
	.setSize(960, 300)
	.setColorValue(0x00000000)
	.setFont(createFont("ProggySquareTT", 35))
	.hideScrollbar()
	.hide();

	upper_voting_prompts[5] = cp5.addTextarea("upper_voting_prompt6")
	.setText("The Christian-Conservatives for President Victor have successfully protested and petitioned for a referendum to illegalize abortion. Illegalize abortion?")
	.setPosition(width/2-480, 300)
	.setSize(960, 300)
	.setColorValue(0x00000000)
	.setFont(createFont("ProggySquareTT", 35))
	.hideScrollbar()
	.hide();

	lower_voting_prompts[0] = cp5.addTextarea("lower_voting_prompt1")
	.setText("The recent ban on immigration into District 4 has been partially effective in containing riots in District 4. District 4 riots are damaging shared infrastructure with District 3. Increased customs officers and border protection will be added to tax rates of District 6. The Department of City Safety and Security advises to continue the ban. Continue the immigration ban?")
	.setPosition(width/2-480, 300)
	.setSize(960, 300)
	.setColorValue(0x00000000)
	.setFont(createFont("ProggySquareTT", 35))
	.hideScrollbar()
	.hide();

	lower_voting_prompts[1] = cp5.addTextarea("lower_voting_prompt2")
	.setText("Recent studies by the Patriotopia City Institute of Economics say that a new commercial zone in District 2 would lead to increased economic growth to District 2 and the surrounding District 3 and District 1. Profits from District 3's new Donald Trump stadium and new taxes on District 4 will help leverage building costs. Build the new commercial zone?")
	.setPosition(width/2-480, 300)
	.setSize(960, 300)
	.setColorValue(0x00000000)
	.setFont(createFont("ProggySquareTT", 35))
	.hideScrollbar()
	.hide();

	lower_voting_prompts[2] = cp5.addTextarea("lower_voting_prompt3")
	.setText("President Victor has initiated a new referendum to outlaw any current race-related national holidays or celebrations for the purposes of 'base-line equality'. Ban race-related national holidays?")
	.setPosition(width/2-480, 300)
	.setSize(960, 300)
	.setColorValue(0x00000000)
	.setFont(createFont("ProggySquareTT", 35))
	.hideScrollbar()
	.hide();

	lower_voting_prompts[3] = cp5.addTextarea("lower_voting_prompt4")
	.setText("President Victor is running for his third four-year term as reigning Executive of Patriotopia. Notable accomplishments include huge economic growth and lower taxes for District 1, District 2, and District 3. The Reagan Institute of Economic Research says this may lead to new jobs and infrastructure for District 5 and District 6. Instate President Victor for a third term?")
	.setPosition(width/2-480, 300)
	.setSize(960, 300)
	.setColorValue(0x00000000)
	.setFont(createFont("ProggySquareTT", 35))
	.hideScrollbar()
	.hide();

	lower_voting_prompts[4] = cp5.addTextarea("lower_voting_prompt5")
	.setText("The recent charter schools built in District 1 and District 2 have shown to be effective and cheap, with tuition averaging at $10,000 a year. Government Educators propose an expedited transition into introducing and building these same schools in District 3, District 4, and District 5, and (tentative) District 6. Build the new charter schools?")
	.setPosition(width/2-480, 300)
	.setSize(960, 300)
	.setColorValue(0x00000000)
	.setFont(createFont("ProggySquareTT", 35))
	.hideScrollbar()
	.hide();

	lower_voting_prompts[5] = cp5.addTextarea("lower_voting_prompt6")
	.setText("The Christian-Conservatives for President Victor have successfully protested and petitioned for a referendum to illegalize abortion. Illegalize abortion?")
	.setPosition(width/2-480, 300)
	.setSize(960, 300)
	.setColorValue(0x00000000)
	.setFont(createFont("ProggySquareTT", 35))
	.hideScrollbar()
	.hide();

	voting_buttons[0] = cp5.addButton("voting_button_yes")
	.setPosition(width/2 -480, 600)
	.setImages(loadImage("yes_button.png"),loadImage("yes_button_mouseover.png"),loadImage("yes_button.png"))
	.setSize(250,175)
	.setCaptionLabel("YES")
	.hide();

	voting_buttons[1] = cp5.addButton("voting_button_no")
	.setPosition(width/2 + 230, 600)
	.setImages(loadImage("no_button.png"),loadImage("no_button_mouseover.png"),loadImage("no_button.png"))
	.setSize(250,175)
	.setCaptionLabel("NO")
	.hide();

	reset_button = cp5.addButton("reset")
	.setPosition(80, 45)
	.setImages(loadImage("reset_button_test.png"),loadImage("reset_button_test.png"),loadImage("reset_button_test.png"))
	.setSize(60,20);

}

void voting_button_yes(){
	if(loaded==true){
		voting_sequence_playing = true;
		thank_you_msg();
		reward_sound.play();
		reward_sound.rewind();
		voting_sequence.start();
		for(int i =0; i < voting_buttons.length; i++){voting_buttons[i].hide();}
		voted_yes_thanks = true;
		if(upper_middle_class_sequence == true){
			upper_middle_counter+=1;
		}
		if(lower_class_sequence == true){
			lower_counter += 1;
		}
	}
}

void voting_button_no(){
	if(loaded==true){
		voting_sequence_playing = true;
		thank_you_msg();
		reward_sound.play();
		reward_sound.rewind();
		voting_sequence.start();
		voted_no_thanks = true;
		if(upper_middle_class_sequence == true){
			upper_middle_counter+=1;
		}
		if(lower_class_sequence == true){
			lower_counter += 1;
		}
	}
}

void thank_you_msg(){
	imageMode(CENTER);
	image(thank_you_msg,width/2,height/2,animation_x,animation_y);
	on_main_screen = false;
	for (int i=0; i<voting_buttons.length;i++){		voting_buttons[i].hide();}
	for (int i=0; i<upper_voting_prompts.length;i++){		upper_voting_prompts[i].hide();}
	for (int i=0; i<lower_voting_prompts.length;i++){		lower_voting_prompts[i].hide();}
}

void error_message(){
	if (social_class == "Lower"){
		error_timer_time = 50;
	}else {
		error_timer_time = 300;
	}
	if (error_timer < error_timer_time){
		error_sound.play();
		all_purpose_muter();
		clear_screen();
		imageMode(CENTER);
		image(error_msg,width/2,height/2);
		for (int i=0; i<2;i++){		voting_buttons[i].hide();}
		for (int i=0; i<6;i++){		upper_voting_prompts[i].hide();}
		for (int i=0; i<6;i++){		lower_voting_prompts[i].hide();}

		error_timer += 1;
	}else{
		error_sound.rewind();
		voted_no_error = false;
		voted_yes_error = false;
		error_timer = 0;
		all_purpose_unmuter();
		for (int i=0; i<2;i++){		voting_buttons[i].hide();}
		for (int i=0; i<6;i++){		upper_voting_prompts[i].hide();}
		for (int i=0; i<6;i++){		lower_voting_prompts[i].hide();}

									reset_button.show();
									on_main_screen = true;
	}
}

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

void begin_button(){
	if(lower_character_intro == false){
		upper_middle_class_sequence = true;
	}else{
		lower_class_sequence = true;
	}
	begin_button.hide();
}
void reset(){
	all_purpose_muter();
	frameRate(60);
	background(255);
	alphaValue = 0;
	if (idle == true){
		begin_button.show();
	}
	if (idle == false){
		begin_button.hide();
	}
	// myPort.write(message);
}

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

void all_purpose_muter(){
	upper_song.mute();
	lower_song.mute();
	middle_song.mute();
}

void all_purpose_unmuter(){
	upper_song.unmute();
	lower_song.unmute();
	middle_song.unmute();
}

void clear_screen(){
	background(255);
		if(loaded==true){
			for (int i=0;i<2;i++){ 		voting_buttons[i].hide();}
			for (int i=0;i<6;i++){ 		upper_voting_prompts[i].hide();}
			for (int i=0;i<6;i++){ 		lower_voting_prompts[i].hide();}
										reset_button.hide();
		}
}

void face_image_instantiator(){
	for (int i = 0; i<male_face_names.length; i++){
		String male_face_name = male_face_names[i];
		male_faces[i] = loadImage(male_face_name);
	}
	for (int i = 0; i<female_face_names.length; i++){
		String female_face_name = female_face_names[i];
		female_faces[i] = loadImage(female_face_name);
	}
}