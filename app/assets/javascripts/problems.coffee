# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
	$('[data-toggle="tooltip"]').tooltip()

	$('#problem-tabs a').click((e) -> 
		e.preventDefault();
		$(this).tab('show');
	);

	# store the currently selected tab in the hash value
	$("ul.nav-tabs > li > a").on("shown.bs.tab", (e) -> 
		id = $(e.target).attr("href").substr(1);
		window.location.hash = id;
	);

	# on load of the page: switch to the currently selected tab
	hash = window.location.hash;
	$('#problem-tabs a[href="' + hash + '"]').tab('show');
