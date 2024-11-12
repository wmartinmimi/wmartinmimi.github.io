# How to use

Also accessed with ```relative path```

## Template

Template for server available at [https://github.com/wmartinmimi/md.html-template](https://github.com/wmartinmimi/md.html-template).

Just put your README.md and other .md in.

## Quick deploy

In your server root:

```bash
curl https://raw.githubusercontent.com/wmartinmimi/md.html/main/md.html -o index.html
```

Done!

### Important

If your server automatically convert markdowns to htmls and deletes markdowns,
you may need to disable the function.

## How to access

If you placed ```md.html``` as ```index.html``` in your server root:

1. Open ```<insert domain here>``` in browser
2. Done!

If you want to access other markdown files than index.md or README.md,
there are 2 options:

- Add links to them in index.md/README.md
- ```<insert domain>/index.html?path=<absolute path to md>```

Example:

- [https://wmartinmimi.github.io/md.html](https://wmartinmimi.github.io/md.html)

