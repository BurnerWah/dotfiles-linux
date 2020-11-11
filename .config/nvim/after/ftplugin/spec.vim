" Options
setl comments=:# commentstring=#\ %s
setl fo-=t fo+=crol
let &l:textwidth = (&textwidth == 0) ? 80 : &l:textwidth
