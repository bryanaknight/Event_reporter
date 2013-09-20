require 'csv'
require 'pry'

class EventReporter
  attr_accessor :phone_number

  def initialize (input = {})
   @queue = []
   @commands = { 'queue clear' => 'clears out queue', 
      'queue count' => 'gives number of items in queue', 
      'queue print' => 'shows items in queue',
      'find' => 'finds item you searched and shows all information related to item',
      'load <filename>' => 'loads file so you can access the data'
      }
  end

  def run

    puts "Welcome to Event Manager!"

    command = ""

      while command != "quit"
        printf "enter command: "
        command = gets.chomp
        puts "Command: #{command}"
        command_parts = command.split(" ")


        case command_parts.first

          when "load"
            parts = command.split(" ",3)
            load(parts[1])
          when "find"
            puts "Finding"
            parts = command.split(" ",3)
            find(parts[1],parts[2])   
          when 'quit' then
            puts 'Goodbye!'

          when "queue" then
            if command_parts[1] == "count"
              puts "there are #{queue_count} items in the queue"
            elsif command_parts[1] == "clear"
              queue_clear
              puts "queue is cleared"
            elsif command_parts[1] == "print" && command_parts[2] == nil
              @queue.empty? ? (puts "Sorry, queue is empty!") : queue_print
            elsif command_parts[1] == "print" && command_parts[2] == "by"
              parts = command.split(" ",4)
              queue_print_by(parts[3])
            elsif command_parts[1] == "save"
              puts "saving and exporting!"
              parts = command.split(" ",4)
              queue_save(parts[3])
            end
          
          when 'help'
            if command_parts.length == 1
              puts @commands.keys
            else
              help_for_command = command_parts[1..-1].join(" ")
              puts @commands[help_for_command]
            end

          end
      end
  end

  def load (filename)
    puts "loading file"
    filename||= "event_attendees.csv"
    @contents = CSV.read filename, headers: true, header_converters: :symbol
  end

  def find(field, input)
    @queue.clear
    input = input.strip.downcase
    field = field.to_sym
    @contents.each do |row|
      if row[field].nil?
        puts "no #{field} listed"
      elsif row[field].downcase == input
        @queue << row
        puts "Found: #{row}"
      end
    end
  end

  def queue_print
    @queue.to_s.upcase
    puts "LAST_NAME".ljust(15)+"FIRST_NAME".ljust(15)+"EMAIL".ljust(50)+"ZIPCODE".ljust(15)+"CITY".ljust(30)+"STATE".ljust(15)+"ADDRESS".ljust(50)+"PHONE".ljust(15)
    @queue.each do |row|
     @phonenumber = clean_phone_number(row[:homephone])
     @zipcode = clean_zipcode(row[:zipcode])
      puts row[:last_name].ljust(15)+row[:first_name].ljust(15)+row[:email_address].ljust(50)+"#{@zipcode}".ljust(15)+row[:city].ljust(30)+row[:state].ljust(15)+row[:street].ljust(45)+"#{@phonenumber}"
    end
  end

  def queue_print_by(field)
    puts field.upcase
    field = field.to_sym
    @queue.each do |row|
      row[field].downcase == field
      puts row[field]
      end
  end

  def queue_save(filename)
    "puts saving #{filename}"
    Dir.mkdir("queue") 
    filename = "queue/#{filename}.csv"
    File.open(filename, 'w') do |file|
     file.puts @queue
    end
  end

  def queue_count
    @queue.length
  end

  def queue_clear
    @queue.clear
  end

  def commands
    @commands
  end

  def clean_phone_number(number)
    number.tr!('^0-9', '')
    if number.length == 10
      number
    elsif number.length < 10 || number.length > 11
      "0" * 10
    elsif number.length == 11 && number.length == "1"
      number[1..10]
    else
      "0" * 10
    end
  end

  def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5,"0")[0..4]
  end

end

e = EventReporter.new
e.run

