*********
Web front
*********


Structure de base d'un document : http://www.alsacreations.com/article/lire/1374-html5-structure-globale-document.html

Juste un petit exemple, on en refera par la suite, c'est juste pour ne pas être (trop) perdu

html
====

.. note:: faire en direct avec le lien vers un navigateur.


Langage à balise. Toujours deux parties, :code:`<head></head>` et :code:`<body></body>`.

Le navigateur interprétera directement le fichier. On ne passe pas par un serveur,
il utilise directement le fichier avec l'uri (https://fr.wikipedia.org/wiki/Uniform_Resource_Identifier)  :code:`file://chemin/absolu/vers/fichier.html`


.. code-block:: html

	<!doctype html>
    <html>
        <head>
            <meta charset="utf-8" />
            <title>Maison page</title>
        </head>
        <body>
            <h1>Enfin du web !</h1>
            <p>Et on aime ça.</p>
        </body>
    </html>


L'html crée un arbre (via les balises imbriquées). Il est appelé arbre DOM (Document Object Model)

ajout du css
============

.. note:: faire uniquement le début pour voir les changements s'effectuer en direct.


css ajouté directement sur la page grâce à la balise :code:`<style></style>`

.. code-block:: html

	<!doctype html>
    <html>
        <head>
            <meta charset="utf-8" />
            <title>Maison page</title>

            <!--        https://fonts.google.com-->
            <link href="https://fonts.googleapis.com/css?family=Indie+Flower" rel="stylesheet">

            <style>
                html, body {
                    margin:0;
                    padding:0;

                    background: skyblue;
                    color: #FFFFFF;
                    font-size: 2em;
                    text-align: center;
                }
                p {
                    font-family: 'Indie Flower';
                }
            </style>
        </head>
        <body>
            <h1>Enfin du web !</h1>
            <p>Et on aime ça.</p>
        </body>
    </html>


Pour la couleur, on la gère en hexadécimal RGB sur 32bits 8 par channel.

* Pour un aperçu des couleurs : https://color.adobe.com/fr/
* pour les couleurs web : https://www.w3schools.com/colors/colors_names.asp


les div et pourquoi c'est important
===================================

les div (ou span) sont des blocs anonymes :
* span: sur une ligne. Ils sont placés les un à côtés des autres (propriété display en css). Comme un img ou un strong
* div: un bloc les un en dessous des autres. Comme un p, ou un h1

 Elles ne vont être caractérisées que par les classes/id css qu'on leur mettra.

* class: plusieurs paramètres peuvent avoir la ou les mêmes classes
* id: unique pour un bloc particulier

On peut très finement caractériser la portée d'un sélecteur css : https://www.w3schools.com/cssref/css_selectors.asp

Attention cependant :

* une caractérisation chasse l'autre (donc on mettra ses propres sfichiers css en dernier)
* les propriété snt appliquées de la plus générale à la slus spécifique (qui masque donc la plus générale)
* il est compliqué de centrer verticalement (on le fera donc rarement tout seul)


.. code-block:: html

  <html>
    <head>
      <title>Maison Page</title>


    </head>
    <body>
      <style>
        html, body {
          margin: 0;
          padding:0;

          background: skyblue;
          color: #FFFFFF;
          font-size: 2em;
          text-align: center;
        }
        .milieu {
          margin: 10px auto;
          height: 50px;
          width: 20px;
        }
        .color {
          background-color: olive;
        }
      </style>

      <h1> Enfin du web !</h1>
      <p> et on aime ça</p>
      <div class="milieu color"></div>
    </body>
  </html>

js (côté front)
===============

Permet la modification de l'arbre DOM

Le script est exécuté lorsqu'il est lu : il est souvent exécuté à la fin  du html ou via un
 évènement lancé après que la page soit chargée.


Le javascript permet de modifier cet arbre DOM via des évènements : https://www.w3schools.com/jsref/dom_obj_event.asp


.. code-block:: html

  <html>
    <head>
      <title>Maison Page</title>


    </head>
    <body>
      <style>
        html, body {
          margin: 0;
          padding:0;

          background: skyblue;
          color: #FFFFFF;
          font-size: 2em;
          text-align: center;
        }
        .milieu {
          margin: 10px auto;
          height: 50px;
          width: 20px;
        }
        .color {
          background-color: olive;
        }
      </style>

      <h1> Enfin du web !</h1>
      <p> et on aime ça</p>
      <div id="mon_div" class="milieu color"></div>

      <script>
        document.getElementById("mon_div").onclick = function() {
          document.getElementById("mon_div").style.backgroundColor = "blue"
        }

      </script>
    </body>
  </html>

On peut aussi faire plus compliqué :

.. code-block:: html

  <script>
    blue = false;
    document.getElementById("mon_div").onclick = function() {
      if (blue) {
        blue = false;
        document.getElementById("mon_div").style.backgroundColor = "olive"
      }
      else {
        blue = true;
        document.getElementById("mon_div").style.backgroundColor = "blue"
      }

    }
  </script>

Comme c'est compliqué comme ça, on utilise souvent (toujours ?) des bibliothèques.

Une nouvelle tendance émerge comme utiliser d'autre langages puis on les "compile" en javascript : https://www.transcrypt.org


js et jquery
------------


.. note::

    * Commencer par n'installer que jquery
    * aller dans les outils de développement et montrer ce que l'on a
    * jouer avec jquery :code:`$("p").html()` un peu.
    * dire qu'il faut que tout soit chargé avant que ça marche.

Ajout de la bibliothèque jquery (http://jquery.com) directement depuis un CDN
(https://fr.wikipedia.org/wiki/Content_delivery_network) et d'un peu de code javascript avec la balise :code:`<script></script>`.

Notez le côté purement fonctionnel de la programmation (ici fin de chargement, entrée/sortie d'un sélecteur).

.. code-block:: html

	<!doctype html>
    <html>
        <head>
            <meta charset="utf-8" />
            <title>Maison page</title>

            <!--        https://fonts.google.com-->
            <link href="https://fonts.googleapis.com/css?family=Indie+Flower" rel="stylesheet">

            <style>
                html, body {
                    margin:0;
                    padding:0;

                    background: skyblue;
                    color: #FFFFFF;
                    font-size: 2em;
                    text-align: center;
                }
                p {
                    font-family: 'Indie Flower';
                }
            </style>

            <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
            <script>
                //le paragraphe n'existe pas encore
                console.log($("p").html())
                $(function() {
                    // le paragraphe est chargé
                    console.log($("p").html())

                    //pour le lol. Appel asynchrone des fonctions.
                    $("p").hover(
                        function() {
                            $(this).css("text-decoration", "underline")
                        },
                        function() {
                            $(this).css("text-decoration", "none")
                        }
                    )
                })
            </script>

        </head>
        <body>
            <h1>Enfin du web !</h1>
            <p>Et on aime ça.</p>
        </body>
    </html>


Le javascript est un langage très utilisé en front. C'est pas le plus beau mais avec la version ES6 (https://fr.wikipedia.org/wiki/ECMAScript), ça commence à ressembler à quelque chose.

.. image:: _static/javascript_the_good_parts.jpg

.. note:: Un peu de lol. javascript en entier vs ce qui en est utilisé.



Nous allons l'utiliser aussi côté back, avec *node*.

On va tout de suite installer node pour utiliser son gestionnaire de package npm
(https://www.npmjs.com) ou un
équivalent yarn (https://yarnpkg.com/lang/en/)

.. code-block sh::

  yarn init
  yarn install


js ui
-----

Pour fabriquer des UI, js est un bon outil, muni des bons frameworks.
 Le très connu et reconnu https://reactjs.org, ou encore https://vuejs.org

Orienté jeu/2D : pixijs (http://www.pixijs.com)
