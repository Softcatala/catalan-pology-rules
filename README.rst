.. image:: https://travis-ci.org/Softcatala/catalan-pology-rules.svg
    :target: https://travis-ci.org/Softcatala/catalan-pology-rules

Introduction
============

This repository collects all the Pology rules developed by Softcatalà.

This repository is intended to facilitate the development of new rules.

Once the new rules are completed they will be contributed to upstream (Pology project).

Generating rules from PO files
==============================

We created a Python application to systematize the creation of rules from PO files with the intention to generate rules that help to make the translation of ISO standards consistant (languages names, currencies, etc).

The po-to-rules.py works like this:

* Takes as input a PO file
* Allows optionally to provide some exceptions (e.g. iso_639-exceptions.json)
* Uses a mustache template to generate a Pology rules file (e.g. iso_639.mustache)

Example:

  po-to-rules.py -i iso_639-3.59.ca.po -t iso_639.mustache -e iso_639-exceptions.json -o iso_639.rules

Continuous integration experiment
=================================

For every rule file there is a:

* rule-file-correct.po -> when pology runs the rule against this file no errors are expected
* rule-file-incorrect.po -> when pology runs the rule against this file all the strings are expected to return error

Contact Information
===================

Jordi Mas: jmas@softcatala.org
