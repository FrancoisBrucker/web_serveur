*****************
Protocole http(s)
*****************

Back vs Front
=============

Le *back* est un serveur rendant accessible des ressources via le protocole http.

Les ressources accessibles sont principalement des pages html, mais bien d'autres choses sont possibles comme des fichiers texte, json voir même des fichiers binaire.


Un serveur est ainsi une machine accessible depuis l'internet. Pour la contacter on a besoin :
    * d'une adresse ip https://fr.wikipedia.org/wiki/Adresse_IP
    * et d'un port de communication (web 80 par défaut) http://www.linuxnix.com/important-port-numbers-linux-system-administrator/

Derrière chaque port un programme peut écouter. 65536 possibilité (au départ sûrement
bloqués par le firewall)

Pour se faciliter la tâche (un humain retient mieux des noms que des nombres), on lui associe un nom (https://fr.wikipedia.org/wiki/Domain_Name_System) et c'est lui que l'on retiendra.

Ainsi :
    * http://www.google.fr est équivalent à http://www.google.fr:80
    * sur un autre port ça risque de ne pas marcher (ex. 1337)

**Un nom particulier :** :code:`localhost` qui correspondra toujours à l'ordinateur courant (équivalent de this pour le réseau)

Tout ceci correspond à une adresse ip (l'adresse de l'ordinateur sur le réseau). Connaître l'ip peut se faire avec la commande :code:`nslookup`

.. code-block:: sh

    fbrucker$ nslookup www.google.fr
    Server:		147.94.19.254
    Address:	147.94.19.254#53

    Non-authoritative answer:
    Name:	www.google.fr
    Address: 216.58.205.99


Le contraire marche aussi :

.. code-block:: sh

    fbrucker$ nslookup 147.94.19.254
    Server:		147.94.19.254
    Address:	147.94.19.254#53

    Non-authoritative answer:
    254.19.94.147.in-addr.arpa	name = resolv.ec-m.fr.

    Authoritative answers can be found from:
    19.94.147.in-addr.arpa	nameserver = ns1.ec-marseille.fr.


**Un numéro particulier :** A quel numéro correspond :code:`localhost` ?

Lorsque l'on créera notre propre serveur, il tournera en développement toujours sur :code:`localhost` et pour ne pas interférer avec un potentiel serveur web déjà existant, on utilisera un port différent (8080 ou 3000 par exemple). On y accédera par l'url : :code:`http://localhost:8080`


.. note:: la commande :code:`dig` est également possible https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/s2-bind-dig.html


protocole http
==============

https://fr.wikipedia.org/wiki/Hypertext_Transfer_Protocol#HTTP_1.1

Il est décrit par une série de RFC, qui définissent les différents standards du net https://fr.wikipedia.org/wiki/Request_for_comments (le RFC 2026 décrit pcomment écrire une RFC).

On peut quasiment tout le temps communiquer avec un serveur via le logiciel  https://fr.wikipedia.org/wiki/Telnet qui permet d'envoyer et recevoir du texte.

Nous allons émuler un navigateur en cherchant à recevoir la page http://www.wikipedia.fr Il faut tout d'abord se connecter :
    * une adresse de serveur (nom ou ip)
    * un port (80 est le protocole http. le quel est https ?)

Une requête est divisée en plusieurs lignes :

#. type de requête
    * type de requête (:code:`GET`, :code:`PUT`, ...)
    * quoi (adresse suivant le serveur)
    * protocole : :code:`HTTP/1.1`

#. liste de méthodes séparées par des retour à la ligne. La méthode :code:`Host` est obligatoire.
#. une ligne vide signifie que l'on attend une réponse.


.. code-block:: sh

    fbrucker$ telnet www.wikipedia.fr 80
    Trying 78.109.84.114...
    Connected to www.wikipedia.fr.
    Escape character is '^]'.
    GET /index.php HTTP/1.1
    Host: www.wikipedia.fr


On vérifie sur *chrome* que c'est identique.

La réponse est composée de 2 parties :
    #. l'entête de réponse
    #. une ligne vide
    #. la réponse

Pour notre requête précédente l'entête était :

.. code-block:: sh

    HTTP/1.1 200 OK
    Date: Wed, 25 Jan 2017 07:32:39 GMT
    Server: Apache
    Vary: Accept-Encoding
    Connection: close
    Transfer-Encoding: chunked
    Content-Type: text/html

En gros :

#. protocole utilisé, status, nom du status (https://en.wikipedia.org/wiki/List_of_HTTP_status_codes ou mieux https://http.cat)
#. listes de méthodes, dont le type de réponse
#. une ligne vide
#. la réponse


Pour plus d'information sur les entêtes de réponses, on pourra lire  http://www.alsacreations.com/astuce/lire/1152-en-tetes-http.html


On vérifie avec les outils de développement de *chrome* que c'est bien la même chose :

#. on ouvre les outils de développement,
#. va sur l'onglet **network**
#. on recharge la page et on voit tout ce qui est téléchargé. Pour :code:`index.php` on voit :
    * son status (200),
    * son type (:code:`document`)
    * le temps que le téléchargement à mis

#. en cliquant sur le nom du fichier on peut accéder à son header complet.



.. note:: on voit que tout un tas d'autres fichiers ont été  téléchargés.

On pourra voir que le navigateur envoit également otut un tas d'autres informations au serveur. C'est la partie *Request Headers*. Regardez par exemple la méthdoe :code:`User-Agent` de l'entête.


Quelques variantes de réponses :

redirect
--------

.. code-block:: sh

    fbrucker$ telnet www.google.com 80
    Trying 216.58.210.196...
    Connected to www.google.com.
    Escape character is '^]'.
    GET / HTTP/1.1
    Host: www.google.com



Le statut est 302 (redirect). Regardez sur *chrome* pour voir ce qu'il s'est passé.

timer et text/plain
-------------------

.. code-block:: sh

    fbrucker$ telnet www.gutenberg.org 80
    Trying 152.19.134.47...
    Connected to gutenberg.org.
    Escape character is '^]'.
    GET /files/20262/20262-0.txt HTTP/1.1
    host: www.gutenberg.org

Attention au timer...


type binaire application/pdf
----------------------------

.. code-block:: sh

    fbrucker$ telnet www.jeuxavolonte.asso.fr 80
    Trying 213.186.33.19...
    Connected to jeuxavolonte.asso.fr.
    Escape character is '^]'.
    HEAD /regles/formula_d.pdf HTTP/1.1
    host: www.jeuxavolonte.asso.fr

On apeut télécharger ce que l'on veut. Ici on ne demande que les header et pas le contenu, car il est binaire. Type  de résulat ?


curl
----


Pour télécharger directement une ressource (html, pdf ou autre) de l'internet, on peut utiliser l'utilitaire https://en.wikipedia.org/wiki/CURL On pourra par exemple l'utiliser pour transférer votre site de votre visible au site distant.

Très simple d'utilisation, il permet cependant de faire des choses complexes. Téléchargeons la documentation :

.. code-block:: sh

    curl -#O https://www.gitbook.com/download/pdf/book/bagder/everything-curl


.. note:: A quoi correspondent les options code:`-#O`?


La suite
========

Le *front* est servi par un *back* via le protocole *http*.

On pourrait tout faire en telnet, mais plein de choses peuvent être automatisées ou rendues plus faciles. C'est le boulot des frameworks comme :
    * https://nodejs.org (petit serveur)
    * https://www.djangoproject.com (moyen serveur)
    * http://projects.spring.io/spring-framework/ (gros serveur)
