const path = require('path');

module.exports = {
	entry: './demo/app.coffee',
	output: {
		path: path.resolve(__dirname, 'demo'),
		filename: 'app.js'
	},
	devServer: {
		disableHostCheck: true
	},
	module: {
		rules: [
			{
				test: /\.coffee$/,
				use: ['coffee-loader']
			}
		]
	}
}
