***********
Formulaires
***********

On va mettre en place un formulaire (`<https://developer.mozilla.org/en-US/docs/Learn/HTML/Forms>`_ ) dans la page de contact.

Mise en place
============= 

form
^^^^ 


Un formulaire tout simple, :file:`commentaires.ejs` :

.. code-block:: html

    <html>

    <head>
        <meta charset="utf-8" />
        <title>Commentaires</title>
    </head>

    <body>
        <form>
            Pseudo :
            <input id="pseudo" type="text" name="pseudo">
            
            <textarea placeholder="dites nous tout le bonheur que vous apporte ce site" name="comment"></textarea>
            <button type="submit">Envoi</button>            
        </form>
    </body>

    </html>

Voyez comment sont envoyées les données (attribut "name" suivi de la valeur). Mais avangt ça, rendons le tout plus joli.


materialize
^^^^^^^^^^^ 

On utilise MaterializeCSS pour que ce soit plus joli : `<http://materializecss.com/forms.html>`_ 


:file:`commentaires.ejs` :


.. code-block:: text

    <html>

    <head>
        <meta charset="utf-8" />
        <title>Commentaires</title>

        <% include partials/head_css_import.ejs %>

        <style>
            html, body {
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
                            <input id="pseudo" type="text" name="pseudo" />
                            <label for="pseudo">pseudo</label>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="input-field col s12">
                        <textarea id="comment" class="materialize-textarea" placeholder="dites nous tout le bonheur que vous apporte ce site" name="comment"></textarea>
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

    </body>

    </html>

Query strings
^^^^^^^^^^^^^ 

Lorsque l'on clique sur le bouton, pour l'instant on envoie une requête GET (cf. les headers) avec les valeurs passées en argument de l'URL. Par exemple : http://localhost:8080/commentaires?pseudo=caro&comment=Trop+cool+ton+site+%28lol%29

On appelle ça des *query string parameters* : `<https://en.wikipedia.org/wiki/Query_string>`_. Le format est assez simple et permet de faire passer des variables dans une url.

Modifion un peu :file:`app.js` pour voir ce qu'il se passe.

.. code-block:: js

    app.get('/commentaires', (request, response) => {
        logger.info(JSON.stringify(request.query))
        response.render("commentaires")
    })



Templating
==========  

On va utiliser ces query strings dans notre template. Commençons par passer les query strings en paramètres de notre template : 

:file:`app.js` :

.. code-block:: js

    app.get('/commentaires', (request, response) => {
        response.render("commentaires", {qs: request.query})
    })


L'objet qs est passé en paramètre de notre template et prend la valeur de notre query string. Dans notre cas, il a donc 2 champs correspondant aux noms de nos formulaires, à savoir :code:`qs.pseudo` et :code:`qs.comment`.

Modifions le template pour les utiliser. On va tout de même faire attention au fait que ces paramètres peuvent être vides. 


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

    </body>

    </html>

    
.. note :: Notez comment le code HTML est imbriqué dans le code EJS. C'est un peu sale, on va donc essayer de le faire le moins possible. Pour le textaera, on est ainsi obligé de tout mettre sur une seule ligne, sinon les retours chariot son comptés comme une réponse.





