# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Handle submissions of the search form
$(document).on 'turbolinks:load', ->
	$('#search').on 'keyup', (event) ->
		if (event.keyCode == 13)
			query = $('#search').val()
			Turbolinks.visit('/search/' + query)

