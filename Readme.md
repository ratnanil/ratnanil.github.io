

## Publishing notes

This site has github pages activated via the `gh-pages` branch, and a CNAME entry pointing to `www.ratnaweera.xyz` (note the `www.`). To publish the website, I need to push the content of the `_site/` folder to the `gh-pages` branch. This is automated with the `ghp-import` tool using the following command: 

```
ghp-import -n -p -c www.ratnaweera.xyz _site/
```

- `-n`: I'm not using jekyll (create `nojekyll` file)
- `-p`: push to origin
- `-c`: create CNAME


At my provider, I've created four A-Records pointing to `185.199.108.153`-`185.199.111.153` (see [these](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site#configuring-an-apex-domain) instructions). This hosts the `ratnanil.github.io` on ratnaweera.xyz (without a subdomain). I've added an additional CNAME record for the `www` subdomain (`www.ratnaweera.xyz`, see [here](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site#configuring-an-apex-domain-and-the-www-subdomain-variant)). 

To make sure that no domains can be taken over, I've verified my domains on github using [these instructions](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/verifying-your-custom-domain-for-github-pages).

PS: Unlike before, I completely omit using netlify, since this just creates additional overhead without much gain. 
