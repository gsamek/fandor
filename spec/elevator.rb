class Elevator
  attr_accessor :floors, :current_floor, :request_queue, :direction
  
  def initialize (number_floors=10, current_floor=1)
    @floors = 1..number_floors
    @current_floor = current_floor
    @request_queue = []
    @direction = 0 # -1 for down, 0 for stopped, 1 for up
  end
  
  def call_request origin_floor, direction
    if @floors.member?(origin_floor) && (-1..1).member?(direction)
      @request_queue.push({'type'=>'call','floor'=>origin_floor, 'direction'=>direction})
    end
  end
  
  def floor_request floor
    if @floors.member?(floor)   
      @request_queue.push({'type'=>'request','floor'=>floor})
    end
  end
  
  # Move elevator to next requested floor based on request queue, return true if you visited that floor
  def move
    visited = false
    if @request_queue.length == 0
      visited = false
    else
      if @direction == 0
        # Set direction based on first item in queue  
        if @current_floor < @request_queue[0]['floor']
          @direction = 1
        elsif @current_floor > @request_queue[0]['floor']
          @direction = -1
        else
          # We are already on the requested floor, keep the direction 0, remove this request, we're done!
          @request_queue.shift
          visited = true
        end
      end
      # Move to next floor in current direction unless that is a floor out of our range
      if(@floors.member?(@current_floor + @direction))
        @current_floor += @direction
      else
        # don't move floors wait for new direction
        @direction = 0
      end
      # Are there any requests or calls for this floor
      if(@request_queue.find{|req| req['floor'] == @current_floor})
        visited = true
        # if this was a call request, we now change direction to match the request
        if(@request_queue.find{|req| (req['floor'] == @current_floor) && (req['type'] == 'call')})
          @direction = @request_queue.find{|req| (req['floor'] == @current_floor) && (req['type'] == 'call')}['direction']
        end
        # Remove requests for this new floor
        @request_queue.keep_if{|req| (req['floor'] != @current_floor)}
      end
      visited
    end
      
  end
  
  def start_elevator
    # track all the visited floors
    floors_visited = []
    # Current floor is visited by default
    floors_visited.push(@current_floor)
    
    #as long as there are floors requested or elevator calls made, keep going
    while @request_queue.length > 0 do
      if move
        floors_visited.push(@current_floor)
      end
    end
    
    return floors_visited
  end
end
