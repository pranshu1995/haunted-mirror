// Theme variables
Boolean themeSelected = false;
String themeName = "";

// Position variables for vertical elements
float shiningBloodYVal = 0;
float holySymbolYVal = 0;

// Doll motion and positioning variables

Boolean dollInMotion = false;

int dollPosY = 0;

int dollPosXLeft = -250;
int dollPosXRight = 640;

int dollMaxXLeft = -120;
int dollMinXLeft = -250;

int dollMaxXRight = 640;
int dollMinXRight = 510;

Boolean dollBack = false;

int randomSide;


public class Theme{
  // Theme class
  
  // Image variables used for theme
   PImage hauntedBackground = loadImage("data/images/background.jpeg");
  
   PImage shiningPoster = loadImage("data/images/the_shining_poster.jpeg");
   PImage poltergeistPoster = loadImage("data/images/poltergeist.jpg");
   PImage annabellePoster = loadImage("data/images/annabelle.jpeg");
   
   PImage drippingBlood = loadImage("data/images/drippingBlood.png");
   
   PImage tvFrame = loadImage("data/images/tvFrame.png");
   PImage tvStaticHand = loadImage("data/images/tvStaticHand.jpeg");
   PImage tvStaticFace = loadImage("data/images/tvStaticFace.jpg");
   
   PImage annabelleDollLeft = loadImage("data/images/annabelleDollLeft.png");
   PImage annabelleDollRight = loadImage("data/images/annabelleDollRight.png");
   
   PImage holySymbol = loadImage("data/images/holySymbol.png");


   void drawThemeSelection(Boolean visible){
     // Select theme
     
     hauntedBackground.resize(640, 480);
     if(visible){
       image(hauntedBackground, 0, 0);
     }
     
     shiningPoster.resize(150,225);
     poltergeistPoster.resize(150,225);
     annabellePoster.resize(150,225);
    
     if(visible){
       // Poster buttons for theme selection
     cp5.addButton("shiningPosterClick")
    .setPosition(47, 128)
    .setSize(150,225)
    .setImage(shiningPoster);
    
    cp5.addButton("poltergeistPosterClick")
    .setPosition(244, 128)
    .setSize(150,225)
    .setImage(poltergeistPoster);
    
    cp5.addButton("annabellePosterClick")
    .setPosition(441, 128)
    .setSize(150,225)
    .setImage(annabellePoster);
     }
     else{
       // Hide buttons on selection
     cp5.getController("shiningPosterClick").setVisible(false);
     cp5.getController("poltergeistPosterClick").setVisible(false);
     cp5.getController("annabellePosterClick").setVisible(false);
     }
     
     textSize(32);
     text("Select mode! Only if you dare", 130, 430); 
   }
   
   void drawShining(float yVal){
     // Shining theme  
     
     drippingBlood.resize(640, 366);
     
     float pos = -350 + yVal; // Update position
     
     if(pos>=-10){
       pos = -10;
     }
     
     tint(255, 200);
     image(drippingBlood, 0, pos); // Blood dripping image
     noTint();
   }
   
   void drawPolter(){
     // Poltergeist theme
     
     tvFrame.resize(640, 480);
     
     image(tvFrame, 0, 0); // SHow recording inside TV frame
   }
   
   void drawAnnabelle(){
   // Annabelle theme 
   
     annabelleDollLeft.resize(250, 220);
     annabelleDollRight.resize(250, 220);
     
     if(dollInMotion){
       // If doll is moving
       if(randomSide == 1){
         // Doll on left side
         
         if(!dollBack){
           // Doll moving in the viewport
           
           dollPosXLeft = dollPosXLeft + 20;
           image(annabelleDollLeft,dollPosXLeft,dollPosY);
           if(dollPosXLeft >= dollMaxXLeft){ // Position threshold point
            dollBack = !dollBack;
           }
         }
         else if(dollBack){
           // Doll moving out of the viewport
           
           dollPosXLeft = dollPosXLeft - 20;
           image(annabelleDollLeft,dollPosXLeft,dollPosY);
           if(dollPosXLeft <= dollMinXLeft){ // Position threshold point
            dollBack = !dollBack;
            dollInMotion = false;
           }
         }
       }
       else if(randomSide == 2){
         // Doll on right side
         
         if(!dollBack){
           // Doll moving in the viewport
           
           dollPosXRight = dollPosXRight - 20;
           image(annabelleDollRight,dollPosXRight,dollPosY);
           if(dollPosXRight <= dollMinXRight){ // Position threshold point
            dollBack = !dollBack;
           }
         }
         else if(dollBack){
           // Doll moving out of the viewport
           
           dollPosXRight = dollPosXRight + 20;
           image(annabelleDollRight,dollPosXRight,dollPosY);
           if(dollPosXRight >= dollMaxXRight){ // Position threshold point
            dollBack = !dollBack;
            dollInMotion = false;
           }
         }
       }
     }
     else{
       // If doll is not in motion
       randomSide = Math.round(random(1,2)); // Select random side
       dollPosY = Math.round(random(10,250)); // Select random vertical position
       dollInMotion = true; // Put doll in motion
     }
   }
   
   void drawHoly(float yVal){
     // Holy symbol
     
     holySymbol.resize(150, 150);
     
     float pos = -150 + yVal; // Position update
     
     if(pos>=10){
       pos = 10;
     }
     
     image(holySymbol, 20, pos);
     
   }
   
   void drawInfoBox(){
     // Info box for hint
     
    fill(255);
    rect(250, 435, 150, 30, 10);
   fill(0);
   textSize(16);
   text("Join hands to pray!", 260, 455);
   
   }
}
