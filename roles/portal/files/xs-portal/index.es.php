
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

<BR><BR>
<BR><BR>
<BR><BR>
<BR><BR>

<br><h2>Cosas interesantes que puedes hacer aquí:</h2>

<div class="xsMenuHeading">
        <img src="/common/images/220px-Wikipedia-logo-v2.svg.png">
        <h2>Wikipedia, libros Gutenberg y más contenido...</h2>
</div>

<?php kiwix_link("wikipedia_es_all_2015-10", "Wikipedia", "Wikipedia, la encliclopedia libre"); ?>

<?php kiwix_link("gutenberg_es_all_10_2014", "Gutenberg", "Biblioteca libre de libros."); ?>

<?php kiwix_link("vikidia_es_all_2015-11", "Vikidia", "La enciclopedia libre de contenido adaptado para niños y jóvenes."); ?>

<?php kiwix_link("wikibooks_es_all_2015-11", "Wikibooks", "Wikilibros, la colección de libros de texto de contenido libre."); ?>

<?php kiwix_link("wikinews_es_all_2015-11", "Wikinoticias", "Wikinoticias, la fuente libre de noticias."); ?>

<?php kiwix_link("wikiquote_es_all_2015-11", "Wikiquote", "Wikiquote, la colección libre de citas y frases célebres."); ?>

<?php kiwix_link("wikisource_es_all_2015-11", "Wikisource", "Wikisource, la biblioteca que todos pueden editar."); ?>

<?php kiwix_link("wikiversity_es_all_2015-11", "Wikiversidad", "Wikiversidad, una plataforma educativa, online, libre, con filosofía wiki.."); ?>

<?php kiwix_link("wikivoyage_es_all_2015-11", "Wikiviajes", "Wikiviajes, la guía libre de viajes."); ?>

<?php kiwix_link("wiktionary_es_all_2015-10", "Wikcionario", "Wikcionario, el diccionario libre."); ?>

<div class="xsMenuHeading">
        <img src="/common/images/ted-talks-logo-150x150.jpg">
        <h2> Conferencias TED de tecnología, entretenimiento y diseño.</h2>
</div>

<?php kiwix_link("ted_en_business_2015-02", "Negocios"); ?>

<?php kiwix_link("ted_en_design_2015-02", "Diseño"); ?>

<?php kiwix_link("ted_en_entertainment_2015-02", "Entretenimiento"); ?>
<BR>

<?php kiwix_link("ted_en_global_issues_2015-02", "Global"); ?>

<?php kiwix_link("ted_en_science_2015-02", "Ciencia"); ?>

<?php kiwix_link("ted_en_technology_2015-02", "Tecnología"); ?>
<BR><BR>

<div class="xsMenuHeading">
        <img src="/common/images/khan-logo-vertical-transparent.png">
        <h2>Khan Academy</h2>
</div>

<?php kalite_link("KA Lite", "Videos educativos de Khan Academy."); ?>

<div class="xsMenuHeading">
        <img src="/common/images/osm.jpg">
        <h2>Mapas</h2>
</div>

<?php hard_link("/iiab/static/map.html", "OpenStreetMap", "Mapa mundial offline.","/library/knowledge/modules/openstreetmap/mod_tile64"); ?>

<h2>Colaboracion</h2>

<?php hard_link("/owncloud", "ownCloud", "Herramienta para compartir archivos, calendario, muy útil para docentes.", "/opt/owncloud/index.php"); ?>

<?php hard_link("/elgg", "Elgg", "Herramienta offline de social media para alumnos.", "/opt/elgg/index.php"); ?>

<?php // hard_link("/content", "Contenido", "TestPrep PDFs and a growing  list of documents.","/library/content"); ?>

<?php service_link("moodle", "Moodle", "Moodle es una colección de clases y materiales de estudio organizados para ayudarle a aprender muchas cosas fascinantes."); ?>

<?php service_link("upload", "Cargar archivos", "Desde este enlace puedes cargar varios archivos, como imágenes y actividades"); ?>

<?php service_link("activity-server", "Descargar una Actividad", "Puedes añadir una nueva actividad a su XO desde este enlace."); ?>

<BR><B> Disfruta explorando esta Biblioteca!!! &nbsp; <I>volunteer@unleashkids.org</I></B>
<BR><BR>

<?php require 'incl/footer.php'; ?>

</div><!-- #main -->
</div><!-- #wrapper -->
</BODY>
<script type="text/javascript" src="incl/xs-portal.js"></script>
</HTML>


