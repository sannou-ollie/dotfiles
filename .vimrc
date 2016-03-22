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

if !1 | finish | endif

if has('vim_starting')
    if &compatible
        set nocompatible               " Be iMproved
    endif
    " Required:
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!

call neobundle#end()

 " Required:
filetype plugin indent on

" NeoBundle 'Shougo/unite.vim'
" NeoBundle 'Shougo/vimproc'
NeoBundle "osyo-manga/vim-anzu"
NeoBundle "ctrlpvim/ctrlp.vim"
NeoBundle "tyru/caw.vim.git"
NeoBundle 'Align'
" NeoBundle 'haya14busa/vim-easymotion'
" NeoBundle 'soramugi/auto-ctags.vim'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'kana/vim-submode'
NeoBundle 'surround.vim'
NeoBundle 'sudo.vim'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'tomasr/molokai'

" 文字色関係設定
set t_Co=256

syntax enable
colorscheme molokai

"vim-submode設定
call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>+')
call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>-')
call submode#map('winsize', 'n', '', '>', '<C-w>>')
call submode#map('winsize', 'n', '', '<', '<C-w><')
call submode#map('winsize', 'n', '', '+', '<C-w>+')
call submode#map('winsize', 'n', '', '-', '<C-w>-')

" vim-anzu 設定
nmap n <Plug>(anzu-n)
nmap N <Plug>(anzu-N)
nmap * <Plug>(anzu-star)
nmap # <Plug>(anzu-sharp)

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

" let g:auto_ctags = 1

" nmap s <Plug>(easymotion-s2)
" xmap s <Plug>(easymotion-s2)

" NeoBundle 'vim-visualstar'

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
