# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Shoudl be in submissions.coffee, but that one does not execute scripts :S
$(document).on 'turbolinks:load', ->
	
	$("#form").on "submit", (e) ->
		file = document.getElementById("file").files[0];	

		formData = new FormData();
		formData.append("shortname", $(problem_name).val());
		formData.append("langid", "c");
		formData.append("code[]", file);

		$.ajax({
			url: 'http://localhost/domjudge/api/submissions',
			type: 'POST',
			data: formData,
			async: false,
			cache: false,
			contentType: false,
			processData: false,
		});
 
  
		return false;
	