" If neovim-gtk is used
if exists('g:GtkGuiLoaded')
    " Ligatures only work on Linux
    call rpcnotify(1, 'Gui', 'Font', 'Fira Code 11')
    call rpcnotify(1, 'Gui', 'Option', 'Tabline', 0)
else
    GuiTabline 0
    GuiPopupmenu 0
    " On windows it is important to install the 'ttf' font
    "GuiFont! Fira Code:h11
    GuiFont! Source Code Pro:h11
endif
