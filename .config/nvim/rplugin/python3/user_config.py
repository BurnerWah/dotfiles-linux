import gi
import pynvim

gi.require_version('Secret', '1')
from gi.repository import Secret


@pynvim.plugin
class UserConfig:
    def __init__(self, nvim):
        self.nvim = nvim
        self.schema = Secret.Schema.new(
            'io.neovim.user', Secret.SchemaFlags.NONE,
            {'nvim_id': Secret.SchemaAttributeType.STRING})

    @pynvim.autocmd('VimEnter')
    def event_vim_enter(self):
        def push_secret_to_env(id, var):
            secure = Secret.password_lookup_sync(self.schema, {'nvim_id': id},
                                                 None)
            self.nvim.command(f'let ${var} = "{secure}"')

        push_secret_to_env('coc-git-github-token', 'GITHUB_API_TOKEN')
        push_secret_to_env('coc-git-gitlab-token', 'GITLAB_PRIVATE_TOKEN')
