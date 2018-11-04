***********
Formulaires
***********

On va mettre en place un formulaire (`<https://developer.mozilla.org/en-US/docs/Learn/HTML/Forms>`_ ) dans la page de contact.

Mise en place
============= 

Form
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

Voyez comment sont envoyées les données (attribut "name" suivi de la valeur). Mais avant ça, rendons le tout plus joli.


Materialize
^^^^^^^^^^^ 

On utilise MaterializeCSS pour que ce soit plus joli : `<http://materializecss.com/forms.html>`_ 


:file:`commentaires.ejs` :


.. code-block:: html

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


Query Strings
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

En cas d'erreur sur lé définition de qs, il est possible d'écrire en choisissant la solution 1 ou 2 :

.. code-block:: js

	app.get('/commentaires', function(request, response) {
	    // qs = {"commentaire": "top"} solution 1 hardcodage
	    // qs = request.query; solution 2 avec les paramètres get
		response.render("commentaires", {qs: qs})
	});

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

    
.. note :: Notez comment le code HTML est imbriqué dans le code EJS. C'est un peu sale, on va donc essayer de le faire le moins possible. Pour la zone de texte, on est ainsi obligé de tout mettre sur une seule ligne, sinon les retours chariot sont comptés comme une réponse.

Et avec Bulma ?
===============

On peut également utiliser Bulma qui est très complet : `<https://bulma.io/documentation/form>`_

Installation/configuration de Bulma
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Une fois dans le répertoire de travail et dans assets (:code:`cd`)


.. code-block:: os

	npm install bulma 
	
Bulma est installé. Reste à l'initialiser dans le fichier html. Pour cela, il faut rajouter dans le :code:`header` la ligne suivante :

.. code-block:: html

	<link rel="stylesheet" href="static/node_modules/bulma/css/bulma.min.css">

	
Exemple de formulaire avec Bulma
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

L'exemple d'un champ basique est le suivant :

.. code-block:: html

	<div class="field">
	  <label class="label">Nom du champ (Pseudo, Nom, Prénom, etc.)</label>
	  <div class="control">
	    <input class="input" type="text" placeholder="Texte mis en indication dans le champ à remplir ('input')">
	  </div>
	  <p class="help">"Help text" pour éventuellement donner des indications</p>
	</div>

Observez bien cet exemple et essayez de jouer avec les différentes possibilités pour bien comprendre. Par exemple, dans la balise :code:`<input ...>` le type peut être changé en fonction de ce que vous voulez que l'utilisateur entre (principalement :code:`text`, :code:`email` et :code:`url`)

Template de formulaire complet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Maintenant que nous avons les bases, voici ce que nous proposons pour le code html du formulaire. Les principaux types de champs sont utilisés dans ce code, libre à vous d'observer comment cela fonctionne — notamment à l'aide de la documentation. Cependant, ce fichier ne récupère pas encore les informations envoyées, il faudra passer par du php pour extraire et traiter les informations (comme précédemment).

.. code-block:: html

	<html>
	<head>
	    <% include partials/head_css_import.ejs %>
	    <meta charset="utf-8" />
	    <title>Commentaires</title>
	    <link rel="stylesheet" href="/static/node_modules/bulma/css/bulma.min.css">
	</head>
	<body>

	<% include partials/navbar.ejs %>

	<div class="row">
	<form id="myForm" class="col s12">
		<div class="field is-horizontal">
		  <div class="field-label is-normal">
		    <label class="label">De</label>
		  </div>
		  <div class="field-body">
		    <div class="field">
		      <p class="control is-expanded">
			<input class="input" type="text" placeholder="Ton petit nom" required="required">
		      </p>
		    </div>
			<div class="field has-addons has-icons-right">
			  <p class="control">
			    <input class="input" type="text" placeholder="prenom.nom">
				<!-- mettre type="email" si vous faites un champ email classique -->
			  </p>
			  <p class="control">
			    <a class="button is-static">
			      @
			    </a>
			</p>
			<div class="select is-fullwidth">
			  <select>
			    <option>centrale-marseille.fr</option>
			    <option>gmail.com</option>
			    <option>outlook.com</option>
					<option>hotmail.fr</option>
					<option>aucun-donc-je-ne-peux-pas-vous-contacter.fr</option>
			  </select>
			</div>
			</div>
		  </div>
		</div>

		<div class="field is-horizontal">
		  <div class="field-label"></div>
		  <div class="field-body">
		    <div class="field is-expanded">
		      <div class="field has-addons">
			<p class="control">
			  <a class="button is-static">
			    +33
			  </a>
			</p>
			<p class="control is-expanded">
			  <input class="input" type="tel" placeholder="Numéro de téléphone">
			</p>
		      </div>
		      <p class="help">Du coup, n'écrivez pas le premier "0"</p>
		    </div>
		  </div>
		</div>

		<div class="field is-horizontal">
		  <div class="field-label">
		    <label class="label">Es-tu un 
				ninja ?</label>
		  </div>
		  <div class="field-body">
		    <div class="field is-narrow">
		      <div class="control">
			<label class="radio">
			  <input type="radio" name="member">
			  Oui
			</label>
			<label class="radio">
			  <input type="radio" name="member">
			  Non
			</label>
		      </div>
		    </div>
		  </div>
		</div>

		<div class="field is-horizontal">
		  <div class="field-label is-normal">
		    <label class="label">Objet</label>
		  </div>
		  <div class="field-body">
		    <div class="field">
		      <div class="control">
			<input class="input is-required" type="text" placeholder='Par exemple : Spam via formulaire de contact'>
		      </div>
		      <p class="help is-required">
			Ce champ est obligatoire
		      </p>
		    </div>
		  </div>
		</div>

		<div class="field is-horizontal">
		  <div class="field-label is-normal">
		    <label class="label">Question</label>
		  </div>
		  <div class="field-body">
		    <div class="field">
		      <div class="control">
			<textarea class="textarea" placeholder="Comment puis-je vous aider ?"></textarea>
		      </div>
		    </div>
		  </div>
		</div>

		<div class="field is-horizontal">
		  <div class="field-label">

		  </div>
		  <div class="field-body">
		    <div class="field">
		      <div class="control">
			<button class="button is-primary" type="submit">
			  Envoyer le formulaire
			</button>
		      </div>
		    </div>
		  </div>
		</div>
	</form>

	<% include partials/js_import.ejs %>
	</body>
	</html>
	
Récupération des champs du formulaire en javaScript et affichage de messages d'alerte
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Nous allons maintenant récupérer les réponses du formulaire pour pouvoir les afficher dans un message d'alerte. Nous allons aussi rajouter un bouton reset qui réinitialise tous les champs. Par ailleurs, plusieurs messages d'alerte indiquent lorsque nous envoyons les données ou lorsqu'on réinitialise la page.

On commence par créer un fichier :file:`form.js` que l'on place dans un dossier :code:`script`.

.. code-block:: js

	var myForm = document.getElementById('myForm');

	
	myForm.addEventListener('submit', function(e) {
		//cette fonction permet à l'utilisateur de valider ou non l'envoi du formulaire
		if(confirm("Êtes-vous sûr de vouloir envoyer le formulaire ?")){ 
			// demande la confirmation à l'utilisateur (renvoie true ou false)
			myForm.submit() // le formulaire est envoyé

			var message = 'Vous avez envoyé le formulaire !\n\nVotre nom est : ' 
			+ document.getElementById('name').value + '.\n' 
			// le champ "nom" est obligatoire donc on l'affiche dans la deuxième alerte quoi qu'il arrive


			if (document.getElementById('mail').value){ //si le champ mail est rempli
				message += 'Votre adresse mail est : ' + document.getElementById('mail').value
				+ '@' + document.getElementById('domaine').value + '.\n' 
				//on l'affiche dans la deuxième alerte
			}

			if (document.getElementById('tel').value){ //idem
				message += 'Votre numéro de téléphone est le : ' 
				+ document.getElementById('tel').value + '.\n'
			}

			if (document.getElementById('object').value){
				message += 'L\'objet de votre contact est : ' 
				+ document.getElementById('object').value + '.\n'
			}

			if (document.getElementById('msg').value){
				message += 'Votre message est : ' 
				+ document.getElementById('msg').value + '.\n'
			}

			alert(message) //on affiche l'alerte avec le message contruit précédemment

		    e.preventDefault();
		    
		} else {
		   e.returnValue = false; 
		   //pour que les champs gardent les mêmes valeurs si on ne veut pas envoyer le formulaire
		}


	});

	myForm.addEventListener('reset', function(e) { 
		//de même, pour confirmer ou non la réinitialisation du formulaire
		if(confirm("Voulez-vous vraiment réinitialiser le formulaire ?")){
	    	alert('Vous avez réinitialisé le formulaire !');
	    } else {
	    e.returnValue = false
	    }
	});

	var ninja1 = document.getElementById('ninja1')
	ninja1.onclick = function() { alert('NINJAAAAA')} //alerte pour le bouton oui de la question ninja

	var ninja2 = document.getElementById('ninja2')
	ninja2.onclick = function() {alert('Triste vie...')} //alerte pour le bouton non de la question ninja

On ajoute ensuite à la fin du fichier :file:`commentaires.ejs` la ligne suivante :

.. code-block:: html

	<script type="text/javascript" src="/js/form.js"></script>

On rajoute également des paramètres :code:`id="..."` afin de pour voir les appeler dans le fichier :code:`form.js`.

Le fichier :file:`commentaires.ejs` devient donc :

.. code-block:: html

	<html>
	<head>

	<% include partials/head_css_import.ejs %>

	    <meta charset="utf-8" />
	    <title>Commentaires</title>
	    <link rel="stylesheet" type="text/css" href="/static/node_modules/bulma/css/bulma.min.css">
	    
	</head>
	
	<body>

	    <% include partials/navbar.ejs %>

	    <div class="row">
		<form id="myForm" class="col s12"> <!-- ajout de l'id "myForm" -->
		    <div class="field is-horizontal">
		      <div class="field-label is-normal">
			<label class="label">Nom</label>
		      </div>
		      <div class="field-body">
			<div class="field">
			  <p class="control is-expanded">
			    <input id="name" class="input" type="text" placeholder="Ton petit nom" required="required">
			    <!-- pour chaque input des champs du formulaire on ajoute un id 
			    "required" permet d'obliger de remplissage de ce champ -->
			  </p>
			</div>
			    <div class="field has-addons has-icons-right">
			      <p class="control">
				<input id='mail' class="input" type="text" placeholder="prenom.nom">
				    <!-- mettre type="email" si vous faites un champs email classique -->
			      </p>
			      <p class="control">
				<a class="button is-static">
				  @
				</a>
			    </p>
			    <div class="select is-fullwidth">
			      <select id="domaine">
				<option>centrale-marseille.fr</option>
				<option>gmail.com</option>
				<option>outlook.com</option>
				<option>hotmail.fr</option>
				<option>aucun-donc-je-ne-peux-pas-vous-contacter.fr</option>
			      </select>
			    </div>
			    </div>
		      </div>
		    </div>

		    <div class="field is-horizontal">
		      <div class="field-label"></div>
		      <div class="field-body">
			<div class="field is-expanded">
			  <div class="field has-addons">
			    <p class="control">
			      <a class="button is-static">
				+33
			      </a>
			    </p>
			    <p class="control is-expanded">
			      <input id="tel" class="input" type="number" placeholder="Numéro de téléphone">
			      <!-- type number pour qu'on ne puisse mettre que des numéros -->
			    </p>
			  </div>
			  <p class="help">Du coup, n'écrivez pas le premier "0"</p>
			</div>
		      </div>
		    </div>

		    <div class="field is-horizontal">
		      <div class="field-label">
			<label class="label">Es-tu un
				    ninja ?</label>
		      </div>
		      <div class="field-body">
			<div class="field is-narrow">
			  <div class="control">
			    <label class="radio">
			      <input id="ninja1" type="radio" name="member">
			      Oui
			    </label>
			    <label class="radio">
			      <input id="ninja2" type="radio" name="member">
			      Non
			    </label>
			  </div>
			</div>
		      </div>
		    </div>

		    <div class="field is-horizontal">
		      <div class="field-label is-normal">
			<label class="label">Objet</label>
		      </div>
		      <div class="field-body">
			<div class="field">
			  <div class="control">
			    <input id="object" class="input is-required" type="text" 
			    placeholder='Par exemple : Spam via formulaire de contact'>
			  </div>
			  <p class="help is-required">
			    Ce champs est obligatoire
			  </p>
			</div>
		      </div>
		    </div>

		    <div class="field is-horizontal">
		      <div class="field-label is-normal">
			<label class="label">Question</label>
		      </div>
		      <div class="field-body">
			<div class="field">
			  <div class="control">
			    <textarea id="msg" class="textarea" placeholder="Comment puis-je vous aider ?">
			    </textarea>
			  </div>
			</div>
		      </div>
		    </div>

		    <div class="field is-horizontal">
		      <div class="field-label">

		      </div>
		      <div class="field-body">
			<div class="field">
			  <div class="control">
			    <input type="submit" value="Envoyer le formulaire" class="button is-primary"/>
			    <!-- ajout du type submit -->
			     <input type="reset" value="Reset" class="button is-secondary"/>
			     <!-- ajout du type reset -->
			  </div>
			</div>
		      </div>
		    </div>
		</form>
	    </div>

	    <script type="text/javascript" src="/js/form.js"></script>

	    <% include partials/js_import.ejs %>

	</body>
	</html>

Dans le fichier :file:`app.ejs`, on ajoute (de la même manière qu'on utilisait :code:`/static` pour :code:`/assets`) : 

.. code-block:: js

	app.use("/js", express.static(__dirname + '/script'));

