# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#$('#problem_name').select2();
$(document).on 'turbolinks:load', ->
	$("#form").on "submit", (e) ->

		file = document.getElementById("file").files[0];	

		formData = new FormData();
		formData.append("shortname", $(problem_name).val());	
		#formData.append("shortname", "boolfind");		
		formData.append("langid", $(language).val());
		formData.append("code[]", file);
		#formData.append("cid", 2);

		res = $.ajax({		
			url: 'http://localhost/domjudge/api/submissions',
			#url: 'http://localhost:1234/domjudge/api/submissions',
			type: 'POST',
			data: formData,
			async: false,
			cache: false,
			contentType: false,
			processData: false,
			error: (xhr, textStatus, errorThrown) ->
				alert(xhr.responseText);   
			success: () ->
				alert("Succesfully submitted!") 
		})
		$('#form')[0].reset();
		return false;

