void controlEvent(ControlEvent theEvent) {
  // Controller funtion for button clicks
  
  // Button controller for theme selection
  if (theEvent.getName() == "shiningPosterClick") {
    themeSelected = true;
    record = true;
    theme.drawThemeSelection(false);
    themeName = "The Shining";
    
    sampleChants.amp(0.02);
    
    sampleTheme = new SoundFile(this, "audio/shiningMusic.mp3");
    sampleTheme.amp(0.1);
    sampleTheme.loop();
    
  }
  if (theEvent.getName() == "poltergeistPosterClick") {
    themeSelected = true;
    record = true;
    theme.drawThemeSelection(false);
    themeName = "Poltergeist";
    
    sampleChants.amp(0.02);
    
    sampleTheme = new SoundFile(this, "audio/poltergeistMusic.mp3");
    sampleTheme.amp(0.1);
    sampleTheme.loop();
  }
  if (theEvent.getName() == "annabellePosterClick") {
    themeSelected = true;
    record = true;
    theme.drawThemeSelection(false);
    themeName = "Annabelle";
    
    sampleChants.amp(0.02);
    
    sampleTheme = new SoundFile(this, "audio/annabelleMusic.mp3");
    sampleTheme.amp(0.1);
    sampleTheme.loop();
  }
}


public float checkDistance(float x1, float y1, float x2, float y2){
  // Find distance between 2 points
  float x = pow( x1 - x2, 2);
  float y = pow( y1 - y2, 2);
  
  float dist = sqrt(x + y);
  
  return dist;
}
