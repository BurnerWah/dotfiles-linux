" Copyright (c) 2017 Brandon Siders
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in all
" copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
" SOFTWARE.

let g:airline#themes#quantum#palette = {}

function! airline#themes#quantum#refresh()
  let g:airline#themes#quantum#palette.accents = {
        \ 'red': airline#themes#get_highlight('Identifier'),
        \ }

  let s:N1 = airline#themes#get_highlight2(['CursorLine', 'bg'], ['Directory', 'fg'], 'bold')
  let s:N2 = airline#themes#get_highlight('Pmenu')
  let s:N3 = airline#themes#get_highlight('TabLine')
  let g:airline#themes#quantum#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)

  let group = airline#themes#get_highlight('Type')
  let g:airline#themes#quantum#palette.normal_modified = {
        \ 'airline_c': [ group[0], '', group[2], '', '' ]
        \ }

  let s:I1 = airline#themes#get_highlight2(['CursorLine', 'bg'], ['MoreMsg', 'fg'], 'bold')
  let g:airline#themes#quantum#palette.insert = airline#themes#generate_color_map(s:I1, s:N2, s:N3)
  let g:airline#themes#quantum#palette.insert_modified = g:airline#themes#quantum#palette.normal_modified

  let s:R1 = airline#themes#get_highlight2(['CursorLine', 'bg'], ['Error', 'fg'], 'bold')
  let g:airline#themes#quantum#palette.replace = airline#themes#generate_color_map(s:R1, s:N2, s:N3)
  let g:airline#themes#quantum#palette.replace_modified = g:airline#themes#quantum#palette.normal_modified

  let s:V1 = airline#themes#get_highlight2(['CursorLine', 'bg'], ['Statement', 'fg'], 'bold')
  let g:airline#themes#quantum#palette.visual = airline#themes#generate_color_map(s:V1, s:N2, s:N3)
  let g:airline#themes#quantum#palette.visual_modified = g:airline#themes#quantum#palette.normal_modified

  let s:IA = airline#themes#get_highlight2(['NonText', 'fg'], ['CursorLine', 'bg'])
  let g:airline#themes#quantum#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
  let g:airline#themes#quantum#palette.inactive_modified = g:airline#themes#quantum#palette.normal_modified
endfun

call airline#themes#quantum#refresh()
