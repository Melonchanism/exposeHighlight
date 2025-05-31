# exposeHighlight

Small macOS mod that changes the color of the window hover border in Mission Control

Inspired by [DockExposeHighlight](https://github.com/w0lfschild/DockExposeHighlight) but works on macOS 15+ for now at least

### Installation (easy / automatic)
[Disable SIP and set nvram](https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection)

Find some sort of injector (I will find some soon), and load it at login, and whenever the Dock restarts.

### Uninstallation
Depends on your form of installation, hope that you're a nerd already because I'm not the best at integrating everything

### Building
Build the target, "exposeHighlight." exposeHighlight.dylib is now ready to be used with some sort of loader (I will find one soon).

### Changing Color
Until I add some way to configure it, `dockInjection.m` at line 11

### Is this safe???
Maybe. I provide no recommendation whether you should use this, as it modifies system processes and requires reduced security settings.

If something goes wrong, [restart in safe mode](https://support.apple.com/guide/mac-help/start-up-your-mac-in-safe-mode-mh21245/mac) and delete the files or loader

### Why?
macOS is stupid in the way that the mission control window hover highlight doesn't care about your accent color or anything else; it is always system blue. Currently there is no way to easily set it to follow something, but I intend on doing that. Also people who use window borders might like the mission control hover to be the same color as their window borders.

### Other info
This project makes extensive use of [Frida](https://frida.re) for function swapping.
Also uses [ZKSwizzle](https://github.com/alexzielenski/ZKSwizzle) (MIT License)

There is literally no way to debug crashes rn, I will eventually write a wrapper for frida and ZKSwizzle because I have other forks as well
