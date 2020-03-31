class Postings
  constructor: (@posts) ->


class @SocketApp

  constructor: () ->
    @dispatcher = new WebSocketRails(window.location.host + "/websocket")
    @posts = @dispatcher.subscribe 'posts'
    @trades = @dispatcher.subscribe 'trades'
    @bindEvents()


  bindEvents: =>
    @dispatcher.bind 'new_message', (message) ->
      console.log(message)

    @dispatcher.bind 'private_message', (message) ->
      console.log(message)

    @posts.bind 'new_post', (message) ->
      message.created_at = "less than a minute"
      Posts.unshift('list', message)

    @trades.bind 'new_trade_post', (trades) ->
      Trades.set(trades)

  sendPrivateMessage: (event) =>
    event.preventDefault()
    message = $('#pMessage').val()
    @dispatcher.trigger 'private_message', message

  sendNewPost: (message) =>
    @dispatcher.trigger 'posting', message


ready = ->

  window.SocketApp = new SocketApp

$(document).ready(ready)
$(document).on('page:load', ready)