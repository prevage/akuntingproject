
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


ready = ->

	arrayOfDate = []

	$('.availability_calendar').fullCalendar
    
    # Calendar View 
    editable: true,
    displayEventEnd: true,
    header:
      left: 'prev',
      center: 'title',
      right: 'next'
    defaultView: 'month',
    height: 500,
    aspectRatio: 2
    slotMinutes: 30,
    eventLimit: true,
    timeFormat: 'HH:mm'
    dragOpacity: "0.5" 


    dayClick: (date, jsEvent, view) ->
      $.ajax
        type: 'GET'
        url: 'availability/date.js?date=' + date.format()
        success: (result) ->
        error: (result) ->
          

      console.log($(this).attr('href', '/date?date=' + date.format()))
      

  $('.set_user_availability_calendar').fullCalendar
    editable: true,
    displayEventEnd: true,
    selectable: true
    header:
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    defaultView: 'month',
    height: 500,
    aspectRatio: 2
    slotMinutes: 30,
    eventLimit: true,
    timeFormat: 'HH:mm'
    dragOpacity: "0.5"

    select : (start, end, jsEvent, view ) -> 
      console.log(start)

    dayClick: (date, jsEvent, view) ->
      console.log($('.set_user_availability_calendar').fullCalendar('getDate');)
      if $.inArray(date.format("MMMM DD YYYY"), arrayOfDate) == -1
        arrayOfDate.push(date.format("MMMM DD YYYY"))
        console.log($('#availability_dates').text(arrayOfDate))
        console.log("in")
      else
        arrayOfDate.splice($.inArray(date.format("MMMM DD YYYY"), arrayOfDate), 1)
        console.log(arrayOfDate)
        $('#availability_dates').text(arrayOfDate) 

      console.log(arrayOfDate)
      $(this).toggleClass('highlight')
      k = $('.'+ date.format()).attr('data-checked')
      
      if k == "true"
        console.log("inside") 
        $('.'+ date.format()).remove()
      else
        console.log("outside") 
        #$('.form-inputs').append('<div class="form-group string optional availability_date ' + date.format() + '" data-checked="true" ><label class="string optional col-lg-2 control-label col-sm-3 control-label" for="availability_date">Date</label><div class="col-sm-9"><input data-date=' +date.format() + ' class="string optional form-control form-control" type="text" name=' + date.format() + ' id="availability_date" ></div></div>')


$(document).ready(ready)
$(document).on('page:load', ready)