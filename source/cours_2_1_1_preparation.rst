***********
Préparation
***********

Départ
======


On recommence un petit site avec ce qu'on a appris la dernière fois. On ajoute juste un formulaire pour mettre son nom, son prénom et permettre d'envoyer un petit compliment aux créateurs du site.

#. :command:`npm init` (on va appeler notre fichier de départ *server*)
#. :command:`npm install express --save`
#. :command:`npm install ejs --save`
#. création des dossiers annexes:

  * :file:`assets` pour les fichiers statiques. On y met une image pour les 404 appele :file:`404.jpg` (prenez par exemple l'image de `<https://fr.wikipedia.org/wiki/Peugeot_404>`_)
  * :file:`views` pour les vues (avec le template *ejs*) et créez le dossier :file:`partials` dans celui-ci.


On doit obtenir l'architecture de dossiers suivante (en utilisant la commande tree (il faut peut-être l'installer d'abord) qui existe sous unix (peut-être à installer) et windows), en ne regardant pas les sous dossiers de :file:`node_modules` (d'ou la commande grep) :

.. code-block:: sh 

  port-mac-brucker:app fbrucker$ tree -f | grep -v "node_modules/.*"
  .
  ├── ./assets
  │   └── ./assets/404.jpg
  ├── ./node_modules
  ├── ./package-lock.json
  ├── ./package.json
  └── ./views
      └── ./views/partials



server.js
^^^^^^^^^

Base du server et on regarde si ça marche.

.. code-block:: javascript

  var express = require('express')
  var app = express()

  app.set('view engine', 'ejs')

  app.use("/static", express.static(__dirname + '/assets'))


  app.listen(8080);
  console.log("c'est parti");


On peut aller sur `<http://localhost:8080>`_ et voir si notre assets fonctionne :
`<http://localhost:8080/static/404.jpg>`_

.. note :: on a dissocié les url (static) du dossier effectif (./assets/) 


404.ejs
^^^^^^^


On commence par gérer les 404, puis on rajoutera toutes les autres routes au-dessus de celle-ci.

On place notre :file:`404.ejs`


.. code-block:: html

  <html>
      <head>
          <meta charset="utf-8" />
          <title>404</title>

          <style>
              img {
                  display: block;
                  width: 580px;
                  height: 419px;
                  margin: auto;
              }
          </style>
      </head>
      <body>
          <h1>Oooops !</h1>
          <img src="/static/404.jpg" />
      </body>
  </html>


Et on ajoute la route dans le :file:`server.js` (à la toute fin, juste avant le lancement de l'appli. Si on a rien trouvé avant, c'est que c'est un 404)

.. code-block:: javascript

  // 404 aucune interception
  app.use(function (req, res, next) {
        res.status(404).render("404")
  })


On le vérifie avec Chrome et les outils de développement (on doit voir le status 404 dans l'onglet *network*. Il faut charger la page une fois dans l'onglet *network*)


main.css
^^^^^^^^ 

L'architecture générale fonctionne, on va commencer notre premier nettoyage : séparer html et style pour que l'on puisse facilement s'y retrouver plus tard (aucun css dans les html). Ici :

* on chargera un fichier :file:`main.css` contenant les caractéristiques générale d'une image
* on spécifiera la taille de l'image voulue dans la balise img


ce qui donne l'ajout de la ligne suivante dans le header de :file:`404.ejs` : 

.. code-block:: html

  <html>
      <head>
          <meta charset="utf-8" />
          <title>404</title>

          <link rel="stylesheet" type="text/css" href="/static/main.css">
      </head>
      <body>
          <h1>Oooops !</h1>
          <img src="/static/404.jpg" width="580px" height="419px" />
      </body>
  </html>
          

et dans le :file:`main.css` on a ajouté, outre le comportement général d'une image (block et centré), les marges du body et de html.


.. code-block:: css 

  html, body {
    margin:0;
    padding:0;

    background: skyblue;
    color: #FFFFFF;
    font-size: 2em;
  }

  img {
    display: block;
    margin: auto;
  }


home.ejs
^^^^^^^^

On ajoute maintenant notre première page, le home (ou la fame).

On va mettre les éléments dans le répertoire :file:`views`. On commence par ajouter la route à :file:`server.js` (avant la route par défaut qui est le 404) :

.. code-block:: javascript

  app.get('/', (request, response) => {
          response.render("home")
  })




Puis on crée notre vue :file:`home.ejs` dnas le répertoire :file:`views`.

.. code-block:: html

  <html>
      <head>
          <meta charset="utf-8" />
          <title>Maison page</title>

          <link rel="stylesheet" type="text/css" href="/static/main.css">
      </head>

      <body>
          <h1>Le site</h1>
          <p>Il va y avoir des données (plein).</p>
      </body>
  </html>



navbar
======

Ajout de `<http://materializecss.com>`_ pour que ce soit plus joli ! Par exemple la navbar : `<http://materializecss.com/navbar.html>`_

.. note :: on peut faire plein de trucs chouette avec materialize ! Mais c'est encore très (trop) instable. Pour une solution (très) stable vous aussi regarder du côté de `<http://getbootstrap.com>`_ (qui à l'heure que je tape ces lignes est en beta de la v4)




On va installer ces bibliothèques dans :file:`assets` puisque ce sont des dépendances front. On crée donc un nouveau projet npm pour gérer les dépendances front, et on y ajoute nos bibliothèques.

.. code-block:: sh

  emma:app $ cd assets
  emma:assets $ npm init
  emma:assets $ npm install materialize-css --save

On peut maintenant importer la bibliothèque dans :file:`home.ejs` : 

.. code-block:: html

  <html>

  <head>
      <meta charset="utf-8" />
      <title>Maison page</title>

      <!--Import Google Icon Font-->
      <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
      <!--Import materialize.css-->
      <link type="text/css" rel="stylesheet" href="/static/node_modules/materialize-css/dist/css/materialize.min.css" media="screen,projection"
      />

      <link rel="stylesheet" type="text/css" href="/static/main.css">
  </head>

  <body>
      <nav>
          <div class="nav-wrapper">
              <a href="/" class="brand-logo left">Da site</a>
              <ul id="nav-mobile" class="right">
                  <li>
                      <a href="commentaires">Commentaires</a>
                  </li>
              </ul>
          </div>
      </nav>

      <h1>Le site</h1>
      <p>Il va y avoir des données (plein).</p>

      <!--Import jQuery before materialize.js-->
      <script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
      <script type="text/javascript" src="/static/node_modules/materialize-css/dist/js/materialize.min.js"></script>
  </body>

  </html>


comentaires (placeholder)
^^^^^^^^^^^^^^^^^^^^^^^^^  

La navbar contient un lien vers une route commentaires. On placera notre formulaire là plus tard. Pour l'instant faisons juste en sorte que la route soit reconnue. 

On ajoute ainsi la route dans :file:`server.js`, juste après la route "/" et avant le "404".

.. code-block:: javascript

  app.get('/commentaires', (request, response) => {
      response.render("commentaires")
  })

Et le fichier :file:`commentaires.ejs`

.. code-block:: html

  <html>

  <head>
      <meta charset="utf-8" />
      <title>Commentaires</title>

      <!--Import Google Icon Font-->
      <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
      <!--Import materialize.css-->
      <link type="text/css" rel="stylesheet" href="/static/node_modules/materialize-css/dist/css/materialize.min.css" media="screen,projection"
      />

      <link rel="stylesheet" type="text/css" href="/static/main.css">
  </head>

  <body>

      <nav>
          <div class="nav-wrapper">
              <a href="/" class="brand-logo left">Da site</a>
              <ul id="nav-mobile" class="right">
                  <li>
                      <a href="commentaires">Commentaires</a>
                  </li>
              </ul>
          </div>
      </nav>

      <ul>
          <li>Si j'ai quoi ? affirmatif.</li> 
          <li>Et quoi d'autre ? No comment.</li>
      </ul>

      <!--Import jQuery before materialize.js-->
      <script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
      <script type="text/javascript" src="/static/node_modules/materialize-css/dist/js/materialize.min.js"></script>
  </body>

  </html>


.. note :: on voit que les liste n'ont pas de puces. En ragardant les propriétés css, on voit que c'est materialize qui a modifié leur comprotement.  C'est pourquoi l'ordre de import des fichiers css et js est important. 


Les partials
============ 

On a dupliqué du code (la navbar et les imports). C'est très dangereux. On va utiliser des partials qui seront importés depuis le dossier :file:`views/partials`

Vous allez faire 3 partials : 

  * :file:`navbar.ejs`
  * :file:`head_imports.ejs`
  * :file:`js_imports.ejs`

Ils seront placés dans tous les ejs à part le 404 qui est spécial (il ne fait PAS partie du site).


:file:`views/partials/navbar.ejs` :

.. code-block:: html

  <nav>
      <div class="nav-wrapper">
          <a href="/" class="brand-logo left">Da site</a>
          <ul id="nav-mobile" class="right">
              <li>
                  <a href="commentaires">Commentaires</a>
              </li>
          </ul>
      </div>
  </nav>


:file:`views/partials/head_css_import.ejs` :

.. code-block:: html

  <!--Import Google Icon Font-->
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <!--Import materialize.css-->
  <link type="text/css" rel="stylesheet" href="/static/node_modules/materialize-css/dist/css/materialize.min.css" media="screen,projection"
  />

  <link rel="stylesheet" type="text/css" href="/static/main.css">


:file:`views/partials/js_import.ejs` :

.. code-block:: html

  <!--Import jQuery before materialize.js-->
  <script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
  <script type="text/javascript" src="/static/node_modules/materialize-css/dist/js/materialize.min.js"></script>


Ce qui donne pour :file:`home.ejs` :

.. code-block:: text

  <html>

  <head>
      <meta charset="utf-8" />
      <title>Maison page</title>
      <% include partials/head_css_import.ejs %>
  </head>

  <body>
      <% include partials/navbar.ejs %>

      <h1>Le site</h1>
      <p>Il va y avoir des données (plein).</p>

      <% include partials/js_import.ejs %>
  </body>

  </html>


et pour :file:`commentaires.ejs` :

.. code-block:: text

  <html>

  <head>
      <meta charset="utf-8" />
      <title>Commentaires</title>

      <% include partials/head_css_import.ejs %>
  </head>

  <body>

      <% include partials/navbar.ejs %>

      <ul>
          <li>Si j'ai quoi ? affirmatif.</li>
          <li>Et quoi d'autre ? No comment.</li>
      </ul>

      <% include partials/js_import.ejs %>
  </body>

  </html>


refactor
========


refactor en séparant les routes du server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

En informatique, on aime bien bien séparer le code en unité fonctionnelles, de préférence dans de petits fichiers.

Ici, on va séparer ce qui est de l'ordre de la création du serveur et les routes qu'il peut prendre (pour l'instant on a peu de routes, mais cela augmente généralement très vite).

.. note :: cela va aussi nous permettre de voir comment javascript gère les modules.  `<https://www.sitepoint.com/understanding-module-exports-exports-node-js/>`_


On crée un fichier :file:`app.js` contenant nos routes :

.. code-block:: js

    var express = require('express')
    var app = express()

    app.set('view engine', 'ejs')


    app.use("/static", express.static(__dirname + '/assets'))


    app.get('/', (request, response) => {
        response.render("home")
    })

    app.get('/commentaires', (request, response) => {
        response.render("commentaires")
    })


    // 404 aucune interception
    app.use(function (req, res, next) {
        res.status(404).render("404")
        logger.info("404 for: " + req.originalUrl);
    })


    module.exports = app


Et le :file:`server.js`

.. code-block:: js

    app = require('./app.js')

    port = 8080
    app.listen(port);
    console.log("c'est parti: http://localhost:" + port.toString())