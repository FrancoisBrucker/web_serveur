**********
Les outils
**********

Les indispensables
==================

Il vous faudra :

* un **terminal** :
    * Par défaut sous linux,
    * :file:`/Applications/Utilitaires/Terminal` sous OSX
    * Powershell sous Windows 10 est plus ou moins équivalent. Sinon, vous pouvez l'activer : http://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/.

* Un navigateur muni d'outils de développement :
    * On utilisera *Chrome* pour ce cours: https://www.google.fr/chrome,
    * Des outils de développement existent pour la plupart des autres navigateurs.

* Un éditeur de texte :
  * 2016-2017 : On utilisera *Brackets* : http://brackets.io
  * 2017-2018 : On utilisera *Atom* : https://atom.io (https://davidl.fr/blog/atom.html) (en fait *Visual Studio Code* https://code.visualstudio.com/)



Vous pouvez venir avec vos propres outils, mas dans ce cas là vous êtes sensés savoir vous en servir et avoir les même fonctionnalités que celles utilisées en cours.


On utilisera peut-être (mais c'est pas sûr) telnet. Par défaut sous OSX et linux, on peut l'activer sous Windows 10 : https://www.rootusers.com/how-to-enable-the-telnet-client-in-windows-10/).

Cours par cours
===============

Cours 1
-------

Web front et qu'est-ce qu'un serveur. On téléchargera les bibliothèques nécessaires.

Partage de code : on utilisera https://codeshare.io ou le pad de l'ECM : https://outils.centrale-marseille.fr/pad/p/cours_serveur_web pour communiquer le code, les ajouts nécessaires, etc.

Cours 2
-------

La bibliothèque de développement *node* (version 7.4 à l'heure où je tape ces lignes, version 9.5 à l'heure où je les corrige) disponible à https://nodejs.org. On installera d'autres package lors du cours.

Installation:

* Sous Windows 10, suivez les instructions de https://nodejs.org/en/download/,
* Sous linux, on pourra suivre https://nodejs.org/en/download/package-manager/,
* Sous OSX, je vous conseille de passer par *brew*: :code:`brew install node`. Brew (http://brew.sh) est un outil magnifique qui permet d'installer sans douleur la quasi totalité des logiciels unix (il y a forcément un package pour ça).

Cours 3
-------

On utilisera node et les bibliothèques de npm comme dans le cours 2. Voir la partie "Préparation" pour plus de détails.


La documentation
================

Elle a été écrite en utilisant Sphinx http://www.sphinx-doc.org.

Le format https://fr.wikipedia.org/wiki/ReStructuredText est à la fois lisible en texte brut et se transforme en différents formats (html, pdf, ...) facilement.
