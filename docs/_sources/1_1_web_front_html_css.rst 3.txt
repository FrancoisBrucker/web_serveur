*********************
Web front : html, css
*********************

On supposera que vous avez suivi un tuto pour apprendre les base de html/css comme celui-là: 
     https://internetingishard.com/html-and-css/ 

Il en existe plein d'autres. Essayez d'avoir des sites de références pour ces diverses techno : 
    * http://www.w3schools.com
    * https://developer.mozilla.org/en-US/docs/Learn/Getting_started_with_the_web
    * http://www.thenetninja.co.uk


.. todo:: faire un projet git avec les diverses parties du projet en tag. https://git-scm.com/book/en/v2/Git-Basics-Tagging

partie d'un tout
================

front/back/ops 

* front (client): affichage de contenu html5, css3, javascript. 

* back (serveur). Peut dans un sens très (trop) large :
    * servir du contenu html, css, js
    * servir des fichiers binaires/textes
    * fonctionnement asynchrone par défaut mais aussi synchrone (websocket)
    * stockage et accès à des données côté serveur (api rest, crud) ou client (cookies)
* communication entre front et back par le protocole http ou https.

* ops : la mise en production. L'idée est que la mise en production doit être un **non-évènement**. On doit pouvoir le faire 20, 30 fois par jour si nécessaire. Parfois ça ratera mais il faut minimiser cela par un workflow efficace et surtout permettre une correction rapide en cas de bug.


projet
======

Créez un projet webstorm de type *empty project*, et initialisez le avec git :
    * initialiser le projet : :code:`git init`
    * gérer le :code:`.gitignore` (:code:`ls -la` pour voir les fichiers cachés)

html
====

.. note:: faire en direct avec le lien vers un navigateur.


Le HTML est un langage à balise. C'est-à-dire qu'il est toujours en deux parties. Par exemple : :code:`<head></head>` et :code:`<body></body>`. 


    Structure de base d'un document html : http://www.alsacreations.com/article/lire/1374-html5-structure-globale-document.html


Juste un petit exemple, on en refera par la suite, c'est juste pour ne pas être (trop) perdu.
Ici, le navigateur interprétera directement le fichier, sans passer par un *serveur*. Il trouve le fichier à afficher via une `uri <https://fr.wikipedia.org/wiki/Uniform_Resource_Identifier)>`__   :code:`file://chemin/absolu/vers/fichier.html`

.. code-block:: html
    :linenos:
    :caption: index.html

    
    <!doctype html>
    <html>
    <head>
        <meta charset="utf-8"/>
        <title>Maison page</title>
    </head>
    <body>
    <h1>Enfin du web !</h1>
    <p>Bonjour à tous.</p>
    </body>
    </html>

Webstorm n'est pas content, il souligne la ligne 2. En passant le curseur à droite de l'éditeur, en regard de la ligne 2 sur le trait orange, il est dit : *Missing required 'lang' attribute*. En cliqant dessus une ampoule orange apparait sur le mot :code:`html`. Si on clique si cette ampoule elle propose un correctif : *insert required tag*. Faisons le et choisissons :code:`fr` comme langue.

Ouvrez le fichier avec chrome : :code:`fichier > ouvrir`. 

.. note:: vous pouvez aussi l'ouvrir avec webstorm via un serveur local. :code:`clique droit su rle fichier > open in browser`

Le html crée un arbre (via les balises imbriquées). Il est appelé arbre dom (Document Object Model).

Ajout du css
============

.. note:: Faire uniquement le début pour voir les changements s'effectuer en direct.


Le css est ajouté directement sur la page grâce à la balise :code:`<style></style>`.

.. code-block:: html
    :caption: index.html
    
    <!doctype html>
    <html lang="fr">
    <head>
        <meta charset="utf-8"/>
        <title>Maison page</title>

        <!-- https://fonts.google.com -->
        <link href="https://fonts.googleapis.com/css?family=Indie+Flower" rel="stylesheet">

        <style>
            html, body {
                margin: 0;
                padding: 0;

                background: skyblue;
                color: #ffffff;
                font-size: 2em;
                text-align: center;
            }

            p {
                font-family: 'Indie Flower', serif;
            }
        </style>
    </head>
    <body>
    <h1>Enfin du web !</h1>
    <p>Bonjour à tous.</p>
    </body>
    </html>


Pour la couleur, on la gère en hexadécimal RGB sur 32bits 8 par channel.

* Pour un aperçu des couleurs : https://color.adobe.com/fr/create.
* Pour les couleurs en hexadécimal pour faire du développement web : https://www.w3schools.com/colors/colors_names.asp.

.. note:: Utilisez les `outils de développement <https://developers.google.com/web/tools/chrome-devtools>`__ pour voir ce que vous avez fait. :code:`plus d'outils > outils de développement`


Les div et pourquoi c'est important
===================================

Les div (ou span) sont des blocs anonymes :

* `span <https://developer.mozilla.org/fr/docs/Web/HTML/Element/span>`__ : sur une ligne. Ils sont placés les un à côtés des autres (propriété display en css). Comme un :code:`<img />` ou un  :code:`<strong></strong>`;
* `div <https://developer.mozilla.org/fr/docs/Web/HTML/Element/div>`__ : un bloc les un en dessous des autres. Comme un :code:`<p></p>`, ou un :code:`<h1></h1>`.

Elles ne vont être caractérisées que par les classes/id css qu'on leur mettra :

* `class <https://developer.mozilla.org/fr/docs/Web/HTML/Attributs_universels/class>`__ : plusieurs paramètres peuvent avoir la ou les mêmes classes;
* `id <https://developer.mozilla.org/fr/docs/Web/HTML/Attributs_universels/id>`__ : unique pour un bloc particulier.

    On peut très finement caractériser la portée d'un sélecteur css : https://www.w3schools.com/cssref/css_selectors.asp

Attention cependant :

* une caractérisation chasse l'autre (donc on mettra ses propres fichiers css en dernier);
* les propriétés sont appliquées de la plus générale à la plus spécifique (qui masque donc la plus générale);
* il est compliqué de centrer verticalement (on le fera donc rarement tout seul).


.. code-block:: html
    :caption: index.html
    
    
    <!doctype html>
    <html lang="fr">
    <head>
        <meta charset="utf-8"/>
        <title>Maison page</title>

        <!-- https://fonts.google.com -->
        <link href="https://fonts.googleapis.com/css?family=Indie+Flower" rel="stylesheet">

        <style>
            html, body {
                margin: 0;
                padding: 0;

                background: skyblue;
                color: #ffffff;
                font-size: 2em;
                text-align: center;
            }

            p {
                font-family: 'Indie Flower', serif;
            }

            .milieu {
                margin: 10px auto;
                height: 50px;
                width: 20px;
            }

            .color {
                background-color: olive;
            }
        </style>
    </head>
    <body>
    <h1>Enfin du web !</h1>
    <div class="milieu color"></div>
    <p>Bonjour à tous.</p>
    </body>
    </html>


projet
======


Créez un projet github pour y téléverser votre projet.

Pour cette partie essayez d'utiliser uniquement les outils mis à votre disposition par webstorm, en particulier :
    * le `terminal <https://www.jetbrains.com/help/webstorm/terminal-emulator.html>`__  
    * `la gestion des sources <https://www.jetbrains.com/help/webstorm/version-control-integration.html>`__ 

.. note :: pour utiliser powershell sous W10, vous pouvez suivre ce `tuto <https://itnext.io/how-to-use-powershell-as-default-terminal-in-intellij-vscode-windows-power-user-menu-ba512e68b566>`__


N'oubliez pas de charger votre clé ssh. Une fois ceci fait :
    * ajoutez un readme depuis l'interface de github
    * mettez à jour votre projet chez vous
    * utilisez l'ovh comme serveur distant pour y mettre votre projet

Un framework web
================


Faire du javascript ou du css à la mimine, c'est rigolo deux minutes mais vite ça devient pénible. Dans la plupart des cas on utilisera des frameworks pour s'éviter de maintenir trop de css.

Nous allons utiliser ici un nouveau framework : https://tailwindcss.com/ qui va nous permettre, non seulement de voir ce qu'un framework css peut faire mais également vous initier au build d'un projet front.

    Un très bon tutoriel : https://www.grafikart.fr/tutoriels/tailwindcss-framework-css-1177
    

On a juste mis tailwind, voyez le résultat. Tout le style par défaut est supprimé (enlevez l'import de tailwind pour voir la différence)

.. code-block:: html
    :caption: index.html
    
    <!doctype html>
    <html lang="fr">
    <head>
        <meta charset="utf-8"/>
        <title>Maison page</title>

        <!-- https://fonts.google.com -->
        <link href="https://fonts.googleapis.com/css?family=Indie+Flower" rel="stylesheet">

        <link href="https://unpkg.com/tailwindcss@^1.0/dist/tailwind.min.css" rel="stylesheet">

        <style>
            p {
                font-family: 'Indie Flower', serif;
            }
        </style>
    </head>
    <body class="bg-gray-100">
    <div class="flex content-center">
        <h1 class="text-6xl max-w-lg mx-auto">Enfin du web !</h1>
    </div>

    <p class="bg-orange-300 shadow-xl hover:underline">Bonjour à tous.</p>
    </body>
    </html>
  

Gestion de packages
===================

Plutôt que de tout installer à la main et de ne plus se souvenir qui est quoi, on a coutume d'installer un gestionnaire de package. Le plus célèbre en front est :code:`npm` l'installeur de node (Node Package Manager). Il y a des alternatives comme :code:`yarn`, que nous utiliserons aujourd'hui.

.. note:: A priori toutes les commandes par :code:`yarn` peuvent être remplacées par :code:`npm`.

installation
------------

Commençez par installer https://nodejs.org/en/ :
    * osx : :code:`brew install nodejs`
    * w10 : :code:`scoop install nodejs`

Puis installez https://yarnpkg.com/lang/en/ : https://yarnpkg.com/en/docs/install#mac-stable

projet
------

On commence par initialiser le projet : :code:`yarn init`

Un fichier :code:`package.json` a été créé. Ainsi qu'un répertoire :code:`node_modules` qui va contenir toutes nos dépendances.

Installation des dépendances. On a uniquement besoin de dépendance de développement : 
    * la bibliothèque https://tailwindcss.com en dépendance pour le développement : :code:`yarn add --dev tailwind`
    * https://postcss.org : :code:`yarn add --dev postcss`


.. note:: node_modules va dans le :code:`.gitignore` et on ajoute :code:`package.json` au projet.

Le fichier :code:`package.json` devrait ressembler à ça :

.. code-block:: javascript
    :caption: package.json
    
    {
      "name": "2019_front",
      "version": "1.0.0",
      "main": "index.js",
      "repository": "git@github.com:FrancoisBrucker/cours_front_ecm.git",
      "author": "François Brucker <francois.brucker@centrale-marseille.fr>",
      "license": "MIT",
      "devDependencies": {
        "postcss-cli": "^6.1.3",
        "tailwindcss": "^1.1.2"
      }
    }
    
    
.. code-block:: html
    :caption: index.html
    
    <!doctype html>
    <html lang="fr">
    <head>
        <meta charset="utf-8"/>
        <title>Maison page</title>

        <!-- https://fonts.google.com -->
        <link href="https://fonts.googleapis.com/css?family=Indie+Flower" rel="stylesheet">

        <link rel="stylesheet" type="text/css" href="tailwind.css">
        <style>


        </style>
    </head>
    <body class="bg-gray-100">
    <div class="flex content-center">
        <h1 class="text-6xl max-w-lg mx-auto">Enfin du web !</h1>
    </div>

    <p class="bg-orange-300 shadow-xl hover:underline">Bonjour à tous.</p>
    </body>
    </html>


.. code-block:: javascript
    :caption: postcss.config.js
    
    module.exports = {
        plugins: [
            require('tailwindcss'),
        ]
    };
    
.. code-block:: css
    :caption: ptailwind.pcss
    
    @tailwind base;

    @tailwind components;

    @tailwind utilities;

    p {
        font-family: 'Indie Flower', serif;
    }


Il faut donc processer le fichier :code:`tailwind.pcss` pour le transformer en un fichier css utilisable. Pour cela on peut exécuter la commande : :code:`yarn run postcss -o tailwind.css tailwind.pcss`

.. note:: :code:`postcss` est un exécutable que l'on peut trouver dans le dossier :code:`./node_modules/.bin`. La commande `yarn run` permet d'exécuter un de ces exécutable directement (on peut aussi bien sur directement taper :code:`./node_modules/.bin/postcss`). 

La comande :code:`yarn run` permet également d'exécuter un script construit dans le fichier :code:`package.json`. Créons notre script de *build* :

.. code-block:: javascript
    :caption: package.json
    
    {
      "name": "2019_front",
      "version": "1.0.0",
      "main": "index.js",
      "repository": "git@github.com:FrancoisBrucker/cours_front_ecm.git",
      "author": "François Brucker <francois.brucker@centrale-marseille.fr>",
      "license": "MIT",
      "scripts": {
        "build": "yarn run postcss -o tailwind.css tailwind.pcss"
      },
      "devDependencies": {
        "postcss-cli": "^6.1.3",
        "tailwindcss": "^1.1.2"
      }
    }

La commande :code:`yarn run build` exécutera notre *build* et créera tout ce qui est nécessaire à la création du projet. 

utilité de postcss
------------------

Les imports 
^^^^^^^^^^^ 

Ils existent a priori pour css pure aussi.
 
 .. note:: les plugins sont exécutés les uns à la suite des autres, dans l'ordre de la liste. Il faut exécuter :code:`postcss-import` en premier, pour les imports passent.

.. code-block:: javascript
    :caption: postcss.config.js
    
    module.exports = {
        plugins: [
            require('postcss-import'),
            require('tailwindcss'),
        ]
    }

.. code-block:: css
    :caption: tailwind.pcss
    
    @import "tailwindcss/base";
    @import "tailwindcss/components";
    @import "tailwindcss/utilities";

    @import "custom-css.css";

.. code-block:: css
    :caption: custom-css.css
    
    p {
        font-family: 'Indie Flower', serif;
    }


apply
^^^^^


.. code-block:: css
    :caption: tailwind.pcss
    
    @import "tailwindcss/base";
    @import "tailwindcss/components";
    @import "tailwindcss/utilities";

    @import "custom-components.pcss";
    @import "custom-css.css";


.. code-block:: html
    :caption: custom-component.pcss
    
    .info {
        @apply bg-orange-300 shadow-xl;
    }

    .info:hover { 
        @apply underline;
    }
    


.. code-block:: html
    :caption: index.html
    
    <!doctype html>
    <html lang="fr">
    <head>
        <meta charset="utf-8"/>
        <title>Maison page</title>

        <!-- https://fonts.google.com -->
        <link href="https://fonts.googleapis.com/css?family=Indie+Flower" rel="stylesheet">

        <link rel="stylesheet" type="text/css" href="tailwind.css">
        <style>


        </style>
    </head>
    <body class="bg-gray-100">
    <div class="flex content-center">
        <h1 class="text-6xl max-w-lg mx-auto">Enfin du web !</h1>
    </div>

    <p class="info">Bonjour à tous.</p>
    </body>
    </html>


variables
^^^^^^^^^

.. code-block:: javascript
    :caption: postcss.config.js
    
    module.exports = {
        plugins: [
            require('postcss-import'),
            require('tailwindcss'),
            require('postcss-variables')({
                globals: {
                    background: '#f7fafc'
                }
            })
        ]
    };    

.. code-block:: html
    :caption: index.html

    <!doctype html>
    <html lang="fr">
    <head>
        <meta charset="utf-8"/>
        <title>Maison page</title>

        <!-- https://fonts.google.com -->
        <link href="https://fonts.googleapis.com/css?family=Indie+Flower" rel="stylesheet">

        <link rel="stylesheet" type="text/css" href="tailwind.css">
        <style>


        </style>
    </head>
    <body>
    <div class="flex content-center">
        <h1 class="text-6xl max-w-lg mx-auto">Enfin du web !</h1>
    </div>

    <p class="info">Bonjour à tous.</p>
    </body>
    </html>


.. code-block:: html
    :caption: tailwind.pcss


    @import "tailwindcss/base";
    @import "tailwindcss/components";
    @import "tailwindcss/utilities";

    @import "custom-components.pcss";
    @import "custom-css.css";

    $color: #bad;


    body {
        background: $background;
        color: $color;
    }

autoprefixer et purgecss
^^^^^^^^^^^^^^^^^^^^^^^^
https://www.purgecss.com/ permet de supprimer le css inutile (et il y en a. Chez moi on passe de 800ko à 10ko)


https://autoprefixer.github.io/ gère tout seul ce qui est browser dépendant. Exemple avec les animations (tiré de https://www.grafikart.fr/tutoriels/parcel-bundler-985). Regardez avec les outils de développement ou dans le fichier :code:`css` généré toutes les animations qui sont générées.

.. code-block:: javascript 
    :caption: package.json
    
    {
      "name": "2019_front",
      "version": "1.0.0",
      "main": "index.js",
      "repository": "git@github.com:FrancoisBrucker/cours_front_ecm.git",
      "author": "François Brucker <francois.brucker@centrale-marseille.fr>",
      "license": "MIT",
      "scripts": {
        "build": "yarn run postcss -o tailwind.css tailwind.pcss"
      },
      "devDependencies": {
        "@fullhuman/postcss-purgecss": "^1.3.0",
        "autoprefixer": "^9.6.4",
        "postcss-cli": "^6.1.3",
        "postcss-import": "^12.0.1",
        "postcss-variables": "^1.1.1",
        "tailwindcss": "^1.1.2"
      }
    }
    

.. code-block:: css
    :caption: custom-css.css
    
    p {
        font-family: 'Indie Flower', serif;
    }

    @keyframes bouge {
        from {transform: scale(.9)}
        50% { transform: scale(1.1)}
        to { transform: scale(.9)}
    }

    h1 {
        animation: bouge 3s infinite;
    }    

.. code-block:: javascript
    :caption: postcss.config.js
    
    const purgecss = require('@fullhuman/postcss-purgecss')

    module.exports = {
        plugins: [
            require('postcss-import'),
            require('tailwindcss'),
            require('postcss-variables')({
                globals: {
                    background: '#f7fafc'
                }
            }),
            require('autoprefixer'),
            purgecss({
                content: ['./*.html']
            }),
        ]
    };
    
    
le reste
^^^^^^^^ 

https://www.postcss.parts/

    un tuto : https://www.grafikart.fr/tutoriels/postcss-663 mais qui commence à être vieux. Utilisation avec gulp qui est un packager ancien. 
    
Quelques plugins très utiles : https://www.hongkiat.com/blog/postcss-plugins/ :
    * minifier (https://cssnano.co/)
    * cssnext (https://cssnext.github.io/) 
    * font magician (https://github.com/jonathantneal/postcss-font-magician)
    * ...
    

build
=====
Pour finir de bien faire les choses, il faudrait mettre toutes nos sources dans un dossier :code:`src` et builder l'application web finale dans un dossier :code:`build` qui serait généré automatiquement à chaque fois.

.. todo:: à faire bien

* dossier src/ et build/
* deux scripts build.sh et build.ps1 si sous w10 et powershell (https://www.dummies.com/computers/operating-systems/windows-xp-vista/create-run-powershell-script/)


