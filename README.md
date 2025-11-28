# exposeHighlight

Small macOS tweak that changes the color of the window hover border in Mission Control
Inspired by [DockExposeHighlight](https://github.com/w0lfschild/DockExposeHighlight) but works on macOS 15, 26, and maybe some other older versions

### Installation (easy / automatic)
[Disable SIP and set nvram](https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection)

Find some sort of injector (I will find some soon), and load it at login, and whenever the Dock restarts.

### Uninstallation
Depends on your form of installation, hope that you're a nerd already because I'm not the best at integrating everything

### Building
Build the target, "exposeHighlight" exposeHighlight.dylib is now ready to be used with some sort of loader (I will find one soon).

### Changing Color
`defaults write com.apple.dock expose-highlight "#rrggbbaa"`
or
`defaults write com.apple.dock expose-highlight "#rrggbb"`

The window highlight color will update immidiately, but the spaces bar outline will require `killall Dock`

### Is this safe???
Define safe. By apple's standards, no.
If something goes wrong, [restart in safe mode](https://support.apple.com/guide/mac-help/start-up-your-mac-in-safe-mode-mh21245/mac) and delete the files or loader

### Why?
Because the macos mission control highlight doesn't care whatever color you choose, but always wants system blue.

### Other info
This project makes use of [Frida](https://frida.re) for function swapping.
Also uses [ZKSwizzle](https://github.com/alexzielenski/ZKSwizzle) (MIT License)
