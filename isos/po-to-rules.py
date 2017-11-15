#!/usr/bin/env python
# -*- encoding: utf-8 -*-
#
# Copyright (c) 2015 Jordi Mas i Hernandez <jmas@softcatala.org>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this program; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place - Suite 330,
# Boston, MA 02111-1307, USA.

import polib
import pystache
import json

from optparse import OptionParser


class Target(object):

    def __init__(self, target):
        self.target = target


class Translation(object):

    def __init__(self, source, all_targets, targets, hint):
        self.source = source
        self.all_targets = all_targets
        self.targets = targets
        self.hint = hint


# Returns a list of diccionary where the key is the msgid where you apply the
# exceptions and a list of these exceptions
def _load_exceptions(filename):
    if filename is None:
        return None

    with open(filename) as json_data:
        data = json.load(json_data)

    return data

def read_po_file(filename, exceptions):
    input_po = polib.pofile(filename)
    translations = []

    for entry in input_po:
        if entry.translated() is False:
            continue

        hint = None
        valid = None
        if exceptions is not None:
            actions = exceptions.get(entry.msgid)
            if actions is not None:
                if actions.get('ignore') == 'yes':
                    continue

                hint = actions.get('hint')
                valid = actions.get('valid')

        msgid = entry.msgid
        for source in msgid.split(';'):
            targets = []
            msgstr = entry.msgstr.replace(',', ';')
            for target in msgstr.split(';'):
                targets.append(Target(target.strip()))

            if valid is not None:
                targets.append(Target(valid.strip()))

            translation = Translation(source.strip(), entry.msgstr, targets, hint)
            translations.append(translation)

    return translations


def process_template(template, filename, ctx):
    template = open(template, 'r').read()
    parsed = pystache.Renderer()
    s = parsed.render(unicode(template, "utf-8"), ctx)

    f = open(filename, 'w')
    f.write(s.encode("utf-8"))
    f.close()


def read_parameters():
    parser = OptionParser()

    parser.add_option("-i", "--input",
                      action="store", type="string", dest="input",
                      help="Input PO file")

    parser.add_option("-t", "--template",
                      action="store", type="string", dest="template",
                      help="Mustache template")

    parser.add_option("-e", "--exceptions",
                      action="store", type="string", dest="exceptions",
                      help="Exceptions file")

    parser.add_option("-o", "--output",
                      action="store", type="string", dest="output",
                      help="Directory to find the TMX files")

    (options, args) = parser.parse_args()

    if options.input is None or options.template is None \
       or options.output is None:
        parser.error('You need to provide input, template and output files')

    return (options.input, options.template, options.exceptions, options.output)


def main():

    print "Converts a PO file into a Pology rules file"

    _input, template, exceptions, output = read_parameters()

    exception_data = _load_exceptions(exceptions)

    translations = read_po_file(_input, exception_data)

    ctx = {
        'rules': translations,
    }

    process_template(template, output, ctx)

if __name__ == "__main__":
    main()
