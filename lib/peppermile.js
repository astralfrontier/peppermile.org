require('babel-polyfill');
require('bootstrap-webpack');
require('font-awesome-webpack');

require('./peppermile.less');

$(document).ready(function() {
	$('.toggle-directors-cut').click(function() {
		$('.directors-cut').toggle();
	});
});
