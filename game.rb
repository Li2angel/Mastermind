# The module below checks and validate the user input
module Common
    RANGE = ['1','2','3','4','5','6']

    def player_input
        puts "Enter your code: four numbers in a row (1 to 6)"
        input = gets.chomp
        input_ascii = input.each_byte.to_a
        until input.length == 4 && input_ascii.all? {|e| e.between?(49,54) }
            puts "Enter valid code"
            input = gets.chomp
            input_ascii = input.each_byte.to_a
        end
        @player_input_code = input.split('')
    end
end

# PlayBreaker Class
class PlayerBreaker
    include Common
    attr_accessor :player_input_code
    def initialize
        @player_input_code = []
    end
end

# PlayMaker class
class PlayerMaker
    include Common
    attr_accessor :player_input_code, :ai_input_code

    def initialize
        @player_input_code = []
        @ai_input_code = []
    end

    def first_guess
        value = Common::RANGE.sample
        i = 1
        while i <= 4
            @ai_input_code << value
            i += 1
        end
        puts "Computer guessed: #{@ai_input_code}"
    end

    def solve
        new_guess = []
        i = 0
        while i <= 3
            if @player_input_code[i] == @ai_input_code[i]
                new_guess << @player_input_code[i]
            else
                value = Common::RANGE.sample
                new_guess << value
            end
            i += 1
        end
        @ai_input_code = new_guess
        puts "Computer guessed: #{@ai_input_code}"
    end
end

# Board Class
class Board
    include Common
    attr_accessor :maker_board, :turn_count

    def initialize
        @maker_board = []
        @breaker_board = []
        @winner = false
        @match = 0
        @partial = 0
        @player_breaker = PlayerBreaker.new
        @player_maker = PlayerMaker.new

        puts "Press 1 to be a code breaker"
        puts "Press 2 to be a code maker"
        puts ""

        @player_choice = gets.chomp
        @turn_count = 1
    end

    def player_is_breaker
        @breaker_board = @player_breaker.player_input_code
    end

    def player_is_maker
        @maker_board = @player_maker.player_input_code
        @breaker_board = @player_maker.ai_input_code
    end

    # Computer makes an array size 4 by selecting random number from our RANGE array
    def computer_maker
        i = 1
        while i <= 4 do
            value = Common::RANGE.sample
            @maker_board << value
            i += 1
        end
    end

    # This method checks if there is any matches or partials
    def check_match_partial
        @match = 0
        @partial = 0
        @maker_board.each_with_index do |a,i|
            @breaker_board.each_with_index do |b,j|
                if a == b && i == j
                    @match += 1
                elsif a == b && i != j
                    @partial += 1
                end
            end
        end
        puts "Match: #{@match}"
        puts "Partial: #{@partial}"
        puts "\r\n"
    end

     # This method checks the winner
     def check_winner
        if @maker_board == @breaker_board
            @turn_count = 13
            @winner = true
        end
    end

    # Display result if winner exist
    def display_result
        case @player_choice
        when '1'
            if @winner == true
                puts "Congrats, you crack the code"
            else
                puts "The code was #{@maker_board.join}. Try again next time"
            end
        else
            if @winner == true
                puts "Computer cracked the code"
            else
                puts "You win"
            end
        end
    end

    # 
    def play_player_breaker
        computer_maker
        until @turn_count >= 13
            puts "Turn: #{@turn_count}"
            @player_breaker.player_input
            player_is_breaker
            check_winner
            check_match_partial
            @turn_count += 1
        end
        display_result
    end

     # 
     def play_player_maker
        @player_maker.player_input
        @player_maker.first_guess
        check_match_partial
        @turn_count += 1
        until turn_count >= 13
            puts "Turn: #{@turn_count}"
            @player_maker.solve
            player_is_maker
            check_winner
            check_match_partial
            @turn_count += 1
            sleep(0.25)
        end
        display_result
    end

    # Selecting player
    def decide_play_method
        case @player_choice
        when '1'
            play_player_breaker
        when '2'
            play_player_maker
        else
            puts "Please select valid input"
        end
    end
end


class Game
    attr_accessor :board

    def initialize
        @board = Board.new
    end

    def play_again
        puts "Enter [y/Y] to play again or [n/N] to quit"
        response = gets.chomp
        case response
        when 'y'
            @board = Board.new
            @board.decide_play_method
            play_again
        when 'Y'
            @board = Board.new
            @board.decide_play_method
            play_again
        else
            puts "Thanks for playing"
        end
    end
end

# Instructions
puts "Welcome to Mastermind game: a code breaking game between you and computer"
puts "\r\n"

game = Game.new
game.board.decide_play_method
game.play_again