
module Package
	require 'json'
	require 'date'

class BidPackage

	#Acquire a json file and parse it 
	def initialize(file)
		@json_file = Array.new

		if File::file?(file)
			@file = File.open(file).read
			@file = JSON.parse(@file)
			prepare_json
		else 
			@file = nil
		end

	end

	#Returns bid package header, which should be start dates
	def header
		@json_file
	end

	def count
		@file.count
	end 

	#Format json file in order to use for creation of model
	def prepare_json
		json_header
		json_assemble
		#order_by_line_id(@file)
		#json_sections
		#json_order_line_by_section

	end

	def json_header
		h = Hash.new
		n = 0
		head = @file.first

		head.each do |key, value|
    		if key == "Line #" || key == "Cycle Name"

    		else
      			n = n+1
      			h["day_#{n}".to_sym] = Date.parse(value).to_s
    		end
		end
		@json_file.push(h)
	end

	def json_assemble
		#h = Hash.new 
		#h  = @file[1..10]
		result = order_by_line_id(@file)
		#@json_file.push(result)	
	end

	def json_sections
		file = @file
		n = 0
		@sections_index  = Hash.new

		for i in 0..(file.count-1)
			file[i].each do |key, value|
				case value
				when "FT CSSA 4 X 4" then
					@sections_index[:ft_cssa_4x4] = i

				when "FT CSSA 5 x 3" then
					@sections_index[:ft_cssa_5x3] = i

				end
			end
		end
		
	end

	def json_order_line_by_section
		ft_cssa_4x4
		ft_cssa_5x3
	end

	def ft_cssa_4x4
		h = Hash.new
		h = @file[(@sections_index[:ft_cssa_4x4]+1)..(@sections_index[:ft_cssa_5x3]-1)]
		result = order_by_line_id(h)
		@json_file[:ft_cssa_4x4] = result
		@json_file[:ft_cssa_4x4]
	end

	def ft_cssa_5x3
		h = Hash.new
		h = @file[(@sections_index[:ft_cssa_5x3]+1)..(@file.count-1)]
		result = order_by_line_id(h)
		@json_file[:ft_cssa_5x3] = result
		@json_file[:ft_cssa_5x3]
	end

	def order_by_line_id(data)
		h = Hash.new
		a = Hash.new
		k = Array.new
		n = 0
		v = ""
		for i in 2..(data.count-1)
			data[i].each do |key, value|
				case key 

					when "Line #"
		    			a[:line_number] = value.to_i
		    			#h[v] = []
	    			when "1","2","3","4","5","6","7", "8"
	    				if value == "X"
	    					a.merge!({ "day_#{key}".to_sym => 
	    								{:scheduled => "OFF"}
	    							}) 
	    				else
	    					if !value.empty?
	    						newVal = value.split("\n")
	    						time = newVal[0].split("-")
	    						a.merge!({ "day_#{key}".to_sym => 
	    								{:position => newVal[2], 
	    								 :start_time => time[0],
	    								 :finish_time => time[1],
	    								 :scheduled => "IN" 
	    								}
	    							})
	    					end  
	    				end
	    			else
    			
    			end

    		end
    		#h[v] = a 
    		@json_file.push(a)
    		h.merge!(a)
    		#puts h
    		a = {}
		end
		#puts k[0..2]
		return k
	end
	
	def specify_data_row(data)
		data[0]
	end

	def self.position
		self[:position]
	end

	def file 
		@json_file
	end

	def self
		@json_file.first
	end
end

#shifts = BidPackage.new("FT.json")

#puts shifts.file[0..3]

end