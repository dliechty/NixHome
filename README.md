# NixHome
 Manage various dotfiles and home dir scripts. Primarily contains settings for bash, vim, and tmux.

## Notes

* Everything maintained in this repo is expected to be symlinked to its appropriate location.
    * The .ssh folder **contents** should be symlinked and not the folder itself
    * The bin directory can be symlinked in its entirety unless there are other scripts that must co-exist with the contents
* The .vimrc file contains references to plugins that must be installed. The instructions are as follows:

    1. From your home directory, run: `curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`
    1. Open vim and run `:PlugInstall`
    1. Make sure cmake and python headers are installed by running: `sudo apt install cmake python3-dev`
    1. From your home directory, run: `./.vim/plugged/YouCompleteMe/install.py`
* This setup uses **powerline**. Here is a reference for how to install it on WSL (on Windows 10): [Powerline Install](https://devpro.media/install-powerline-windows)
* Requires Python 3 as a dependency
* Some vim setting are server dependent... for example, all plugins are only initialized for a specific set of hostnames that must be defined. The list of valid servers are defined in `~/.vim/.valid_hosts`.
