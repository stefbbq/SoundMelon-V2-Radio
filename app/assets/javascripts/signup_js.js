$('document').ready(function() {

	function doEmailComp(email_val, email_conf_val){
		// perform an email comparison and display live validation for confirm email field
		if(email_val !== email_conf_val){
			$(".warning_div").remove();
			var warning_div = $('<div class="warning_div">Please check your email address</div>')
			warning_div.insertAfter(email_conf);
		}
		else{
			$(".warning_div").remove();
		}
	}


	$('label').hide(); // hides all labels which are required for testing 
										 // correct fields


	//Vars to collect email input fields
	var email = $('#email_input')
	var email_conf = $('#conf_email_input')
	
	email.blur(function() {
		// perform email confirmation check if conf_email field is not empty
		// and email field is changed/added to
		var email_val = email.val();
		var email_conf_val = email_conf.val();
		if(email_conf_val !== ''){
			doEmailComp(email_val, email_conf_val);
		}
	});

	email_conf.blur(function() {
		// perform email confirmation check if conf_email field is tabbed out of
		var email_val = email.val();
		var email_conf_val = email_conf.val();
		doEmailComp(email_val, email_conf_val);
	});
	
});
