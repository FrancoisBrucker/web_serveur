*******************
Premier projet html
*******************

.. todo:: écrire Premier projet html. 1er cours de 2019-2020.
.. todo:: ajout des tutos git/ssh. pour créer sa clé, la mettre sur gihub etc

tbd

- clé ssh
- ovh
- git config
- git init
- push (avec avant un -u pour initialiser le tout)
- vim pour un commit
- un pull avant push en ajoutant un readme dans github
- un merge en modifiant deux trucs (un clone autre part dabord)


utilisation git
---------------     

On utilisera git comme gestionnaire de source. quelques liens utiles :

* initialisation de git/github : https://kbroman.org/github_tutorial/pages/first_time.html (faites tout sauf le lien avec l'éditeur de texte, que vous pourrez faire depuis là :  https://help.github.com/en/articles/associating-text-editors-with-git )
* Si ce n'est pas encore fait créez vous une paire de clés ssh et ajoutez la clé public à votre compte github : https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/


* utilisation de github :
    * `créer/cloner un dépot <https://git-scm.com/book/fr/v2/Les-bases-de-Git-D%C3%A9marrer-un-d%C3%A9p%C3%B4t-Git>`_: 
    * Créez un nouveau projet sur github https://help.github.com/articles/creating-a-new-repository/
    * ajouter le projet github nouvellement créer à notre projet git :  https://help.github.com/articles/adding-an-existing-project-to-github-using-the-command-line/


Bouquin généraux : 
    * http://www-cs-students.stanford.edu/~blynn/gitmagic/intl/fr/
    * https://fr.wikibooks.org/wiki/Git/Principes
    * https://git-scm.com/book/fr/v2


Apparté pour github
===================

On a un premier site qui fonctionne. Il n'a qu'un fichier mais il marche. On peut donc créer un repository git, puis crer un repository central sur github. Ceci nous permettra de facilement partager le code et de mettre en production très facilement (c'est devops de partout).

projet git
----------

On commence par se placer à la racine du site avec votre terminal/powershell, puis :

 .. code-block:: sh

    git init


On peut voir l'état dans le quel est notre projet :

.. code-block:: sh

   git status


qui devrait rendre :

.. code-block:: sh

    On branch master

    No commits yet

    Untracked files:
    (use "git add <file>..." to include in what will be committed)

    index.html

    nothing added to commit but untracked files present (use "git add" to track)


On peut donc sauvegarder notre premier commit :

.. code-block:: sh

    git add index.html
    git commit -m "first commit"

github
------

Pour facilement mettre un projet en production et avoir un projet de référence, on va mettre le code sur https://github.com/

Ceci participe de l'adage : "ce qui se fait souvent doit se faire rapidement", ici la mise en production.

* Si ce n'est pas encore fait créez vous une paire de clés ssh et ajoutez la clé public à votre compte github : https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/
* Créez un nouveau projet sur github https://help.github.com/articles/creating-a-new-repository/
* ajouter le projet github nouvellement créer à notre projet git :  https://help.github.com/articles/adding-an-existing-project-to-github-using-the-command-line/

Par exemple, chez moi après avoir ajouté la ligne :

.. code-block:: sh

    git remote add origin git@github.com:FrancoisBrucker/test_cours.git

Mon fichier de conf `.git/config`  ressemble à :

.. code-block:: sh

  [core]
      repositoryformatversion = 0
      filemode = true
      bare = false
      logallrefupdates = true
      ignorecase = true
      precomposeunicode = true
  [remote "origin"]
      url = git@github.com:FrancoisBrucker/test_cours.git
      fetch = +refs/heads/*:refs/remotes/origin/*


On peut maintnenant envoyer le projet sur github :
.. code-block:: sh

  git push origin master


Voyez le résultat sur votre compte github.

Github vous demande de rajouter un fichier README.md pour décrire ce qu'est NOTRE PROJET ! Faisons le directement sur le site (.md est pour markdown, un façon sympathique d'écrire du texte : https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)

On en profitera alors également pour ajouter :

    * un fichier de license :  https://help.github.com/articles/adding-a-license-to-a-repository/ J'ai une petite préférence pour la license IV ou la WTFPL (https://github.com/jslicense/WTFPL ) mais à vous de voir
    * un fichier .gitignore . Vous pouvez le laisser pour l'instant, ou choisir un template. Les utilisateurs de mac peuvent cepndant dés à présent y ajouter la ligne .DS_Store


Notre programme diffère maintenant entre ce qui est sur github et sur notre machine. On va récupérer le tout :
.. code-block:: sh

  git pull origin master


.. note::  ?? comment conaitre les différences entre les 2 ??


ovh
---

La dernière pointe du triangle va être de mettre NOTRE PROJET ! sur le server ovh.

On commence par se connecter sur le serveur ovh  :

.. code-block:: sh

    ssh raifort@ovh1.ec-m.fr


Puis on va cloner le projet de github sur notre page web.

.. code-block:: sh

    cd www
    git clone https://github.com/FrancoisBrucker/test_cours


Comme vous pouvez le remarquer dans le fichier de config, l'origin est placée directement.

Tout est maintenant visible à l'adresse : http://raifort.ovh1.ec-m.fr/test_cours/

Lorsque l'on voudra mettre à jour le site, il suffira de faire un :

.. code-block:: sh

  git pull origin master

Ou de créer un script que le fera de façon automatique, sans même avoir à se logger sur la machine distante.

