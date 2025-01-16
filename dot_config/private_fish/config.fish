if status is-interactive
    # Abbreviations

    ## git
    abbr --add gs git status
    abbr --add gc git commit
    abbr --add gco git checkout
    abbr --add gpr git pull --rebase

    ## navigation etc
    abbr --add l ls -laF
    abbr --add cd.. cd ..
    abbr --add c clear
    abbr --add cls clear
    abbr --add repo cd ~/dev/repo

    # docker
    abbr --add dc docker compose
    abbr --add dcd docker compose down
    abbr --add dcu docker compose up
    abbr --add dsa docker ps

    ## fish config
    abbr --add cfgfish zed ~/.config/fish/config.fish
    abbr --add cfgtmux zed ~/.tmux.conf

    ## replace cat with bat
    abbr --add cat bat

    abbr --add sourcefish source ~/.config/fish/config.fish

    # Change default location of vim config
    set -Ux VISUAL "vim"
    set -Ux EDITOR "vim"
    set -x VIMINIT 'source ~/.config/vim/.vimrc'

    # Open scratch notes in vim
    function scn
        vim +normal\ Go ~/dev/notes/scratch.txt
    end

    # Set default node version via nvm
    set -Ux nvm_default_version v22.11.0

    # Adding a comment to trigger chezmoi
    # Start ssh agent
    set SSH_AUTH_SOCK /var/folders/5l/5khp6mf95qqg27fcwxy3hn480000gn/T//ssh-petcZlkXvLcc/agent.7616
end
