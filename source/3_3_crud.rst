********
API CRUD
********

Les données sont usuellement stockées quelque part. Celles-ci peuvent prendre des formes différentes (base de données, fichier json, objets) et se stocker de façon diverses : 

  * en mémoire ;
  * dans un fichier (plat ou SQlite) ;
  * être une base (SQL ou mongodb).

Pour manipuler les données on utilisera un formalisme `CRUD <https://en.wikipedia.org/wiki/Create,_read,_update_and_delete>`__ et pour les transmettre une architecture `REST <https://en.wikipedia.org/wiki/Representational_state_transfer>`__.

api
===

On va attaquer toutes nos requêtes vers les données en utilisant une URL commençant par :code:`api`. Parfois on ajoute aussi le numéro de version, ce qui permet de garder des anciennes api en parallèle de l'api courante. 

Donc la route : 

.. code-block:: javascript
    :caption: ./routes/api.js
    
    var express = require('express');
    var router = express.Router();

    var winston = require('../winston.config');

    router.get('/', function(req, res, next) {
      winston.warn("TBD: implement me");

      res.send('api');

    });

    module.exports = router;
    

Le chargement et le lien dans :file:`app.js`.

Chargement des routes (juste après les autres chargements de routes) :

.. code-block:: javascript 
    :caption:  api.js

    // ... 
    
    var apiRouter = require('./routes/api');    
    
    // ... 
    

LLe lien, juste après les autres liens de routes : 

.. code-block:: javascript 
    :caption:  api.js

    // ...     
    
    app.use('/api', apiRouter);
    app.use('/api/v1', apiRouter); 

    // ...     

L'api courante est l'api v1. Cela pourra changer plus tard, lorsque l'on développera de nouvelles api tout en maintenant le legacy. 

.. note:: garder le legacy peut être important lorsque l'on développe des apis, car les utilisateurs ne veulent pas changer leurs interfaces tout le temps. Mais une api se devant aussi d'évoluer, il est nécessaire de permettre le changement. 


CRUD
====


Notre modèle de donnée va être ici:
  * pseudo (la clé)
  * commentaire

Il va bien s'adapter avec les bases de données *nosql*. Nous ne ferons ici que le traitement en mémoire. Il n'y aura donc pas de persistance des données (après l'arrêt du serveur) ni de méthodes de recherche.

Les différentes méthodes seront :

.. code-block:: javascript
    :caption: ./routes/api.js

    var express = require('express');
    var router = express.Router();

    var winston = require('../winston.config');

    router.get("/", (req, res) => {
      winston.info("TBD: implement me");
      res.send("READ all the comments");
    });

    router.post("/", (req, res) => {
      winston.info("TBD: implement me");
      res.send("CREATE a comment");
    });

    router.get("/:pseudo", (req, res) => {
      winston.info("TBD: implement me");
      res.send("Comment with pseudo "+ req.params.pseudo);
    });

    router.post("/:pseudo", (req, res) => {
      winston.info("TBD: implement me");
      res.send("UPDATE with pseudo " + req.params.pseudo);
    });

    router.delete("/:pseudo", (req, res) => {
      winston.info("TBD: implement me");
      res.send("DELETE comment with pseudo " + req.params.pseudo);
    });


    module.exports = router;
    

    
Testez ces routes avec Postman
    
Lier l'api aux commentaires
===========================

Le javascript de la page des commentaires doit pointer sur routes. Il suffit de 

* supprimer la méthode post dans la route :file:`./routes/comments.js` 
* changer le paramètre :code:`url` de la méthode :code:`ajax` par : 

    .. code-block:: javascript 

        // ...
    
        url: "http://" + $(location).attr('host') + "/api",
    
        // ...
    


Stockage des données
====================

Ave une *base de données* en mémoire (*ie.* un dictionnaire).


On va créer un fichier :file:`data_storage.js` dont le but est de stocker nos données. Ce fichier pourra ensuite amélioré si l'on veut mettre une vraie base de données.


.. code-block:: javascript
    :caption: ./data_storage.js

    const comments = {
    };

    comments["françois"] = "le web c'est la vie.";
    comments["pascal"] = "L'algo c'est rude.";

    module.exports = {
        getAllComments: () => {
            return comments;
        },
        getCommentByPseudo: (pseudo) => {
            return comments[pseudo];
        },
        setCommentByPseudo: (pseudo, comment) => {
            comments[pseudo] = comment;
        },
        deleteCommentByPseudo: (pseudo) => {
            delete comments[pseudo];
        },
    };


.. code-block:: javascript
    :caption: ./routes/api.js
    
    var express = require('express');
    var router = express.Router();

    var winston = require('../winston.config');

    var data = require('../data_storage');

    router.get("/", (req, res) => {
      res.send(data.getAllComments());
    });

    router.post("/", (req, res) => {
      winston.info("post: " + JSON.stringify(req.body));
      data.setCommentByPseudo(req.body.pseudo, req.body.comment);
      res.send("CREATE a comment");
    });

    router.get("/:pseudo", (req, res) => {
      winston.info("TBD: implement me");
      res.send(data.getCommentByPseudo(req.params.pseudo));
    });

    router.post("/:pseudo", (req, res) => {
      data.setCommentByPseudo(req.params.pseudo, req.body);
      res.send("UPDATE with pseudo " + req.params.pseudo);
    });

    router.delete("/:pseudo", (req, res) => {
      data.deleteCommentByPseudo(req.params.pseudo)
      res.send("DELETE comment with pseudo " + req.params.pseudo);
    });


    module.exports = router;
    
    
.. note:: Attention au fait que parfois, on utilise :code:`req.params`, lorsque c'est un paramètre de l'url et parfois on utilise :code:`req.body` lorsque les données sont passées dans le corps de la requête.


Testez botre api avec postman et l'url :

    * http://localhost:3000/api en GET : rend un objet
    * http://localhost:3000/api/françois en GET : rend une chaine de caractères
    
    * http://localhost:3000/api en POST avec comme corps de message :
        .. code-block:: json
        
            {
                "pseudo": "Geo",
                "comment": "ce serait pas plus simple en sh ?"
            }
        
        puis un http://localhost:3000/api en GET
        
    http://localhost:3000/api/françois en DELETE puis un http://localhost:3000/api en GET 
            
      
.. note:: postman et utf8 pas ok... Et c'est une honte. Bref il faut encoder l'url à la main. Par exemple en ouvrant une console et en tapant : encodeURIComponent("françois") ce qui me retourne : fran%C3%A7ois que je peux utiliser dans postman

  