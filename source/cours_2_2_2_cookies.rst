*******
Cookies
*******

On va utiliser les cookies pour se rappeler de notre pseudo.

Un `<https://fr.wikipedia.org/wiki/Cookie_(informatique)>`_ c'est un objet chez le client. Il a un nom, une durée de vie et contient des informations.

Les cookies mis par un serveur sont envoyé par le client à chaque requête de celui-ci. Ceci permet de sauvegarder des données directement chez le client et de les retrouver


voir les cookies
================ 

* les cookie d'un site en particulier, dans l'onglet application des outils de développement. Allez voir sur un site contenant des publicités par exemple pour voir le nombre de cookies qui vous concerne.
* à la console : :code:`document.cookie`

Créer des cookies
=================

Pour avoir accès aux cookies, il faut utiliser un middleware : :code:`cookie-parser` `<https://www.npmjs.com/package/cookie-parser>`_

On commence par l'installer : :command:`npm install --save cookie-parser` puis on l'utilise dans :file:`app.js` :

.. code-block :: js

    var express = require('express')
    var cookieParser = require('cookie-parser')

    var app = express()
    app.use(cookieParser())

Ceci nous donnera accès aux cookies que nous aurons créé. 

* les cookies seront dans :code:`request.cookies` : `<https://expressjs.com/en/4x/api.html#req.cookies>`_
* on pourra en créer de nouveaux en les placant dans la réponse : `<https://expressjs.com/en/4x/api.html#res.cookie>`_

 Comme tout sera géré au niveau des commentaires, regardons la route dédiée dans :file:`app.js` :


.. code-block:: js

    app.get('/commentaires', (request, response) => {
        if (request.cookies.pseudo) {
            logger.info("cookie (request) : " + request.cookies.pseudo)
            if (!request.query.pseudo) {
                logger.info("cookie as default name")
                request.query.pseudo = request.cookies.pseudo
            } 
        }
        if (request.query.pseudo) {            
            response.cookie("pseudo", request.query.pseudo, {"maxAge": 3000})
        }
        
        response.render("commentaires", {qs: request.query})
    })


On vérifie si un cookie existe déjà pour donner un nom par défaut. La durée de vie du cookie que l'on crée est de 3s.




