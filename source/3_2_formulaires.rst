***********
Formulaires
***********

On va mettre en place un formulaire (`<https://developer.mozilla.org/en-US/docs/Learn/HTML/Forms>`_ ). dans la page de contact.


Mise en place
============= 

On va créer une nouvelle route dans notre application. 

Pour cela :

    * on crée la route
    * on ajoute le template

le template
-----------

Dans nos vues :


.. code-block:: html
    :caption: ./views/comments.ejs
    
    <html lang="fr">

    <head>
        <meta charset="utf-8"/>
        <title>Commentaires</title>
    </head>

    <body>
    <form>
        <label for="pseudo">Pseudo :</label>
        <input id="pseudo" type="text" name="pseudo"/>

        <label for="message">Message :</label>
        <textarea id="message" placeholder="dites nous tout le bonheur que vous apporte ce site" name="comment"></textarea>

        <button type="submit">Envoi</button>
    </form>
    </body>

    </html>

la route
-------- 


.. code-block:: javascript
    :caption: ./routes/comments.ejs
    
    const express = require('express');
    const router = express.Router();

    router.get('/', function(req, res) {
      res.render('comments');
    });

    module.exports = router;
    

Puis on fait les liens entre notre route et l'app, dans :code:`app.js` :
    * on charge la route : :code:`var commentsRouter = require('./routes/comments');`
    * on utilise la route : :code:`app.use('/comments', commentsRouter);`
    


fonctionnement
==============

Lancez votre serveur et testez la route http://localhost:3000/comments

Une fois appuyé sur le bouton *envoi* on voit que requête GET est envoyée au serveur avec une url contenant nos envois. Par exemple : http://localhost:3000/comments?pseudo=caro&comment=Trop+cool+ton+site+%28lol%29


..note:: c'est en clair. Donc pas de bêtises avec des messages confidentiels.

On appelle ça des *query string parameters* : `<https://en.wikipedia.org/wiki/Query_string>`__. Le format est assez simple et permet de faire passer des variables dans une url.

Modifions un peu :file:`app.js` pour voir ce qu'il se passe.

.. code-block:: javascript
    :caption: ./routes/comments.js

    const express = require('express');
    const router = express.Router();
    const winston = require('../winston.config');

    router.get('/', function(req, res) {
      winston.info(JSON.stringify(req.query));
      res.render('comments');
    });

    module.exports = router;
    

Dans le fichier de log vous verrez le message passé au format http://www.json.org/ (voir ci-après)

.. code-block::js

    {"pseudo": "caro",
     "comment": "Trop cool ton site (lol)",
    }

Le format json, qui est une adaptation des dictionnaires javascript (ou python, est le format d'échange de données roi du net (et des environs). Il permet en effet de transformer un objet en texte avant de l'envoyer sur le réseau *via une requête http*, puis de le retransformer en objet à l'arrivée très simplement. 


Templating
==========  

On va utiliser ces query strings dans notre template. Commençons par passer les query strings en paramètres de notre template : 

.. code-block:: javascript
    :caption: ./routes/comments.js

    const express = require('express');
    const router = express.Router();
    const winston = require('../winston.config');

    router.get('/', function(req, res) {
      winston.info(JSON.stringify(req.query));
      res.render('comments', {qs: req.query});
    });

    module.exports = router;


L'objet qs est passé en paramètre de notre template et prend la valeur de notre query string. Dans notre cas, il a donc 2 champs correspondant aux noms de nos formulaires, à savoir :code:`qs.pseudo` et :code:`qs.comment`.

Modifions le template pour les utiliser. On va tout de même faire attention au fait que ces paramètres peuvent être vides. 



.. code-block:: text
    :caption: ./views/comments.ejs

    <html lang="fr">

    <head>
        <meta charset="utf-8"/>
        <title>Commentaires</title>
    </head>

    <body>
    <form>
        <label for="pseudo">Pseudo :</label>
        <input id="pseudo" type="text" name="pseudo" <% if (qs.pseudo) { %> value=<%= qs.pseudo %> <% } %> />

        <label for="message">Message :</label>
        <textarea id="message" placeholder="dites nous tout le bonheur que vous apporte ce site" name="comment"><% if (qs.comment) { %><%= qs.comment %><% } %></textarea>
        

        <button type="submit">Envoi</button>
    </form>
    </body>

    </html>

.. note:: il faut mettre tout le textarea surune ligne. Sinon il peut y avoir des caractères en trop par défaut.

Postman
=======

Pour visualiser les différentes requêtes, on utilise souvent `postman <https://www.getpostman.com/>`__ qui est un utilitaire bien pratique 

    un tuto : https://www.guru99.com/postman-tutorial.html


On va tester les façons de gérer des requêtes avec postman : 

#. On lance l'application,
#. On dit que l'on ne veut pas de compte (c'est tout en bas),
#. On ferme la fenêtre qui demande de sauver ses requêtes (croix en haut à droite),

On peut tester la requête `<http://localhost:3000/comments?pseudo=caro&comment=c%27est+moins+bien+que+sonate+je+trouve>`_ en GET. On récupère bien des headers par défaut et du HTML.



Requête POST
============  

Les query strings sont un moyen utile de passer des données au serveur via une URL, mais une méthode plus *pure* est d'utiliser le protocole HTTP lui-même et la méthode POST, car elle permet de transmettre des données arbitraires.

Toutes les données vont être transférées sous forme de chaîne de caractères. On utilise pour cela le format `<http://www.json.org>`_ qui est fait pour ça. C'est *en gros* un dictionnaire. Donc pour transférer un objet javascript :code:`data`:

  #. On transforme :code:`data` en chaine de caractères : :code:`JSON.stringify(data)`,
  #. On transfère cette chaîne d'un endroit à un autre,
  #. On récupère notre donnée en retransformant notre chaîne de caractères en objet :code:`JSON.parse(chaine_de_caractère)`. Cette étape est souvent faite automatiquement si l'on sait que l'on transporte du JSON.


Côté serveur, on attend une requête de type POST sur l'adresse contact. Pour avoir accès au corps de notre requête, ici l'objet transmis sous la forme d'un JSON, il faut utiliser `<https://github.com/expressjs/body-parser>`_ qui va nous permettre de récupérer le body de la requête, c'est à dire les données envoyées au serveur. On l'installe comme d'habitude: :command:`yarn add body-parser`. 

Puis on l'utilise dans :file:`app.js`, juste après l'utilisation de Express :

    * chargement du module : :code:`var bodyParser = require('body-parser');`
    * utilisation du module (juste avant les routes) : :code:`app.use(bodyParser.json());`
    

Puis la route en elle même : 

.. code-block:: javascript
    :caption: ./routes/comments.js
    
    const express = require('express');
    const router = express.Router();
    const winston = require('../winston.config');

    router.get('/', function(req, res) {
      winston.info(JSON.stringify(req.query));
      res.render('comments', {qs: req.query});
    });

    router.post('/', (req, res) => {
      winston.info("post: " + JSON.stringify(req.body));
      res.send('Ok')
    });


    module.exports = router;


* type : POST (à la place de GET)
* url : `<http://localhost:3000/comments>`_
* body : 

    #. type : raw
    #. un menu déroulant est apparu : choisir JSON (application/json)
    #. texte : 

        .. code-block:: json

            {
                "pseudo": "Geo",
                "comment": "ce serait pas plus simple en sh ?"
            }

Si tout se passe comme prévu. Le retour dans postman devrait être "Ok", et côté serveur, :code:`request.body` devrait être un objet javascript. 


POST et formulaires
===================

jquery
------


L'objectif est que lorsque l'on va appuyer sur notre bouton, on veut envoyer les données à notre serveur en POST. Pour cela on va utiliser `<http://jquery.com>`_ la bibliothèque à tout faire pour le javascript en front.

Pour installer jquery, utilisons yarn ! Mais comme c'est pour le front, faisons un nouveau :code:`package.json` dans public. Donc placez vous dans le dossier :code:`public` qui va contenir nos fichiers statiques, puis tapez : :code:`yarn init`. Puis :code:`yarn add jquery`

javascript post
--------------- 

On a plusieurs choses à faire pour que notre binding fonctionne.

Charger jquery et notre script dans le template :

.. code-block:: text
    :caption: ./views/comments.ejs
    
    
    <html lang="fr">

    <head>
        <meta charset="utf-8"/>
        <title>Commentaires</title>

        <script src="/node_modules/jquery/dist/jquery.js"></script>
        <script src="/javascripts/comments_post.js"></script>
    </head>

    <body>
    <form>
        <label for="pseudo">Pseudo :</label>
        <input id="pseudo" type="text" name="pseudo" <% if (qs.pseudo) { %> value=<%= qs.pseudo %> <% } %> />

        <label for="message">Message :</label>
        <textarea id="message" placeholder="dites nous tout le bonheur que vous apporte ce site" name="comment">
            <% if (qs.comment) { %><%= qs.comment %><% } %>
        </textarea>

        <button type="submit">Envoi</button>
    </form>
    </body>

    </html>
    

Faire le lien entre le bouton et l'envoie : 

.. code-block:: javascript 
    :caption: ./public/javascripts/comments_post.js
    
    $(function() {
        $( "form" ).submit(function( event ) {
            event.preventDefault();

            data = {
                pseudo: $("input[name=pseudo]").val(),
                text: $("#message").val(),
            };
            console.log("data sent: " + JSON.stringify(data))
        })
    });
    

Deux choses :
    * pour l'instant il n'envoie rien. Il affiche juste un message sur la console (du navigateur)
    * on a bloqué le comportement par défaut (:code:`event.preventDefault();`), sinon la page serait rechargée.

requête ajax
------------ 


Pour envoyer des choses au serveur, il faut que le navigateur fasse une requête post à notre serveur. Tout ceci se fera via une requête *ajax* (http://learn.jquery.com/ajax/)

.. code-block:: javascript 
    :caption: ./public/javascripts/comments_post.js
    
    $(function () {
        $("form").submit(function (event) {
            event.preventDefault();

            data = {
                pseudo: $("input[name=pseudo]").val(),
                text: $("#message").val(),
            };

            if (data.text) {
                console.log("data to send: " + JSON.stringify(data));
                $.ajax({
                    url: "http://" + $(location).attr('host') + "/comments",
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(data),
                })
                    .done(function (json) {
                        console.log("comment sent: " + JSON.stringify(data));
                        $("textarea").val("");
                    })
                    .fail(function( xhr, status, errorThrown ) {
                        console.log( "Sorry, there was a problem!" );
                        console.log( "Error: " + errorThrown );
                        console.log( "Status: " + status );
                    })
                    // Code to run regardless of success or failure;
                    .always(function( xhr, status ) {
                        console.log( "The request is complete!" );
                    });
            } else {
                console.log("no text to send.");
            }
        })
    });
    
    
    Tester que tout fonctionne. Vous pouvez également supprimer (ou commenter) la ligne qui supprime le comportement par défaut.

