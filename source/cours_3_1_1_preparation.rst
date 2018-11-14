***********
Préparation
***********

Départ
======


On recommence un petit site avec ce qu'on a appris la dernière fois. On ajoute juste un formulaire pour mettre son nom, son prénom et permettre d'envoyer un petit compliment aux créateurs du site.

#. :code:`npm init` (on va appeler notre fichier de départ *server*),
#. :code:`npm install express --save`,
#. :code:`npm install ejs --save` (Plus de détails sur ejs dans le prochain point)
#. création des dossiers annexes:

  * :file:`assets` pour les fichiers statiques. On y met une image pour les 404 appelée :file:`404.jpg` (prenez par exemple l'image de `<https://fr.wikipedia.org/wiki/Peugeot_404>`_)
  * :file:`views` pour les vues (avec le template *ejs*) et créez le dossier :file:`partials` dans celui-ci.


On doit obtenir l'architecture de dossiers suivante (en utilisant la commande tree qu'il faut peut-être installer d'abord), sans regarder les sous dossiers de :file:`node_modules` (d'où la commande :code:`grep`) :

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


ejs
^^^^^^^^^

Présentatiob test de ejs

server.js
^^^^^^^^^

C'est la base du serveur :

.. code-block:: javascript

  var express = require('express')
  var app = express()

  app.set('view engine', 'ejs')

  app.use("/static", express.static(__dirname + '/assets'))


  app.listen(8080);
  console.log("c'est parti");


Regardons si ça marche... On peut aller sur `<http://localhost:8080>`_ et voir si notre assets fonctionne :
`<http://localhost:8080/static/404.jpg>`_

.. note :: on a dissocié les URL (static) du dossier effectif (./assets/) 


404.ejs
^^^^^^^


On commence par gérer les 404, puis on rajoutera toutes les autres routes au-dessus de celle-ci.

On place notre :file:`404.ejs` :


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


Et on ajoute la route dans le :file:`server.js` (à la toute fin, juste avant le lancement de l'appli. Si on a rien trouvé avant, c'est que c'est un 404) :

.. code-block:: javascript

  // 404 aucune interception
  app.use(function (req, res, next) {
        res.status(404).render("404")
  })


On peut le vérifier avec Chrome et les outils de développement (on doit voir le status 404 dans l'onglet *network*. N'oubliez pas d'actualiser la page pour que l'onglet *network* fonctionne).


main.css
^^^^^^^^ 

L'architecture générale fonctionne, on va commencer notre premier nettoyage : séparer HTML et style pour que l'on puisse facilement s'y retrouver plus tard (aucun css dans les html). Ici :

* On chargera un fichier :file:`main.css` contenant les caractéristiques générales d'une image,
* On spécifiera la taille de l'image voulue dans la balise img.


Ce qui donne l'ajout de la ligne suivante dans le header de :file:`404.ejs` : 

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
          

Et dans le :file:`main.css` on a ajouté, outre le comportement général d'une image (block et centré), les marges des balises body et html.


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




Puis on crée notre vue :file:`home.ejs` dans le répertoire :file:`views`.

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



Navbar
======

Ajout de `<http://materializecss.com>`_ pour que ce soit plus joli ! Par exemple la navbar : `<http://materializecss.com/navbar.html>`_

.. note :: on peut faire plein de trucs chouette avec materialize ! Mais c'est encore très (trop) instable. Pour une solution (très) stable vous pouvez aussi regarder du côté de `<http://getbootstrap.com>`_ (qui à l'heure que je tape ces lignes est en beta de la v4) (et qui à l'heure où je corrige ces lignes, en est à la v4 tout court)




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


Commentaires (placeholders)
^^^^^^^^^^^^^^^^^^^^^^^^^^^ 

La navbar contient un lien vers une route "commentaires". On placera notre formulaire là-bas plus tard. Pour l'instant, faisons juste en sorte que la route soit reconnue. 

On ajoute ainsi la route dans :file:`server.js`, juste après la route "/" et avant le "404".

.. code-block:: javascript

  app.get('/commentaires', (request, response) => {
      response.render("commentaires")
  })

Et le fichier :file:`commentaires.ejs` :

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


.. note :: on voit que les listes n'ont pas de puces. En regardant les propriétés css, on voit que c'est materialize qui a modifié leur comportement.  C'est pourquoi l'ordre des import des fichiers css et js est important. 


Les partials
============ 

On a dupliqué du code (la navbar et les imports). C'est très dangereux. Pour corriger cela, on va utiliser des partials qui seront importés depuis le dossier :file:`views/partials`

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


Refactor
========


Refactor en séparant les routes du serveur
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
        // logger.info("404 for: " + req.originalUrl); Le logger n'a pas ete defini, on en parle juste apres
    })


    module.exports = app


Et le :file:`server.js`

.. code-block:: js

    app = require('./app.js')

    port = 8080
    app.listen(port);
    console.log("c'est parti: http://localhost:" + port.toString())
    
Les Logs
========

Parlons un peu des fichiers logs. Formellement, les fichiers logs sont définis au sens large comme " Un dispositif, permettant de stocker un historique des évènements attachés à un processus". 

Dans le cas de notre site, ils constituent en quelque sorte le journal d'accès à notre serveur.

Ils sont un élément essentiel côté administrateur, pour de mutiples raisons :
 * Comprendre la provenance d’erreurs,
 * Témoin de l’activité d’un site,
 * Statistiques de connexion,
 * Etc.
 
Durant les chapitres précédents, nous avons utilisé les logs pour affichers quelques informations en console (Lancement du serveur, etc.). C'est sympa, mais l'on peut faire beaucoup plus de choses, on va le voir avec la bibliothèque Winston.

:code:`npm install winston --save`

Premiers exemples
^^^^^^^^^^^^^^^^^

Ouvrez votre fichier server.js, et collez y le code suivant, avant de relancer votre serveur :

.. code-block:: js

 // On importe Winston
 const { createLogger, format, transports } = require('winston');

 // On crée ici notre logger, et l'on va le customiser via ses paramètres
 const logger = createLogger({
   level: 'debug',   // Niveau de log (Nous en parlerons après)	
   format: format.combine(format.colorize(), format.simple()), // Format de sortie (Couleur, format de données ...)
   transports: [new transports.Console()] // Destination du fichier  log (console, fichier...)
 });

 // On utilise notre logger ainsi crée pour afficher du texte
 logger.info('Hello world');
 logger.debug('Debugging info');	 
 
Vous devriez obtenir dans votre console des logs similaires à ceux que vous avez déjà vus. Jusque là rien de nouveau donc, mais vous constatez dans les commentaires du code que l'on peut personnaliser pas mal de choses.

Par exemple, ajoutons un peu de couleur (Remplacez le code précédent par celui-ci), et la date aux début de nos logs :

.. code-block:: js

 const { createLogger, format, transports } = require('winston');

 const logger = createLogger({
   level: 'debug',
   format: format.combine( // Ici tout se passe dans le format
     format.colorize(), // On ajoute de la couleur
     format.timestamp({ // Gestion de la date
       format: 'YYYY-MM-DD HH:mm:ss' // Format de la date
     }),
     format.printf(info => `${info.timestamp} ${info.level}: ${info.message}`) // Ajout de la date en début de fichier
   ),
   transports: [new transports.Console()]
 });

 logger.info('Hello world');
 logger.debug('Debugging info');

Créons également une nouvelle direction de sortie pour nos fichiers logs (En plus de la console) :

.. code-block:: js

 const { createLogger, format, transports } = require('winston');

 // Pour préparer notre fichier de réception des logs
 const fs = require('fs');
 const path = require('path');
 const logDir = 'log';

 // On crée le fichier si il n'existe pas
 if (!fs.existsSync(logDir)) {
   fs.mkdirSync(logDir);
 }

 const filename = path.join(logDir, 'results.log');

 const logger = createLogger({
   // Nous ne voulons pas la couleur dans notre fichier texte : On ne la défini plus dans les paramètres généraux
   level: 'debug',
   format: format.combine(
     format.timestamp({
       format: 'YYYY-MM-DD HH:mm:ss'
     }),
     format.printf(info => `${info.timestamp} ${info.level}: ${info.message}`)
   ),
   transports: [
     // En console, nous voulons toujours de la couleur ! On le précise ici
     new transports.Console({
       format: format.combine(
         format.colorize(),
         format.printf(info => `${info.timestamp} ${info.level}: ${info.message}`)
       )
     }),
     // Nouvelle direction de transport : Notre fichier
     new transports.File({ filename })
   ]
 });
 
 logger.info('Hello world');
 logger.debug('Debugging info');

Dans les codes d'exemples précédents, vous voyez apparaître le paramètre "level" dans notre logger, initialisé à "debug". Vous voyez également des "logger.info" et "logger.debug" dans l'affichage des logs. 

En fait, il existe plusieurs niveaux de logs, définis selon des conventions. Par défaut, Winston utilise les mêmes que npm, à savoir :

 * :code:`error` - Niveau 0,
 * :code:`warn` - Niveau 1,
 * :code:`info` - Niveau 2,
 * :code:`verbose` - Niveau 3,
 * :code:`debug` - Niveau 4,
 * :code:`silly` - Niveau 5

Selon le niveau attribué au logger, tous les messages envoyés à celui-ci d'un niveau inférieur ou égal seront traités, pas les autres. Essayez ainsi de passer dans les exemples précédents la valeur du level de "debug" (4) à "info" (2), et vous verrez que la commande "logger.debug" ne sera plus traitée ! 

Celà permet d'attribuer un niveau de gravité aux messages, pour les interpréter et les traiter différemment. Ainsi, un message d'erreur (important !) sera toujours traité, car de niveau 0, alors qu'un message debug pas forcément, selon le niveau du logger. 

Application à notre site web
^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 

Ces quelques exemples vous montrent que l'on peut facilement modifier l'apparence et la destination de sortie de nos logs grâce à Winston. C'est bien, mais pour l'instant celà reste un peu indépendant de notre site web ! En effet, nos messages sont affichés avant même de lancer notre site. Or en pratique, ils nous informent sur son activité.

Pour celà, nous allons télécharger un complément à notre librairie Winston : 
:code:`npm install express-winston --save`

Celle-ci ajoute les middlewares pour pouvoir exploiter Winston avec Express. Et pour illustrer cela, nous allons utiliser un des points forts de express-winston, à savoir afficher des logs d'informations sur les requêtes HTTP effectuées sur notre site (A ajouter dans server.js):

.. code-block:: js

 const {createLogger, format, transports} = require('winston'); 
 var expressWinston = require('express-winston'); 

 const fs = require('fs'); 
 const path = require('path'); 

 const env = process.env.NODE_ENV || 'development'; // Mode développement
 const logDir = 'log'; 

 if (!fs.existsSync(logDir)) { 
   fs.mkdirSync(logDir);}

 const filename = path.join(logDir, 'Resultats.log');

 // Notre middleware 

 const newLogger = expressWinston.logger({    	 	
  transports: [ 
      new transports.Console(), 
      new transports.File({
       filename,
       level: env === 'development' ? 'debug' : 'info',
       }) 
      ],  	
     format: format.combine( // Affichage
      format.timestamp({format: 'YYYY-MM-DD HH:mm:ss' }), 
      format.json(), // Format json en sortie
  ),

  // Quelques fonctionnalités en plusm spécifiques à winston-express
     msg: "Vous avez fait une requête HTTP", // Petit message dans notre log
     expressFormat: false, // Le format voulu est json
     });

  app.use(newLogger) // On utilise notre logger à chaque requête (Applique un next par défaut)
  
Si tout se passe bien, votre fichier log devrait se remplir d'un nouveau log au format json à chaque nouvelle requète. Dans le log, on trouve tout un tas de données (Pas toute utiles, mais l'administrateur peut trier ensuite) sur la requète, comme sa date, son url, etc.


Sécurité
======

Last but not least, discutons à présent sécurité.
La **sécurité** d'un site est un problème très important à prendre en compte lorsque l'on en crée un, sans quoi un utilisateur malveillant pourrait récupérer les données contenues sur vos pages !
Node.js propose un module permettant de mettre en place quelques options de sécurité (nous n'en verrons que quelques unes, mais vous pouvez aller voir par vous même les autres !),  il s'agit de **Helmet**.

Comme toujours, on commence par : 

 :code:`npm install helmet --save`,

en-tête http
^^^^^^^^ 
Les en-têtes http contiennent de nombreuses données, il faut donc y attacher une importance particulière.

Voilà quoi ressemble une entête http sans Helmet (vous pouvez voir vos entêtes http lorsque vous faites une requête, soit directement sur le navigateur: https://o7planning.org/fr/11631/comment-afficher-les-en-tetes-http-dans-google-chrome pour chrome, ou sur powershell, avec la commancd **curl**): 

.. code-block:: js

- HTTP/1.1 200 OK
- X-Powered-By: Express
- Content-Type: text/html; charset=utf-8
- Content-Length: 20
- ETag: W/"14-SsoazAISF4H46953FT6rSL7/tvU"
- Date: Wed, 01 Nov 2017 13:36:10 GMT
- Connection: keep-alive



le code suivant permet de modifier le contenu des ent-têtes http. Copiez le dans le fichier server.js.

.. code-block:: js

   var helmet = require('helmet')

    app.use(helmet());  

Voici notre nouvelle entête:

.. code-block:: js

- HTTP/1.1 200 OK
- X-DNS-Prefetch-Control: off
- X-Frame-Options: SAMEORIGIN
- Strict-Transport-Security: max-age=15552000; includeSubDomains
- X-Download-Options: noopen
- X-Content-Type-Options: nosniff
- X-XSS-Protection: 1; mode=block
- Content-Type: text/html; charset=utf-8
- Content-Length: 20
- ETag: W/"14-SsoazAISF4H46953FT6rSL7/tvU"
- Date: Wed, 01 Nov 2017 13:50:42 GMT
- Connection: keep-alive
 
 Cette fonction permet donc de gérer les données apparaissant dans une en-tête http :
- Elle permet notamment de cacher le fait qu'on ait utilisé express ici pour faire notre site.
- elle permet d'arrêter le DNS-Fetching. Je vous invite à cliquer sur le lien pour en savoir plus: "https://www.alsacreations.com/astuce/lire/1567-prefetch-prerender-dns-prefetch-link.html


 
Comme on peut le voir, il y a d'autres modifications effectuées. Vous pouvez aller voir tout ça sur le web.

Content Security Policy
^^^^^^^^ 

On peut à l'aide d'Helmet, définir des options de csp:

.. code-block:: text

const helmet = require('helmet')

app.use(helmet.contentSecurityPolicy({
  directives: {
    defaultSrc: ["'self'"],
    
    styleSrc: ["'self'", 'maxcdn.bootstrapcdn.com']
  }
}))



Par exemple, la ligne **defaultSrc** permet de définir des contraintes sur les fichiers que l'on peut charger, à partir de leur emplacement. Ici le "self" n'autorise des fichiers que sur notre domaine.
Il existe beaucoup d'autres options, permettant de gérer des provenances de fichiers par exemple, mais je ne les citerai pas ici, car il y en a un grand nombre.


XSS
^^^^^^^^ 

Enfin, un des derniers problèmes dont nous allons parler est l'injection de code ou XSS : Via l'url, un utilisateur malveillant peut injecter du code qui va effectuer des actions sur votre serveur comme par exemple récupérer des données.
Pour l'éviter , Helmet propose la fonction **xssFilter()**.

Il vous suffit de rentrer ce code dans server.js :

.. code-block:: js

app.use(helmet.xssFilter());

**Attention :**

La fonction XSS-filter peut poser certains soucis avec des vieilles version d'internet explorer par exemple, voire faciliter les attaques XSS ironiquement !
Faites donc attention en utilisant cette fonction.

C'était un petit survol d'Helmet afin de vous montrer comment gérer la sécurité de son site, comme je l'ai dit précedemment, il existe d'autres fonctionnalités afin de rendre votre site encore plus sécurisé!



