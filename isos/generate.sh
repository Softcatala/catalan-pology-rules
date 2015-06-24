#!/bin/bash
./po-to-rules.py -i iso_639-3.57.ca.po -t iso_639.mustache -e iso_639-exceptions.json -o ../iso_639.rules
./po-to-rules.py -i iso_3166-3.57.ca.po -t iso_3166.mustache -o ../iso_3166.rules
