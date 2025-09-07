FROM ubuntu
RUN apt-get update && apt-get upgrade

# core prerequisites
RUN apt-get install -y git

# nvim build requisites
RUN apt-get install -y ninja-build gettext cmake unzip curl
RUN git clone https://github.com/neovim/neovim
RUN cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo && make install

# nvim config pull
RUN git clone https://github.com/romanceOSX/init.lua.git ~/.config/nvim

CMD ["nvim"]

