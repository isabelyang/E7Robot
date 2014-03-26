function [out] = my_robot(self, enemy, tank, mine)
%THE ROBOT THAT IS GOING TO WIN THE COMPETITION
%   Isabel Yang, Melody Jung, Handong Ling

self.fuel = self.fuel - (self.prev(1)^2 + self.prev(2)^2 + 2);

if self.pos(:) >= 20 && self.pos(:) <= 80
    if dist(self.pos, tank.pos) <= 2
        self.fuel = self.fuel + tank.val;
    end
    
    if dist(self.pos, mine.pos) <= 5
        self.fuel = self.fuel - mine.pos;
    end

elseif self.pos(:) >= 0 && self.pos(:) <= 100
    if dist(self.pos, tank.pos) <= 2
        self.fuel = self.fuel + tank.val;
    end
    
    if dist(self.pos, mine.pos) <= 5
        self.fuel = self.fuel - mine.pos;
    end
    
end

end
