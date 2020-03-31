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
            <a href="trade_with_collegue/" class="collegue_trade">Trade With Collegue</a>'
            template:'<div class="popover" role="tooltip"><div class="arrow"></div><h3 class="popover-title" ></h3><div class="popover-content">hello</div></div> ' 
            container: 'body'


        element.text(" ").css('height', '10px')

    eventDataTransform: (eventData, startParam) ->
      s = DateConvert(eventData.start)
      f = DateConvert(eventData.end)
      
      eventData
      
    eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc) ->
      updateEvent(event);

    eventResize: (event, dayDelta, minuteDelta, revertFunc) ->
      updateEvent(event);

    eventClick: (calEvent, jsEvent, view) -> 
        $('.post').on "click", -> 
          $(this).prop('href', "/post_shift/" + calEvent.id)

        $('.collegue_trade').on "click", ->
          $(this).prop 'href', 'trade_with_collegue/' + calEvent.id
              
  ## Private Msging Testing will be removed later ##
  PrivateMsg = new Ractive
    el: "#template2Wrapper"
    template: '#template2'
  
   $('#private_msg').on 'submit', (event) ->
    SocketApp.sendPrivateMessage(event)
  

$(document).ready(ready)
$(document).on('page:load', ready)