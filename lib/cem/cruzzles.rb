
##
# cruzzles Christopher's Ruby Puzzle Utilities
#
# Includes:
# - Point2D, Grid, Dirs(ections)2D
# - Some Numeric hackery
#

module Cem
  def self.min(a, b)
    return a <= b ? a : b
  end

  def self.max(a, b)
    return a >= b ? a : b
  end
end

extend Cem

class Numeric
  # Make all methods in Math module available as methods for numeric (e.g. 3.sqrt instead of Math.sqrt(3))
  Math.methods(false).each do |method|
    define_method method do |*args|
      Math.send(method, self, *args)
    end
  end
end

Point2D = Struct.new("Point2D", :x, :y) {
  def to_s
    "#{x},#{y}"
  end
  
  def flip
    Point2D.new(-x,-y)
  end
  
  def +(other)
    if other.is_a? Array
      other.map { |o| self + o }
    else
      Point2D.new(x + other.x, y + other.y)
    end
  end
  
  def -(other)
    if other.is_a? Array
      other.map { |o| self - o }
    else
      Point2D.new(x - other.x, y - other.y)
    end
  end
  
  # Scalar multiplication
  def *(other)
    Point2D.new(x * other, y * other)    
  end
  
  def manhattan(other)
    return (x - other.x).abs + (y - other.y).abs
  end
  
  # returns the euclidean distance to the given Point2D
  def dist(other)
    return ((x - other.x) ** 2 + (y - other.y) ** 2).sqrt
  end
  
  def area
    return x * y
  end
  
  def self.from_s(s)
  
    case s.upcase
      when 'E', 'RIGHT', 'R', '>'
        Point2D.new(+1,  0)
      when 'N', 'UP', 'TOP', 'T', 'U', '^'
        Point2D.new( 0, -1)
      when 'S', 'DOWN', 'BOTTOM', 'B', 'D', 'v', 'V'
        Point2D.new( 0, +1)
      when 'W', 'LEFT', 'L', '<'
        Point2D.new(-1,  0)
    else 
      raise s
    end
    
  end

  # Returns the component-wise minimum as a new Point2D
  #
  #   Point2D.new(5,2).min(Point2D.new(1,3)) == Point2D.new(1,2) -> true
  #
  def min(other)
    return self if !other
    
    if other.is_a? Array
      other.reduce(self) { |min, o| min.min(o) }
    else
      Point2D.new(Cem.min(x, other.x), Cem.min(y, other.y))
    end
  end
  
  # Returns the component-wise maximum as a new Point2D
  #
  #   Point2D.new(5,2).min(Point2D.new(1,3)) == Point2D.new(5,3) -> true
  #
  def max(other)
    return self if !other

    if other.is_a? Array
      other.reduce(self) { |max, o| max.max(o) }
    else
      Point2D.new(Cem.max(x, other.x), Cem.max(y, other.y))
    end
  end

  # Returns the minimum and maximum coordinates of this and the given point/point array.  
  def minmax(other)
    [self.min(other), self.max(other)]
  end
  
  # Returns the minimum and maximum coordinates of the point array. 
  def self.minmax(array)
    return [nil, nil] if !array || array.size == 0
    
    [array.reduce { |min, o| min.min(o) }, array.reduce { |max, o| max.max(o) } ]
  end
  
  def left 
    return self + Dir2D.LEFT
  end
  
  def left!
    x += Dir2D.LEFT.x
    y += Dir2D.LEFT.y
    return self
  end

  
  def to_dir_bitmask 
  
    if x == 0 && y == -1
      return 1
    elsif x == 1 && y == 0
      return 2
    elsif x == 0 && y == 1
      return 4
    elsif x == -1 && y == 0
      return 8
    else
      raise self.p
    end
  end
      
  def self.from_dir_bitmask(v) 
  
    result = []
    if v & 1 > 0
      result << Point2D.new(0, -1)
    end
    if v & 2 > 0
      result << Point2D.new(1, 0)
    end
    if v & 4 > 0
      result << Point2D.new(0, 1)
    end
    if v & 8 > 0
      result << Point2D.new(-1, 0)
    end
    return result
  end
  
  def <=>(other)
    y == other.y ? x <=> other.x : y <=> other.y
  end
  
  def ==(other)
    return false if !other.respond_to?(:x) || !other.respond_to?(:y)
    y == other.y && x == other.x
  end
}

Seg2D = Struct.new("Seg2D", :p1, :p2) {
  def to_s
    "#{p1},#{p2}"
  end
  
  def x_range
    if p1.x < p2.x 
      return p1.x..p2.x
    else
      return p2.x..p1.x
    end
  end
  
  def y_range
    if p1.y < p2.y 
      return p1.y..p2.y
    else
      return p2.y..p1.y
    end
  end
  
}

Dirs2D = [Point2D.new(0, -1), Point2D.new(1, 0), Point2D.new(0, 1), Point2D.new(-1, 0)]

class Dir2D < Point2D

  N = UP    = Dir2D.new( 0, -1)
  E = RIGHT = Dir2D.new( 1,  0)
  S = DOWN  = Dir2D.new( 0,  1)
  W = LEFT  = Dir2D.new(-1,  0)
  
  #
  # Dir2D * Range = array of Dir2D
  # E * (1..3) = [E, E*2, E*3]
  #
  def *(other)
    if other.is_a? Range
      other.to_a.map { |b| self * b }
    else
      super
    end  
  end
  
  def self.vert(length=1)
    return [N * (1..length), S * (1..length)].flatten
  end
  
  def self.hori(length=1)
    return [E * (1..length), W * (1..length)].flatten
  end
  
  def self.x(length=1)
    return vert(length) + hori(length)
  end

end
  

class Grid

  attr_accessor :data

  def initialize(x, y, default=0, &block)
    
    @data = []
    
    if block
    
      case block.arity
      when 0 
        y.times {
          row = []
          x.times {
            row << block.call()
          }
          @data << row
        }
      when 2 
        y.times { |iy|
          row = []
          x.times { |ix|
            row << block.call(iy, ix)
          }
          @data << row
        }
      else
        raise
      end
    
    else # if no block given
    
      y.times {
        row = []
        x.times {
          row << default
        }
        @data << row
      }
      # @data = [[default] * x] * y
    end
  end

  def initialize_copy(orig)
    super
    
    @data = Marshal.load(Marshal.dump(orig.data))
    # Do custom initialization for self
  end
  
  #
  # Given a list of Point2D, will create a Grid that contains all points.
  #
  # By default the grid will be recentered using the 'bottomleft'-most point.
  # Set :bounding_box to false to get coordinates transferred as is.
  #
  # By default all cells for which points are found are marked with an 'x'. 
  # Set :char to another character or supply a block which receives the point and should return the character to use.
  #
  # By default the empty cells are filled with spaces. Set :empty to something else to change this.
  #  
  def self.from_points(point_array, bounding_box=true, char='x', empty=' ', &block)
    
    min, max = Point2D.minmax(point_array)
    if !bounding_box
      min = Point2D.new(0,0)
    end
    
    result = Grid.new(max.x - min.x + 1, max.y - min.y + 1, empty)
    
    point_array.each { |p|
      result[p-min] = if block
        block.call(p)
      else
        char
      end
    }
    
    return result
  end
  
  def minmax(null=nil)
    min = nil
    max = nil
    
    @data.each_with_index { |l, y|
      l.each_with_index { |c, x|
       
        if c != null
          if min == nil || max == nil
            min = max = Point2D.new(x,y)
          end
          min = Point2D.new([min.x, x].min, [min.y, y].min)
          max = Point2D.new([max.x, x].max, [min.y, y].max)
        end
      }
    }
    
    return min, max
  end
    
  def [](y, x=nil)
    if x == nil
      # puts y.inspect
      if y.respond_to?(:x) && y.respond_to?(:y)
        return @data[y.y][y.x]
      end
      return @data[y]
    end
    
    if y.is_a? Range
      return @data[y].map { |row| row[x] }
    end
    return @data[y][x]
  end
  
  #
  # Array assignment to grid. 
  #
  #  grid[y,x]     = a    # Store a in row y and column x
  #  grid[point2d] = a    # Use point2d.y and point2d.x to store a
  #
  def []=(y, x, assign=nil)
    if assign == nil
      if y.respond_to?(:x) && y.respond_to?(:y)
        return @data[y.y][y.x] = x
      end
      return @data[y] = x
    end
    return @data[y][x] = assign
  end
  
  def to_a
    return @data.flatten
  end
    
  #
  # Returns the Point2Ds in the directions NSEW as an array (no diagonals, see adja_index for this)
  #
  # Will not return Point2Ds in case we are at the boundary of the Grid
  #
  def nsew_index(x,y=nil)
    
    # puts "#{@data.size} x #{@data[0].size}"
    
    if y == nil
      if x.respond_to?(:x) && x.respond_to?(:y)
        y = x.y
        x = x.x
      else
        raise "Need Point2D with :x and :y or two parameters"
      end
    end
  
    result = []
    if x > 0
      result << Point2D.new(x-1,y)
    end
    if y > 0
      result << Point2D.new(x,y-1)
    end
    if y + 1 < @data.size - 1
      result << Point2D.new(x, y+1)
    end
    if x + 1 < @data[0].size - 1
      result << Point2D.new(x+1,y)
    end
    return result
  end
  
  #
  # Will remove all invalid indices from the array
  # 
  def select_valid(a)
    a.select { |p|
      (p.x >= 0) && (p.y >= 0) && (p.y <= @data.size-1) && (p.x <= @data[0].size-1)
    }
  end
  
  def adja_index(x,y=nil)
    if y == nil
      if x.respond_to?(:x) && x.respond_to?(:y)
        y = x.y
        x = x.x
      else
        raise "Need Point2D with :x and :y or two parameters"
      end
    end
  
    result = []
    if x > 0
      if y > 0
        result << Point2D.new(x-1,y-1)
      end
      result << Point2D.new(x-1,y)
      if y + 1 < @data.size - 1
        result << Point2D.new(x-1, y+1)
      end
    end
    if y > 0
      result << Point2D.new(x,y-1)
    end
    
    # result << Point2D.new(x,y)
    
    if y + 1 < @data.size - 1
      result << Point2D.new(x, y+1)
    end
    if x + 1 < @data[0].size - 1
      if y > 0
        result << Point2D.new(x+1,y-1)
      end
      result << Point2D.new(x+1,y)
      if y + 1 < @data.size - 1
        result << Point2D.new(x+1, y+1)
      end
    end
    return result
  end
  
  def to_s
    printBoard()
  end
    
  #
  # returns a copy of the underlying 2D array, with linking to the content (rather than dup the content also)
  #
  def to_a
    @data.map { |row| row.dup }
  end
  
  def data
    @data
  end
  
  #
  # Maps each cell of the grid by the given block. 
  #
  # If block has...
  #  - one parameter, passes the cell value
  #  - two parameters, passes the coordinates as a Point2D and the cell value
  #  - three parameteres, passes y, x and the cell value
  #
  # If the block returns nil, the original value is kept.
  #
  def map_a(&block)
  
    case block.arity
      when 1 
        @data.map { |row| row.map { |value| block.call(value) || value } }
      when 2 
        @data.each_with_index.map { |row, y| row.each_with_index.map { |value, x| block.call(Point2D.new(x, y), value) || value } }
      when 3      
        @data.each_with_index.map { |row, y| row.each_with_index.map { |value, x| block.call(y, x, value) || value} }
      else
        raise
    end
  
  end
  
  def map_a!(&block)
    @data = map_a(&block)
  end
  
  def each(&block)
    @data.each { |row|
      row.each { |cell|
        block.call(cell)
      }
    }
  end
  
  def each_with_index(&block)    
    case block.arity
      when 2 
        @data.each_with_index { |l, y|
            l.each_with_index { |c, x|
              block.call(c, Point2D.new(x,y))
            }
          }
      
      when 3      
        @data.each_with_index { |l, y|
            l.each_with_index { |c, x|
              block.call(c, y, x)
            }
          }
      else
        raise
    end
  end
  
  def sum(&block)    
    sum = 0
    each { |cell|
      sum += block.call(cell)
    }
    return sum
  end
    
  def printBoard(overlay = nil)

    result = ""
    @data.each_with_index { |l, y|
      l.each_with_index { |c, x|
       
        if overlay 
          pos = Point2D.new(x,y)
          if overlay.has_key?(pos)
            result += overlay[pos]
          end
          next
        else
          result += c.to_s
        end
      }
      
      result += "\r\n"
    }
    return result
  end
  
end

Point3D = Struct.new("Point3D", :x, :y, :z) {

  def manhattan(other=nil)
    if other != nil
      return (self - other).manhattan
    end
    return x.abs + y.abs + z.abs
  end
  
  def -(other) Point3D.new(x - other.x, y - other.y, z - other.z) end
  
  def +(other) Point3D.new(x + other.x, y + other.y, z + other.z) end
  
  def to_s 
    "#{x}, #{y}, #{z}"   
  end
  
  def []=(i, v)
    case i
      when 0
        self.x = v
      when 1
        self.y = v
      when 2
        self.z = v
      else 
        raise
    end
  end
  
  def [](i)
    case i
      when 0
        x
      when 1
        y
      when 2
        z
      else 
        raise
    end
  end 
}
    
    

    