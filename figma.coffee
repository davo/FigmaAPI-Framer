#
#
# https://gist.github.com/fgilio/230ccd514e9381fafa51608fcf137253

Figma = require 'figma-js'
chroma = require 'chroma-js'

_ = require 'lodash'

require './src/moreutils.coffee'
require './src/secret.coffee'

client = Figma.Client({
	personalAccessToken: token
})

class Rect extends Layer
	constructor: (props={}) ->
		_.assign props,
			name: 'FigmaNodeRect'
			# blending: getBlendingMode(options.node)

		super props

		Utils.define @, 'nodeType', props.nodeType

	# @setProps()

	# setProps: (props) ->
	# 	Object.keys(@props).map (k) =>
    #     	@[k] = @props[k]


poll = (fn, retries = Infinity, timeoutBetweenAttempts = 1000) ->
  Promise.resolve().then(fn).catch (err) ->
    if retries-- > 0
      return delay(timeoutBetweenAttempts).then(fn).catch(retry)
    throw err
    return

getColorFromNode = (node) ->

	c = node.fills[0].color

	color = chroma.gl c.r, c.g, c.b

	return color


getColorFromDocument = (data) ->

	c = data.document.children[0].backgroundColor

	color = chroma.gl c.r, c.g, c.b

	return color

	# validate = ({data}) ->
	# 	# print data
	# 	unless !data
	# 	# or data.content.status isnt 200
	# 	# 	console.log res
	# 		# print data.document.children[0].backgroundColor
	# 		return getBackgroundColor data


	# 		# return c

	# poll(client.file(fileurl).then(validate), 2, 5000)

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

getNodeType = (data) ->

	console.log data.document.name
	console.log data.document.type

	console.log data

	console.log _.find(data, (node) -> node.type is 'CANVAS' )


	# print node
	# unless node is undefined
	# switch
	# 	when data.node is 'DOCUMENT'
	# 		print data.node

Canvas = new Layer
	size: Screen.size
	backgroundColor: null

# cache = {}

# loadFigma = (id) =>
#   new Promise((resolve, reject) ->
#     if cache[id]
#       console.log 'hit from cache', id
#       resolve cache[id]
#     else
#       console.log 'fetching', id
#       client.file(id).then((_ref) ->
#         data = _ref.data
#         cache[id] = data
#         console.log 'stored', id
#         resolve data
#       ).catch ->
#         reject()
#     return
# )

client.file(fileurl).then(({data}) ->

	# # print _.map data, getNodeType
	# getNodeType data

	# print _.find(data, (data) -> data.type is 'CANVAS' )

	# print _.each data.document.children


	data.document.children.forEach (canvas) ->



		canvas.children.forEach (rect, index) ->

			# print rect.absoluteBoundingBox

			r = new Rect
				parent: Canvas
				x: Align.center(rect.absoluteBoundingBox.x)
				y: Align.center(rect.absoluteBoundingBox.y)
				width: rect.absoluteBoundingBox.width
				height: rect.absoluteBoundingBox.height
				borderRadius: rect.cornerRadius
				backgroundColor: getColorFromNode(rect).css()
				blending: getBlendingMode(rect)
				# rect: rect
				opacity: 0

			r.animate
				opacity: 1
				options:
					time: 0.25
					delay: 0.05 * index

			# print r.size

	Canvas.animate
		backgroundColor: getColorFromDocument(data).css()

	).catch (error) ->
		throw Error error

# function poll(fn, retries = Infinity, timeoutBetweenAttempts = 1000) {
# 	return Promise.resolve()
# 		.then(fn)
# 		.catch(function retry(err) {
# 			if (retries-- > 0)
# 				return delay(timeoutBetweenAttempts)
# 					.then(fn)
# 					.catch(retry)
# 			throw err
# 		})
# }

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

createDeviceComponent = () ->
	comp = new DeviceComponent()

	# DeviceComponent.Devices["test"] =
	# 		"deviceType": "phone"
	# 		"screenWidth": 720
	# 		"screenHeight": 1000
	# 		"deviceImageWidth": 800
	# 		"deviceImageHeight": 1203

	# comp.deviceType = "test"


# class Airtable extends Framer.BaseClass

# 	constructor: (options={}) ->
# 		apiKey = options.apiKey ?= null
# 		baseId = options.baseId ?= null
# 		tableName = options.tableName ?= null
# 		view = options.view ?= null


# 		super options

# 	request = (project) ->