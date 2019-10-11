******
Outils
******

Les indispensables
==================

Il vous faudra :

* un **terminal** :
  * Par défaut sous linux,
  * :file:`/Applications/Utilitaires/Terminal` sous OSX
  * Powershell sous Windows 10.

* Un navigateur muni d'outils de développement :
    * On utilisera `chrome <https://www.google.fr/chrome>`_ pour ce cours
    * Des outils de développement existent pour la plupart des autres navigateurs.

* Un éditeur de texte :
    * 2019-2020 : On utilisera `Webstorm <https://www.jetbrains.com/webstorm/>`_
    * 2018-2019 : On utilisera *Atom* : https://atom.io (https://davidl.fr/blog/atom.html)
    * 2017-2018 : On utilisera *Visual Studio Code* https://code.visualstudio.com/
    * 2016-2017 : On utilisera *Brackets* : http://brackets.io



Vous pouvez venir avec vos propres outils, mas dans ce cas là vous êtes sensés savoir vous en servir et avoir les même fonctionnalités que celles utilisées en cours.


On utilisera peut-être (mais c'est pas sûr) telnet. Par défaut sous OSX et linux, on peut l'activer sous Windows 10 : https://www.rootusers.com/how-to-enable-the-telnet-client-in-windows-10/).

utilisation
-----------

terminal :
    * micro tuto : https://www.youtube.com/watch?v=t7Ci2hwUpIM,
    * l'excellent https://informatique.centrale-marseille.fr/tutos/post/initiation-linux.html
powershell :
    * https://www.guru99.com/powershell-tutorial.html (je ne sais pas ce que ça vaut. dites moi)

outils de développement :
    * https://developers.google.com/web/tools/chrome-devtools

Installeur de package
=====================

Nous aurons besoin de nombreuses bibliothèques, applis au cours de ce cours. Il faut un moyen d'installer tout ça rapidement.

* `brew <https://brew.sh/>`_ sous osx
* `scoop <https://scoop.sh/>`_ sous w10
* apt-get sous linux (par défaut). Voir :  https://vitux.com/how-to-use-apt-get-package-manager-on-ubuntu-command-line/


Sous windows installez également wsl, qui nous servira de roue de secours lorsque plus rien de logique ne fonctionnera : https://docs.microsoft.com/fr-fr/windows/wsl/about choisissez une distribution debian, puis `apt-get  install curl git` dans un terminal puis vous pouvez installer brew pour wsl (https://docs.brew.sh/Homebrew-on-Linux) 


ssh
===

osx
--- 

    :code:`brew install openssh` 

w10
---

    :code:`scoop install openssh`


Il faut aussi mettre à jour les service ssh de windows même : `scoop install win32-openssh`. Une fois installé win32-openssh, scoop vous indique comment créer le service ssh-agent. Il s’agit d’exécuter une ligne commençant par sudo. Exécutez la ligne **en enlevant le mot sudo** (exécuter juste le programme) dans un powershell ouvert en mode administrateur.

Une fois ceci fait, vous pourrez : dans un powershell en mode administrateur  :
    * stopper le service avec la commande : :code:`Stop-Service ssh-agent`
    * permettre à l’agent de se lancer au boot de façon automatique : :code:`Set-Service -Name ssh-agent   * StartupType 'Automatic'`
    * exécuter le service avec la commande : :code:`Start-Service ssh-agent`

utilisation
-----------

* cours debian : https://formation-debian.viarezo.fr/ssh.html
* Je ne sais pas ce que ça vaut (dites-moi) : https://www.youtube.com/watch?v=QGixbJ9prEc&list=PLQqbP89HgbbYIarPqOU8DdC2jC3P3L7a6

git
===

On utilisera git et github comme gestionnaire de sources.

github
------ 

Faites vous un compte sur https://github.com/ Ajoutez y votre clé publique pour vous y connecter.

osx
---

    :code:`brew install git` 

w10
---

    tiré de https://dev.to/qm3ster/setting-up-gitsshgpg-on-windows-5c85 
    
    * :code:`scoop install git-with-openssh`
    * exécuter la commande en mode administrateur : :code:`[environment]::setenvironmentvariable('GIT_SSH', (resolve-path (scoop which ssh)), 'USER')`
    * ouvrez une nouvelle fenêtre powershell et git devrait fonctionner.

utilisation
-----------

git est très puissant. En utilisation courante, on ne va utiliser que 2% de ses capacités. On montrera petit à petit l'utilisation de git. Mais pour la doc complète, elle est là :

    * http://www-cs-students.stanford.edu/~blynn/gitmagic/intl/fr/
    * https://fr.wikibooks.org/wiki/Git/Principes
    * https://git-scm.com/book/fr/v2

node
====

La bibliothèque de développement *node* (version 7.4 à l'heure où je tape ces lignes, version 9.5 à l'heure où je les corrige) disponible à https://nodejs.org. On installera d'autres package lors du cours.

Installation:

* Sous Windows 10, suivez les instructions de https://nodejs.org/en/download/,
* Sous linux, on pourra suivre https://nodejs.org/en/download/package-manager/,
* Sous OSX, je vous conseille de passer par *brew*: :code:`brew install node`. Brew (http://brew.sh) est un outil magnifique qui permet d'installer sans douleur la quasi totalité des logiciels unix (il y a forcément un package pour ça).


java
====


.. todo:: à remanier.

Pour le cours de java android de la semaine prochaine, vous aurez besoin de :
- java (un jdk) d’installé
- android studio : https://developer.android.com/studio/?gclid=Cj0KCQjwrfvsBRD7ARIsAKuDvMMw7iwPWLVNsbhPcyvxj5-kIyiTKbbnGxRjjvaxC-Dvs9Y4LR_SiDkaAs3dEALw_wcB

Pour installer sans problème un jdk, je vous conseille d’utiliser https://sdkman.io/ (une fois installer il suffit de taper sdk install java). Pour que cette installation fonctionne sous w10, il va être nécessaire de faire plein de choses :

sdkman et java pour w10 : 

#. supprimer java si vous l'aviez déjà installé : paramètres > Applications > trouver java puis le désinstaller.

#. installation de sdkman : https://sdkman.io/install 

	#. avant d'installer sdkman, il faut installer zip avec scoop : :code:`scoop install zip` dans un powershell
	#. si git-bash n’est pas déjà installé (tapez git-bash dans un powershell ou dans une barre de recherche), installez le en suivant le lien dans le tuto de sdkman. Lors de l’installation, on n'a pas besoin de modifier le path de git (puisque c'est scoop qui nous a installé git).
	#. ouvrez une fenêtre git-bash et faites comme dit dans le tuto d’install de sdkman
	#. fermez la fenêtre git-bash et ouvrez en une autre.

#. modification du path. Il faut que notre java soit reconnu par windows. 
	#. - trouver où est java : tapez la commande `which java` dans le nouveau git-bash
	#. utilsez  https://www.java.com/fr/download/help/path.xml pour modifier le path. Il faut ajouter le chemin où est java. Attention, dans le monde windows on utilise de \ à la place des / :
    
		* chez moi :code:`which java` donne : /c/Users/francois/.sdkman/candidates/java/current/bin/java
		* le path que j’ai ajouté est : C:\Users\francois\.sdkman\candidates\java\current\bin

#. dans un powershell, en tapant :code:`get-command java` on doit trouver le bon.


odds & ends
===========


Un pad pour les divers copier/coller : https://outils.centrale-marseille.fr/pad/



La documentation
================

Elle a été écrite en utilisant Sphinx http://www.sphinx-doc.org.

Le format https://fr.wikipedia.org/wiki/ReStructuredText est à la fois lisible en texte brut et se transforme en différents formats (html, pdf, ...) facilement.
