************************************
Squelette d'une application complète
************************************


initialisation
==============


Avec Webstorm, créez un projet **Node.js Express App** avec comme paramètres :
    * :code:`yarn` comme package manager
    * :code:`ejs` comme View engine
    * :code:`Plain CSS` comme stylesheet engine

Cela va créer des dossiers (il utilise `express-generator <https://expressjs.com/fr/starter/generator.html>`__) :
    * :code:`bin` qui va contenir votre exécutable (regardez le scripts *start* dans le fichier :code:`package.json`)
    * :code:`node_modules` qui va contenir nos modules
    * :code:`public` pour les fichiers statiques
    * :code:`routes` pour les différentes routes
    * :code:`views` pour les templates

On aura aussi un fichier :code:`app.js` qui sera importé pour être exécuté par le script :code:`./bin/www`

    On peut lancer le serveur en tapant :code:`yarn run start`. Un serveur est crée à l'adresse http://localhost:3000/ 

Essayons de comprendre comment tout ça fonctionne :

* :code:`bin/www` charge app et l'exécute. 
* variables d'environnement https://medium.com/the-node-js-collection/making-your-node-js-work-everywhere-with-environment-variables-2da8cdf6e786 (changer le port en 8080. ); C'est super bien pour avoir plusieurs configurations (dev, prod, ...)
* debug https://www.npmjs.com/package/debug (utilisez le. Avec une variable d'environnement)
* les routes : elles sont importées. Combien y en a-t-il ? 
* utilisation du module `path <https://nodejs.org/api/path.html>`__
* des cookies https://www.npmjs.com/package/cookie-parser
* un logger https://alligator.io/nodejs/getting-started-morgan/

.. note:: plusieurs variables d'environnement en même temps :code:`DEBUG=untitled3:server PORT=8080 yarn run start` 

.. note:: si vous avez installé tree, vous pouvez taper :code:`tree -f | grep -v "node_modules/.*"` pour avoir l'arborescence jolie.


ejs
=== 

Vous voyez que le rendu de l'index se fait via un paramètre : :code:`{ title: 'Express' }`. Il est utilisé dans le template par le bout de code :code:`<%= title %>`

Il est également possible de rajouter des tests, des boucles etc. Regardez du côté dela doc : https://ejs.co/#docs

    Mélanger du script dans du html devient vite indigeste. Donc indentez bien le tout pour ne pas s'y perdre.

logger
======

Un loggeur permet de rendre compte de tout ce que fait le server.C'est super important si le serveur crash et que l'on veut savoir pourquoi.

On va voir 2 loggueur :

* `morgan <https://github.com/expressjs/morgan>`__ : un logger tout simple de toute requête http
* `winston <https://github.com/winstonjs/winston>`__ qui permet de faire bien plus de choses.

    Pourquoi et quoi logger : https://stackify.com/winston-logging-tutorial/

morgan
------ 

C'est `morgan <https://github.com/expressjs/morgan>`__ qui est utilisé pour loguer tous les appels http. C'est un middleware : commentez la ligne :code:`app.use(logger('dev'));`
dans :code:`app.js` pour voir la différence. Utilisez une autre façon de logger les choses : :code:`app.use(logger('combined'));` par exemple. 

    la doc : https://github.com/expressjs/morgan


winston
-------

    https://github.com/winstonjs/winston


On doit pouvoir a priori logger tout ce que fait le serveur. Mais il ne faut pas tout logger tout le temps sinon ne va plus rien retrouver, et les fichiers de logs vont être énormes. L'usage veut que l'on donne donc des niveaux de log et que ne sont stockés que les log de niveau inférieur à un seuil donné. Pour winston les `logging levels <https://github.com/winstonjs/winston#logging-levels>`__ sont ceux de npm par défaut :

.. code:: sh

    { 
      error: 0, 
      warn: 1, 
      info: 2, 
      verbose: 3, 
      debug: 4, 
      silly: 5 
    }

En production on pourra par exemple utiliser le level 0, en développement le 2 et en debug le 4.

    Le tuto pour winston que l'on va utiliser ici : https://www.digitalocean.com/community/tutorials/how-to-use-winston-to-log-node-js-applications
    Le tuto est bien mais écrit pour une vieille version de winston. Il y a donc quelques changements de temps en temps.


On va commencer par installer le logger winston (:code:`yarn add winston`) et le module app-root-path (:code:`yarn add app-root-path`) qui va nous permettre de spécifier dans l'appli les chemins.

config
^^^^^^

Une fois ça fait, on peut créer le fichier de configuration de winston :

.. code:: javascript
    :name: winston.config.js
    

    var appRoot = require('app-root-path');
    var winston = require('winston');

    // define the custom settings for each transport (file, console)

    var options = {
        file: {
            level: 'info',
            filename: `${appRoot}/logs/app.log`,
            handleExceptions: true,
            json: true,
            maxsize: 5242880, // 5MB
            maxFiles: 5,
            colorize: false,
        },
        console: {
            level: 'debug',
            handleExceptions: true,
            json: false,
            colorize: true,
        },
    };

    // instantiate a new Winston Logger with the settings defined above
    var logger = new winston.createLogger({
        transports: [
            new winston.transports.File(options.file),
            new winston.transports.Console(options.console)
        ],
        exitOnError: false, // do not exit on handled exceptions
    });

    // create a stream object with a 'write' function that will be used by `morgan`
    logger.stream = {
        write: function(message, encoding) {
            // use the 'info' log level so the output will be picked up by both transports (file and console)
            logger.info(message);
        },
    };

    module.exports = logger;


A chaque fois que l'on va accéder à des routes, elles vont être ajoutées dans le fichier de log.

log des erreurs dans app.js
^^^^^^^^^^^^^^^^^^^^^^^^^^^

* Remplace la ligne : :code:`app.use(logger('combined'));` par :code:`app.use(logger('combined', { stream: winston.stream }));`. Ceci va faire que les messages de morgan sont transformés en messages winston.
* dans la gesion des erreurs, ajouter un message winston : 

.. code:: javascript 

    winston.error(`${err.status || 500} - ${err.message} - ${req.originalUrl} - ${req.method} - ${req.ip}`);

log dans user
^^^^^^^^^^^^^

On peut ajouter un log dans le fichier users. pour cela on importe winston avec la ligne : 
.. code:: javascript

    var winston = require('../winston.config');
    
    
Puis, dans la route '/' on peut ajouter la ligne :

.. code:: javascript

    winston.warn("TBD: implement me");


Testez votre nouveau log !

.. note:: même si on redemande avec un require un fichier. Il n'est pas re-exécuté. Le contenu du module est en cache et va être donné tel quel. C'est donc le même winston qui va être donné à tous les require. Pour plus d'infos sur les require : https://www.freecodecamp.org/news/requiring-modules-in-node-js-everything-you-need-to-know-e7fbd119be8/




