
require 'io/wait' # usefull for read input without waiting
# Do  the Map
X = 20 # declare the size of the map
t = 0.8 # how fast at the beginning?

Signal.trap('INT') do # SIGINT = control-C
  exit
end

def char_if_pressed(last_tast)
  system('stty raw -echo') # turn raw input on
  c = nil
  c = $stdin.getc if $stdin.ready?
  c.chr if c
  return c if c
  return last_tast
ensure
  system 'stty -raw echo' # turn raw input off
end

a = Array.new(X) { Array.new(X, 'X') } # declare 2d Array

# Build the field
a.each.with_index do |row, row_index|
  row.each.with_index do |_column, column_index|
    unless column_index.zero? || (column_index == (X - 1)) ||
           row_index.zero? || (row_index == (X - 1))
      row[column_index] = ' '
    end
  end
end

# create food
class Food
  def self.init(ar)
    running = true
    while running
      a = Random.rand(1...(X - 1)) # create random point for food
      b = Random.rand(1...(X - 1))

      unless ar[a][b] == 'S' # make sure that the snake is not at the food point
        ar[a][b] = 'F'
        running = false
      end
    end
  end
end
# Crash?
class Crash
  def self.c(ar, hx, hy)
    return true if ar[hx][hy] == 'X' # is the next step the wall?
  end
end
# declare beginning snake
class Snake
  def self.init(_ar, x)
    hx = x / 2
    hy = x / 2
    head = [hx, hy]
    head << hx
    head << (hy - 1)
    head << hx
    head << (hy - 2)
    head # return the head position from the snake
  end

  # move the snake in the right direction
  def self.move(_ar, md, hx, hy)
    if md == 'w'
      hx -= 1
      newhead = [hx, hy]
    elsif md == 's'
      hx += 1
      newhead = [hx, hy]
    elsif md == 'a'
      hy -= 1
      newhead = [hx, hy]
    elsif md == 'd'
      hy += 1
      newhead = [hx, hy]
    else
      puts('False key! Pleas play with w,a,s,d. No capital letters!')
    end
    newhead
  end

  def self.check(ar, hx, hy)
    ar[hx][hy]
  end

  def self.go(ar, hx, hy, i)
    ar2 = ar.clone
    (0..(i - 1)).each do |n|
      ar[3 + (n * 2)] = ar2[1 + (n * 2)]
      ar[2 + (n * 2)] = ar2[0 + (n * 2)]
    end
    ar[1] = hy
    ar[0] = hx
    ar
  end

  # show the whole array of the snake
  def self.show(ar, ar2, i)
    (0..i).each do |n|
      ar[ar2[(0 + (n * 2))]][ar2[(1 + (n * 2))]] = 'S'
    end
    ar[ar2[(0 + (i * 2))]][ar2[(1 + (i * 2))]] = ' '
  end

  # make sure that the steps are only forward
  def self.button_check(t, ot)
    if (t == 'a') && (ot == 'd') || (t == 'd') && (ot == 'a') ||
       (t == 'w') && (ot == 's') || (t == 's') && (ot == 'w')
      ot
    else
      t
    end
  end
end

p = 2 # beginning length to show
snake = Snake.init(a, X) # init the snake array
Snake.show(a, snake, p) # give the whole snake to the map array
# function to show the map
def print_board(board)
  board.each do |row|
    row.each do |column|
      print column
    end
    print "\n"
  end
end

Food.init(a) # init food
newhead1 = snake # where is the head?
print_board(a) # print the whole field
tast = 'd' # beginn to the right step
tastold = tast # remember the lsat key
gaming = true # while should run
while gaming == true # working loop

  tast = char_if_pressed(tast) # check is there a key? Yes? return it
  tast = Snake.button_check(tast, tastold) # check is the key possible
  tastold = tast # remember the last key

  newhead1 = Snake.move(a, tast, newhead1[0], newhead1[1]) # move forward

  if Snake.check(a, newhead1[0], newhead1[1]) == 'X' # is there a wall?
    gaming = false
  elsif Snake.check(a, newhead1[0], newhead1[1]) == 'F' # is there food?
    p += 1 # Yes? get longer
    snake = Snake.go(snake, newhead1[0], newhead1[1], p) # go to the next step
    Food.init(a) # make new food
    if t > 0.06
      t -= 0.05 # get faster you are bigger now
    end
  elsif Snake.check(a, newhead1[0], newhead1[1]) == 'S' # you hit yourself?stop!
    gaming = false
  else
    snake = Snake.go(snake, newhead1[0], newhead1[1], p) # go to the next step
  end
  Snake.show(a, snake, p) # get the snake in the field array
  system 'clear' # clear the old field
  print_board(a) # print the new field
  sleep t # wait a little for the next step
end

print 'Game Over!' # end text
