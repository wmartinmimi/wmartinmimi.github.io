# md.html

![Images](md.html_logo.png)

Convert markdown to html on the fly, client-based js pre-styled markdown viewer.

Simple and easy to deploy.

## Quick deploy

md.html pratically have a zero-config deploy!

In your server root:

```bash
curl https://raw.githubusercontent.com/wmartinmimi/md.html/main/md.html -o index.html
```

And you can now view .md files in your server!

More information on usage can be found [here](parent/howtouse.md)

## Updating

The md.html should dynamically fetch the latest required code, meaning that usually no manual intervention is required.
However, the file ```md.html``` itself would not automatically update itself and therefore requires manual intervention.
Warning to update the ```md.html``` file will be displayed in the console starting from ```v2.6```. (Error 1)

To update the ```md.html``` file, see **Quick Deploy** and follow the normal download procedure.

If you want to disable automatic update, after downloading, modifiy the following line in ```flags section```.

from:

```js
let auto_update = true;
```

to:

```js
let auto_update = false;
```

## Style

Similar to Github, with slight differences here and there.

md.html also already do latex rendering and syntax highlighting for you.

## Extra feature

- Dynamic title based on 1st `h1` heading
- Custom save function to save as markdown or styled html for offline viewing
- Correct 404 error by displaying the 404.html
- No need for modified internal links, `relative/path.md` and `/absolute/path.md` works
- Latex equations rendering

---

## Error Codes

```Error 1```

Update of ```md.html``` file required.
See **Quick deploy** to download the latest version.

## Examples

See this README.md rendered on <https://wmartinmimi.github.io/mdhtml/md.html?path=/mdhtml/README.md>

### Headings

Inline styles such as **bold**, _italic_, **_both_**, ~~strikethrough~~, `monospace`.

> Block quotes, including
>
> > nested block quotes.

```
Fenced code blocks
```

    Indented code blocks

```python
# highlighted code block
def lineequ():
  y = kx + c

lineequ()
```

```html
<!--supports multiple languages-->
<p class="lovely">helloworld</p>
```

```d
/* A wide range of different languages */

import std.stdio;

void main() {
    writeln("Hello, D!");
}
```

Latex:

$$c = \\pm\\sqrt{a^2 + b^2}$$

1. Numbered lists
2. Another entry in my numbered list.

- Unordered lists
  - Nested entry

- [x] task
- [ ] more task

| Tables | Tables | Tables |
| ------ | ------ | ------ |
| Cell 1 | Cell 2 | Cell 3 |
| Cell 4 | Cell 5 | Cell 6 |
| Cell 7 | Cell 8 | Cell 9 |

[Outside Links](https://example.com)

[absolute link](/parent/absolute.md)

[relative link](parent/howtouse.md)

bare url: <https://example.com>

Images:

![Images](md.html_logo.png)

Image in links:

[![Images](md.html_logo.png)](md.html_logo.png)

---

## Issues

Issues and pull requests are always welcome!

You can submit issues the following ways:

- via [Github Issues](https://github.com/wmartinmimi/md.html/issues)

## Contributions

You are welcomed to create pull requests and add/fix features reasonably. :>

## Credits

- [markedjs/marked](https://github.com/markedjs/marked) (MIT License)
- [KaTeX/KaTeX](https://github.com/KaTeX/KaTeX) (MIT License)
- [jquery/jquery](https://github.com/jquery/jquery) (MIT License)
- [jsdelivr/jsdelivr](https://github.com/jsdelivr/jsdelivr) (MIT License)
- [highlightjs/highlight.js](https://github.com/highlightjs/highlight.js) (BSD 3-Clause Licensed)
- [Yukaii/github-highlightjs-themes](https://github.com/Yukaii/github-highlightjs-themes) (MIT License)

