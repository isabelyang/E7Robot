function [out] = Belodong(self, enemy, tank, mine)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

%GSI BOT

%functions
    function [x,y,goodcoord] = radius(tanks, r)

        function d = distance(x1, y1, x2, y2)

            d = sqrt( (x1 - x2 ) ^2 + (y1 - y2)^2);
        end
        coord2 = {};
        A = [];
        B = [];
        C = [];
        coord = [];
        for k = 1:length(tanks.pos)
            for j = 1:length(tanks.pos)
                if distance(tanks.pos(k,1), tanks.pos(k,2), tanks.pos(j, 1), tanks.pos(j,2)) <= r
                    A = [A,tanks.val(j)];
                    coord = [coord; tanks.pos(j,:)];
                end 
            end
            C = [C; tanks.pos(k,:)];
            B = [B; sum(A)];
            A = [];
            coord2 = [coord2,coord];
            coord = [];
        end

        maxB = max(B);
        ind=1;
        for k=1:length(B) 
            if B(k)==maxB
                ind=k;
            end
        end
        goodcoord = coord2{ind};
        position = C(ind,:);        

        x = position(1);
        y = position(2);       

    end

params.speed_fuel = 2;
params.speed_end = 2.5;

    if ~isempty(tank)
        
        tankPos = radius(tank, 25);
        % make movement towards closest fuel tank
        
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