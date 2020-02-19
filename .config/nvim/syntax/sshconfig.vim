" Fix spelling issues
syn match sshconfigComment '^#.*$' contains=sshconfigTodo,@Spell
syn match sshconfigComment '\s#.*$' contains=sshconfigTodo,@Spell
