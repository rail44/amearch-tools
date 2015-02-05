FROM rail44/amearch

# Set mirror for building on dockerhub
RUN mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.new
RUN mv /etc/pacman.d/mirrorlist.old /etc/pacman.d/mirrorlist

# Set locale
ADD ./locale.gen /etc/locale.gen
RUN locale-gen
ADD ./locale.conf /etc/locale.conf
ENV LANG ja_JP.utf8

# Install Neovim
RUN pacman -S --noconfirm base-devel
RUN sudo aura -A --noconfirm neovim-git python2-neovim-git

# Install Byobu
RUN sudo aura -A --noconfirm byobu

# Add dotfiles and install plug-vim
RUN mkdir -p /etc/skel/.vim/autoload
RUN curl -fLo /etc/skel/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ADD ./.vimrc /etc/skel/.vimrc
RUN cd /etc/skel && ln -s .vim .nvim
RUN cd /etc/skel && ln -s .vimrc .nvimrc

# Install fish
RUN pacman -S --noconfirm fish
RUN mkdir -p /etc/skel/.config/fish
ADD ./config.fish /etc/skel/.config/fish/config.fish

# Install openssh
RUN pacman -S --noconfirm openssh

# Restore mirror
RUN mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.old
RUN mv /etc/pacman.d/mirrorlist.new /etc/pacman.d/mirrorlist
