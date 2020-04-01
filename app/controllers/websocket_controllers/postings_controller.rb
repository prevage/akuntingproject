class WebsocketControllers::PostingsController < WebsocketRails::BaseController

	def new_post
		#puts 'message:' + message
		post = profile.posts.create!(content: message)
		@p = post.attributes.merge!({user: post.profile.attributes})
		WebsocketRails[:posts].trigger(:new_post, @p)
		#WebsocketRails.users[current_employee.id].send_message('new_notification', {:message => 'you\'ve got an upvote '})

	end

	def new_trade_post
		puts "new trade post"
		shift_for_pick = ShiftForTrade.count
		broadcast_message 'new_trade_post', {pick: "#{shift_for_pick}"}
	end

	def private_message
		#puts 'private message', message
		recipient = WebsocketRails.users[2]
		recipient.send_message 'private_message', {content: message}
	end

    def format_post(post)
    	p = p.attributes.symbolize_keys!
    	p[:id] = p.id
    	p[:profile] = p.profile._id
    	p[:created_at] = time_ago_in_words(post.created_at)
    	p[:conent] = post.content
		p[:user] = {:fname => p.user.fname, :lfname => p.user.lname}
	    return p 
	end

	def client_connected
    	WebsocketRails.users[current_employee.id] = connection
	end

	def delete_user
		user_client = WebsocketRails.users[current_employee.id]
		user_client.connections.delete (connection)
	end
end