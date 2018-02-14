******************
Sauver les Données
******************

.. note:: à mettre à jour avec la version actuelle

Côté serveur
============

La base de données :

  * elle peut être en mémoire ;
  * elle peut être dans un fichier (plat ou SQlite) ;
  * elle peut être en base (SQL ou mongodb).

Pour manipuler les données on utilisera un formalisme CRUD (`<https://en.wikipedia.org/wiki/Create,_read,_update_and_delete>`_) et pour les transmettre une architecture REST (`<https://en.wikipedia.org/wiki/Representational_state_transfer>`_).

.. note:: Durant ce cours, nous ne verrons que les bases de données en mémoire.

Route spéciale
^^^^^^^^^^^^^^

On va attaquer toutes nos requêtes vers les données en utilisant une URL commençant par API. Parfois on ajoute aussi le numéro de version. Pour ne pas avoir à refaire toutes les routes à chaque changement de version, on va utiliser les router de express (`<http://expressjs.com/fr/4x/api.html#router>`_).

Pour l'instant on va placer le code dans le fichier :file:`server.js` :

.. code-block:: javascript

  var router = express.Router();

  router.get("/comment", (request, response) => {
      response.send(request.originalUrl)
  })

  app.use('/api', router);
  app.use('/api/v1', router);


CRUD
^^^^
Notre modèle de donnée va être ici:
  * id
  * nom
  * prénom
  * commentaire

Il va bien s'adapter avec les bases de données *NOSQL*. Nous ne ferons ici que le traitement en mémoire. Il n'y aura donc pas de persistence des données (après l'arrêt du serveur) ni de méthodes de recherche très frustre.

Les différentes méthodes seront :

.. code-block:: javascript

  router.get("/comment", (request, response) => {
      response.send("READ all the comments")
  })

  router.post("/comment", (request, response) => {
      response.send("CREATE a comment")
  })

  router.get("/comment/:id", (request, response) => {
      response.send("Comment with id", id)
  })

  router.post("/comment/:id", (request, response) => {
      response.send("UPDATE with id", id)
  })

  router.delete("/comment/:id", (request, response) => {
      response.send("DELETE comment with id", id)
  })

Test avec Postman
^^^^^^^^^^^^^^^^^

`<https://www.getpostman.com>`_ est une application permettant de tester facilement vos API REST.

Ceci va nous aider pour créer effectivement les différentes méthodes.

Module de routage
^^^^^^^^^^^^^^^^^

On fait comme la fin de cette page `<http://expressjs.com/fr/guide/routing.html>`_
en créant un module spécifique pour l'API CRUD.

On va créer un fichier :file:`comment.js` dans le répertoire :file:`route/api` de notre application.

.. code-block:: javascript

  var express = require('express')
  var router = express.Router();

  router.get("/comment", (request, response) => {
      response.send("READ all the comments")
  })

  router.post("/comment", (request, response) => {
      response.send("CREATE a comment")
  })

  router.get("/comment/:id", (request, response) => {
      response.send("READ comment with id: " + request.params.id)
  })

  router.post("/comment/:id", (request, response) => {
      response.send("UPDATE comment with id: " + request.params.id)
  })

  router.delete("/comment/:id", (request, response) => {
      response.send("DELETE comment with id: " + request.params.id)
  })

  module.exports = router;


Et dans notre :file:`server.js`, on pourra se contenter de :
.. code-block:: javascript

  var commentAPI = require("./routes/api/comment")

  app.use('/api', commentAPI);
  app.use('/api/v1', commentAPI);


.. note:: A faire: ajouter des logs pour cette partie. En faisant un nouveau loggeur.


Implémentation des méthodes ave une base de données en mémoire
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ici, notre ID va être un nombre qui va toujours grandir. Dans une vrai base de données, cet ID aurait été généré automatiquement.

.. note:: En codant vos méthodes, n'oubliez pas d'utiliser postman pour vérifier que tout se passe au mieux.

.. code-block:: javascript

  var express = require('express')
  var router = express.Router();

  var comments = [{id: 0,
                   firstname: "François",
                   name: "Brucker",
                   comment: "Le web c'est la vie !"
                  },
                  {id: 1,
                   firstname: "Pascal",
                   name: "Préa",
                   comment: "La recherche est en n, on peut faire mieux. Comment ?"
                  },
                  {id: 2,
                   firstname: "Joëlle",
                   name: "Gazérian",
                   comment: "Un beau projet."
                  }
                 ]
  var nextID = 3


  router.get("/comment", (request, response) => {
      response.send(comments)
  })

  router.post("/comment", (request, response) => {
      comment = {
          id: nextID,
          firstname: "",
          name: "",
          comment: ""
      }
      comments.push(comment)

      nextID += 1

          if (request.body.firstname) {
              comment.firstname = request.body.firstname
          }
          if (request.body.name) {
              comment.name = request.body.name
          }
          if (request.body.comment) {
              comment.comment = request.body.comment
          }

      response.send(comment)
  })

  router.get("/comment/:id", (request, response) => {

      result_index = get_index_by_id(request.params.id)

      if (result_index === -1) {
          response.status(404).send({})
      }
      else {
          response.send(comments[result_index])
      }

  })

  router.post("/comment/:id", (request, response) => {

      result_index = get_index_by_id(request.params.id)

      if (result_index === -1) {
          response.status(404).send({})
      }
      else {
          result = comments[result_index]

          if (request.body.firstname) {
              result.firstname = request.body.firstname
          }
          if (request.body.name) {
              result.name = request.body.name
          }
          if (request.body.comment) {
              result.comment = request.body.comment
          }

          response.send(comments[result_index])
      }

  })

  router.delete("/comment/:id", (request, response) => {

      result_index = get_index_by_id(request.params.id)

      if (result_index === -1) {
          response.status(404).send({})
      }
      else {
          delete comments[result_index]
      }

  })

  function get_index_by_id(id) {
      for (var i=0; i < comments.length ; i += 1) {
          if (String(comments[i]) === id) {
              return i
          }
      }
      return -1;

  }

  module.exports = router;


.. note:: Si on a le temps les laisser faire une méthode.


.. note:: A faire:  Changer le code du javascript client de :file:`contact.ejs` pour qu'il utilise l'API. Supprimer la requête POST restante dans :file:`server.js`.


Bases de données
================

Utilisez par exemple `<https://www.youtube.com/watch?v=L4OP8JGKbQU&index=35&list=PL4cUxeGkcC9gcy9lrvMJ75z9maRw4byYp>`_
pour mettre en place le tout avec une base de données MONGODB.
