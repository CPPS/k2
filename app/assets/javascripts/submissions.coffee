# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#$('#problem_name').select2();
$(document).on 'turbolinks:load', ->
	
	$("#file").on "change", (e) ->
		file = document.getElementById("file").files[0];	

		reader=new FileReader();
		reader.onload = (e) ->
			$("#code").val(reader.result);
		reader.readAsText(file);

	$("#form").on "submit", (e) ->
		plain_code = $("#code").val()
		blob = new Blob([plain_code], {type: "text/plain;charset=utf-8"});
		url = $(server_url).val();

		formData = new FormData();
		formData.append("shortname", $(problem_name).val());				
		formData.append("langid", $(language).val());
		formData.append("code[]", blob);
		#formData.append("cid", 2);

		res = $.ajax({		
			url: url + '/api/submissions',
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

		res = $.ajax({
			url: '/new_submission',
			type: 'POST'
		})
		return false;