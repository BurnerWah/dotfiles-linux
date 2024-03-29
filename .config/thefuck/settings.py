# mypy: ignore-errors
# pylint: disable=C0103
"""The Fuck settings file

The rules are defined as in the example bellow:

rules = ['cd_parent', 'git_push', 'python_command', 'sudo']

The default values are as follows. Uncomment and change to fit your needs.
See https://github.com/nvbn/thefuck#settings for more information.
"""

# rules = [<const: All rules enabled>]
exclude_rules = ["yum_invalid_operation"]
require_confirmation = True
wait_command = 3
no_colors = False
debug = False
priority = {}
history_limit = None
alter_history = True
wait_slow_command = 15
slow_commands = ["lein", "react-native", "gradle", "./gradlew", "vagrant"]
env = {"LC_ALL": "C", "LANG": "C", "GIT_TRACE": "1"}
