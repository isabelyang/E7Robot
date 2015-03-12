function [out] = Belodong(self, enemy, tank, mine)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

%GSI BOT
%subfunctions

    %Radius Function
    function [x,y,goodcoord] = radius(tanks, r, self)
        
        %Distance Function
        function d = distance(x1, y1, x2, y2)
            d = sqrt( (x1 - x2 ) ^2 + (y1 - y2)^2);
        end
        
        
        coord2 = {};
        A = [];
        B = [];
        C = [];
        len = size(tanks);
        coord = [];
        for k = 1:len(2)
            for j = 1:len(2)
                dist = distance(tanks(k).pos(1), tanks(k).pos(2), tanks(j).pos(1), tanks(j).pos(2));
                distSelf = distance(tanks(j).pos(1), tanks(j).pos(2), self.pos(1), self.pos(2));
                if dist <= r
                    if tanks(j).pos(1) <= 80 && tanks(j).pos(1) >= 20 && tanks(j).pos(2) <= 80 && tanks(j).pos(2) >= 20
                        A = [A,tanks(j).val/(distSelf*10)];
                    else
                        A = [A,tanks(j).val/(distSelf)];
                    end 
                    coord = [coord; tanks(j).pos(:)'];
                end 
            end
            C = [C; tanks(k).pos(:)'];
            B = [B; sum(A)];
            A = [];
            coord2 = [coord2, coord];
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

params.speed_fuel = 3;
params.speed_end = 2.5;

    if ~isempty(tank)
        
        %Finds if tank exists within 25 spaces
        d = 25;
        Z = 0;
        for i = 1:length(tank)
            D = norm(tank(i).pos - self.pos);
            if tank(i).pos(1) < 80 && tank(i).pos(1) > 20 && tank(i).pos(2) < 80 && tank(i).pos(2) > 20
                D = D + 15;
            end
            if  D < 25
                if D < d
                    d = D;
                    Z = i;
                end
            end
        end
        
            
        %Move when enemy is out of fuel
        if enemy.fuel == 0 
            d = norm(self.pos - enemy.pos);

            % make movement toward enemy
            dx = (params.speed_end/d)*(enemy.pos(1)-self.pos(1));
            dy = (params.speed_end/d)*(enemy.pos(2)-self.pos(2));

            % assign output
            out = [dx, dy];
            
        %Move when enemy is closeby and has less fuel
        elseif enemy.fuel < self.fuel && norm(self.pos - enemy.pos) < 10 
            d = norm(self.pos - enemy.pos);
            dx = (params.speed_fuel/d)*(enemy.pos(1)-self.pos(1));
            dy = (params.speed_fuel/d)*(enemy.pos(2)-self.pos(2));

            out = [dx, dy];           
        %{
        %Move when enemy is closeby and has more fuel and is closer to tank
        elseif isempty(d) == 0 && (norm(self.pos - enemy.pos) < 10) && (self.fuel < enemy.fuel) && (norm(tank(Z).pos-self.pos) > norm(tank(Z).pos-enemy.pos))
            d = norm(self.pos - enemy.pos);
            dx = (params.speed_fuel/d)*(enemy.pos(1)-self.pos(1));
            dy = (params.speed_fuel/d)*(enemy.pos(2)-self.pos(2));

            out = [-dx, -dy];
            %}
        
        %Move when enemy is closeby and has more fuel and there is no fuel
        %tank
        elseif norm(self.pos - enemy.pos) < 8 && self.fuel < enemy.fuel 
            d = norm(self.pos - enemy.pos);
            dx = (params.speed_fuel/d)*(enemy.pos(1)-self.pos(1));
            dy = (params.speed_fuel/d)*(enemy.pos(2)-self.pos(2));

            out = [-dx, -dy];
   
        %If tank within 25, go toward tank          
        elseif d < 25
             dx = (params.speed_fuel/d)*(tank(Z).pos(1)-self.pos(1));
             dy = (params.speed_fuel/d)*(tank(Z).pos(2)-self.pos(2));
            
             out = [dx, dy];
             
        %Else run radius function
        else
            [tankPos1, tankPos2, coords] = radius(tank, 25, self);
            tankPos = [tankPos1, tankPos2];
            d = norm(tankPos - self.pos);
            dx = (params.speed_fuel/d)*(tankPos(1)-self.pos(1));
            dy = (params.speed_fuel/d)*(tankPos(2)-self.pos(2));
            
            if self.pos(1) > 20 && self.pos(1) < 80 &&self.pos(2) > 20 && self.pos(2) <80 && ((tankPos(1) > 80 || tankPos(1) < 20 || tankPos(2) < 20 || tankPos(2) > 80)) 
                if min( [81 - self.pos(1), self.pos(1) - 20, 81 - self.pos(2),self.pos(2) - 20]) == (81 - self.pos(1))
                    dy = 0;
                    dx = 3;
                elseif min( [81 - self.pos(1), self.pos(1) - 20, 81 - self.pos(2),self.pos(2) - 20]) == (self.pos(1) - 20)
                    dy = 0;
                    dx = -3;
                elseif min( [81 - self.pos(1), self.pos(1) - 20, 81 - self.pos(2),self.pos(2) - 20]) == (81 - self.pos(2))
                    dy = 3;
                    dx = 0;
                elseif min( [81 - self.pos(1), self.pos(1) - 20, 81 - self.pos(2),self.pos(2) - 20]) == (self.pos(2) - 20)
                    dy = -3;
                    dx = 0;
                end
                
            elseif (self.pos(1)+dx) >=20 && (self.pos(1)+dx) < 80 && (self.pos(2)+dy) >= 20 && (self.pos(2)+dy) < 80 && ((tankPos(1) > 80 || tankPos(1) < 20 || tankPos(2) < 20 || tankPos(2) > 80))
                if self.pos(2)<=20 %FIXED SHIT
                    if (dy/dx)>0 && (tankPos(1) >= 80)
                        dy=0; 
                        dx=3; 

                    elseif (dy/dx)<0 && (tankPos(1) < 20)
                        dy=0; 
                        dx=-3; 
                    else
                        if self.pos(1) <= 50
                            dx = -3;
                            dy = 0;
                        else 
                            dx = 3;
                            dy = 0;
                        end 
                    end

                elseif self.pos(2)>=80 
                    if (dy/dx)>0 && tankPos(1) < 20
                        dy=0; 
                        dx=-3;
                    elseif (dy/dx)<0 && tankPos(1) >= 80
                        dy=0;
                        dx=3;
                    else
                        if self.pos(1) <= 50
                            dx = -3;
                            dy = 0;
                        else 
                            dx = 3;
                            dy = 0;
                        end 
                    end

                elseif self.pos(1)<=20 %FIXED SHIT
                    if (dy/dx)>0 && tankPos(2) > 80
                        dy=3; 
                        dx=0; 

                    elseif (dy/dx)<0 && tankPos(2) < 20
                        dy=-3; 
                        dx=0;
                    else
                        if self.pos(2) <= 50
                            dx = 0;
                            dy = -3;
                        else 
                            dx = 0;
                            dy = 3;
                        end     
                    end

                elseif self.pos(1)>= 80 
                    if (dy/dx)<0 && tankPos(2) >= 80 
                        dy=3; 
                        dx=0; 

                    elseif (dy/dx)>0 && tankPos(2) <20 
                        dy=-3; 
                        dx=0; 
                    else
                        if self.pos(2) <= 50
                            dx = 0;
                            dy = -3;
                        else 
                            dx = 0;
                            dy = 3;
                        end    
                    
                    end
                else 
                    if self.pos(2) < 20 || self.pos(2) > 80
                        if self.pos(1) < 50
                            dx = -3;
                            dy = 0;
                        else 
                            dx = 3;
                            dy = 0;
                        end 
                    elseif self.pos(1) < 20 || self.pos(1) > 80
                        if self.pos(2) < 50
                            dx = 0;
                            dy = -3;
                        else 
                            dx = 0;
                            dy = 3;
                        end
                    end 
                end   
            end
                

            out = [dx, dy];
        end 

    else
        d = norm(self.pos - enemy.pos);
        dx = (params.speed_end/d)*(enemy.pos(1)-self.pos(1));
        dy = (params.speed_end/d)*(enemy.pos(2)-self.pos(2));
        
        if self.fuel >= enemy.fuel
            out = [dx, dy];
        else
            if self.pos(1) == 0 || self.pos(1) == 100
                out = [0, 0];
            elseif self.pos(2) == 0 || self.pos(2) == 100
                out = [0, 0];
            else
                out = [ -dx, -dy ];
            end
        end
    end
end
