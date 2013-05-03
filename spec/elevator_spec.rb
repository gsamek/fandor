require 'elevator'

describe "Elevator" do
  before (:each) do
    @e = Elevator.new(20)
  end
  
  describe "#call_request" do
    context "out of range call request" do
      before do
        @e.call_request(22, 1)
      end
      
      it "should still have an empty request queue" do
        @e.request_queue.should == []
      end
    end
    
    context "in range call request" do
      before do
        @e.call_request(17, -1)
      end
      
      it "should have a request queue length of 1" do
        @e.request_queue.length.should == 1
      end
    end
  end
  
  describe "#floor_request" do
    context "out of range floor request" do
      before do
        @e.floor_request(31)
      end
      
      it "should still have an empty request queue" do
        @e.request_queue.should == []
      end
    end
    
    context "in range floor request" do
      before do
        @e.floor_request(11)
      end
      
      it "should have a request queue length of 1" do
        @e.request_queue.length.should == 1
      end
    end
  end
  
  describe "#move" do
    context "elevator simple move" do
      before do
        @e.call_request(11, -1)
        20.times do
          @e.move
        end
      end
      
      it "should have a current floor of 11" do
        @e.current_floor.should == 11
      end
      
      it "should have an empty request queue" do
        @e.request_queue.length.should == 0
      end
    end
  end
  
  describe "#move" do
    context "elevator complete run" do
      before do
        @e.call_request(9, -1)
        @e.call_request(2, 1)
        @e.call_request(7, -1)
        @e.floor_request(5)
        @e.floor_request(1)
        @visited = @e.start_elevator
      end
  
      it "should visit all requested floors" do
        @visited.should == [1,2,5,7,1,9]
      end
    
      it "should have an empty request queue when done" do
        @e.request_queue.length.should == 0
      end
    end
  end
end
