# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "turbolinks:load", ->
	$('.unlink-account-start').click ->
		$('#account-unlink-confirm-text').text("Do you want to unlink your account from " + $(this).data("accname") + "'s account on " + $(this).data("server") + "?")
		$('#id').val($(this).data("accid"))
		$('#account-unlink-confirm').modal('show')

	$('#account-unlink-confirm-button').click ->
		$('#account-unlink-form form').submit()
