<!DOCTYPE html>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<?php require 'incl/service_list.php'; ?>
<link rel="stylesheet" type="text/css" media="all" href="xs-portal.css" />
<HTML>
<HEAD>

<TITLE>Bienvenido al servidor de la escuela</TITLE>

</HEAD>
<BODY>
<div id="wrapper">	
<h1>Bienvenido al servidor de la escuela</h1>
<?php require 'incl/banner.html'; ?>

<div id="main"> 
		
<br><h2>Cosas interesantes que puedes hacer aquí:</h2>

<?php service_link("pathagar", "Lee libros en Pathagar", "Pathagar es un servidor de libreta que contiene una colección local de los libros que se pueden leer sin tener que descargarlos desde internet."); ?>
<?php // iiab_link("Internet In A Box", 
//                "Internet-in-a-Box is a copy of some of the most important material on the internet, such as the Wikipedia, stored locally where you can reach it easily.",
//                "Searching for Internet In A Box"); 
?>
<?php hard_link("/content", "Acceso Otros Contenidos", "Ponga el contenido adicional en /library/content y los subdirectorios y enlace a ella con esta función, como syans en Haití."); ?>
<?php service_link("iiab", "Internet In A Box", "Internet-in-a-Box es una copia de una parte del material más importante en Internet, como la Wikipedia, almacenado localmente donde se puede llegar con facilidad."); ?>
<?php service_link("moodle", "Moodle Home Page", "Moodle es una colección de clases y materiales de estudio organizados para ayudarle a aprender muchas cosas fascinantes."); ?>
<?php service_link("upload", "Cargar archivos", "Desde este enlace puedes cargar varios archivos, como imágenes y actividades"); ?>
<?php service_link("activity-server", "Descargar una Actividad", "Puedes añadir una nueva actividad a su XO desde este enlace."); ?>

<BR> Disfrute explorando!
</div><!-- #main -->
</div><!-- #wrapper -->
</BODY>
<script type="text/javascript" src="incl/xs-portal.js"></script>
</HTML>
