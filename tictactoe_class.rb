class Tictactoe
  #Add AI

  def initialize
    @gamestate = Hash.new
    self.game_setup
    @victory_state = "none"
    @active_player = "X"
    @turn_counter = 0
    @board = Board.new(3, 3)
    self.play
  end

  def game_setup
    #populating the gamestate hash
    column = 'a'
    3.times do
      row = '1'
      3.times do
        element = (column+row).to_sym
        @gamestate[element] = " "
        row.next!
      end
      column.next!
    end
  end

  def victory_check
    row = '1'
    column = 'a'
    lines = []

    3.times do
      #putting all the horizontal and vertical rows into the lines array
      lines <<
        (@gamestate.select {|k, v| k.to_s.start_with?(column)}).values

      lines <<
        (@gamestate.select {|k, v| k.to_s.end_with?(row)}).values

      row.next!
      column.next!
    end

    diagonals = [[:a1, :b2, :c3], [:a3, :b2, :c1]]

    diagonals.each do |item|
      #putting diagonals into lines array
      arr = []
      item.each do |element|
        arr << @gamestate[element]
      end
      lines << arr
    end

    #lines now contains all possible victory conditions
    #if any element is all X's or O's, game has been won
    lines.each{ |line|
      if line.count("X") == line.length
        @victory_state = "X"
      elsif line.count("O") == line.length
        @victory_state = "O"
      end
    }

    if @victory_state == "none" && !moves_left?
      @victory_state = "draw"
    end

  end

  def moves_left?
    #checks is there are any remaining empty squares
    if @gamestate.has_value?(" ")
      return true
    else
      return false
    end
  end

  def player_X
    #user input sanitization
    valid = false
    until valid == true
      move = (gets.chomp).to_sym
      if @gamestate[move] == " "
        valid = true
      else
        puts "Invalid move!"
      end
    end
    return move
  end

  def player_O
    return player_X
  end

  def play
    while @victory_state == "none"
      @board.construct(@gamestate)
      @board.display
      puts "Player #{@active_player}, please enter your move!"

      if @active_player == "X"
        move = player_X
      elsif @active_player == "O"
        move = player_O
      end

      #puts X or O on square moved to depending on active player
      @gamestate[move] = @active_player
      
      #toggle active player
      @active_player == "X" ? @active_player = "O" : @active_player = "X"
      self.victory_check
      @turn_counter += 1
    end

    @board.construct(@gamestate)
    @board.display
    if @victory_state == "draw"
      puts "The game ended in a draw!"
    elsif @victory_state == "X"
      puts "Player X wins!"
    elsif @victory_state == "O"
      puts "Player O wins!"
    end
    puts "This game took #{@turn_counter} turns!"
  end
end
