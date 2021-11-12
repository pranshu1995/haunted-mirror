// Deep vision library for face detection

import ch.bildspur.vision.*;
import ch.bildspur.vision.result.*;

import ch.bildspur.vision.DeepVision;
import ch.bildspur.vision.SingleHumanPoseNetwork;
import ch.bildspur.vision.result.HumanPoseResult;
import ch.bildspur.vision.result.KeyPointResult;

// Video capture, play and sound libraries

import processing.video.Capture;
import processing.video.*;
import processing.sound.*;

// Library for video export
import com.hamoid.*;

// Control library for interactive elements
import controlP5.*;

// Library Variables

Movie myMovie;
VideoExport videoExport;

SingleHumanPoseNetwork pose;
HumanPoseResult result;

Capture cam;

DeepVision vision;
CascadeClassifierNetwork network;
ResultList<ObjectDetectionResult> detections;

ControlP5 cp5;

Amplitude amp;
SoundFile sampleChants;
SoundFile sampleTheme;
SoundFile sampleHoly;

// Face detection interval variables

int[] lengthArray;
int count = 0;

// Swiching record and playback video variables

Boolean record = false;
Boolean recordInit = false;
Boolean loadMov = false;
Boolean stopper = false;

// Detection probability threshold variable
float threshold = 0.4;

Theme theme;

public void setup() {
  size(640, 480, FX2D);
  //colorMode(HSB, 360, 100, 100);

  println("creating network...");
  vision = new DeepVision(this);
  network = vision.createCascadeFrontalFace();

  println("loading model...");
  network.setup();

  println("setup camera...");
  String[] cams = Capture.list();
  cam = new Capture(this, cams[0]);
  cam.start();
  
  cp5 = new ControlP5(this);
  
  theme = new Theme();
  theme.drawThemeSelection(true); // Initial display to choose theme
  
  // Haunted chants played in the background
  
  sampleChants = new SoundFile(this, "audio/horrorChants.wav");
  sampleChants.amp(0.1);
  sampleChants.loop();
   
  lengthArray = new int[5000];
  
  
}

public void draw() {
  if(themeSelected){ 
    
    // Load once the theme is selected by the user
  
    background(55);

  if (cam.available()) {
    cam.read();
  }

  if(record){ // Recording on
    image(cam, 0, 0);
  }
  else{ // Recording off -> Playback
    //cam.stop();
    //network.wait(50000,50000);
    
    detections.remove(network);
    if(loadMov == false){ // Load the movie recorded
      loadMov = true;
      myMovie = new Movie(this, "video.mp4");
      myMovie.frameRate(Math.round(frameRate)); // Set playback framerate equal to current framerate
      myMovie.loop();
      
      
      
      println("creating network...");
      pose = vision.createSingleHumanPoseEstimation();
    
      println("loading model...");
      pose.setup();
    }
    else{ // Display movie in frame
    if(stopper == false){
      
      // Display according to the theme selected
      
      if(themeName == "The Shining"){
        image(myMovie,0,0);
       theme.drawShining(shiningBloodYVal);
       shiningBloodYVal = shiningBloodYVal + 10; // Update position of blood dripping
       
      
     }
     else if(themeName == "Poltergeist"){
       
       float rand = Math.round(random(1,20));
      
      // Show static haunted image randomly in between
      
       if(rand == 3 || rand == 17){
         theme.tvStaticFace.resize(500,450);
         image(theme.tvStaticFace,0,0);
       }
       else if(rand == 5 || rand == 19){
         theme.tvStaticHand.resize(500,450);
         image(theme.tvStaticHand,0,0);
       }
       else{
         tint(0, 153, 204, 240);
         image(myMovie,0,0);
         noTint();
       }
       
       theme.drawPolter();
     }
     else if(themeName == "Annabelle"){
       image(myMovie,0,0);
       theme.drawAnnabelle();
     }
      
      result = pose.run(cam); 
      checkPose(result); // Check pose of user while playing back video
      
      theme.drawInfoBox(); // Display hint 
    }
    else{
      // When user breaks from haunted video
      image(cam,0,0);
      theme.drawHoly(holySymbolYVal); // Display holy symbol
      holySymbolYVal = holySymbolYVal + 5; // Update position of holy symbol
    }
    
    }
  }

  // Detect human face
  detections = network.run(cam);

  lengthArray[count] = detections.size();
  count++;

  surface.setTitle("Face Recognition Test - FPS: " + Math.round(frameRate));
  
  if(record == true){
    checkPresence(); // Check if there's a face in viewport
  }
  }
  
  
}

void checkPresence(){ // Funtion to check human face presence 
  rec(true);
  Boolean present = true;
  
  for( int i = count; i > count - 20 && i > 0; i--){ // If face is consistently out of viewport
    if(lengthArray[i] == 0){
      present = false;
    }
    else if(lengthArray[i] == 1){
      present = true;
      break;
    }
  }
  
  if(count >10){ // Don't consider the first 10 frames -> Startup
    if(!present){
       record = false;
      rec(false);
    }
  }
  
}

void rec(Boolean flag) { // Switching recording on or off
  if(flag){
    if(recordInit == false){ // Initialise recording
      videoExport = new VideoExport(this, "data/video.mp4");
      videoExport.setFrameRate(5);  
      videoExport.startMovie();
      recordInit = true;
  }
    videoExport.saveFrame(); // Save each frame
  }
  else{ // Stop recording
    videoExport.endMovie();
    record = false;
  }
}

void movieEvent(Movie m) {
  m.read();
}    



private void checkPose(HumanPoseResult human) {
  
  // Check pose of user
    
    if(human.getLeftWrist().getProbability() > threshold && human.getRightWrist().getProbability() > threshold){
    
      
    
    float jointHandDistance = checkDistance(human.getLeftWrist().getX(), human.getLeftWrist().getY(),human.getRightWrist().getX(), human.getRightWrist().getY());  
      if(jointHandDistance < 125){ // If hands are joined together (distance between 2 hands is less
        println("Stopped by prayer");
        stopper = true; // Stop haunted video
        
        // Stop haunted chants, music
        sampleChants.stop();
        sampleTheme.stop();
        
        // Play holy music
        sampleHoly = new SoundFile(this, "audio/holyMusic.mp3");
        sampleHoly.amp(0.1);
        sampleHoly.loop();
      }
    }
}
