Figma = require 'figma-js'
chroma = require 'chroma-js'
shades = require 'shades'

_ = require 'lodash'

require './src/moreutils.coffee'
{ token, fileid } = require './src/secret.coffee'

client = Figma.Client({
	personalAccessToken: token
})

{ file, fileImages, comments, postComment, teamProjects, projectFiles } = client

cache = {}

getFigma = (fn, id, params) ->
	new Promise (resolve, reject) ->
		isParams = params
		if cache[id]
			console.log cache[id]
			data = cache[id]
			resolve data
		else
			console.log 'fetching', id
			fn(id, isParams).then((_ref) ->
				data = _ref.data
				cache[id] = data
				console.log 'stored', cache[id]
				resolve data
				return
			).catch reject
		return


loadFigma = (id) -> getFigma file, id

# Utilities

getImageURL = (hash) ->
  squash = hash.split('-').join('')
  'url(https://s3-us-west-2.amazonaws.com/figma-alpha/img/' + squash.substring(0, 4) + '/' + squash.substring(4, 8) + '/' + squash.substring(8) + ')'

getColorFromNode = (node) ->

	c = node.fills[0].color

	color = chroma.gl c.r, c.g, c.b

	return color

getColorFromDocument = (data) ->

	c = data.document.children[0].backgroundColor

	color = chroma.gl c.r, c.g, c.b

	return color

getBlendingMode = (node) ->

	blend = node.blendMode
	framerLayerBlending = null

	switch
		when blend is 'PASS_THROUGH'
			framerLayerBlending = Blending.normal
		when blend is 'MULTIPLY'
			framerLayerBlending = Blending.multiply
		else
			framerLayerBlending = Blending.normal

	return framerLayerBlending


NodeTypes = ['BOOLEAN' , 'CANVAS' , 'COMPONENT' , 'DOCUMENT' , 'ELLIPSE' , 'FRAME' , 'GROUP' , 'INSTANCE' , 'LINE' , 'RECTANGLE' , 'REGULAR_POLYGON' , 'SLICE' , 'STAR' , 'TEXT' , 'VECTOR']
GroupTypes = ['GROUP']
VectorTypes = ['BOOLEAN', 'ELLIPSE', 'LINE', 'REGULAR_POLYGON', 'STAR', 'VECTOR']


class Rect extends Layer
	constructor: (props={}) ->
		_.assign props,
			name: 'FigmaNodeRect'
			# blending: getBlendingMode(options.node)

		super props

		Utils.define @, 'nodeType', props.nodeType


getNodeTypeProps = (node) ->

	return unless node is undefined

		nodeType = null

		isFrame = ->
			nodeType = 'FRAME'

		isVector = ->
			nodeType = 'VECTOR'

		types = 
			'FRAME':			isFrame
			'GROUP':			isFrame
			'COMPONENT':		isFrame
			'INSTANCE':			isFrame
			'TEXT':				isVector
			'BOOLEAN':			isVector
			'STAR':				isVector
			'ELLIPSE':			isVector
			'LINE':				isVector
			'REGULAR_POLYGON':	isVector
			'VECTOR':			isVector



		types[node.type]()

Canvas = new Layer
	size: Screen.size
	backgroundColor: null

loadFigma(fileid).then((data) ->


	doc = data.document

	doc.children.forEach (canvas, index) ->

		nodes = canvas.children and canvas.children.filter (child) -> child.visible isnt false
		nodes.forEach (node, index) ->
			nodeProps = getNodeTypeProps node
			console.log nodeProps
				
	Canvas.animate
		backgroundColor: getColorFromDocument(data).css()

	).catch (error) ->
		throw Error error


getFramerVersion = () ->

	version = new TextLayer
		text: 'framer.js v' + Framer.Version.build
		color: '#FFF'
		fontStyle: 'normal'
		fontVariantCaps: 'normal'
		fontWeight: 'normal'
		fontSize: 16
		lineHeight: 1.5
		fontFamily: '-apple-system, BlinkMacSystemFont'
		outline: 'none'
		whiteSpace: 'pre-wrap'
		wordWrap: 'break-word'
		padding: {top: 12, bottom: 12, left: 12, right: 12}
		y: Align.bottom

getFramerVersion()


