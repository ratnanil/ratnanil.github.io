

## Publishing notes

This site has github pages activated via the `gh-pages` branch, and a CNAME entry pointing to `www.ratnaweera.xyz` (note the `www.`). To publish the website, I need to push the content of the `_site/` folder to the `gh-pages` branch. This is automated with the `quarto publish` tool using the following command: 

```
quarto publish gh-pages --no-prompt
```

At my provider, I've created four A-Records pointing to `185.199.108.153`-`185.199.111.153` (see [these](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site#configuring-an-apex-domain) instructions). This redirects EVERYTHING from `ratnanil.github.io` to `ratnaweera.xyz` (including pages of other repos that I'm the owner of). I've added an additional CNAME record for the `www` subdomain (`www.ratnaweera.xyz`, see [here](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site#configuring-an-apex-domain-and-the-www-subdomain-variant)). 

To make sure that no domains can be taken over, I've verified my domains on github using [these instructions](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/verifying-your-custom-domain-for-github-pages).

PS: Unlike before, I completely omit using netlify, since this just creates additional overhead without much gain. 


## Preview images

All preview images should have an aspect ratio of 3:2 (width:height). When working with `ggplot2`, 15cm x 10cm is usually fine.

## Large Files 

I've had too many repos that have become huge because I thoughlessly committed large files. Using `git lfs` as a workaround was not very satisfactory either, since it's not easy to free up the quota of `git lsf` my simply deleting files from the history (you have to delete the whole repo intead!). I'm still looking into this, I think good practice for now would be to simply put all large files in subdirectories containing a `.gitingore` file containing a `*`.


&#114;&#97;&#116;&#97;&#114;&#104;&#97;&#119;.&#99;&#104;
