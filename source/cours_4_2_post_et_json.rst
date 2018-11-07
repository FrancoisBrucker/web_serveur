*************
Requêtes POST
*************

Les query strings sont un moyen utile de passer des données au serveur via une URL. La méthode la plus pratique est d'utiliser le protocole HTTP lui-même et la méthode POST, car elle permet de transmettre des données arbitraires.


Toutes les données vont être transférées sous forme de chaîne de caractères. On utilise pour cela le format `<http://www.json.org>`_ qui est fait pour ça. C'est *en gros* un dictionnaire. Donc pour transférer un objet javascript :code:`data`:

  #. On transforme :code:`data` en chaine de caractères : :code:`JSON.stringify(data)`,
  #. On transfère cette chaîne d'un endroit à un autre,
  #. On récupère notre donnée en re-transformant notre chaîne de caractères en objet :code:`JSON.parse(chaine_de_caractère)`. Cette étape est souvent faite automatiquement si l'on sait que l'on transporte du JSON.


Requête POST
============  

Avant de gérer directement les connections côté client (avec du javascript), installons une application bien pratique qui permet de faire des requêtes HTTP. 


Postman
^^^^^^^

Pour télécharger Postman, c'est par ici: `<https://www.getpostman.com/>`_.

On va tester les façons de gérer des requêtes avec postman : 

#. On lance l'application,
#. On clique sur "Request",
#. On lui donne un nom, par exemple "test post",
#. On clique sur "create a collection" et on donne un nom au repertoire ("Tests" par exemple)
#. On clique sur "Save"

Tout est prêt, et on utilisera le logiciel un peu plus loin lorsqu'on aura implémenté la gestion de la requête côté serveur.

POST en serveur
^^^^^^^^^^^^^^^

L'idée c'est de créer un endpoint sur notre serveur qui gérera notre requête POST. Pour pouvoir exploiter le JSON qu'on va recevoir, il va falloir le parser.Il faut donc au préalable installer la bibliothèque `<https://github.com/expressjs/body-parser>`_. On l'installe comme d'habitude: :`npm install body-parser --save`. 

Puis l'importe dans :file:`app.js`, juste après l'utilisation de Express :

.. code-block:: javascript

    var express = require('express')
    var app = express()

    var bodyParser = require('body-parser');
    app.use(bodyParser.json()); // for parsing application/json

Ce middleware nous permet d'utiliser l'attribut *body* de request, qui contiendra notre objet.

On créé l'endpoint "/commentaires" qui recevra notre requête.


.. code-block:: javascript

  app.post('/commentaires', (request, response) => {
      console.log("post: " + JSON.stringify(request.body));
      response.send('Ok')
  })


.. note :: Pour plus d'infos `<http://expressjs.com/fr/api.html#req.body>`_.

On peut alors tester notre requête POST avec Postman: 

* type : POST (à la place de GET)
* url : `<http://localhost:8080/commentaires>`_
* body : 

    #. type : raw
    #. un menu déroulant est apparu : choisir JSON (application/json)
    #. Et on copie colle le JSON suivant : 

        .. code-block:: JSON

            {
                "pseudo": "Geo",
                "comment": "ce serait pas plus simple en sh ?"
            }

Si tout se passe comme prévu. Le retour dans postman devrait être "Ok", et côté serveur, :code:`request.body` devrait être un objet javascript. 
On devrait également voir le JSON en log dans le terminal de notre IDE (Remarque: on aurait également pu utiliser logger).

POST côté client 
================

Postman est bien pratique pour tester ses requêtes, mais pour donner un exemple un peu plus concret, on va créer un formulaire avec deux champs (pseudo et comment), côté client, qui permet d'envoyer un commentaire.

Mise en place de jQuery 
^^^^^^^^^^^^^^^^^^^^^^^

L'objectif est d'envoyer les données rentrées par l'utilisateur dans le formulaire lorsqu'il appuie sur le bouton envoyer. Pour cela on va utiliser `<http://jquery.com>`_ la bibliothèque à tout faire pour le javascript en front.

Elle est a priori déjà utilisé avec materialize.

Javascript est exécuté lorsqu'il arrive. Il faut que tout soit chargé côté client avant d'exécuter du javascript :

D'un point de vue syntaxique pour notre utilisation, il est important de comprendre ceci:

.. code-block:: html

    <!-- déclaration de jQuery avant ça -->
  <script>
      $(function() {
          // mettre votre code client ici
      })
  </script>

Le code ci dessus exécute une fonction anonyme (avec uniquement un commentaire pour l'instant) une fois que le document sera chargé (pour + d'infos, voir `<http://learn.jquery.com/using-jquery-core/document-ready/>`_). Ici, la console est celle de votre navigateur, puisque ce code est exécuté côté front.

Le signe :code:`$` est la marque de jQuery. Tout ce qui utilise jQuery commence par :code:`$`. Pour plus d'infos, lisez la doc : `<http://learn.jquery.com>`_.

Bind du bouton
^^^^^^^^^^^^^^

On veut récupérer l'évènement d'envoi du formulaire pour fabriquer nos propres données et les envoyer.

Le code suivant le fait :

.. code-block:: javascript

  $(function() {
      $( "#form1" ).submit(function( event ) {
        data = {
            pseudo: $("input[name=pseudo]").val(),
            comment: $("textarea").val()
        }
        console.log("data sent: " + JSON.stringify(data))
      })
  })


Quelques remarques :
  * On stoppe l'exécution normale du formulaire avec :code:`event.preventDefault()`,
  * On utilise la localisation d'éléments en jQuery comme on le ferait en CSS. Par exemple :code:`$("input[pseudo=monPseudo]")` rend l'objet de type input ayant un attribut name valant pseudo.
  * Une fois l'élément récupéré, jQuery met à notre disposition de nombreuses méthodes, comme ici :code:`val()` qui va nous permettre de récupérer la valeur d'un champ.



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




Envoi de fichiers
=================

Gérer la réception de fichiers sur notre serveur
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Afin de gérer la réception de fichiers autres que le JSON, nous utiliserons le middleware multer. Ce dernier va notamment
nous permettre de gérer le :code:`multipart/form-data` essentiellement utilisé pour uploader des fichiers.

:code:`npm install --save multer`

On créera également un dossier 'uploads' dans le répertoire de notre projet, puis nous intégrerons au fichier :code:`app.js` le code suivant:

app.js
^^^^^^

.. code-block:: javascript

    var express = require('express')
    var multer  = require('multer')

    var storage = multer.diskStorage({
        destination: function(req, file, callback) {
            callback(null, './uploads'); //configuration du chemin pour la réception de nos fichiers
        },
        filename: function(req, file, callback) {
            callback(null,Date.now()+file.originalname); //nomenclature de nos fichiers
        }
    })
    var upload = multer({ storage: storage });

    var app = express()

    app.post('/upload', upload.any(), (req, res)=> { //on gère ici l'upload de n'importe quel type de fichier
            res.end('Merci !');
        });

Pour faire le test, commencez par lancer votre serveur : :code:`node app.js`

Maintenant nous pouvons de nouveau utiliser postman.
Choisissez la méthode POST, puis dans body changez le type de value à :code:`File`.
Sélectionnez alors un fichier sur votre machine et envoyez la requête `<http://localhost:8080/upload/>`_.
Le serveur devrait vous renvoyer "Merci !" peu importe le format de fichier que vous avez sélectionné, et théoriquement plusieurs fichiers peuvent être envoyés simultanément.

Faire l'essai avec un formulaire
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Pour envoyer des fichiers à notre serveur, il est possible de créer un formulaire très simple dans un front, nous utiliserons ici un ejs.
Pour cela nous allons créer un répertoire "views" dans notre projet, puis un fichier :code:`formulaire.ejs`.
Il nous faudra également installer ejs :

:code:`npm install --save ejs`

Voici comment se présente le formulaire dans notre ejs :

formulaire.ejs
^^^^^^

.. code-block:: html

    <form action="/upload" method="post" enctype="multipart/form-data"> // l'encodage multipart/form-data est ce qui est attendu par notre serveur
        <input type="file" name="userFile">
            <br />
        <input type="submit" value="OK" />
    </form>

Une fois le formulaire.ejs créé, il faut ajouter un routage à notre serveur pour pouvoir y accéder. Si nous voulons avoir le formulaire sur la page principale, voici le get à ajouter juste avant le post :

app.js
^^^^^^

.. code-block:: javascript

    app
    .get('/', (req, res)=> {
        res.render('formulaire.ejs'); //la page d'accueil renverra désormais vers formulaire.ejs
    })
    .post('/upload', upload.any(), (req, res)=> {
            res.end('Merci !');
        });

On peut désormais tester en accéder à notre page d'accueil via le navigateur (URL `<http://localhost:8080/>`_. Un formulaire apparait et nous permet d'envoyer un fichier de notre machine.
N'hésitez pas à vérifier que le fichier apparait ensuite dans le répertoire "uploads" de votre projet.

Ajouter un filtre de format et de quantité
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Selon les circonstances, nous préférons souvent fixer le format de fichier possible à l'envoi,
nous allons donc modifier légèrement le code de :code:`app.js` pour fixer l'envoi d'un seul fichier et de format fixé.
Pour ces modifications, l'ajout d'une ligne :code:`var path = require('path');` sera nécessaire.


app.js
^^^^^^

.. code-block:: javascript

    var express = require('express')
    var multer  = require('multer')
    var path = require('path'); // ligne ajoutée

    var storage = multer.diskStorage({
        destination: function(req, file, callback) {
            callback(null, './uploads');
        },
        filename: function(req, file, callback) {
            callback(null,Date.now()+file.originalname);
        }
    })
    var upload = multer({ storage: storage });

    var app = express()

    app.post('/upload',function(req,res) {
            var upload = multer({storage: storage, fileFilter: function (req, file, callback) { //ajout d'un filtre de format
                    var ext = path.extname(file.originalname);
                    if(ext !== '.png' && ext !== '.jpg' && ext !== '.gif' && ext !== '.jpeg') { //condition sur les formats acceptés
                        return callback(new Error('Only images are allowed'))
                    }
                    callback(null, true)}
            }).single('userFile');//méthode any remplacée par single : un seul fichier à la fois, le nom du fichier est imposé ("userFile")

            upload(req, res, function (err) {
                if (err) {
                    return res.end("Error uploading file.");
                }
                res.end("File is uploaded");
            });
        })

On peut alors refaire un test avec postman :

* En sélectionnant un fichier du format .png,.jpg,.jpeg ou .gif l'upload devrait réussir et le serveur devrait renvoyer "File is uploaded".
* Si on sélectionne tout autre format de fichier, le serveur renverra une erreur.

Remarque : d'autres méthodes de :code:`multer` existent pour pouvoir limiter le nombre de d'upload acceptés simultanément, comme :code:`array(fileName[,maxcount])` au lieu de :code:`single(fileName)`.


