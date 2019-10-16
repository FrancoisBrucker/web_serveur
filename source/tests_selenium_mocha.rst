*****
Tests
*****

.. todo:: à mettre à jour et utiliser jest et jsdom

Tests
=====

.. note :: 

    `<https://www.slideshare.net/robertgreiner/test-driven-development-at-10000-feet>`_
    regardez en particulier la courbe décroissante.

Côté Client
^^^^^^^^^^^  


Tests côté front
================ 

On fera plutôt des tests fonctionnels en racontant des petites histoires que doit satisfaire notre site, mais on peut aussi voir si nos balises html se placent bien.


webdriver.io
^^^^^^^^^^^^ 

On peut tester le rendu client en simulant un navigateur.

Pour cela on utilise Selenium `<http://www.seleniumhq.org>`_ et ses webdrivers qui simulent un browser. Tout ceci fonctionne en java, donc assurez vous d'avoir un java qui corresponde.
Étapes à suivre : 

#. installation de java (si nécessaire. Tapez java dans un terminal/powershell et si ça rate, c'est qu'il faut l'installer) : `<https://www.java.com/fr/download/faq/develop.xml>`_ et suivez le lien pour télécharger le jdk.
#. récupérer le fichier jar de Selenium standalone server : `<http://www.seleniumhq.org/download/>`_.
#. ajouter un driver. Nous utiliserons celui de Chrome : `<https://sites.google.com/a/chromium.org/chromedriver/>`_. Il y en a d'autres possibles (par exemple pour Firefox : `<https://github.com/mozilla/geckodriver/releases>`_).

Une fois Selenium et le driver placé dans un dossier Selenium. Je l'ai placé dans le dossier parent de l'application. On peut tester pour voir si ça marche. En utilisant ce que j'ai téléchargé et mis dans le même dossier : :code:`java -Dwebdriver.chrome.driver=./chromedriver -jar selenium-server-standalone-3.14.jar` 


sous windows la commande devient : :code:`java "-Dwebdriver.chrome.driver=chromedriver.exe" -jar "selenium-server-standalone-3.14.0.jar"`


.. note:: Attention à la version du serveur selenium et au driver que vous utilisez.

Un serveur web Selenium est lancé. Il est sur le port 4444 par défaut (lisez les logs).

.. note :: Java est toujours verbeux dans ses logs. Apprenez à les lire. 

Et maintenant, il nous reste à installer `<http://webdriver.io>`_ pour utiliser Selenium avec Node : :code:`npm install --save-dev webdriverio`

.. note :: On a installé webdriver.io uniquement pour le développement. Il n'est pas nécessaire de l'emmener avec nous en production. voir https://docs.npmjs.com/cli/install



Et on fait un premier essai avec le tout : :file:`selenium.test.js` dans un repertoire de test :

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




Avant d'exécuter le fichier avec :code:`node ./tests/selenium.test.js` On s'assure que le serveur Selenium tourne toujours sur le port 4444.

.. note :: Assurez vous de ne part avoir de serveur qui tourne sur le port par défaut. Sinon, changez de port par défaut.

On peut maintenant faire la même chose pour notre fichier : 

.. code-block:: js 

    var webdriverio = require('webdriverio');
    var path = require('path');

        var options = {
            desiredCapabilities: {
                browserName: 'chrome'
            }
        }

    var toUpload = path.join(__dirname, '..', '/index.html')
    
    webdriverio
        .remote(options)
        .init()
        .url('file://' + toUpload)
        .saveScreenshot("snapshot.png")
        .catch(function(err) {
            console.log(err);}) 
        .end();



Notez que l'on a ajouté un module (:code:`path`) pour concaténer des chemins (NE JAMAIS LE FAIRE A LA MAIN !) et utilisé la variable spéciale :code:`__dirname` qui rend le repertoire où est le fichier qui est entrain d'être lu (ici :code:`selenium.test.js`).


Pour l'instant ce ne sont pas de vrais tests. Pour cela, on va utiliser une bibliothèque de test (ici https://mochajs.org/).

Commençons par voir ce que l'on veut tester :

 
.. code-block:: js 

	var webdriverio = require('webdriverio');
	var path = require('path');

	var options = {
	    desiredCapabilities: {
	        browserName: 'chrome'
	    }
	}
	var toUpload = path.join(__dirname, 'index.html')

	browser = webdriverio
	    .remote(options)
	    .init()
		.url('file://' + toUpload)
	.getTitle().then( (title) => {
	    console.log("titre : " + title)
	})
	.getText('h1.title').then((title) => {
	    console.log("h1 : " + title)
	})
	.catch(function(err) {
	    console.log(err);
	    }) 

	.end()
    

.. note :: Attention au .end(). Tout est asynchrone donc si on ajoute une ligne avec le .end(), il risque d'être exécuté avant la fin de la requête.

On peut attraper plein de choses avec Selenium et Webdriver.io en utilisant les selecteurs : `<http://webdriver.io/guide/usage/selectors.html>`_



mocha
^^^^^

On peut finalement rajouter tous nos tests à la batterie de tests de Node en créant un dernier morceau notre fichier avec le nom


on utilise toujours celui dans node_modules. Sur le serveur on peu en avoir un vieux. Et on ajoute la ligne dans les tests.

Les tests js et de routes sont lents par rapport aux tests python ou java. C'est comme ça. Mais il faut tout de même en faire.

* la bibliothèque de tests : :code:`npm install mocha --save-dev`
* ecrire des jolis tests : :code:`npm install chai --save-dev`


Le code des tests :code:`mocha` pour le fichier :file:`./tests/index.test.js` : 

https://medium.com/@ChrisDobler/getting-started-guide-to-browser-testing-with-webdriver-io-and-mocha-and-chai-323c2ff3c773

A expliquer :

* tout est asynchrone. Donc on ne continue qu'après le :code:`done()`
* before est exécuté avant les tests. Si on ne mets pas done, gettitle va rater puisque la page ne sera pas chargée. Faite le test
* after est exécuté après les tests. On log les erreurs et on stope le browser


.. code-block:: js 

    var webdriverio = require('webdriverio');
    var path = require('path');

    const expect = require('chai').expect;

    var options = {
        desiredCapabilities: {
            browserName: 'chrome'
        }
    }
    const browser = webdriverio.remote(options);

    let toUpload = path.join(__dirname, '..', 'index.html')

    describe('index tests', function() {    
        before(function(done) {
            browser.init().url('file://' + toUpload)
                .then(() => {done();})
                .catch((err) => done(err));
          });

          after(function() {
          browser
              .catch((err) => { console.log(err);}) 
              .end();
          });
      
        it('page title', function(done) {
            browser.getTitle().then((title) => {
              expect(title).to.equal('Maison page');
              done();
            }).catch((err) => done(err));
        });

        it('h1 title', function(done) {
            browser.getText('h1.title').then((title) => {
              expect(title).to.equal('Enfin du web');
              done();
            }).catch((err) => done(err));
        });
    
    });    



On lance le test avec la comande : :code:`./node_modules/.bin/mocha ./tests/index.test.js --timeout 0`

A expliquer :

* :code:`timeout` il faut le temps de lancer le nvigateur, de charger la page, etc. Par défaut c'est 2 secondes et c'est trop court (tester le sans)
* on utilise le :code:`mocha` installé, il n'existe pas globalement (a priori)



autre truc
========== 

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

ou mocha.


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

