# Introduction

This repository collects all the Pology rules developed by Softcatalà.

This repository is intended to facilitate the development of new rules.

Once the new rules are completed they will be contributed to upstream (https://invent.kde.org/sdk/pology), except for rules that are very specific to us.

# Generating rules from PO files

We created a Python application to systematize the creation of rules from PO files with the intention to generate rules that help to make the translation of ISO standards consistant (languages names, currencies, etc).

The _po-to-rules.py_ works like this:

* Takes as input a PO file
* Allows optionally to provide some exceptions (e.g. iso_639-exceptions.json)
* Uses a mustache template to generate a Pology rules file (e.g. iso_639.mustache)

Example:

  po-to-rules.py -i iso_639-3.59.ca.po -t iso_639.mustache -e iso_639-exceptions.json -o iso_639.rules

# Contact Information

Jordi Mas: jmas@softcatala.org
