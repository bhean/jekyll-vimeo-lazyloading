jekyll-vimeo-lazyloading
========================

This Jekill/Octopress plugin improves the responsiveness on page that embed many Vimeo iframe by delaying the iframe creation until the user clicks on the video.

It's based in the great jekyll-youtube-lazyloading by erossignon (https://github.com/erossignon/jekyll-youtube-lazyloading)

## How to use it 

Add a ```{% vimeo <videoid> %}``` in your markdown page

It's optional, but You can specify a width & height (in pixels) for the video:

```{% vimeo <videoid> [width] [height] %}```

And an alternative text for the link (optional too):

```{% vimeo <videoid> [width] [height] [Alternative text for the link] %}```


## Demo 
  
See [this page for a demo](https://pornohardware.com/2014/09/27-jekyll-vimeo-lazyloading-un-nuevo-plugin-para-mostrar-videos-de-vimeo-en-octopress)


## How to install it ?

1. Add ```vimeo.rb``` to your ```plugin``` folder
2. Copy ```_rve.sccs``` to ```/sass/custom```
3. Copy ```video-play-button.png``` and ```video-play-button-hover.png``` to ```/source/images```
4. Add ```@import "custom/rve"``` to  ```/sass/screen.scss```


## Credits

Thanks to [erossignon](https://github.com/erossignon) for the original plugin for Youtube.
