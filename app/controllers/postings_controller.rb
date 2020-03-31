class PostingsController < WebsocketRails::BaseController

	def new_post
		puts 'new message:' + message
		broadcast_message :new_post, 'Echo: ' + message
	end
end