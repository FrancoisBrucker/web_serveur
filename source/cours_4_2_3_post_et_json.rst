*************
Requêtes POST
*************

Les query strings sont un moyen utile de passer des données au serveur via une URL. La méthode la plus pratique est d'utiliser le protocole HTTP lui-même et la méthode POST, car elle permet de transmettre des données arbitraires.


Toutes les données vont être transférées sous forme de chaîne de caractères. On utilise pour cela le format `<http://www.json.org>`_ qui est fait pour ça. C'est *en gros* un dictionnaire. Donc pour transférer un objet javascript :code:`data`:

  #. On transforme :code:`data` en chaine de caractères : :code:`JSON.stringify(data)`,
  #. On transfère cette chaîne d'un endroit à un autre,
  #. On récupère notre donnée en retransformant notre chaîne de caractères en objet :code:`JSON.parse(chaine_de_caractère)`. Cette étape est souvent faite automatiquement si l'on sait que l'on transporte du JSON.


Requête POST
============  

Avant de gérer directement les connections côté client (avec du javascript client), on va installer une appllication extension permettant de simuler l'envoi de données via la méthode POST. Il y en a plusieurs. 


Postman
^^^^^^^

J'utilise ici `<https://www.getpostman.com/>`_.

On va tester les façons de gérer des requêtes avec postman : 

#. On lance l'application,
#. On dit que l'on ne veut pas de compte,
#. On choisit de faire une requête que l'on ne veut pas sauver,
#. On clique sur fermer la fenêtre.

On peut tester la requête `<http://localhost:8080>`_ en GET. On récupère bien des headers par défaut et du HTML.

Essayons de voir si un cookie peut être placé : 

* `<http://localhost:8080/commentaires?pseudo=caro&comment=c%27est+moins+bien+que+sonate+je+trouve>`_
* on peut en créer un nous-mêmes en cliquant sur cookie juste en dessous de boutons send :

    * Add cookie,
    * A la place de :code:'Cookie_1=value;' on met notre :code:'pseudo=toto',
    * On sauvegarde.

En exécutant la requête GET : `<http://localhost:8080/commentaires/>`_, on voit que notre cookie est bien placé.

POST en serveur
^^^^^^^^^^^^^^^

Côté serveur, on attend une requête de type POST sur l'adresse contact. Pour avoir accès au corps de notre requête, ici l'objet transmis sous la forme d'un JSON, il faut utiliser `<https://github.com/expressjs/body-parser>`_. On l'installe comme d'habitude: :command:`npm install body-parser --save`. 

Puis on l'utilise dans :file:`app.js`, juste après l'utilisation de Express :

.. code-block:: javascript

    var express = require('express')
    var app = express()

    var bodyParser = require('body-parser');
    app.use(bodyParser.json()); // for parsing application/json

Ce middleware nous permet d'utiliser l'attribut *body* de request, qui contiendra notre objet :


.. code-block:: javascript

  app.post('/commentaires', (request, response) => {
      logger.debug("post: " + JSON.stringify(request.body));
      response.send('Ok')
  })


.. note :: Voir `<http://expressjs.com/fr/api.html#req.body>`_.

On peut alors tester notre requête POST avec Postman (`<https://www.youtube.com/watch?v=FyZBTbv7UM0>`_) : 

* type : POST (à la place de GET)
* url : `<http://localhost:8080/commentaires>`_
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


POST avec un formulaire
=======================

On n'utilisera pas la méthode POST directement avec un formulaire : 
:code:`<form class="form" id="form1" method="POST" action="/commentaire">`


Mais c'est ce qu'on a fait. À l'avenir, il faudrait éviter qu'une recharge de page envoie à nouveau un formulaire.

Pour ce faire, deux possibilités : 

* Classiquement, on redirige la page vers une version GET de celle-ci. Voir : `<https://fr.wikipedia.org/wiki/Post-redirect-get>`_.
* Utiliser le parser :code:`urlencoded` de body-parser.
 

On va utiliser une autre méthode, avec un bouton adapté.



POST client 
===========

Mise en place de jquery 
^^^^^^^^^^^^^^^^^^^^^^^

L'objectif est que lorsque l'on va appuyer sur notre bouton, on veut envoyer les données à notre serveur. Pour cela on va utiliser `<http://jquery.com>`_ la bibliothèque à tout faire pour le javascript en front.

Elle est a priori déjà utilisé avec materialize.

Javascript est exécuté lorsqu'il arrive. Il faut que tout soit chargé côté client avant d'exécuter du javascript :


.. code-block:: html

    <!-- déclaration de jquery avant ça -->
  <script>
      $(function() {
          // mettre votre code client ici
      })
  </script>

Le code ci dessus exécute une fonction anonyme (avec uniquement un commentaire pour l'instant) une fois que le document est chargé (voir `<http://learn.jquery.com/using-jquery-core/document-ready/>`_). Ici, la console est celle de votre navigateur, puisque ce code est exécuté côté front.

Le signe :code:`$` est la marque de JQuery. Tout ce qui utilise JQuery commence par :code:`$`. Pour plus d'infos, lisez la doc : `<http://learn.jquery.com>`_.

Bind du bouton
^^^^^^^^^^^^^^

On veut récupérer l'évènement d'envoi du formulaire pour fabriquer nos propres données et les envoyer.

Le code suivant le fait :

.. code-block:: javascript

  $(function() {
      $( "#form1" ).submit(function( event ) {
        data = {
            firstname: $("input[name=firstname]").val(),
            name: $("input[name=name]").val(),
            text: $("textarea").val(),
        }
        console.log("data sent: " + JSON.stringify(data))
      })
  })


Quelques remarques :
  * On stoppe l'exécution normale du formulaire avec :code:`event.preventDefault()`,
  * On utilise la localisation d'éléments en JQuery comme on le ferait en CSS. Par exemple :code:`$("input[name=firstname]")` rend l'objet de type input ayant un attribut name valant firstname.
  * Une fois l'élément récupéré, JQuery met à notre disposition de nombreuses méthodes, comme ici :code:`val()`.



Côté client, on va envoyer un JSON contenant les données. Tout ceci se fera via
une requête *ajax* (`<http://learn.jquery.com/ajax/>`_) :

Le fichier :file:`commentaires.ejs` en entier (seule la partie script est modifiée) :


.. code-block:: text

    <html>

    <head>
        <meta charset="utf-8" />
        <title>Commentaires</title>

        <% include partials/head_css_import.ejs %>

            <style>
                html,
                body {
                    font-size: 1em;
                }
            </style>

    </head>

    <body>

        <% include partials/navbar.ejs %>

            <div class="row">
                <form class="col s12">
                    <div class="row">
                        <div class="col s12">
                            Pseudo :
                            <div class="input-field inline">
                                <input id="pseudo" type="text" 
                                    name="pseudo"
                                    <% if (qs.pseudo) { %>
                                        value=<%= qs.pseudo %>
                                <% } %>
                            />
                                <label for="pseudo">pseudo</label>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="input-field col s12">
                            <textarea id="comment" class="materialize-textarea" placeholder="dites nous tout le bonheur que vous apporte ce site" name="comment"><% if (qs.comment) { %><%= qs.comment %><% } %></textarea>
                            <label for="comment">Petit compliment :</label>
                        </div>
                    </div>
                    <button class="btn waves-effect waves-light" type="submit">
                        <i class="material-icons right">send</i>
                        Envoi
                    </button>
                </form>
            </div>

            <% include partials/js_import.ejs %>

            <script>
                $(function() {
                    $( "form" ).submit((event) => {
                        event.preventDefault();

                        data = {
                            pseudo: $("input[name=pseudo]").val(),
                            comment: $("textarea").val()
                        }

                        if (data.comment) {
                            console.log("data sent: " + JSON.stringify(data))
                            $.ajax({
                                url: "http://" + $(location).attr('host') + "/commentaires",
                                type: 'POST',
                                contentType: 'application/json',
                                data: JSON.stringify(data),
                                success: function(data) {
                                    console.log("comment sent: " + data)
                                    $("textarea").val("")
                                }
                            })
                        }
                        else {
                            console.log("no text to send.")
                        }
                    })
                })
            </script>

    </body>

    </html>

Remarques :

* On n'envoie des données que si le texte est non-vide,
* Si les données ont été envoyées avec succès, on supprime le texte pour éviter d'envoyer 2 fois les même choses.
* On utilise le serveur courant avec la commande :command:`$(location).attr('host')` Ceci fera que ça va marcher également en production.


  .. note:: on ne gère pas les cookies ici puisque c'est via la requète POST. Cela pourrait être à ajouter.

