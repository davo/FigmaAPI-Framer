# Documentation
# Purpose: This demo aims to show how to fetch content from a Figma File.

# API

# requestFigmaFile
# This will fetch all the Canvas objects from the file url & loop to get the IDs for each Canvas.

# requestFigmaImage
# This function will fetch an image from a canvas ID.

# addToFigmaImageObject (WIP)
# This function will append the response from requestFigmaImage() and it will create a new Figma Image Layer.

# loadImageFromFigmaCDN (WIP)
# This function will create a new Figma Image Layer and it will preload the image into the session cache.

# setImageInFigmaImageLayer (WIP)
# This function include the image into the already created Figma Image Layer and it will push the Image Layer into the Page Component.

# Configuration

# 1. Open the secret.coffee in /modules and add your own Figma Personal Token

# Token

# { token, fileurl } = require '../secret.coffee'

token = '247-7d2608ba-08be-4fd2-ab2b-f2cee4b57e10'

fileurl = 'https://www.figma.com/file/NlSvIpXvpmE0mtmBUMMTENKr/FramerFigma'


# FigmaImageLayer

class FigmaImageLayer extends Layer
	constructor: (options={}) ->

		@options.backgroundColor = "white"
		@options.size = Screen.size
		@options.x = 0
		@options.y = 0

		super @options

## Figma Object
# Problem, Figma exports images and host them in AWS
# When fetching the images the order is based on the images
# that loads faster.

# Attempt to order the images coming from Figma API

figmaImages = {}

addToFigmaImageObject = (image, nodeId, name) ->
	figmaImages[name] = {image, nodeId, name}
	loadImageFromFigmaCDN image, nodeId, name
	return figmaImages

loadImageFromFigmaCDN = (imageUrl, nodeId, name) ->
	
# 	print imageUrl, nodeId, name

	figmaImageLayer = new FigmaImageLayer
		name: 'figmaImageLayer'+name

# 	_.sortBy(figmaImages, ['name'])

	figmaImage = new Image()
	figmaImage.onload setImageInFigmaImageLayer(figmaImageLayer, name)
	figmaImage.src = imageUrl
	
	print imageUrl


setImageInFigmaImageLayer = (figmaImageLayer, name) ->

	updateStatus 'Creating Image Layers...'
	

	switch
		when name is '01'
			figmaImageLayer.image = figmaImages[name].image
			slide?.addPage figmaImageLayer, 'right'
		when name is '02'
			figmaImageLayer.image = figmaImages[name].image
			slide?.addPage figmaImageLayer, 'right'

		when name is '03'
			figmaImageLayer.image = figmaImages[name].image
			slide?.addPage figmaImageLayer, 'right'

		when name is '04'
			figmaImageLayer.image = figmaImages[name].image
			slide?.addPage figmaImageLayer, 'right'


		when name is '05'
			figmaImageLayer.image = figmaImages[name].image
			slide?.addPage figmaImageLayer, 'right'

		when name is '06'
			figmaImageLayer.image = figmaImages[name].image
			slide?.addPage figmaImageLayer, 'right'


		when name is '07'
			figmaImageLayer.image = figmaImages[name].image
			slide?.addPage figmaImageLayer, 'right'

# Figma API

imagesFromEndpoint = null

getFileKey = (pageUrl) ->
# 	updateStatus 'Getting file key for: '+pageUrl
	parser = document.createElement('a')
	parser.href = pageUrl
	parser.pathname.replace('/file/', '').replace /\/.*/, ''

getNodeId = (pageUrl) ->
# 	updateStatus 'Getting page for: '+pageUrl
	parser = document.createElement('a')
	parser.href = pageUrl
	decodeURIComponent(parser.search).replace '?node-id=', ''

apiRequest = (endpoint) ->
# 	updateStatus 'Fetching from: '+endpoint
	fetch('https://api.figma.com/v1' + endpoint,
		method: 'GET'
		headers: 'x-figma-token': token).then((response) ->
# 		updateStatus 'Resolving promises from API...'
		response.json()
	).catch (error) ->
		throw Error error

requestFigmaFile = (url) ->
	updateStatus 'Request Figma File: '+url
	nodeId = getNodeId(url)
	apiRequest('/files/' + getFileKey(url) + '?ids=' + nodeId).then (response) ->
		updateStatus 'Parsing response...'
		response.document.children.forEach (canvas) ->
			updateStatus 'Parsing canvas IDs...'
			canvas.children.forEach (id) ->
# 				print id
				imagesFromEndpoint = imagesFromEndpoint + 1
				requestFigmaImage fileurl+'?node-id='+id.id, id.id, id.name


requestFigmaImage = (url, nodeId, name) ->
	updateStatus 'Requesting images from Figma...'
	nodeId = getNodeId(url)
	apiRequest('/images/' + getFileKey(url) + '?ids=' + nodeId).then((response) ->
		image = response.images[nodeId]
# 		loadImageFromFigmaCDN image, nodeId, name
		addToFigmaImageObject image, nodeId, name


	).catch (error) ->
		{ err: error }

# Loading Animation

matrix = [30, -30, 45, -45, 60, -60, 90, -90]

animateLogo = false

figmaStates = {}
framerStates = {}


figmaColors = [
	'rgb(0, 208, 128)',
	'rgb(162, 81, 255)',
	'rgb(3, 187, 255)',
	'rgb(244, 77, 2)',
	'rgb(255, 114, 93)'
]

framerColors = [
	'rgb(5, 77, 255)',
	'rgb(4, 169, 255)',
	'rgb(4, 169, 255)',
	'rgb(132, 220, 255)',
	'rgb(132, 220, 255'
]

loadingState = () ->

	animateLogo = true


	figma.children.forEach (f) ->



		# print (f._svgLayer._properties.fill).toRgbString()

		figmaStates[f.id] = f.props
		f.animate
			x: f.x + _.sample matrix
			y: f.y + _.sample matrix
			rotationY: _.sample matrix
			rotationX: _.sample matrix
# 			opacity: Math.random() * 1
			options:
				delay: Math.random() * 0.5
				time: 0.2

		f.onAnimationEnd ->
			unless animateLogo is false
				Utils.delay 0.1, ->
					f.animate
						x: f.x + _.sample matrix
						y: f.y + _.sample matrix
						rotationY: _.sample matrix
						rotationX: _.sample matrix
						options:
							delay: Math.random() * 0.5
							time: 0.2

	framer.children.forEach (f) ->

		#print (f._svgLayer._properties.fill).toRgbString()

		framerStates[f.id] = f.props
		f.animate
		
			x: _.sample matrix
			y: _.sample matrix
			rotationY: _.sample matrix
			rotationX: _.sample matrix
			options:
				delay: Math.random() * 0.5
				time: 0.2
				
		f.onAnimationEnd ->
			unless animateLogo is false
				Utils.delay 0.1, ->
					f.animate
						x: _.sample matrix
						y: _.sample matrix
						rotationY: _.sample matrix
						rotationX: _.sample matrix
						options:
							delay: Math.random() * 0.5
							time: 0.2

start = () ->

	animateLogo = false

	updateStatus 'Ready'

	pageIndicator = slide.selectChild 'pageIndicator'

	pageIndicator.animate opacity: 1

	# Animate individual indicators?
	# pageIndicator.children.forEach (i) ->
	#	print i

	figma.children.forEach (f, i) ->
		id = f.id
		f.animateStop()
		Utils.delay 0.5, ->
			figma.animate
				scale: 0.5
				y: 339
				options:
					delay: 0.5
					time: 1.25
			f.animate
				x: figmaStates[id].x + 90
				y: figmaStates[id].y
				rotationY: figmaStates[id].rotationY
				rotationX: figmaStates[id].rotationX
				backgroundColor: figmaColors[i]
				opacity: 1
				options:
					delay: 0.25 * i
					time: 0.35 * i

	framer.children.forEach (f, i) ->
		id = f.id
		f.animateStop()
		Utils.delay 0.5, ->
			framer.animate
				scale: 0.5
				y: 339
				options:
					delay: 0.5
					time: 1.25
			f.animate
				x: framerStates[id].x - 90
				y: framerStates[id].y
				rotationY: framerStates[id].rotationY
				rotationX: framerStates[id].rotationX
				backgroundColor: framerColors[i]
				opacity: 1
				options:
					delay: 0.25 * i
					time: 0.35 * i



# Page Component

slide = new PageComponent
	size: Screen.size
	scrollVertical: false
	backgroundColor: 'white'

slide.content.backgroundColor = 'white'

loading.parent = slide.content

createPageIndicator = (parent, pages, y) ->

	indicatorColor = framerColors[2]

	currentIndex = 0



	pageIndicator = new Layer
		parent: parent
		name: 'pageIndicator'
		x: 0
		y: y
		width: Screen.width
		height: 8
		backgroundColor: null


	movingIndicator = new Layer
		parent: parent
		name: '.movingIndicator'
		x: Align.center(0-((pages/2 - 0.5))*18)
		y: y
		backgroundColor: framerColors[1]
		size: 8
		borderRadius: 4
		opacity: 0


	for i in [0...pages]

		indicator = new Layer
			parent: pageIndicator
			x: Align.center((i - (pages/2 - 0.5))*18)
			y: Align.center
			size: 8
			borderRadius: 4
			name: '.indicator'+i
			backgroundColor: indicatorColor
			opacity: 0.5

		indicator.states =
			active:
				opacity: 1
				backgroundColor: framerColors[1]

	pageIndicator.children[0].stateSwitch('active')

	parent.on 'change:currentPage', ->
		pageIndicator.children[currentIndex].stateSwitch('default')
		currentIndex = parent.horizontalPageIndex(parent.currentPage)
		pageIndicator.children[currentIndex].stateSwitch('active')
		movingIndicator.animate
			opacity: 0.5
			x: pageIndicator.children[currentIndex].x
			options:
				time: 0.25

status = loading.selectChild 'status'

updateStatus = (message) ->
	status.template =
		status: message



# Initialize

Utils.domComplete ->

	createPageIndicator slide, 8, Align.bottom(-24)

	pageIndicator = slide.selectChild 'pageIndicator'

	pageIndicator.opacity = 0
	loadingState()
	updateStatus 'Pinging Figma API...'
	Utils.delay 0.5, ->
		requestFigmaFile(fileurl)

	Utils.delay 2, ->
		start()
