import processing.serial.*;
Serial myPort;

float sex_probability;
float race_probability;
float class_probability;
float district_probability;

String sex;
String race;
String social_class;
String birthday;
String id;
String message;

boolean printed = false;
JSONObject person = new JSONObject();

void setup()
{
	size(1000,1414);
	background(255);
	frameRate(1);
	myPort = new Serial(this, "COM7", 9600);
	// Load name files here
	// Probably should load picture files here
	// as well

	// Generate character data in JSON data format.
	sex_probability = random(0,1);
	race_probability = random(0,1);
	class_probability = random(0,1);
	int idNumber = int(random(100000, 999999));
	id = "ID#: " + idNumber;
	textSize(60);
	fill(224,22,43);
	textAlign(LEFT);
	text("Patriotopia ID",50,100);
	textSize(60);
	fill(224,22,43);
	textAlign(RIGHT);
	text(id, width - 50, 100);
	textSize(60);
	sex = sex_determiner(sex_probability);
	race = race_determiner(race_probability);
	social_class = class_determiner(class_probability);
	birthday = birthday_generator();
	// String district = district_determiner(district_probability); will add once printer works
	message = "NAME: Generic Name" + "\n" + "BIRTHDAY: " + birthday + "\n" + "RACE: " + race + "\n" + "SEX: " + sex + "\n" + id + "\n" + "CLASS: " + social_class + "\n" + "|";
	println(message);
	// This is the string to be sent to the Arduino printer
	// myPort.write("NAME: Generic Name" + '\n' + "BIRTHDAY: " + birthday + '\n' + "RACE: " + race + '\n' + "SEX: " + sex + '\n' + id + '\n' + "CLASS: " + social_class + '$');
	person.setInt("id",idNumber);
	person.setString("sex", sex);
	person.setString("class", social_class);
	person.setString("race", race);
	person.setString("birthday", birthday);
	saveJSONObject(person, "data/person.json");
	noLoop();
	// The JSON file will now be read by the voting terminal
}

void draw()
{

	myPort.write(message);
	// if(keyPressed){
	// 	if(key == 'p' ){
	// 		myPort.write(message);
	// 		printed = true;
	// 	}
	// }
	println(myPort.read());
}

void keyPressed(){
	if (key == 'p'){
		redraw();
		println("HIT");
	}
}

// boolean printed (String message){
// 	myPort.write(message);
// 	return true;
// }

// message idea from Nick, "Help me I'm trapped in the machine"

String race_determiner(float race_probability)
// Projected demographics
{
	if (race_probability <= .61){
		String white = "white";
		return white;
	}
	else if (race_probability > .61 && race_probability < .78)
	{
		String hispanic = "hispanic";
		return hispanic;
	}
	else if (race_probability > .78 && race_probability <.91)
	{
		String boaa = "boaa";
		// Black or African American
		return boaa;
	}
	else if (race_probability > .91 && race_probability < .96)
	{
		String asian = "asian";
		return asian;
	}
	else if (race_probability > .96 && race_probability < .98)
	{
		String aioan = "aioan";
		// American Indian or Alaska Native
		return aioan;
	}
	else if (race_probability > .98 && race_probability<1.0)
	{
		String nhoopi = "nhoopi";
		// Native Hawaiian or Other Pacific Islander
		return nhoopi;
	}
	else
	{
		return "";
	}
}


String sex_determiner(float sex_probability)
{
	if (sex_probability<.50)
	{
		String male = "male";
		return male;
	}
	else
	{
		String female = "female";
		return female;
	}
}


String class_determiner(float class_probability)
{
	if(class_probability<=.50)
	{
		String middle_class = "middleclass";
		return middle_class;
	}
	else if (class_probability > .5 && class_probability<=.79){
		String lower_class = "lowerclass";
		return lower_class;
	}
	else if(class_probability > .79 && class_probability <= 1.0){
		String upper_class = "upperclass";
		return upper_class;
	}
	else
	{
		return "";
	}
}

// String district_determiner(float district_probability){
// 	if (district_probability)
// }

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

