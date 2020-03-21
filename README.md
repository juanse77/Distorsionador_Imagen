<h1>Distorsionador de imagen:</h1>

<p>Esta práctica consiste en la manipulación de los frames de un vídeo de entrada al cual se le alteran los valores del pixelado para crear un efecto de distorsión. Para la captura de vídeo se ha utilizado la biblioteca 'Video (GStreamer-based video library for Processing)' y para el procesado de los frames la biblioteca 'OpenCV 4.0' en la versión para Processing CVImage compilada por Chung.</p>

<h2>Detalles de implementación:</h2>

<p>Para la creación de la distorsión se ha hecho uso de varios efectos:

<ul>

<li>La imagen de salida presenta una alteración en los valores de los canales verde y azul. El canal rojo no se altera en este efecto. Los canales verde y azul incrementarán los valores de sus píxeles en un rango aleatorio entre 64 y 96. Si cualquiera de estos valores superan el máximo de 255 se le aplicará el módulo.</li>

```java
azul = (int)blue(img_original.pixels[loc]);
verde = (green(img_original.pixels[loc]) + random(64, 96)) % 256;
rojo = (red(img_original.pixels[loc]) + random(64, 96)) % 256;
```

<li>Para este segundo efecto se ha utilizado el filtro absdiff de OpenCV, el cual toma dos fotogramas en escala de grises (los fotogramas consecutivos) y devuelve una imagen también en escala de grises en la cual aparece en un fondo negro las siluetas de los objetos que se mueven (varían su valor de pixelado) resaltadas en tonos blanco-grises. Los píxeles con valor mayor o igual a 16 se colorearán completamente de azul, produciendo un efecto de barrido en la imagen.</li>

```java
Mat gris = img.getGrey();
Mat pgris = pimg.getGrey();
Mat diff = new Mat();
    
Core.absdiff(gris, pgris, diff);
```

<li>En el tercer efecto se ha hecho uso del filtro Canny de OpenCV. Este filtro captura, en una imagen en blanco y negro, los bordes de una imagen en escala de grises que se recibe como parámetro del método. Los bordes se ajustan a unos determinados umbrales para modificar el resultado de la salida al gusto o necesidad del usuario. El efecto se produce al añadir los bordes calculados mediante este filtro en color rojo sólido.</li>

```java
Mat canny = img.getGrey();
Imgproc.Canny(gris, canny, 50, 100, 3);
```

<li>En este último efecto el usuario podrá ajustar la transparencia de la imagen mediante el uso del ratón. La transparencia se modifica con el desplazamiento horizontal del ratón sobre la imagen tranformada situada a la derecha. Con el ratón en el límite derecho el valor de la transparencia es 255 con lo cual la imagen se presenta sin alterar. En el límite izquierdo la imagen tiene un alpha 0 con lo cual se verá el fondo negro y la imagen no se apreciará en absoluto.</li>

```java
float transparencia = 0;
if(mouseX > width/2){
	transparencia = (mouseX - width/2) * 255/(width/2);
}
    
tint(255, transparencia);
image(auximg, width/2 + random(-5, 5), 0 + random(-5, 5));
tint(255, 255);
```
<li>Otro efecto, aunque mínimo, se produce al hacer temblar la imagen de salida con un pequeño desplazamiento vertical y horizontal aleatorio de la posición de la imagen dentro del marco.</li>

</lu>
 
<div align="center">
	<p><img src="./Distorsionador_Imagen.gif" alt="Imagen distorsionada" /></p>
</div>

<p>Esta aplicación se ha desarrollado como sexta práctica evaluable para la asignatura de "Creando Interfaces de Usuarios" de la mención de Computación del grado de Ingeniería Informática de la Universidad de Las Palmas de Gran Canaria en el curso 2019/20 y en fecha de 16/3/2020 por el alumno Juan Sebastián Ramírez Artiles.</p>

<p>Referencias a los recursos utilizados:</p>

- Modesto Fernando Castrillón Santana, José Daniel Hernández Sosa: [Creando Interfaces de Usuario. Guion de Prácticas](https://cv-aep.ulpgc.es/cv/ulpgctp20/pluginfile.php/126724/mod_resource/content/25/CIU_Pr_cticas.pdf)
- Processing Foundation: [Processing Reference.](https://processing.org/reference/)
- Biblioteca CVImage: [Compilación de OpenCV 4.0 para Processing](http://www.magicandlove.com/blog/2018/11/22/opencv-4-0-0-java-built-and-cvimage-library/)
- Biblioteca Video 1.0.1 (Gstream-based video library for Porcessing).