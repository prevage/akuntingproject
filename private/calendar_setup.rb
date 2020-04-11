class Array
    def except(value)
        self - [value]
    end
end

class Hash
   def remove!(*keys)
     reject! { |key| keys.include?(key) }
   end
end

module Calendar

    class Calendar   
        def initialize (start_date, line, profile)
            @start_date = start_date.to_date
            @line = line.remove!(:line_number)
            @days = line.keys
            @profile = profile
            @date_cycle = (start_date..(start_date + 3.month)).map {|date| date.strftime("%b-%d-%Y")}
            @days_length = @days.length - 1
            @loop_set = 0
        end

        def line
            @line 
        end

        def all
            @shifts
        end

        def days
            i = 0
             @days.each do |day|
                if i < @days_length
                    puts line[@days[i]]
                end
                i += 1
            end
        end

        def build
            profile_shifts = Array.new
            @date_cycle.each do |date|

            case 

                when @loop_set < @days_length   
                    shift = @line[@days[@loop_set]].merge(:date => date, :original_owner => @profile.id) 
                    shift[:start_time] = "#{shift[:date]} #{shift[:start_time]}"
                    shift[:finish_time] = "#{shift[:date]} #{shift[:finish_time]}"
                    profile_shifts << @profile.shifts.new(shift)
                    @loop_set += 1
                    

                when @loop_set == @days_length
                    shift = @line[@days[@loop_set]].merge(:date => date)
                    shift[:start_time] = "#{shift[:date]} #{shift[:start_time]}"
                    shift[:finish_time] = "#{shift[:date]} #{shift[:finish_time]}"
                    profile_shifts << @profile.shifts.new(shift)
                    #@profile.shifts.create(shift)
                    @loop_set = 0
                            
                else
                    shift.clear
                    @loop_set = 0
                    "Outside Range"
                end
            end

            Shift.transaction do
                profile_shifts.each(&:save!) 
            end
        end

    end
end

#  line = {:line_number => 5219, 
#           :day_1 => { :position => "Z5", :time => "11:00-15:00", :schedule => "IN"},
#           :day_2 => { :position => "Z5", :time => "11:00-15:00", :schedule => "IN"},
#           :day_3 => { :position => "Z5", :time => "12:00-16:00", :schedule => "IN"},
#           :day_4 => { :position => "Z5", :time => "13:00-18:00", :schedule => "IN"},
#           :day_5 => { :schedule => "OFF"},
#           :day_6 => { :position => "Z5", :time => "13:00-18:00", :schedule => "IN"},
#           :day_7 => { :schedule => "OFF"},
#           :day_8 => { :schedule => "OFF"}
#        }

#  start_date = Date.new(2015, 05, 31).to_date

# shifts = Calendar::Calendar.new(start_date, line)

# puts shifts.build