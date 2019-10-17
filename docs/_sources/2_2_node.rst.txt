****
Node
****

https://nodejs.org/en/ est idéal pour créer des petits serveur web, des sites à une seule page ressemblant à une application, ou encore une interface *REST*.

Il est utilisé en conjonction d'autres bibliothèques pour créer des applications *MEAN* (`<https://en.wikipedia.org/wiki/MEAN_(software_bundle)>`__) . Actuellement, il y a des alternatives sérieuses à A (angular), comme react.js mais il est bien revenu.

Node en console
===============

Node peut être vu comme un interpréteur javascript. Il incorpore le moteur javascript V8 de google (`<https://fr.wikipedia.org/wiki/V8_(moteur_JavaScript)>`__).

Tapez :code:`Node` dans un terminal. Vous vous retrouverez dans un interpréteur javascript. Idéal pour tester des choses, en particulier pour reprendre les exemples de https://www.destroyallsoftware.com/talks/wat

Node et serveur web
===================

Node est surtout utilisé pour créer des serveurs web. Essayons l'exemple minimal d'un serveur node de https://nodejs.org/api/synopsis.html

.. code-block:: javascript
    :caption: exemple.js

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

  node exemple.js


Et on peut ensuite voir le résultat dans un naviguateur à l'url : http://localhost:3000.

Le code précédent crée un serveur *http* qui répond toujours la même chose dès qu'on le contacte. Il affiche en log la requête reçue, qui elle dépend de l'url donnée.


Regardons le code de près :

  * :code:`const` : déclaration de constantes. Changer port par exemple produit une erreur.
  * :code:`require` : importation d'une bibliothèque (ici de nodejs mais on créera les nôtres bientôt) et affectation de celle-ci à une constante.
  * les fonctions peuvent se créer à la volée avec : :code:`nomFonction((paramètres) => {})`
  * création d'un objet serveur avec une fonction ayant 2 paramètres, la requête et la réponse (voir doc).
  * :code:`listen` : lien entre le serveur et le couple adresse + port.


On peut afficher l'url de la requête : On récupère les variables *hostname* et *port* et on les affiche dans la console.
  
Détails, en utilisant la `documentation <https://nodejs.org/en/docs/>`__ de nodejs :

    * :code:`http` : C'est le module s'occupant des échanges et du codage des données.
    * :code:`http.createServer` : demande un `requestListener <https://www.w3schools.com/nodejs/func_http_requestlistener.asp>`__ qui est ajouté à l'événement request.
    * event request : deux paramètres :code:`http.IncomingMessage`  et :code:`http.ServerResponse`. Il est émit à chaque fois qu'un *request* est demandé
    * :code:`http.IncomingMessage` a un attribut url : il sert à générer le *Readable Stream interface* et beaucoup d'autres choses (événements, méthodes, ...).

.. note:: La `documentation <https://nodejs.org/api/>`__ de nodejs est très bien faite. Trouvez tous les éléments mentionnés ci-dessus.


Tout est orienté autours d'évènements auxquels le serveur doit répondre.


sur le serveur distant
======================

écrire le code en vim
--------------------- 


Faire un peu de vim :
    * tuto : https://www.youtube.com/watch?v=ggSyF1SVFr4 (je ne sais pas ce que ça vaut)
    * https://danielmiessler.com/study/vim/
    * https://www.cs.cmu.edu/~15131/f17/topics/vim/vim-cheatsheet.pdf


configuration du serveur
------------------------

On a un https://www.nginx.com/ qui tourne.

son boulot :
    * lire les requête et les envoyer au bon endroit (port)
    * servir des fichiers statiques(html css, images, ...)
    
Un tuto : https://www.grafikart.fr/tutoriels/nginx-692

Allez voir sur le serveur : 
    * :code:`/etc/nginx/nginx.conf` : configuration générale
    * :code:`/etc/nginx/conf.d/` puis :code:`nodejs.conf` par exemple
        * routes normales : commençant par :code:`/` : le reste est passé au port
        * routes statiques : commençant par :code:`/static/` : le reste est un fichier à partir du répertoire :code:`www` de l'utilisateur. Voir fichier :code:`static.conf`

exécuter node
-------------


* trouver le port 
* exécuter en screen executer la commande : `/usr/bin/screen -d -m -S node node exemple.js`
    * en utilisant man et `/`
    * -S : When creating a new session, this option can be used to specify a meaningful name for the session. This name  identifies
            the session for "screen -list" and "screen -r" actions. It substitutes the default [tty.host] suffix.
    * -d -m :  Start  screen  in  "detached"  mode.  This  creates a new session but doesn't attach to it. This is useful for system startup scripts.
* http://node.raifort.ovh1.ec-m.fr/

screen manual : https://linuxize.com/post/how-to-use-linux-screen/

* :code:`screen -ls` : trouve les différents screen
* :code:`screen -X -S [session # you want to kill] quit` : tue le screen


.. todo:: faire un speech sur les ps et kill

:code:`ps aux| grep raifort` puis kill (sans -9) le numéro du process (le 1er numéro)


Globaux et Asynchrones
======================

    **RTFM -- Merci de lire la notice** : https://nodejs.org/api/

Node est un interpréteur javascript, mais sa grande force est dans ses modules et son fonctionnement purement asynchrone :

    *Lorsque cet évènement se produit ou lorsque j'ai fini de faire quelque chose, j'exécute une fonction.*


Création de fonctions à la volée
--------------------------------

Ceci est possible car en javascript, comme en python, un fonction peut être une assignée à une variable que l'on peut ensuite exécuter. Tester le code suivant dans l'interpréteur :code:`node`. 
    
    Ouvrez une console (ou un powershell) et tapez :code:`node` puis la touche entrée. Il vous suffit ensuite de copier/coller le code dans le terminal.

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

Événements
----------

On utilise la méthode :code:`setInterval` utilisable par défaut en node.

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
        


Les Routes
==========

Le principe d'un serveur web est de servir des pages différentes selon les requêtes. 

Avant de passer à un framework permettant de le faire, voyons comment faire en node pure :


.. code-block:: javascript
    :caption: routes.js

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


.. code-block:: sh

    node routes.js

Le serveur précédent est instalé sur le port 3000 de localhost répond à trois routes :
    * http://localhost:3000/
    * http://localhost:3000/home
    * http://localhost:3000/contact
    
Dans la partie suivante, on utilisera le framework *express* pour gérer tout cela de façon un peu plus élégante.


Servir des fichiers
===================

On simule un petit serveur web qui charge des fichiers. On utilisera quasi jamais ça en production. Les fichiers html étant des fichiers statiques, et donc mieux servis par nginx que par node.

fichier local
-------------


.. code-block:: javascript
    :caption: servir_fichier.js
    
    
    var http = require('http')
    var fs = require('fs')

    var server = http.createServer((request, response) =>{
        response.writeHead(200,  {'Content-Type': 'text/html'})

        //file stream
        var readStream = fs.createReadStream(__dirname + "/index.html", "utf8")
        readStream.pipe(response)
    })
    
    server.listen(3000, 'localhost')

Le nom `__dirname` est un globals de node (https://nodejs.org/docs/latest/api/globals.html). Il permet de connaitre le répertoire du module courant (ici, notre application) 


.. code-block:: html
    :caption: index.html
    
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


fichier distant
---------------

Les fichiers précédents ne sont pas volumineux, ils sont donc quasi-immédiatement chargés, mais pour de gros fichiers, le chargement peut être long, node organise ainsi tout chargement en stream pour permettre de servir du contenu le plus tôt possible. 

L'exemple suivant récupère un gros fichier de l'internet.


.. code-block:: javascript
    :caption: gutemberg.js
    
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

.. note:: À sauter si on est en retard.



Modules
-------


La force de Node est ses modules. Le mécanisme de création est assez spécial. On en créera lorsque l'on voudra séparer notre code en unités fonctionnelles.

Le mécanisme est expliqué dans les tutoriaux 6 et 7 du *ninja du net* : https://www.youtube.com/watch?v=xHLd36QoS4k&index=6&list=PL4cUxeGkcC9gcy9lrvMJ75z9maRw4byYp


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

    // importe le module, c'est à dire que l'on rend l'objet module.exports
    // il est ensuite placé dans une variable, ici monModule
    var monModule = require("./un_module");

    monModule.klaxon()

    console.log(monModule.reponse)



La gestion des exports est le plus souvent utilisé comme on l'a vu en front en créant un objet ayant déjà tous ces attributs :

.. code-block:: javascript

    module.exports = {
        klaxon : () => {
            console.log("tuuuut !");
        },

        reponse: 42,
    }
    
    
scope de variables
------------------

.. note:: Pas forcément pertinent dans ce cours, on pourra passer outre si on est en retard.


En javascript, on peut utiliser des variables définies dans des *scopes* plus haut sans les redéfinir. Dans le code ci-après :code:`delta1` et :code:`delta2` sont ainsi mis à jour (pour avoir le même comportement en python par exemple, on aurait dû utiliser le mot clé *global*)

.. code-block:: javascript

    var delta_1 = 0  // ces variables vont être utilisées autre part.
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

    