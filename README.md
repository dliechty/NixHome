# NixHome
 Manage various dotfiles and home dir scripts. Primarily contains settings for bash, vim, and tmux, but also contains some expect scripting used to log into AWS resources.

## Notes

* Everything maintained in this repo is linked to the git repo using this tutorial: [Managing Dotfiles](https://www.atlassian.com/git/tutorials/dotfiles)
* The .vimrc file contains references to plugins that must be installed. The instructions are as follows:

    1. From your home directory, run: `curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`
    1. Open vim and run `:PlugInstall`
    1. Make sure cmake and python headers are installed by running: `sudo apt install cmake python3-dev`
    1. From your home directory, run: `./.vim/plugged/YouCompleteMe/install.py`
* This setup uses **powerline**. Here is a reference for how to install it on WSL (on Windows 10): [Powerline Install](https://www.ricalo.com/blog/install-powerline-ubuntu/#)
* Requires Python 3 as a dependency
* Some vim setting are server dependent... for example, all plugins are only initialized for a specific set of hostnames that must be defined. The list of valid servers are defined in `~/.vim/.valid_hosts`.
* The aws scripts in `~/bin` rely on `expect`. To install, just run `sudo apt install expect`.
    * Additionally, these scripts expect credentials to be found at `~/.secrets/logindata`. The file should contain two lines- the first line with your username and the second line with your password.
