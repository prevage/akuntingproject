
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready =  -> 
	$('button#enable_bidline').click ->
		BidLineButton = $('.enable_bidline_text')
		BidLineInput = $('#employee_profile_attributes_bid_line')

		if BidLineButton.text() == 'Enable'
			isGood = confirm("Warning: If you enable this field and change your line number, 
							all your previous shifts will be deleted! New line number will generate new shifts on calendar. 
							\n\n Do you want to enable this field?")
		if isGood
			if BidLineButton.text() == 'Enable'
		    	BidLineButton.text 'Disable'
		    	BidLineInput.removeAttr('disabled')
		else
		    BidLineButton.text 'Enable'
		    BidLineInput.attr('disabled', 'disabled')

		


		
$(document).ready(ready) 
$(document).on('page:load', ready)
        
    	