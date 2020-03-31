# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#= require dashboards/trade_info_widget
#= require dashboards/post_widget

ready = -> 
  DateConvert = (d) ->
    time = moment(d).utcOffset(d).format("HH:mm")

  $('#calendar').on 'click', (e) ->
    e.stopPropagation()
    $('html').on 'click', ->
      $('.popover').remove()

  $('.user_full_calendar').fullCalendar
    
    # Calendar View 
    editable: true,
    displayEventEnd: true,
    header:
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    defaultView: 'month',
    height: 400,
    aspectRatio: 1
    slotMinutes: 30,
    eventLimit: true,
    timeFormat: ''
    dragOpacity: "0.5" 
    

    # Events 
    events: "/shifts.json"


    eventRender: (event, element, view) -> 
        
        $('.fc-container').css('font-size', '1.8em !important')
        posted_shift_path = "post_shift/" + event.id.toString()
        #console.log(event.posted)
        if event.posted
          element.css('background-color', '#d43f3a')

        if event.original_owner != employee
          element.css('background-color', 'green')

        console.log(event.original_owner) 
        element.popover
            title: event.title,
            placement: 'bottom',
            html: true,
            animation: true,
            content: 'Start: ' + event.start.format("HH:mm") + '<br />End: ' + event.end.format("HH:mm") + '<br />Description: ' + event.description + '<br /> <a id="post_shift" href= "post_shift/" class= "post" role ="button">Post Shift</a> |
            <a href="trade_with_collegue/" class="collegue_trade">Trade With Collegue</a