*******************************
Outils de développement continu
*******************************

Cette partie traîte les loggeurs et les tests unitaires/fonctionnels.

Logger
=======

On commence à avoir pas mal de trafic sur notre site, et on est pas à l'abri de bug. La première chose à faire est donc de stocker tout ce qui se passe niveau serveur. En cas d'erreurs, on pourra remonter la trace de ce qui a conduit à l'erreur ou pire au plantage.

De nombreuses applications de log existent pour node, nous utiliserons `<https://github.com/winstonjs/winston>`_.

.. note:: voir par exemple `<https://blog.risingstack.com/node-js-logging-tutorial/>`_ ou encore `<http://thisdavej.com/using-winston-a-versatile-logging-library-for-node-js/>`_

Pour la version 3, celle que nous utiliserons, il faut installer la version de développement de winston : :code:`npm install winston@next --save`. 


.. note ::  Le code ci-après ne fonctionnera pas avec la version 2.4, qui est la version stable à l'heure où j'écris ces lignes.


App.js
^^^^^^ 


En lisant un peu la doc et les tutos, on ajoute son propre logger dans :file:`app.ejs` :

.. code-block:: javascript

  const winston = require('winston');
  const logger = winston.createLogger({
      format: winston.format.combine(winston.format.timestamp(),
      winston.format.simple())
  });

Puis on ajoute la visibilité des logs. Ci-après, on ajoute un retour console qui va tout afficher jusqu'à un level silly : 

.. code-block:: javascript

  logger.add(new winston.transports.Console({
      level: 'silly'    
  }));  


Par défaut, le level d'affichage est de :code:`info` (voir `<https://github.com/winstonjs/winston#logging-levels>`_). 

On ajoute les deux dernières lignes à :file:`app.js` :

.. code-block:: javascript

  logger.info("c'est parti")
  logger.silly("mon kiki")

L'affichage console est pratique en développement. En production, on préfère peu de log mais les stocker dans des fichiers. Par exemple : 

.. code-block:: javascript

  logger.add(new winston.transports.File({ filename: 'error.log', level: 'error' }))
  logger.add(new winston.transports.File({ filename: 'combined.log' }))
 

On va ajouter un log systématique à chaque appel grâce à un petit middle-ware : 

.. code-block:: javascript

  app.use(function(req, res, next) {
      logger.debug("url: " + req.originalUrl);
      next();
  })

Et on log également les 404 :

.. code-block:: javascript

  // 404 aucune interception
  app.use(function (req, res, next) {
      logger.info("404 for: " + req.originalUrl);

      res.status(404).render("404")
  })


En changeant le level de notre logger à *debug* ont devrait voir tous les appels.

.. note :: Les différents attributs de requêtes sont décrits ici : `<http://expressjs.com/fr/api.html#req>`_.


Logger.js
^^^^^^^^^

De part la nature des imports js, on peut passer des paramètres à la création d'un module. Utilisons ça pour séparer logger et app.

Fichier :file:`logger.js` :

.. code-block:: js

    const winston = require('winston');
    const logger = winston.createLogger({
        format: winston.format.combine(winston.format.timestamp(),
        winston.format.simple())
    });

    // dev mode logger
    logger.add(new winston.transports.Console({
        level: 'silly'    
    }));  

    //file
    //logger.add(new winston.transports.File({ filename: 'error.log', level: 'error' }))
    //logger.add(new winston.transports.File({ filename: 'combined.log' }))

    module.exports = logger


Fichier :file:`app.js` :

.. code-block:: js 

    var express = require('express')
    var app = express()

        module.exports = (logger) => {

            app.set('view engine', 'ejs')

            app.use(function(req, res, next) {
                logger.debug("url: " + req.originalUrl);
                next();
            })

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
                logger.info("404 for: " + req.originalUrl)
            })

            return app
        }


Fichier :file:`server.js` :

.. code-block:: js 

    logger = require('./logger.js')
    app = require('./app.js')(logger)

    port = 8080
    app.listen(port);

    logger.info("c'est parti: http://localhost:" + port.toString())
    logger.silly("mon kiki")


Tests
=====

.. note :: 

    `<https://www.slideshare.net/robertgreiner/test-driven-development-at-10000-feet>`_
    regardez en particulier la courbe décroissante.

Côté Client
^^^^^^^^^^^  

On peut tester le rendu client en simulant un navigateur.

Pour cela on utilise Selenium `<http://www.seleniumhq.org>`_ et ses webdrivers qui simulent un browser. Tout ceci fonctionne en java, donc assurez vous d'avoir un java qui corresponde.
Étapes à suivre : 

#. installation de java (si nécessaire. Tapez java dans un terminal/powershell et si ça rate, c'est qu'il faut l'installer) : `<https://www.java.com/fr/download/faq/develop.xml>`_ et suivez le lien pour télécharger le jdk.
#. récupérer le fichier jar de Selenium standalone server : `<http://www.seleniumhq.org/download/>`_.
#. ajouter un driver. Nous utiliserons celui de Chrome : `<https://sites.google.com/a/chromium.org/chromedriver/>`_. Il y en a d'autres possibles (par exemple pour Firefox : `<https://github.com/mozilla/geckodriver/releases>`_).

Une fois Selenium et le driver placé dans un dossier Selenium. Je l'ai placé dans le dossier parent de l'application. On peut tester pour voir si ça marche. En utilisant ce que j'ai téléchargé et mis dans le même dossier : :code:`java -Dwebdriver.chrome.driver=./chromedriver.exe -jar selenium-server-standalone-3.8.1.jar` 

Un serveur web Selenium est lancé. Il est sur le port 4444 par défaut (lisez les logs).

.. note :: Java est toujours verbeux dans ses logs. Apprenez à les lire. 

Et maintenant, il nous reste à installer `<http://webdriver.io>`_ pour utiliser Selenium avec Node : :code:`npm install --save-dev webdriverio`

.. note :: On a installé webdriver.io uniquement pour le développement. Il n'est pas nécessaire de l'emmener avec nous en production.

Et on fait un premier essai avec le tout : :file:`selenium.essai.js` :

.. code-block:: js 
 
    var webdriverio = require('webdriverio');

    var options = {
        desiredCapabilities: {
            browserName: 'chrome'
        }
    }

    webdriverio
    .remote(options)
    .init()
    .url('https://www.google.fr')
    .saveScreenshot("snapshot.png")
    .catch(function(err) {
        console.log(err);}) 
    .end();




Avant d'exécuter le fichier avec :code:`node selenium.essai.js` On s'assure que le serveur Selenium tourne toujours sur le port 4444.

.. note :: Assurez vous de ne part avoir de serveur qui tourne sur le port par défaut. Sinon, changez de port par défaut.

On peut maintenant faire des vrais tests pour notre application : 

* vérifier que par défaut on est sur la page d'accueil ;
* en cliquant sur commentaires on arrive bien sur la page de commentaires ;
* en recliquant sur le nom de la page, on retourne à l'accueil.

.. code-block:: js 

    var webdriverio = require('webdriverio');


    var options = {
        desiredCapabilities: {
            browserName: 'chrome'
        }
    }

    browser = webdriverio
    .remote(options)
    .init()


    browser.url('http://localhost:8080')
    .getTitle().then( (title) => {
        console.log("titre : " + title)
    })
    .click("a[href='commentaires']")
    .getTitle().then( (title) => {
        console.log("titre : " + title)
    })
    .click("a*=Da")
    .getTitle().then( (title) => {
        console.log("titre : " + title)
    })
    .catch(function(err) {
        console.log(err);
        }) 
    .end()


.. note :: Attention au .end(). Tout est asynchrone donc si on ajoute une ligne avec le .end(), il risque d'être exécuté avant la fin de la requête.

On peut attraper plein de choses avec Selenium et Webdriver.io en utilisant les selecteurs : `<http://webdriver.io/guide/usage/selectors.html>`_


On peut finalement rajouter tous nos tests à la batterie de tests de Node en créant un dernier morceau notre fichier avec le nom "test.js". Voir partie suivante pour créer une batterie de tests avec jest.js.


Côté Serveur
^^^^^^^^^^^^ 

`<https://facebook.github.io/jest/>`_

Tester le JS et les routes.


Pour l'instant on a pas de fonction JS, donc on va faire comme si et reprendre le tuto.

:file:`sum.js` :

.. code-block:: js

  function sum(a, b) {
      return a + b;
    }
    module.exports = sum;


:file:`sum.test.js` :

.. code-block:: js

  const sum = require('./sum');

  describe('test sum', () => {
      test('adds 0 + 0 to equal 0', () => {
          return expect(sum(0, 0)).toBe(0)
        });    
      test('adds 1 + 2 to equal 3', () => {
          return expect(sum(1, 2)).toBe(3)
        });
  })


On installe jest pour le développement, :code:`npm install --save-dev jest`, puis on mets jest comme commande de test dans :file:`package.json`. Par exemple le mien ressemble à : 

.. code-block:: json

  {
    "name": "donnees",
    "version": "1.0.0",
    "description": "cours sur les données",
    "main": "server.js",
    "scripts": {
      "test": "jest"
    },
    "author": "",
    "license": "ISC",
    "dependencies": {
      "ejs": "^2.5.7",
      "express": "^4.16.2",
      "winston": "^3.0.0-rc1"
    },
    "devDependencies": {
      "jest": "^21.2.1"
    }
  }


On peut ensuite utiliser la commande :code:`npm test`  pour exécuter tous les fichiers qui finissent par `test.js` 


.. note :: on peut aussi utiliser jest en ligne de commande en l'installant de façon globale. Voir `<https://facebook.github.io/jest/docs/en/getting-started.html#running-from-command-line>`_


Pour tester des routes maintenant : on utilise en plus supertest `<https://github.com/visionmedia/supertest>`_ 

:code:`npm install --save-dev supertest`

.. note :: voir `<http://www.albertgao.xyz/2017/05/24/how-to-test-expressjs-with-jest-and-supertest/>`_

:file:`routes.test.js` :

.. code-block:: js

  const request = require('supertest');
  logger = require('./logger.js')
  app = require('./app.js')(logger)

  describe('routes ok', () => {
      test('It should response the GET method', (done) => {
          request(app).get("/").then((response) => {
              expect(response.statusCode).toBe(200)            
              done()
          })
      });
      test('It should response the GET method', (done) => {
          request(app).get("/commentaires").then((response) => {
              expect(response.statusCode).toBe(200)  
              done()          
          })
      });
  })

  describe('routes 404', () => {
      test('It should response 404', (done) => {
          request(app).get("/troululu").then((response) => {
              expect(response.statusCode).toBe(404)            
              done()
          })
      });
  })




Test Utilisateur (UI)
^^^^^^^^^^^^^^^^^^^^^ 

`<https://www.invisionapp.com/blog/ux-usability-research-testing/>`_

`<https://blogs.adobe.com/creativecloud/best-practices-for-usability-testing-in-ux-design/>`_

