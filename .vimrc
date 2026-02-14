" Quartz local Vim config (terminal Vim/Neovim)
set nocompatible
filetype plugin indent on
syntax on

if has("termguicolors")
  set termguicolors
endif
set background=dark

" QoL mappings aligned with your Obsidian vim habits
nnoremap j gj
nnoremap k gk
nnoremap <F9> :nohlsearch<CR>
nnoremap <Space>j J

if has("clipboard")
  set clipboard=unnamed,unnamedplus
endif

" Load local dashboard.
let s:quartz_root = expand("<sfile>:p:h")
if filereadable(s:quartz_root . "/.vim/quartz-dashboard.vim")
  execute "source " . fnameescape(s:quartz_root . "/.vim/quartz-dashboard.vim")
endif

