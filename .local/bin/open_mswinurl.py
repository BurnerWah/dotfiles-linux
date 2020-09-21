#!/usr/bin/env python3
""" Simple parser for .url files (mime type `application/x-mswinurl`)

An older version of this used `jc` and `jq`, but this verson has fewer
dependencies so it's preferable.

There's a possibility that this doesn't actually work on every .url file, since
I do remember the old version failing on one file, but I don't think I have the
file it failed with anymore, and that may have also been caused by `jq`.

Giving this command an easy to use name is mostly irrelevant since it should be
accesed using `xdg-open`.
"""

import configparser, subprocess, sys

config = configparser.ConfigParser()
config.read(sys.argv[1])

subprocess.call(['xdg-open', config['InternetShortcut']['URL']])
