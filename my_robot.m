function [out] = my_robot(self, enemy, tank, mine)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

isabel.fuel = isabel.fuel - (isabel.prev(1)^2 + isabel.prev(2)^2 + 2);

if self.fuel == 0
    out = [0, 0];
end

if self.pos(:) >= 20 && self.pos(:) <= 80
    if dist(self.pos, tank.pos) <= 2 && self.fuel <= 1500
        self.fuel = self.fuel + tank.val;
    end
    
    if dist(self.pos, mine.pos) <= 5
        self.fuel = self.fuel - mine.pos;
    end

elseif self.pos(:) >= 0 && self.pos(:) <= 100
    if dist(self.pos, tank.pos) <= 2 && self.fuel <= 1500
        self.fuel = self.fuel + tank.val;
    end
    
    if dist(self.pos, mine.pos) <= 5
        self.fuel = self.fuel - mine.pos;
    end
    
 
end

end
