if [ (readlink (command -s gpg)) = gpg ]
    complete -c gpg2 -w gpg
else
    __fish_complete_gpg gpg2
end
