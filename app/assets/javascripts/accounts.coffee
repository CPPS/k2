$(document).on "turbolinks:load", ->
	$("#account-link-table tr").click ->
		$("#account-link-confirm-text").text("Do you want to link your account to " + $(this).data("accname") + "'s account on " + $(this).data("server") + "?")
		$("#id").val($(this).data("accid"))
		$("#account-link-confirm").modal('show')

	$("#account-link-confirm-button").click ->
		$("#account-link-form form").submit()
