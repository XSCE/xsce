<!DOCTYPE html>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<?php require 'incl/service_list.php'; ?>
<link rel="stylesheet" type="text/css" media="all" href="xs-portal.css" />
<HTML>
<HEAD>

<TITLE>Bienvenue sur le site de l’école</TITLE>

</HEAD>
<BODY>
<div id="wrapper">	
<h1>Bienvenue sur le site de l’école</h1>
<?php require 'incl/banner.html'; ?>

<div id="main"> 
<br><h2>Des documents intéressants que tu peux découvrir ici:</h2>

<?php service_link("pathagar", "Lire des livres sur Pathagar", "Pathagar est un serveur qui contient une collection de livres que tu peux lire sans avoir à les télécharger depuis Internet."); ?>
<?php hard_link("/content/syans", "Lire des livres de sciences", "Ici sont des livres educatifs sur sciences en creole haitien pour enfants de 7 - 9 ans."); ?>

<?php // iiab_link("Internet-in-a-Box", 
//                "Internet-in-a-Box contient une partie des plus importantes information disponibles sur Internet, comme Wikipedia.  Ces informations sont stockées localement pour que tu puisses les lire facilement.",
//                "Recherche de Internet-in-a-Box"); 
?>
<?php service_link("iiab", "Internet-in-a-Box", "Internet-in-a-Box contient une partie des plus importantes information disponibles sur Internet, comme Wikipedia.  Ces informations sont stockées localement pour que tu puisses les lire facilement."); ?>
<?php service_link("moodle", "Accueil Moodle", "Moodle est une collection de leçons et de contenus scolaires organisés pour t’aider à apprendre des choses fascinantes."); ?>
<?php service_link("upload", "Télécharge Fichiers", "A partir de ce lien, tu peux télécharger une variété de fichiers, des images, des activité."); ?>
<?php service_link("activity-server", "Télécharge une activité", "Tu peux ajouter une nouvelle activité sur ton XO depuis ce lien."); ?>

<BR> Bon Voyage!
</div><!-- #main -->
</div><!-- #wrapper -->
</BODY>
<script type="text/javascript" src="incl/xs-portal.js"></script>
</HTML>
