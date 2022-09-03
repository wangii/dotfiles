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
alias global W write 
alias global Q quit 

hook global KakBegin .* %sh{
    if [ "$TERM_PROGRAM" = "iTerm.app" ] && [ -z "$TMUX" ]; then
        echo "require-module iterm-win"
    fi

    if [ -n "$TMUX" ]; then
        echo "require-module tmux-win"
    fi
}

# hook global BufWritePre filetype=(c|cpp|objc|objcpp) %{
#     format
# }

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

	# set-option global termcmd "uxterm -e sh -c"
	set-option global termcmd "alacritty msg create-window --command sh -c"

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
plug "Ersikan/bookmarks.kak"
hook global WinCreate .* bookmarks-enable

plug "andreyorst/fzf.kak"
hook global ModuleLoaded fzf-file %{
	# set-option global fzf_file_command 'git ls-files --exclude-standard --others --cached'
	# set-option global fzf_file_command 'git ls-files'
    hook global WinCreate .* %sh{
        if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        	echo "set-option window fzf_file_command 'git ls-files'"
        fi
    }
}

set-option global windowing_modules 'x11'
plug 'delapouite/kakoune-i3' %{
      # Suggested mapping
	map global user 3 ': enter-user-mode i3<ret>' -docstring 'i3 mode'

    alias global vsp i3-new-right
    alias global sp i3-new-down
}

plug 'dgrisham/jai.kak'

## lsp
eval %sh{kak-lsp --kakoune -s $kak_session --config ~/.config/kak/kak-lsp.toml}

hook global WinSetOption filetype=(c|cpp|objc|objcpp) %{
    set window formatcmd 'clang-format13'
    lsp-enable-window
    lsp-auto-signature-help-enable
    # clang-disable-autocomplete
	lsp-auto-hover-enable
	lsp-auto-hover-insert-mode-enable
    map -docstring 'jump to counter-part file' window user c ':cpp-alternative-file<ret>'

    hook buffer BufWritePre .* %{
    	format
    }
}

hook global WinSetOption filetype=(go) %{
	set-option window formatcmd "gofmt"
    lsp-enable-window
    lsp-auto-signature-help-enable
	lsp-auto-hover-enable
	lsp-auto-hover-insert-mode-enable

    hook buffer BufWritePre .* %{
    	format
    }
}

# xmake mode
declare-user-mode xmake
define-command xmake-fn -hidden -params 1 %{
    evaluate-commands %sh{
    	pipe=/tmp/xmake.kak_p
        if [ ! -p ${pipe} ]; then
            mkfifo ${pipe}
        fi
        echo "edit -fifo ${pipe} -scroll *xmake*"
        echo "ansi-enable"
	    (eval $1>${pipe} 2>&1 &) >/dev/null 2>&1 </dev/null
    }
}

define-command xmake-clean -docstring "clean up" %{
	xmake-fn "xmake c"
}

define-command xmake-build -docstring "build" %{
    xmake-fn "xmake b -v"
}

define-command xmake-gen-json -docstring "generate compile command" %{
    xmake-fn "xmake project -k compile_commands -v"
}

map global xmake c :xmake-clean<ret> -docstring "clean"
map global xmake b :xmake-build<ret> -docstring "build"
map global xmake g :xmake-gen-json<ret> -docstring "gen compile cmds"

map global user x ':enter-user-mode xmake<ret>' -docstring 'xmake'

# kak-ansi: https://github.com/eraserhd/kak-ansi 
declare-option -hidden str kak_ansi_filter_path %sh{ dirname "$kak_source" }

declare-option -hidden range-specs ansi_color_ranges
declare-option -hidden str ansi_command_file
declare-option -hidden str ansi_filter %sh{
    filter="${kak_opt_kak_ansi_filter_path}/kak-ansi-filter"
    if ! [ -x "${filter}" ]; then
        ( cd "$filterdir" && ${CC-c99} -o kak-ansi-filter kak-ansi-filter.c )
        if ! [ -x "${filter}" ]; then
            filter=$(command -v cat)
        fi
    fi
    printf '%s' "$filter"
    #printf '~/.local/bin/kak-ansi-filter'
}

define-command \
    -docstring %{ansi-render-selection: colorize ANSI codes contained inside selection

After highlighters are added to colorize the buffer, the ANSI codes
are removed.} \
    -params 0 \
    ansi-render-selection %{
    try %{
        add-highlighter buffer/ansi ranges ansi_color_ranges
        set-option buffer ansi_color_ranges %val{timestamp}
        set-option buffer ansi_command_file %sh{mktemp}
    }
    execute-keys "|%opt{ansi_filter} -range %val{selection_desc} 2>%opt{ansi_command_file}<ret>"
    update-option buffer ansi_color_ranges
    source "%opt{ansi_command_file}"
}

define-command \
    -docstring %{ansi-render: colorize buffer by using ANSI codes  After highlighters are added to colorize the buffer, the ANSI codes are removed.} \
    -params 0 \
    ansi-render %{
    evaluate-commands -draft %{
        execute-keys '%'
        ansi-render-selection
    }
}

define-command \
    -docstring %{ansi-clear: clear highlighting for current buffer.} \
    -params 0 \
    ansi-clear %{
    set-option buffer ansi_color_ranges %val{timestamp}
}

define-command \
    -docstring %{ansi-enable: start rendering new fifo data in current buffer.} \
    -params 0 \
    ansi-enable %{
    hook -group ansi buffer BufReadFifo .* %{
        evaluate-commands -draft %{
            select "%val{hook_param}"
            ansi-render-selection
        }
    }
}

define-command \
    -docstring %{ansi-disable: stop rendering new fifo content in current buffer.} \
    -params 0 \
    ansi-disable %{
        remove-hooks buffer ansi
    }

hook -group ansi global BufCreate '\*stdin(?:-\d+)?\*' ansi-enable

# rofi
declare-user-mode rofi

define-command rofi-buffers \
-docstring 'Select an open buffer using Rofi' %{ evaluate-commands %sh{
        BUFFER=$(printf "%s\n" "${kak_buflist}" | tr " " "\n" | rofi -dmenu -font 'Consolas 18'| tr -d \')
        if [ -n "$BUFFER" ]; then
            printf "%s\n" "buffer ${BUFFER}"
        fi
}}

define-command rofi-files \
-docstring 'Select files in project using Ag and Rofi' %{nop %sh{
        FILE=$(ag -g "" | rofi -dmenu -font 'Consolas 18')
        if [ -n "$FILE" ]; then
            printf 'eval -client %%{%s} edit %%{%s}\n' "${kak_client}" "${FILE}" | kak -p "${kak_session}"
		fi
}}

map global rofi b :rofi-buffers<ret> -docstring "buffers"
map global rofi f :rofi-files<ret> -docstring "files"

map global user r ':enter-user-mode rofi<ret>' -docstring 'rofi'
