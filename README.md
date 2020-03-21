<h1>Distorsionador de imagen:</h1>

<p>Esta pr�ctica consiste en la manipulaci�n de los frames de un v�deo de entrada al cual se le alteran los valores del pixelado para crear un efecto de distorsi�n. Para la captura de v�deo se ha utilizado la biblioteca 'Video (GStreamer-based video library for Processing)' y para el procesado de los frames la biblioteca 'OpenCV 4.0' en la versi�n para Processing CVImage compilada por Chung.</p>

<h2>Detalles de implementaci�n:</h2>

<p>Para la creaci�n de la distorsi�n se ha hecho uso de varios efectos:

<ul>

<li>La imagen de salida presenta una alteraci�n en los valores de los canales verde y azul. El canal rojo no se altera en este efecto. Los canales verde y azul incrementar�n los valores de sus p�xeles en un rango aleatorio entre 64 y 96. Si cualquiera de estos valores superan el m�ximo de 255 se le aplicar� el m�dulo.</li>

```java
azul = (int)blue(img_original.pixels[loc]);
verde = (green(img_original.pixels[loc]) + random(64, 96)) % 256;
rojo = (red(img_original.pixels[loc]) + random(64, 96)) % 256;
```

<li>Para este segundo efecto se ha utilizado el filtro absdiff de OpenCV, el cual toma dos fotogramas en escala de grises (los fotogramas consecutivos) y devuelve una imagen tambi�n en escala de grises en la cual aparece en un fondo negro las siluetas de los objetos que se mueven (var�an su valor de pixelado) resaltadas en tonos blanco-grises. Los p�xeles con valor mayor o igual a 16 se colorear�n completamente de azul, produciendo un efecto de barrido en la imagen.</li>

```java
Mat gris = img.getGrey();
Mat pgris = pimg.getGrey();
Mat diff = new Mat();
    
Core.absdiff(gris, pgris, diff);
```

<li>En el tercer efecto se ha hecho uso del filtro Canny de OpenCV. Este filtro captura, en una imagen en blanco y negro, los bordes de una imagen en escala de grises que se recibe como par�metro del m�todo. Los bordes se ajustan a unos determinados umbrales para modificar el resultado de la salida al gusto o necesidad del usuario. El efecto se produce al a�adir los bordes calculados mediante este filtro en color rojo s�lido.</li>

```java
Mat canny = img.getGrey();
Imgproc.Canny(gris, canny, 50, 100, 3);
```

<li>En este �ltimo efecto el usuario podr� ajustar la transparencia de la imagen mediante el uso del rat�n. La transparencia se modifica con el desplazamiento horizontal del rat�n sobre la imagen tranformada situada a la derecha. Con el rat�n en el l�mite derecho el valor de la transparencia es 255 con lo cual la imagen se presenta sin alterar. En el l�mite izquierdo la imagen tiene un alpha 0 con lo cual se ver� el fondo negro y la imagen no se apreciar� en absoluto.</li>

```java
float transparencia = 0;
if(mouseX > width/2){
	transparencia = (mouseX - width/2) * 255/(width/2);
}
    
tint(255, transparencia);
image(auximg, width/2 + random(-5, 5), 0 + random(-5, 5));
tint(255, 255);
```
<li>Otro efecto, aunque m�nimo, se produce al hacer temblar la imagen de salida con un peque�o desplazamiento vertical y horizontal aleatorio de la posici�n de la imagen dentro del marco.</li>

</lu>
 
<div align="center">
	<p><img src="./Distorsionador_Imagen.gif" alt="Imagen distorsionada" /></p>
</div>

<p>Esta aplicaci�n se ha desarrollado como sexta pr�ctica evaluable para la asignatura de "Creando Interfaces de Usuarios" de la menci�n de Computaci�n del grado de Ingenier�a Inform�tica de la Universidad de Las Palmas de Gran Canaria en el curso 2019/20 y en fecha de 16/3/2020 por el alumno Juan Sebasti�n Ram�rez Artiles.</p>

<p>Referencias a los recursos utilizados:</p>

- Modesto Fernando Castrill�n Santana, Jos� Daniel Hern�ndez Sosa: [Creando Interfaces de Usuario. Guion de Pr�cticas](https://cv-aep.ulpgc.es/cv/ulpgctp20/pluginfile.php/126724/mod_resource/content/25/CIU_Pr_cticas.pdf)
- Processing Foundation: [Processing Reference.](https://processing.org/reference/)
- Biblioteca CVImage: [Compilaci�n de OpenCV 4.0 para Processing](http://www.magicandlove.com/blog/2018/11/22/opencv-4-0-0-java-built-and-cvimage-library/)
- Biblioteca Video 1.0.1 (Gstream-based video library for Porcessing).