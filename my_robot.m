function [out] = my_robot(self, enemy, tank, mine)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

%{
    function d = distance(x1, y1, x2, y2)
        d = sqrt( (x1 - x2 ) ^2 + (y1 - y2)^2);
    end

dTank = distance(self.pos(1), self.pos(2), tank.pos(1), tank.pos(2));
    
if dTank > 2 && dTank <= 5
    beforeGas = self.fuel
end

if dTank <= 2
    afterGas = self.fuel
end
%}

%GSI BOT
params.speed_fuel = 2;
params.speed_end = 2.5;

if ~isempty(tank)
    
    % start d at infinity
    d = inf;
    I = 0;
    
    % loop through fuel tanks checking if current fuel tank is
    % closer than previous closest.
    for i = 1:length(tank)
        
        % get distance to this fuel tank
        D = norm(tank(i).pos - self.pos);
        if  D < d
            d = D;
            I = i;
        end
    end
    
    % make movement towards closest fuel tank
    dx = (params.speed_fuel/d)*(tank(I).pos(1)-self.pos(1));
    dy = (params.speed_fuel/d)*(tank(I).pos(2)-self.pos(2));
    
    % assign output
    out = [dx, dy];
    
else
    
    % get distance to enemy
    d = norm(self.pos - enemy.pos);
    
    % make movement toward enemy
    dx = (params.speed_end/d)*(enemy.pos(1)-self.pos(1));
    dy = (params.speed_end/d)*(enemy.pos(2)-self.pos(2));
    
    % assign output
    out = [dx, dy];
    
end

end
