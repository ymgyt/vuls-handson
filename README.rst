=============
vuls hands on
=============

Dependencies
============

- `docker <https://www.docker.com/>`_
- `mage <https://github.com/magefile/mage>`_


Usage
=====

prepare
-------

.. code-block:: console

   # build docker image
   $ mage docker:build

   # run container
   $ mage docker:run


vuls
----

.. code-block:: console

   # fetch cve(populate cve.sqlite3)
   $ go-cve-dictionary fetchnvd -years 2018

   # fetch oval(populate oval.sqlite3)
   $ goval-dictionary fetch-redhat 7

   # fetch gost(populate gost.sqlite3)
   $ gost fetch redhat --after 2017-01-01

   # fetch exploitdb(populate (go-exploitdb.sqlite3)
   $ go-exploitdb fetch

   # start vulsrepo server
   $ $GOPATH/src/github.com/usiusi360/vulsrepo/server/vulsrepo-server
