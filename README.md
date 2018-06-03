# AppClient
the front-end dev of theYelda.

What we use:

- vue
- element-ui
- vue-resource

## Start
```
npm install
npm run serve
```
- Before serve, need to delete or comment the `/vue.config.js`, which is config for build but 

## Build
```
npm run build
```
- Drag the `/dist/fonts` to `/dist/css` after build, because of the path setting of element-ui (to cause file inferencein problems in html)


