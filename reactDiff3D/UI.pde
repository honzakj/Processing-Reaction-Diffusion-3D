import controlP5.*;
import peasy.*;

PeasyCam cam;
ControlP5 controlP5;

//SETUP FUNCTIONS
void initCam() {
  cam = new PeasyCam(this, 150);
  cam.setMinimumDistance(120);
  cam.setMaximumDistance(150);
}

void initControl() {
  controlP5 = new ControlP5(this);
  controlP5.setAutoDraw(false);
  Button captureButton = controlP5.addButton("Export csv").setPosition(25, 25).setSize(150, 25).setValue(0).activateBy(ControlP5.RELEASE);

  captureButton.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent event) {
      switch(event.getAction()) {

        //capture state to table.csv on release
        case(ControlP5.ACTION_RELEASED):
          exportTable();
      }
    }
  }
  );
}

void gui() {
  stroke(0);
  strokeWeight(1);
  noFill();
  rect(0, 0, width, 75);

  controlP5.draw();
  controlP5.setAutoDraw(false);
}

void mousePressed() {
  if (mouseX > 0 && mouseX < width && mouseY < 75) {
    cam.setActive(false);
  } else {
    cam.setActive(true);
  }
}
