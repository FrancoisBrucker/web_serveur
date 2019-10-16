**********************
Web front : javascript
**********************


Permet la modification de l'arbre DOM.

Le script est exécuté lorsqu'il est lu : il est souvent exécuté à la fin du html ou via un évènement lancé après que la page soit chargée.


Le javascript permet de modifier cet arbre DOM via des évènements : https://www.w3schools.com/jsref/dom_obj_event.asp.


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

Une nouvelle tendance émerge comme utiliser d'autres langages puis on les "compile" en javascript : https://www.transcrypt.org


Javascript et jQuery
--------------------


.. note::

    * Commencer par n'installer que jQuery
    * aller dans les outils de développement et montrer ce que l'on a
    * jouer avec jQuery :code:`$("p").html()` un peu.
    * dire qu'il faut que tout soit chargé avant que ça marche.

Ajout de la bibliothèque jQuery (http://jquery.com) directement depuis un CDN
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


Le Javascript est un langage très utilisé en front. C'est pas le plus beau mais avec la version ES6 (https://fr.wikipedia.org/wiki/ECMAScript), ça commence à ressembler à quelque chose.

.. image:: _static/javascript_the_good_parts.jpg

.. note:: Un peu de lol. Javascript en entier vs ce qui en est utilisé.



Nous allons l'utiliser aussi côté back, avec *node*.

On va tout de suite installer node pour utiliser son gestionnaire de package npm
(https://www.npmjs.com) ou un
équivalent yarn (https://yarnpkg.com/lang/en/).

build
----- 

.. todo:: à faire bien

jquery est utilisé en production pour notre site. Il faut modifier notre script de build

https://yarnpkg.com/lang/en/docs/cli/install/ : yarn install --production --modules-folder="../build"

outils de build
===============

 Il existe plusieurs outils de build, comme https://webpack.js.org/ https://brunch.io ou encore https://parceljs.org

.. note:: A l'aide du tuto https://www.grafikart.fr/tutoriels/parcel-bundler-985 séparez le code en src et build

