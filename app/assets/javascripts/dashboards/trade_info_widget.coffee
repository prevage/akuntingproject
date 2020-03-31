ready = ->
  
 ## Sets Trades Template ##
 window.Trades = new Ractive
  el: "#TradeWidgetWrapper"
  template: "#tradeWidget"
  data: {pickUpShifts: 0, availableEmp: 0}

	getPickUpShifts =     
    $.ajax
      async: true
      type: 'GET'
      dataType: 'json'
      url: '/trade_center_info'
      success: (data) ->
        console.log(data)

  
  $.when(getPickUpShifts).done (tradings) ->
    trades = tradings
    Trades.set({pickUpShifts: trades.pickUps, availableEmp: trades.availables})

  

$(document).ready(ready)
$(document).on('page:load', ready)