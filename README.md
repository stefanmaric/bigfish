Bigfish
=======

A long, two-lines fishshell prompt theme.

![bigfish](https://cloud.githubusercontent.com/assets/1009040/20610008/1448be08-b26a-11e6-9363-820eb279d419.gif)

I was tired of issues with patched fonts like [Powerline](https://github.com/powerline/powerline) so I crafted this prompt that relies on Unicode glyphs only.


## Install

Use [fisher](https://github.com/jorgebucaran/fisher):

```shell
fisher add stefanmaric/bigfish
```

If you are interested in manual installation, please open an issue asking for help and I will give you instructions and then update this README.


## Know the prompt

### First line, from left to right:

* In bold `blue`: Current directory, shortened a bit.
* Gear (⚙) in `magenta` if there are any background jobs.
* Git info, `green` when clean and `yellow` when dirty:
  * On top of branch (🜉), tag (⌂), or detached head (⌀) glyph.
  * Branch name, tag name, or short commit checksum.
  * Branch is behind (⭳), ahead (⭱), or diverged (🔀) from remote.
  * There is least one stash (≡).
  * There are staged changes ready for commit (±).
  * There are changes not ready for commit (dirty state) (\*).
  * There are new untracked files (…).
* Nodejs version (⬡) in `cyan` if there's a `package.json` file around.
* Vagrant glyph (🇻) in `purple` if you can run `vagrant` commands.


* Last command duration.
* Time when last command returned control to the shell.
* Last command error code in `red` if any.

### Second line, from left to right

* Regular user (•) in `gray` or root user (⌁) in `red`,


## Contribute

Just open a Pull Request


## License

MIT ♥ — See [LICENSE](./LICENSE)
