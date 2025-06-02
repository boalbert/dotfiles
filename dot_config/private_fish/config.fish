if status is-interactive
    # Abbreviations

    ## git
    abbr --add gs git status
    abbr --add gc git commit
    abbr --add gco git checkout
    abbr --add gpr git pull --rebase
    abbr --add gca git commit --amend
    abbr --add lg lazygit

    # kubernetes
    abbr --add k kubectl

    ## navigation etc
    abbr --add l ls -laF
    abbr --add cd.. cd ..
    abbr --add c clear
    abbr --add cls clear
    abbr --add repos cd ~/dev/repos
    abbr --add bra cd ~/dev/repos/brandon/
    alias sd "cd ~ && cd (find * -type d | fzf)"

    # docker
    abbr --add dc docker compose
    abbr --add dcd docker compose down
    abbr --add dcu docker compose up
    abbr --add dsa docker ps

    ## fish config
    abbr --add cfgfish chezmoi edit ~/.config/fish/config.fish
    abbr --add cfggho chezmoi edit ~/.config/ghostty/config

    ## Brandon
    abbr --add logger cd ~/dev/repos/brandon/brandon-camel-logger
    abbr --add router cd ~/dev/repos/brandon/brandon-camel-router
    abbr --add webshop cd ~/dev/repos/brandon/brandon-camel-webshop-adapter
    abbr --add common cd ~/dev/repos/brandon/brandon-common-camel
    abbr --add docs cd ~/dev/repos/brandon/int-docs
    abbr --add warehouse cd ~/dev/repos/brandon/brandon-camel-warehouse-sweden-adapter
    abbr --add jeeves cd ~/dev/repos/brandon/brandon-camel-jeeves-adapter

    ## replace cat with bat
    abbr --add cat bat

    abbr --add sourcefish source ~/.config/fish/config.fish

    # Change default location of vim config
    # set -Ux VISUAL "vim"
    # set -Ux EDITOR "vim"
    set -x VIMINIT 'source ~/.config/vim/.vimrc'

    set -gx PATH /opt/homebrew/opt/curl/bin $PATH

    # Open scratch notes in vim
    function scn
        vim +normal\ Go ~/dev/notes/scratch.txt
    end

    # Set default node version via nvm
    set -Ux nvm_default_version v22.11.0

    # Start ssh agent
    set SSH_AUTH_SOCK /var/folders/5l/5khp6mf95qqg27fcwxy3hn480000gn/T//ssh-petcZlkXvLcc/agent.7616

    # Set Zed as default editor
    set -Ux VISUAL "zed --wait"
    set -gx EDITOR "zed --wait"

    # Set up fzf key binding: https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration
    fzf --fish | source

    # Allow ctrl+x > ctrl+e to edit current command buffer
    bind \cx\ce edit_command_buffer

    # Pretty print Java project to terminal
    function java-pkg-tree
        find src -name "*.java" | \
        sed 's/\.java$//' | \
        sed 's/^src\///' | \
        sed 's/\//./g' | \
        sort | \
        awk 'BEGIN {prev=""; indent=""}{
            split($0,parts,".");
            pkg="";
            for(i=1;i<length(parts);i++) {
                pkg = pkg (i>1?".":"") parts[i];
            };
            if(pkg!=prev) {
                printf("\n%s\n", pkg);
                prev=pkg;
            };
            printf("  └── %s\n", parts[length(parts)]);
        }'
    end

end
