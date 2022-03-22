Set-Alias -Name autopep8 -Value autopep8-3
Set-Alias -Name ls -Value exa
# Set-Alias -Name ls -Value Get-ChildItem
Set-Alias -Name vi -Value nvim
Set-Alias -Name vim -Value nvim

Function la {exa --color=auto --color-scale --classify --long --all}
# Function la {Get-ChildItem -Force}

Invoke-Expression (& {
  $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
  (zoxide init --hook $hook powershell | Out-String)
})

Invoke-Expression "$(thefuck --alias)"

Import-Module posh-sshell

Invoke-Expression (&starship init powershell)
