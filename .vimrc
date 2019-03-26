" ----------------------------エンコード設定----------------------------
" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif

" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif
" ----------------------------エンコード設定----------------------------

" 設定値（プラグイン関係)
set title
set showmode
set ruler
set laststatus=2
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%5p%%
set number

set cindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

"タブ、空白、改行の可視化
set list
set listchars=tab:>.,trail:_,extends:>,precedes:<

"全角スペースをハイライト表示
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
endfunction

if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme       * call ZenkakuSpace()
        autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
    augroup END
    call ZenkakuSpace()
endif

nmap <C-_> <Plug>(caw:i:toggle)
vmap <C-_> <Plug>(caw:i:toggle)

nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sw <C-w>w
nnoremap sn gt
nnoremap sp gT
nnoremap st :<C-u>tabnew<CR>

" 検索を現在位置に
nnoremap * *nN

" 範囲 * 検索
vnoremap * "zy:let @/ = @z<CR>nN

nnoremap <silent> cy ce<C-r>0<ESC>
vnoremap <silent> cy c<C-r>0<ESC>
vnoremap <silent> ciy ciw<C-r>0<ESC>
vnoremap > >gv
vnoremap < <gv

set runtimepath+=~/.vim/bundle/qfixapp/

let QFixWin_EnableMode = 1
let QFix_UseLocationList = 1
"Grepコマンドのキーマップ
let MyGrep_Key  = 'g'
"Grepコマンドの2ストローク目キーマップ無し
let MyGrep_KeyB = ''

"ctags関連設定
"let g:vim_tags_project_tags_command = "ctags -R -f ~/.vt_locations /var/www/projectpp2/server/pp/server/v1/ 2>/dev/null"
" let g:vim_tags_cache_dir = expand($HOME)
" au BufNewFile,BufRead *.php set tags+=$HOME/.vt_locations
set tags+=$HOME/.vt_locations
nnoremap <C-h> :vsp<CR> :exe("tjump ".expand('<cword>'))<CR>
nnoremap <C-k> :split<CR> :exe("tjump ".expand('<cword>'))<CR>

augroup PHP
  autocmd!
  autocmd FileType php set makeprg=php\ -l\ %
  " php -lの構文チェックでエラーがなければ「No syntax errors」の一行だけ出力される
  autocmd BufWritePost *.php make | if len(getqflist()) != 1 | copen | else | cclose | endif
augroup END


"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/home/ec2-user/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/home/ec2-user/.cache/dein')
  call dein#begin('/home/ec2-user/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('/home/ec2-user/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here like this:
  "call dein#add('Shougo/neosnippet.vim')
  "call dein#add('Shougo/neosnippet-snippets')
  call dein#add('scrooloose/nerdtree')
  map <silent><C-n> :NERDTreeToggle<CR>

  call dein#add('osyo-manga/vim-anzu')
  call dein#add('ctrlpvim/ctrlp.vim')
  " call dein#add('Shougo/unite.vim')
  " call dein#add('Shougo/neomru.vim')

  call dein#add('tpope/vim-abolish')
  call dein#add('tyru/caw.vim.git')
  " call dein#add('Align')
  call dein#add('vim-scripts/Align')
  " NeoBundle 'haya14busa/vim-easymotion'
  " NeoBundle 'soramugi/auto-ctags.vim'
  call dein#add('mattn/emmet-vim')
  " call dein#add('kana/vim-submode')
  " call dein#add('surround.vim')
  call dein#add('vim-scripts/surround.vim')
  " call dein#add('sudo.vim')
  call dein#add('tomasr/molokai')
  " call dein#add('szw/vim-tags')
  "
  call dein#add('Shougo/unite.vim')
  call dein#add('Shougo/vimfiler.vim')

  "vim-submode設定
  "call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
  "call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
  "call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>+')
  "call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>-')
  "call submode#map('winsize', 'n', '', '>', '<C-w>>')
  "call submode#map('winsize', 'n', '', '<', '<C-w><')
  "call submode#map('winsize', 'n', '', '+', '<C-w>+')
  "call submode#map('winsize', 'n', '', '-', '<C-w>-')

  " vim-anzu 設定
  nmap n <Plug>(anzu-n)
  nmap N <Plug>(anzu-N)
  nmap * <Plug>(anzu-star)
  nmap # <Plug>(anzu-sharp)

  "map <C-n> :NERDTreeToggle<CR>
  "map <silent><C-n> :NERDTreeToggle<CR>
  "nmap <C-n>VimFilerBufferDir -split -winwidth=35 -toggle -no-quit<CR>


  " command noh noh<Plug>(anzu-clear-search-status)
  " set statusline=%{anzu#search_status()}
  " %<%f = ファイル名ロング表示
  " %m   = 変更フラグ表示  [+]
  " %r   = ReadOnly 表示   [RO]
  " %h   = Help 表示       [help]
  " %w   = Preview 表示    [Preview]
  " %{   = グループ化
  " %=   = 右寄せ
  " %l   = LineNumber
  " %c   = Column number
  "
  set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%5p%%%{'['.anzu#search_status().']'}

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------


colorscheme molokai
" 文字色関係設定
set t_Co=256
syntax on
set hlsearch

" backspaceで文字削除
set backspace=indent,eol,start
