# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# Initialize Datatables
$(document).on "turbolinks:load", ->
	$("#targetTable").dataTable({
		"paging": false,
		"searching": false,
		"info": false
	})

