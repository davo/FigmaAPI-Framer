# Figma API Wrapper for Framer - Work in progress

### Configuration

1. Open the secret.coffee in /src and add your own Figma Personal Token

```coffeescript
exports.token = 'ai3-57wg5gbhe9-cspl-gclno-deheq-1qfrpxq6ax7x'
exports.fileurl = 'https://www.figma.com/file/FileKey/YourFile'
```

### Setting up your environment
To run the demo
```bash
yarn install
yarn run start
```

## Todo

* [x] Create API Wrapper Module.
* [x] Fetch GET single `file` from URL.
* [x] Parse canvas from a given figma JSON file.
* [x] Parse props from a `RECTANGLE` node type.
* [ ] Parse props from a `FRAME` node type.
* [ ] Parse props from a `VECTOR` node.
* [ ] Parse props from a `LINE` node.
* [ ] Parse props from a `ELLIPSE` noe.
* [ ] Parse props from a `TEXT` object.
* [ ] Parse props from a `TypeStyle` node.
* [ ] Fetch GET `images` from node.
* [ ] Fetch GET `projects`.
* [ ] Fetch GET `comments`.
* [ ] Fetch POST `comments`.
* [ ] Implement a destructed assignment method for a cleaner parsing.



## Related Projects

https://github.com/expressjs/body-parser
https://github.com/jamesmcnamara/shades

## For more documentation

- [Figma Web API](https://www.figma.com/developers)

- [Figma API Documentation](https://www.figma.com/developers/docs)

- [Figma API Global Props](https://www.figma.com/developers/docs#global-properties)
