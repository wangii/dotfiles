# plugins
source "%val{config}/plugins/plug.kak/rc/plug.kak"

plug "andreyorst/fzf.kak"

# plug "andreyorst/powerline.kak" defer "powerline" %{
#     powerline-separator triangle
#     set-option global powerline_format 'powerline-format git bufname filetype mode_info line_column position'
#     powerline-toggle line_column off
#     powerline-theme gruvbox
# }

# change status bar to top
set-option global ui_options ncurses_status_on_top=yes ncurses_assistant=none ncurses_enable_mouse=yes

# change user mode leader key to space
map global normal , <space>
map global normal <space> ,

# 
colorscheme zenburn
set-option global tabstop 4
set-option global indentwidth 4

map -docstring "comment a line" global user / ':comment-line<ret>'
map -docstring "fzf" global user t ':fzf-mode<ret>'

# vim old habits
map global normal D '<a-l>d' -docstring 'delete to end of line'
map global normal = :format<ret> -docstring 'format buffer'

## lsp
eval %sh{kak-lsp --kakoune -s $kak_session --config ~/.config/kak/kak-lsp/kak-lsp.toml}

hook global WinSetOption filetype=(c|cpp|objc|objcpp) %[
    set window formatcmd 'clang-format'
    lsp-enable-window
    lsp-auto-signature-help-enable
    clang-disable-autocomplete
	lsp-auto-hover-enable
	lsp-auto-hover-insert-mode-enable
    map -docstring 'jump to counter-part file' window user c ':cpp-alternative-file<ret>' 
]

hook global WinSetOption filetype=(go) %[
    lsp-enable-window
    lsp-auto-signature-help-enable
	lsp-auto-hover-enable
	lsp-auto-hover-insert-mode-enable
]

# tab to completions
hook global WinCreate .* %[
    hook window InsertCompletionShow .* %{
            map window insert <tab> <c-n>
            map window insert <s-tab> <c-p>
    }

    hook window InsertCompletionHide .* %{
            unmap window insert <tab> <c-n>
            unmap window insert <s-tab> <c-p>
    }
]
