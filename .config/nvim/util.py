""" Provides utilities that are helpful for setting up neovim.

If something isn't accessed in here' it's probably supposed to be directly
accessed in the init.vim file, or a file that it will call.
"""

import os
from importlib.util import find_spec
from shutil import which

def has_module(module):
    return find_spec(module) is not None

def has_any_cmd(*commands):
    for command in commands:
        if which(command) is not None:
            return True

    return False
