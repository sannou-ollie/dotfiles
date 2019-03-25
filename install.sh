#/bin/bash

function editDotfiles(){
    if [ ! -e ~/local/etc/dotfiles/${fileName} ]
    then
      echo -e "\033[0;31mConf File Not Exist\033[0;39m"
      exit 1;
    fi

    local fileName=$1
    if [ -e ~/${fileName} ]
    then
       echo -e "\n# old ${fileName} add\n" >> ~/local/etc/dotfiles/${fileName}
       cat ~/${fileName} >> ~/local/etc/dotfiles/${fileName}
       mv ~/${fileName} ~/${fileName}_`date +%Y%m%d`
    fi
    ln -s ~/local/etc/dotfiles/${fileName}  ~/
}

echo -n "make install directory ~/local OK? (Y/N) : "
read anser
if [ "$anser" = 'y' ]
then
    # ベースディレクトリ作成
    mkdir -p ~/local/etc/lib
    mkdir -p ~/local/etc/source
    mkdir -p ~/local/bin
    mkdir -p ~/local/bin
    echo -e -n "created dir "
    tree ~/local -L 2
fi

# ruby用ディレクトリ作成+インストール
echo -n "install Ruby? (Y/N) : "
read anser
if [ "$anser" = 'y' ]
then
    mkdir -p ~/local/etc/lib/ruby-2.1.9
    wget -O ~/local/etc/source/ruby-2.1.9.tar.gz --no-check-certificate https://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.9.tar.gz 
    cd ~/local/etc/source/
    tar -xvf ruby-2.1.9.tar.gz > /dev/null
    cd ruby-2.1.9
    ./configure --prefix=$HOME/local/etc/lib/ruby-2.1.9/  > /dev/null
    make > /dev/null
    make install > /dev/null

    # シンボルリンクを生成
    ln -s ~/local/etc/lib/ruby-2.1.9/bin/* ~/local/bin
fi


# vim7用ディレクトリ作成+インストール
echo -n "install Vim? (Y/N) : "
read anser
if [ "$anser" = 'y' ]
then
    sudo yum install -y ncurses-devel

    cd ~/local/etc/source/
    # git clone https://github.com/vim/vim.git vim7
    wget https://ftp.nluug.nl/pub/vim/unix/vim-7.4.tar.bz2

    tar -xvf vim-7.4.tar.bz2

    cd vim74/
    mkdir -p $HOME/local/etc/lib/vim74/
    sudo ./configure \
        --prefix=$HOME/local/etc/lib/vim74/ \
        --enable-multibyte \
        --enable-tclinterp \
        --enable-pythoninterp \
        --enable-python3interp \
        --enable-rubyinterp \
        --enable-luainterp  \
        --disable-darwin \
        --disable-xsmp \
        --disable-netbeans \
        --disable-gtktest \
        --disable-gpm \
        --disable-selinux \
        --without-gnome \
        --disable-gui \
        --without-x
    make
    make install

    ln -s ~/local/etc/lib/vim74/bin/* ~/local/bin

    mkdir -p ~/.vim/bundle

    cd
    curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
    sh ./installer.sh ~/.vim/bundle/
fi


# tmux用ディレクトリ作成+インストール
echo -n "install Tmux? (Y/N) : "
read anser
if [ "$anser" = 'y' ]
then
    # libEvent install
    # cd ~/local/etc/source
    # wget -O libevent2.tar.gz "https://github.com/libevent/libevent/releases/download/release-2.0.22-stable/libevent-2.0.22-stable.tar.gz"
    # tar -xvf libevent2.tar.gz
    # cd libevent-2.0.22-stable/
    # mkdir -p ~/local/etc/lib/libevent2
    #
    # ./configure --prefix=$HOME/local/etc/lib/libevent2/
    # make
    # make install
    sudo yum install -y libevent libevent-devel

    #tmuxインストーる
    cd ~/local/etc/source
    wget -O tmux22.tar.gz "https://github.com/tmux/tmux/releases/download/2.2/tmux-2.2.tar.gz"
    tar -xvf tmux22.tar.gz 
    cd tmux-2.2/
    mkdir -p ~/local/etc/lib/tmux22

    ./configure --prefix=$HOME/local/etc/lib/tmux22/ LIBEVENT_LIBS="-L$HOME/local/etc/lib/libevent2/lib -levent" LIBEVENT_CFLAGS="-I$HOME/local/etc/lib/libevent2/include"
    make
    make install

    mkdir -p $HOME/local/lib/
    # ln -s $HOME/local/etc/lib/libevent2/lib/libevent-2.0.so.5 $HOME/local/lib/
    ln -s ~/local/etc/lib/tmux22/bin/* ~/local/bin

    # LD_LIBRARY_PATH=$HOME/local/lib/:$LD_LIBRARY_PATH
    # export LD_LIBRARY_PATH

fi


bash_profile_count=`cat ~/.bash_profile | grep 'PATH=$HOME/local/bin:$PATH' | wc -l`

if test $bash_profile_count -eq 0; then
    echo 'edited bash_profile'

    #バックアップ作成
    echo -e "\n# program add\nPATH=\$HOME/local/bin:\$PATH\nexport PATH\n" >> ~/.bash_profile
fi

# 設定ファイル作成
echo -n "Configure DotFiles? (Y/N) : "
read anser
if [ "$anser" = 'y' ]
then
    cd ~/local/etc
    git clone https://github.com/sannou-ollie/dotfiles.git

    # edit .bash_profile
    editDotfiles ".bash_profile"

    # edit .bashrc
    editDotfiles ".bashrc"

    # edit .tmux.conf
    editDotfiles ".tmux.conf"

    # edit .vimrc
    editDotfiles ".vimrc"
fi

source ~/.bash_profile
