# Figma API Wrapper for Framer - Work in progress

![Importing Figma artwork in Framer. Images on this prototype were requested using the new Figma API.](https://user-images.githubusercontent.com/76307/37884359-9d48eb8c-307d-11e8-9b3f-2c87b52e7789.gif)

### Documentation
Purpose: This demo aims to show how to fetch content from a Figma File.

# API Methods (Demo WIP)

- `requestFigmaFile` this will fetch all the Canvas objects from the file url & loop to get the IDs for each Canvas. 

- `requestFigmaImage` this function will fetch an image from a canvas ID.

- `addToFigmaImageObject` (WIP) this function will append the response from requestFigmaImage() and it will create a new Figma Image Layer.

- `loadImageFromFigmaCDN` (WIP) this function will create a new Figma Image Layer and it will preload the image into the session cache.

- `setImageInFigmaImageLayer` (WIP) this function include the image into the already created Figma Image Layer and it will push the Image Layer into the Page Component.

### Configuration

1. Open the secret.coffee in /modules and add your own Figma Personal Token

```coffeescript
exports.token = 'ai3-57wg5gbhe9-cspl-gclno-deheq-1qfrpxq6ax7x'
exports.fileurl = 'https://www.figma.com/file/FileKey/YourFile'
```

## For more documentation

- [Figma Web API](https://www.figma.com/developers)

- [Figma API Documentation](https://www.figma.com/developers/docs)

- [Figma API Global Props](https://www.figma.com/developers/docs#global-properties)

## Todo

* [ ] Create API Wrapper Module.
* [ ] Fetch GET single `file` from URL.
* [ ] Parse canvas from a given figma JSON file.
* [ ] Parse props from a `FRAME` node type.
* [ ] Parse props from a `VECTOR` node.
* [ ] Parse props from a `LINE` vector.
* [ ] Parse props from a `ELLIPSE` vector.
* [ ] Parse props from a `RECTANGLE` vector.
* [ ] Parse props from a `TEXT` object.
* [ ] Parse props from a `TypeStyle` node.
* [ ] Fetch GET `images` from node.
* [ ] Fetch GET `projects`.
* [ ] Fetch GET `comments`.
* [ ] Fetch POST `comments`.


## Notes

- Scale: The `/v1/images/:key` ENDPOINT provides a set of path parameters to have in mind. For instance `scale` will need to be exposed to the current screen density on the prototype.
