# Ramblings of a demented sysadmin

## [Powerline]()

[Powerline]() is a status line plugin for `vim`, and provides status line and prompts for several other applications, including `zsh`, `bash`, `tmux`, IPython, Awesome and Qtile.

- `powerline.sh` --- configure powerline for `bash`, `vim` and `tmux` with fixes for `SSH_AUTH_SOCK` for `tmux`

### Usage

1. Edit `~/.bashrc`.
    ```bash
    vim ~/.vimrc
    ```
0. Add the script.
    ```bash
    source powerline.sh
    ```

To update/overwrite configuration for `bash`, `vim` and `tmux` run

```bash
POWERLINE_OVERWRITE=1 source .bashrc
```


## Hyperthreding

- `ht.sh` - turn off and on hyperthreading

###### vim: spell spelllang=en ts=2 st=2 et ai:

[Powerline]: https://github.com/powerline/powerline
