var race_probability;
var sex_probability;


function setup() {           
  createCanvas(1000, 1414);
  background(0);  
  race_probability = random();
  race_determiner(race_probability);
  sex_probability = random();
  sex_determiner(sex_probability);
}

function draw() {                       
  // Empty for now
}

function sex_determiner(sex_probability){
  textSize(50);
  textAlign(CENTER);
  fill(255);
  text("Sex:", width/2,(height/5)+10)
  if (sex_probability < .50){
  	textSize(30)
  	fill(255);
  	text("Female",width/2, (height/5)+50);
  }else{
  	textSize(30)
  	fill(255);
  	text("Male",width/2, (height/5)+50);
  }
}

function race_determiner(race_probability){
  textSize(50);
  textAlign(CENTER);
  fill(255);
  text("Race:", width/2, (height/6) - 50)
  if (race_probability <= .61){
  	textSize(30);
  	fill(255);
  	text("White", width/2, height/6)
  }
  else if (race_probability > .61 && race_probability< .78){
  	textSize(30);
  	fill(255);
  	text("Hispanic", width/2, height/6)
  }
  else if (race_probability > .78 && race_probability < .91) {
  	textSize(30);
  	fill(255);
  	text("Black or African", width/2, height/6)
  }
  else if (race_probability > .91 && race_probability < .96){
  	textSize(30);
  	fill(255);
  	text("Asian", width/2, height/6)
  }
  else if (race_probability >.96 && race_probability <.98){
  	textSize(30);
  	fill(255);
  	text("American Indian or Alaska Native", width/2, height/6)
  }
  else if (race_probability >.98 && race_probability <1.0){
  	textSize(30);
  	fill(255);
  	text("Native Hawaiian or Other Pacific Islander", width/2, height/6)
  }
}