****
node
****

https://nodejs.org/en/ est ideal pour créer de petits serveur web, des *single-page appication*, ou encore une interface *REST*.

Il est utilisé en conjonction d'autres bibliothèque pour créer des application *MEAN* (https://en.wikipedia.org/wiki/MEAN_(software_bundle)). Actuelement, il y a des alternatives serieuse à A (angular).


node en console
===============

node peut être vu comme un interpréteur javascript. Il incorpore la moteur javascript V8 de google (https://fr.wikipedia.org/wiki/V8_(moteur_JavaScript) )

Tapez :code:`node` dans un terminal. Vous vous retrouverez dans un interpréteur javascript. Idéal pour tester des choses, en particulier pour reprendre les exemples de https://www.destroyallsoftware.com/talks/wat

node et serveur Web
===================

Node est surtout utilisé pour créer des serveur web. Essayons l'exemple minimal d'un serveur node de https://nodejs.org/api/synopsis.html

example.js
^^^^^^^^^^

.. code-block:: javascript

  const http = require('http');

  const hostname = '127.0.0.1';
  const port = 3000;

  const server = http.createServer((req, res) => {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end('Hello World\n');
  });

  server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
  });


On exécute ce fichier en console :

.. code-block:: sh

  node example.js


Et on peut ensuite voir le résultat dans un naviguateur à l'url : http://localhost:3000

Le code précédent crée un serveur *http* qui répond toujours la même chose dès qu'on le contacte. Il affiche en log la requête reçue, qui elle dépend de l'url donnée.


Regardons le code de pres :

  * `const` : déclaration de constantes. Changer port par exmple produit une erreur.
  * `require` : importation d'une bibliothèque (ici de node mais on créera les notres bientôt) et affectation de celle-ci à une constantes
  * les fonctions peuvent se créer à la volée
  * création d'un objet serveur avec une fonction ayant 2 paramètres, la requête et la réponse (voir doc)
  * `listen` lien entre le serveur et le couple adresse + port.


On peut :

  * afficher l'url de la requete : chercher dans la doc :
    * http -> méthode http.createServer : demande un requestListener qui est ajouté à l'event request.
    * event request : deux parametres http.IncomingMessage et http.ServerResponse.
    * http.IncomingMessage a un attribut url.
  * que fait listen : on cherche dans la doc pour http.Server qui est le retour de http.createServer

Tout est orienté autour d'évènements.

globals et asynchrone
=====================

**RTFM** : https://nodejs.org/api/

Node est un interpréteur javascript, mais sa grande force est dans ses modules et son sonctionnement purement asynchrone :

*Lorsque cet évènement se produit ou lorsque j'ai fini de faire quelque chose, j'execute une fonction.*


Création de fonctions à la volée
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ceci est possible car en javascript, comme en python, un fonction peut être une assignée à une variable que l'on peut ensuite exécuter.

.. code-block:: javascript

    function affiche_bloup() { // definition classique d'une fonction
        console.log("bloup")
    }

    affiche_bloup()

    var x = affiche_bloup //affectation de la fonction à une variable

    x() //exécution de la variable, donc de la fonction.



    //fonction sans nom assignée à une variable
    var affiche_2 = function() { // On utilisera surtout celle là.
        console.log("bloup 2")
    }

    affiche_2()

évènements
^^^^^^^^^^

Exemple avec les intervalles. On utilise la méthode :code:`setInterval` utilisable par défaut en node.

Ce qui est utilisable par défaut est définit dans https://nodejs.org/api/globals.html

.. code-block:: javascript

    function affiche_bloup() {
        console.log("bloup")
    }

    // tout est asyncrone.
    // Lorsque la condition est vérifiée on exécute une fonction.
    var timer1 = setInterval( affiche_bloup, 1000) // un intervalle

    var timer2 = setInterval(function() { // un deuxième avec une function anonyme
        console.log("bim")
    }, 2000)



les routes
==========

Le principe d'un serveur web est de servir des pages différentes selon les requètes. Avant de passer à un framework permettant de le faire ben, voyons comment faire en node pure :


routes.js
^^^^^^^^^^

.. code-block:: javascript

	var http = require('http')

		var server = http.createServer((request, response) =>{
		    // http://www.ecma-international.org/ecma-262/5.1/#sec-11.9.3
		    response.statusCode = 200;
		    response.setHeader('Content-Type', 'text/html');

		    if (request.url === "/" || request.url === "/home") {
		        response.end("<html><head><title>home</title></head><body><h1>sweet home</h1></body></html>");
		    }
		    else if (request.url === "/contact") {
		        response.end("<html><head><title>contact</title></head><body><h1>contact</h1></body></html>");
		    }
		    else {
		      response.statusCode = 404;
		      response.setHeader('Content-Type', 'text/plain');
		      response.end();
		    }
		})

		server.listen(3000, 'localhost')
		console.log("c'est parti")


Dans la partie suivante, on utilisera le framework *express* pour gérer tout cela de façon un peu plus élégante.


Servir des fichiers
===================


.. code-block:: javascript

    var http = require('http')
    var fs = require('fs')

    var server = http.createServer((request, response) =>{
        response.writeHead(200,  {'Content-Type': 'text/html'})

        //file stream
        var readStream = fs.createReadStream(__dirname + "/index.html", "utf8")
        readStream.pipe(response)
    })

Le nom `__dirname` est un globals de node (https://nodejs.org/docs/latest/api/globals.html). Il permet de connaitre le répertoire du module courant (ici, notre application) 

routes_2.js
^^^^^^^^^^^ 

.. code-block:: javascript

	const http = require('http')
	const fs = require('fs')

		var server = http.createServer((request, response) =>{
		    // http://www.ecma-international.org/ecma-262/5.1/#sec-11.9.3
		    response.statusCode = 200;
		    response.setHeader('Content-Type', 'text/html');

		    if (request.url === "/" || request.url === "/home") {
		       fs.createReadStream(__dirname + "/html/index.html", "utf8").pipe(response)     
			}
		    else if (request.url === "/contact") {
		       fs.createReadStream(__dirname + "/html/contact.html", "utf8").pipe(response)      		    
			}
		    else {
		      response.statusCode = 404;
			  fs.createReadStream(__dirname + "/html/404.html", "utf8").pipe(response)      		    
			}
		})

		server.listen(3000, 'localhost')
		console.log("c'est parti")



index.html
^^^^^^^^^^ 

.. code-block:: html

    <!doctype html>
    <html>
        <head>
            <title>Maison page</title>  
            <meta charset="utf-8" />
        
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
                   font-family: 'Indie Flower', cursive; 
                }
            </style>
        </head>
        <body>
            <h1>Enfin du web !</h1>
            <p>Et on aime ça.</p>
        </body>
    </html>


contact.html
^^^^^^^^^^^^ 

.. code-block:: html

    <html>
        <head>
            <meta charset="utf-8" />
            <title>Contact</title>

            <style>
                html, body {
                    margin:0;
                    padding:0;
                
                    background: skyblue;
                    color: #FFFFFF;
                    font-size: 2em;
                    text-align: center;
                }
            
                img {
                    display: block;
                    width: 452px;
                    height: 600px;
                    margin: auto;
                }
            </style>
        </head>
        <body>
            <h1>Contact</h1>
            
            <img src="https://www.mauvais-genres.com/6047/full-contact-affiche-40x60-fr-90-jean-claude-van-damne-movie-poster-.jpg" />
        </body>
    </html>


404.html
^^^^^^^^ 

.. code-block:: html

	<html>
	    <head>
	        <meta charset="utf-8" />
	        <title>404</title>

	        <style>
	            html, body {
	                margin:0;
	                padding:0;

	                background: skyblue;
	                color: #FFFFFF;
	                font-size: 2em;
	                text-align: center;
	            }

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
	        <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/Peugeot404-berline.jpg/1200px-Peugeot404-berline.jpg" />


	    </body>
	</html>

streaming
=========

Les fichiers précédents ne sont pas volumineux, ils sont donc quasi-immédiatement chargés, mais pour de gros fichiers, le chargement peut être long, node organise ainsi tout chargement en stream pour permettre de servir du contenu le plus tôt possible. 

L'exemple suivant récupère un gros fichier de l'internet.


.. code-block:: javascript

    var http = require('http')

    // le streaming permet de commencer à envoyer des données alors que le fichier n'est pas fini.
    //exemple avec un gros fichier.

    var server = http.createServer((request, response) => {
    	response.statusCode = 200;
		response.setHeader('Content-Type', 'text/plain');
	
        // stream : chargement par paquets.
        http.get("http://www.gutenberg.org/files/4300/4300-0.txt", (response_get) => {
            response_get.setEncoding('utf8');
            response_get.pipe(response)
        });

    })


    server.listen(3000, 'localhost')
    console.log("c'est parti")


Odds and ends
=============

.. note:: a sauter si on est à la bourre

scope de variables
^^^^^^^^^^^^^^^^^^

.. note:: la suite pas forcément utile si on est à la bourre


En javascript, on peut utiliser des variables définies dans des *scope* plus haut sans les redéfinir. Dans le code ci-après :code`delta1` et :code:`delta2` sont ainsi mis à jour (pour avoir le même comportement en python par exmeple, on aurait du utiliser le mot clé *global*)

.. code-block:: javascript

    var delta_1 = 0  // vont être utilisées autre part.
    var delta_2 = 0  // un peu comme une variable "globale" (attention au scope)

    setInterval(() => {  // encore une autre façon d'écrire une fonction
        if (delta_1 == 3) {  // mieux vaut supprimer le timer dans le timer considéré.
            clearInterval(timer1)
            delta_1 += 1
        }
        else {
            delta_1 += 1
        }

        if (delta_2 == 10) {
            clearInterval(timer2)
            delta_2 += 1
        }
        else {
            delta_2 += 1
        }

    }, 1000)



modules
^^^^^^^

.. note:: partie pas forcément utile si on est à la bourre


La force de node est ses modules. Le mécanisme de création est assez spécial. On en créera lorsque l'on voudra séparer notre code en unités fonctionnelles.

Le méchanisme est expliqué dans les tutoriaux 6 et 7 du *ninja du net* : https://www.youtube.com/watch?v=xHLd36QoS4k&index=6&list=PL4cUxeGkcC9gcy9lrvMJ75z9maRw4byYp


Un module nommé :code:`un_module.js` :

.. code-block:: javascript

    //module.exports est un objet rendu par require.
    // on lui donne donc comme attribut, les méthodes et constante que l'on veut voir transmise.

    module.exports.klaxon = function() {
        console.log("tuuuut !");
    }


    module.exports.reponse = 42


On l'utilise dans le code suivant, qui est un fichier dans le même répertoire que le module :

.. code-block:: javascript

    // importe le module, c'est à dire que l'on rend l'obet module.exports
    // il est ensuite placé dans une variable, ici monModule
    var monModule = require("./un_module");

    monModule.klaxon()

    console.log(monModule.reponse)


