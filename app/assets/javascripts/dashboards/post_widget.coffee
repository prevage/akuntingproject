
ready = ->
  
  ## Sets Posts Template ##
  window.Posts = new Ractive
    el: "#templateWrapper"
    template: '#template'
    data: {list:[], EmpId: EmpId}

  ## Retrieve current posts ##
  GetPosts =     
    $.ajax
      async: true
      type: 'GET'
      url: '/posts.json'
      success: (data) ->

  $.when(GetPosts, Posts).done (a1) ->
    posts = a1[0]
    i = 0
    while i < posts.length
      if posts[i].profile_id == EmpId
        posts[i].isUser = true
      else
        posts[i].isUser = false

      Posts.push('list', posts[i])
      i++

  ## Posts Actions ##
  Posts.on
    ## Hand new posts ##
    post: ( event ) ->
      event.original.preventDefault()
      ## reset the form ##
      SocketApp.sendNewPost(this.get('content'))
      this.set({content: '' })

    remove: ( event, index ) ->
      list = this.get 'list'
      post = list[index]
      $.ajax
        type: 'post'
        url: 'posts/' + post.id
        data: {"_method": "delete"}
        complete: ->
          list.splice( index, 1 )


$(document).ready(ready)
$(document).on('page:load', ready)