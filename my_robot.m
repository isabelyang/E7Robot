function [out] = my_robot(self, enemy, tank, mine)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

%{
dTank = distance(self.pos(1), self.pos(2), tank.pos(1), tank.pos(2));
    
if dTank > 2 && dTank <= 5
    beforeGas = self.fuel
end

if dTank <= 2
    afterGas = self.fuel
end
%}

%GSI BOT

%functions
    function [x,y] = radius(tanks, r)

        function d = distance(x1, y1, x2, y2)
            d = sqrt( (x1 - x2 ) ^2 + (y1 - y2)^2);
        end
        
        A = [];
        B = [];
        C = [];
        
        for k = 1:length(tanks.pos)
            for j = 1:length(tanks.pos)
                if distance(tanks.pos(k,1), tanks.pos(k,2), tanks.pos(j, 1), tanks.pos(j,2)) <= r
                    A = [A,tanks.val(j)];
                end 
            end
            C = [C; tanks.pos(k,:)];
            B = [B; sum(A)];
            A = [];
        end

        maxB = max(B);
        ind=1;
        for k=1:length(B) 
            if B(k)==maxB
                ind=k;
            end
        end

        position = C(ind,:);        

        x = position(1);
        y = position(2);       

    end

params.speed_fuel = 3;
params.speed_end = 3;

    if ~isempty(tank)

        % start d at infinity
        %d = inf;
        %I = 0;

        % loop through fuel tanks checking if current fuel tank is
        % closer than previous closest.
        %{
        for i = 1:length(tank)

            % get distance to this fuel tank
            D = norm(tank(i).pos - self.pos);
            if  D < d
                d = D;
                I = i;
            end
        end
        %}

        
        tankPos = radius(tank, 25);
        % make movement towards closest fuel tank
        %dx = (params.speed_fuel/d)*(tank(I).pos(1)-self.pos(1));
        %dy = (params.speed_fuel/d)*(tank(I).pos(2)-self.pos(2));
        d = norm(tankPos - self.pos);
        dx = (params.speed_fuel/d)*(tankPos(1)-self.pos(1));
        dy = (params.speed_fuel/d)*(tankPos(2)-self.pos(2));
        
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
