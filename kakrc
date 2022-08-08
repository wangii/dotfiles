
# 
colorscheme zenburn
# colorscheme github

# change status bar to top
set-option global ui_options ncurses_status_on_top=yes ncurses_assistant=none ncurses_enable_mouse=yes

set-option global tabstop 4
set-option global indentwidth 4

# change user mode leader key to space
map global normal , <space>
map global normal <space> ,

map -docstring "comment a line" global user / ':comment-line<ret>'
map -docstring "fzf" global user t ':fzf-mode<ret>'

# vim old habits
map global normal D '<a-l>d' -docstring 'delete to end of line'
map global normal = :format<ret> -docstring 'format buffer'

hook global KakBegin .* %sh{
    if [ "$TERM_PROGRAM" = "iTerm.app" ] && [ -z "$TMUX" ]; then
        echo "require-module iterm-win"
    fi

    if [ -n "$TMUX" ]; then
        echo "require-module tmux-win"
    fi
}

provide-module tmux-win %{
    # for tmux
    # screen/pane management
    define-command vsp 'tmux-terminal-horizontal kak -c %val{session}'
    define-command hsp 'tmux-terminal-vertical kak -c %val{session}'
    define-command tmux-select-pane -params 1.. %{
        evaluate-commands %sh{
            TMUX="${kak_client_env_TMUX}" tmux select-pane "$@" > /dev/null
        }
    }

    map global user h ':tmux-select-pane -L<ret>'
    map global user l ':tmux-select-pane -R<ret>'
    map global user k ':tmux-select-pane -U<ret>'
    map global user j ':tmux-select-pane -D<ret>'

    define-command term 'tmux-repl-vertical fish'
}

provide-module iterm-win %{
    # for iterm:
    define-command vsp 'iterm-terminal-vertical kak -c %val{session}'
    define-command sp 'iterm-terminal-horizontal kak -c %val{session}'
    define-command term 'iterm-terminal-horizontal fish'
}

# tab to completions
hook global WinCreate .* %{

	set-option global termcmd 'uxterm -fa MonoSpace -fs 13 -e sh -c'

	# use spc+/ to toggle comment
    hook window InsertCompletionShow .* %{
            map window insert <tab> <c-n>
            map window insert <s-tab> <c-p>
    }

    hook window InsertCompletionHide .* %{
            unmap window insert <tab> <c-n>
            unmap window insert <s-tab> <c-p>
    }
}

# plugins
source "%val{config}/plugins/plug.kak/rc/plug.kak"
plug "andreyorst/plug.kak" noload

plug "andreyorst/fzf.kak"
hook global ModuleLoaded fzf-file %{
	set-option global fzf_file_command 'git ls-files --exclude-standard --others --cached'
	# declare-option str fzf_file_command 'git ls-files --exclude-standard --others --cached'
}

set-option global windowing_modules 'x11'
plug 'delapouite/kakoune-i3' %{
      # Suggested mapping
	map global user 3 ': enter-user-mode i3<ret>' -docstring 'i3 mode'

    alias global vsp i3-new-right
    alias global sp i3-new-down
}

## lsp
eval %sh{kak-lsp --kakoune -s $kak_session --config ~/.config/kak/kak-lsp.toml}

hook global WinSetOption filetype=(c|cpp|objc|objcpp) %{
    set window formatcmd 'clang-format13'
    lsp-enable-window
    lsp-auto-signature-help-enable
    clang-disable-autocomplete
	lsp-auto-hover-enable
	lsp-auto-hover-insert-mode-enable
    map -docstring 'jump to counter-part file' window user c ':cpp-alternative-file<ret>' 
}

hook global WinSetOption filetype=(go) %{
	set-option window formatcmd "gofmt"
    lsp-enable-window
    lsp-auto-signature-help-enable
	lsp-auto-hover-enable
	lsp-auto-hover-insert-mode-enable
}
