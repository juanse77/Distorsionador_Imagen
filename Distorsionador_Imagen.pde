import processing.video.*;
import cvimage.*;
import org.opencv.core.*;
import org.opencv.imgproc.Imgproc;
import gifAnimation.*;

//GifMaker ficherogif;
//int cuentaFrames = 0;

Capture cam;
CVImage img, pimg, auximg;

void setup() {
  size(1280, 480);
  
  //ficherogif = new GifMaker( this, "Distorsionador_Imagen.gif");
  //ficherogif.setRepeat(0);
  
  cam = new Capture(this, width/2 , height);
  cam.start(); 
  
  //OpenCV
  //Carga biblioteca core de OpenCV
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  
  img = new CVImage(cam.width, cam.height);
  pimg = new CVImage(cam.width, cam.height);
  auximg = new CVImage(cam.width, cam.height);
}

void imprime_mensaje(){
  noStroke();
  fill(230, 10, 30);
  rect(0, 0, width/2, 28);
  
  textFont(createFont("Arial", 14));
  textAlign(LEFT, TOP);
  
  fill(255);
  text("Deslice el ratón a derecha e izquierda para cambiar la transparencia de la imagen transformada", 5, 5);
}

void draw() {  
  if (cam.available()) {
    background(0);
    
    cam.read();
    
    img.copy(cam, 0, 0, cam.width, cam.height, 
    0, 0, img.width, img.height);
    img.copyTo();
    
    Mat gris = img.getGrey();
    Mat pgris = pimg.getGrey();
    Mat diff = new Mat();
    
    Core.absdiff(gris, pgris, diff);
    
    Mat canny = img.getGrey();
    Imgproc.Canny(gris, canny, 50, 100, 3);
    
    compoundImage(canny, diff, img, auximg);
    
    image(img,0,0);
    
    imprime_mensaje();
    
    float transparencia = 0;
    if(mouseX > width/2){
      transparencia = (mouseX - width/2) * 255/(width/2);
    }
    
    tint(255, transparencia);
    image(auximg, width/2 + random(-5, 5), 0 + random(-5, 5));
    tint(255, 255);
    
    pimg.copy(img, 0, 0, img.width, img.height, 
    0, 0, img.width, img.height);
    pimg.copyTo();
    
    //if(cuentaFrames == 3){
      //ficherogif.addFrame();
      //cuentaFrames = 0;
    //}
  
    //cuentaFrames++;
    
    gris.release();
    canny.release();
    diff.release();
  }
}

void  compoundImage(Mat canny, Mat diff, CVImage img_original, CVImage out_img)
{    
  byte[] dataCanny = new byte[cam.width*cam.height];
  byte[] dataDiff = new byte[cam.width*cam.height];
  
  out_img.loadPixels();
  img_original.loadPixels();
  
  canny.get(0, 0, dataCanny);
  diff.get(0, 0, dataDiff);
  
  for (int x = 0; x < cam.width; x++) {
    for (int y = 0; y < cam.height; y++) {
      
      int loc = x + y * cam.width;
      //Conversión del valor a unsigned basado en 
      //https://stackoverflow.com/questions/4266756/can-we-make-unsigned-byte-in-java
      int azul = dataDiff[loc] & 0xFF;
      
      float verde = 0;
      float rojo = 0;
      
      if(azul < 16){
        
        azul = (int)blue(img_original.pixels[loc]);
        verde = (green(img_original.pixels[loc]) + random(64, 96)) % 256;
        rojo = (red(img_original.pixels[loc]) + random(64, 96)) % 256;
        
      }else{
        azul = 255;
      }
      
      int borde = dataCanny[loc] & 0xFF;
      
      if(borde > 245){
        rojo = 255;
        verde = 0;
        azul = 0;
      }
      
      out_img.pixels[loc] = color(rojo, verde, azul);
    }
  }
  out_img.updatePixels();
}

void keyPressed(){
  //if(key == 'r'){
    //ficherogif.finish();
  //}
}
