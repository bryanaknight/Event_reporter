require 'csv'

class EventReporter

  def initialize
   @queue = []
   @commands = { 'queue clear' => 'clears out queue', 
      'queue count' => 'gives number of items in queue', 
      'queue print' => 'shows items in queue'
      }
  end

  def run
    puts "Welcome to Event Manager!"
    command = ""
      while command != "quit"
        printf "enter command: "
        input = gets.chomp
        command = input
        puts "Command: #{command}"

        command_parts = command.split(" ")


        case command_parts.first
          when "find"
            puts "Finding"
            parts = command.split(" ",3)
            find(parts[1],parts[2])    

          when 'quit' then

            puts 'Goodbye!'

          when "queue" then

            if command_parts[1] == "count"
              puts "there are #{queue_count} items in the queue"
            end

            if command_parts[1] == "clear"
              queue_clear
              puts "queue is cleared"
            end

            if command_parts[1] == "print"
              @queue.empty? ? (puts "Sorry, queue is empty!") : (puts @queue)
            end

          when 'help'

            if command_parts.length == 1
              # just "help"
              puts @commands.keys
            else

              # "help", "queue" "count"
              # "queue" "count"
              # "queue count"
              help_for_command = command_parts[1..-1].join(" ")
              puts @commands[help_for_command]

            end
          end
      end
  end

  # def execute_command
  # end

  def load_file
    @contents = CSV.read 'event_attendees.csv', headers: true, header_converters: :symbol
  end

def find(field, input)
  @queue.clear
  load_file
  input.downcase!
  field = field.to_sym
  @contents.each do |row|
    if row[field].downcase == input
      @queue << row
      puts "Found #{row}"
    end
  end
end
  

  # if row (attribute) contains (criteria)
  # take that info and store in the queue 



  def queue_count
    @queue.length
  end

  def commands
    @commands
  end


  def queue_clear
    @queue.clear
  end

  def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5,"0")[0..4]
  end


end

e = EventReporter.new
e.run

