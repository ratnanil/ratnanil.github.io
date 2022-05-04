

## Publishing notes

This site has github pages activated via the `gh-pages` branch, and a CNAME entry pointing to 
`nils.ratnaweera.net`. I completely omit using netlify, since this just creates additional overhead without much gain. To publish the website, I need to push the content of the `_site/` folder to the `gh-pages` branch. This is automated with the `ghp-import` tool using the following command: 

```
ghp-import -n -p _site/
```