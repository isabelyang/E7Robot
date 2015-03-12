function [out] = Belodong(self, enemy, tank, mine)

%subfunctions
%Radius Function
    function [x,y,Bfinal] = radius(tanks, r, self)
        
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
                dist = norm(tanks(k).pos-tanks(j).pos);
                distSelf = norm(tanks(j).pos - self.pos);
                if dist <= r
                    if tanks(j).pos(1) <= 80 && tanks(j).pos(1) >= 20 && tanks(j).pos(2) <= 80 && tanks(j).pos(2) >= 20
                        A = [A,tanks(j).val-(distSelf)*7];
                    else
                        A = [A,tanks(j).val - (distSelf)];
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
        Bfinal = B;
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

tankPos = [0, 0];
Z = 0;

if self.pos(1) >=20 && self.pos(1) <= 79 && self.pos(2) <= 79 && self.pos(2) >= 20
    params.speed_fuel = 1;
else
    params.speed_fuel = 2;
end


    if ~isempty(tank)       
        %Finds if tank exists within 25 spaces
        d = 15;
        for i = 1:length(tank)
            D = norm(tank(i).pos - self.pos);
            if tank(i).pos(1) < 80 && tank(i).pos(1) > 20 && tank(i).pos(2) < 80 && tank(i).pos(2) > 20
                D = D + 5;
            end
            if  D < 15
                if D < d
                    d = D;
                    Z = i;
                end
            end
        end        
           
        %Move when enemy is out of fuel
        if enemy.fuel == 0 
            if self.pos(1) >= 20 && self.pos(1) <= 79 && self.pos(2) >= 20 && self.pos(2) <= 79
                params.speed_fuel = 1;
            else
                params.speed_fuel = 1.5;
            end
            dx = (params.speed_fuel/d)*(enemy.pos(1)-self.pos(1));
            dy = (params.speed_fuel/d)*(enemy.pos(2)-self.pos(2));
            tankPos = enemy.pos;
            if Z == 0
                if self.pos(1) >= 20 && self.pos(1) < 81 &&self.pos(2) >= 20 && self.pos(2) <81 && ((enemy.pos(1) >= 81 || enemy.pos(1) < 20 || enemy.pos(2) < 20 || enemy.pos(2) >= 81)) 
                    if min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (81 - self.pos(1))
                        dy = 0;
                        dx = params.speed_fuel;
                    elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (self.pos(1) - 19)
                        dy = 0;
                        dx = -params.speed_fuel;
                    elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (81 - self.pos(2))
                        dy = params.speed_fuel;
                        dx = 0;
                    elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (self.pos(2) - 19)
                        dy = -params.speed_fuel;
                        dx = 0;
                    end
                elseif tankPos(1) >= 20 && tankPos(1) <= 80 && tankPos(2) >= 20 && tankPos(2) <= 80 && (self.pos(1) < 20 || self.pos(1) > 80 || self.pos(2) < 20 || self.pos(2) > 80)
                    if min( [81 - tankPos(1), tankPos(1) - 19, 81 - tankPos(2),tankPos(2) - 19]) == (81 - tankPos(1))
                        tankPos = [81,tankPos(2)];
                    elseif min( [81 - tankPos(1), tankPos(1) - 19, 81 - tankPos(2),tankPos(2) - 19]) == (tankPos(1) - 19)
                        tankPos = [19,tankPos(2)];
                    elseif min( [80 - tankPos(1), tankPos(1) - 19, 81 - tankPos(2),tankPos(2) - 19]) == (81 - tankPos(2))
                        tankPos = [tankPos(1), 81]; 
                    elseif min( [81 - tankPos(1), tankPos(1) - 19, 81 - tankPos(2),tankPos(2) - 19]) == (tankPos(2) - 19)
                        tankPos = [tankPos(1), 19];
                    end 
                end 

                if tankPos(1) == 19 || tankPos(1) == 81 || tankPos(2) == 19 || tankPos(2) == 81
                    if self.pos(1) < 20 && tankPos(1) == 19
                        tankPos = [20,tankPos(2)];
                        dx = -params.speed_fuel/norm(tankPos-self.pos)*(self.pos(1)-tankPos(1));
                        dy = -params.speed_fuel/norm(tankPos-self.pos)*(self.pos(2)-tankPos(2));
                    elseif self.pos(1) > 80 && tankPos(1) == 81
                        tankPos = [80,tankPos(2)];
                        dx = -params.speed_fuel/norm(tankPos-self.pos)*(self.pos(1)-tankPos(1));
                        dy = -params.speed_fuel/norm(tankPos-self.pos)*(self.pos(2)-tankPos(2));
                    elseif self.pos(2) < 20 && tankPos(2) == 19
                        tankPos = [tankPos(1), 20];
                        dx = -params.speed_fuel/norm(tankPos-self.pos)*(self.pos(1)-tankPos(1));
                        dy = -params.speed_fuel/norm(tankPos-self.pos)*(self.pos(2)-tankPos(2));
                    elseif self.pos(2) > 80 && tankPos(2) == 81
                        tankPos = [tankPos(1), 80];
                        dx = -params.speed_fuel/norm(tankPos-self.pos)*(self.pos(1)-tankPos(1));
                        dy = -params.speed_fuel/norm(tankPos-self.pos)*(self.pos(2)-tankPos(2));
                    elseif self.pos(1) >= 20 && self.pos(1) < 81 &&self.pos(2) >= 20 && self.pos(2) <81 && ((tankPos(1) >= 81 || tankPos(1) < 20 || tankPos(2) < 20 || tankPos(2) >= 81)) 
                        if min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (81 - self.pos(1))
                            dy = 0;
                            dx = params.speed_fuel;
                        elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (self.pos(1) - 19)
                            dy = 0;
                            dx = -params.speed_fuel;
                        elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (81 - self.pos(2))
                            dy = params.speed_fuel;
                            dx = 0;
                        elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (self.pos(2) - 19)
                            dy = -params.speed_fuel;
                            dx = 0;
                        end   
                    elseif self.pos(1) < 20 && self.pos(2) >= 20 && self.pos(2) <= 80
                        if (tankPos(2) < (((80-self.pos(2))/(20-self.pos(1))*(tankPos(1)-self.pos(1))+self.pos(2)))) && tankPos(1) >= 20 && (tankPos(2) > (self.pos(2) + (20 - self.pos(2))/(20-self.pos(1))*(tankPos(1)-self.pos(1))))
                            if tankPos(2) >50
                                dx = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(1)-19);
                                dy = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(2)-81);
                            else
                                dx = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(1)-19);
                                dy = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(2)-19);
                            end
                        end

                    elseif self.pos(1) > 80 && self.pos(2) >= 20 && self.pos(2) <= 80
                        if (tankPos(2) < ((80 - self.pos(2))/(80-self.pos(1))*(tankPos(1)-self.pos(1))+self.pos(2))) && tankPos(1) <= 80 && (tankPos(2) > (self.pos(2) + (self.pos(2)-20)/(80-self.pos(1))*(self.pos(1)-tankPos(1))))
                            if tankPos(2) >50
                                dx = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(1)-81);
                                dy = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(2)-81);
                            else
                                dx = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(1)-81);
                                dy = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(2)-19);
                            end 
                        end

                   elseif self.pos(2) < 20 && self.pos(1) >= 20 && self.pos(1) <= 80
                        if (tankPos(1) < (((80-self.pos(1))/(20-self.pos(2))*(tankPos(2)-self.pos(2))+self.pos(1)))) && tankPos(2) >= 20 && tankPos(1) > ((self.pos(1)  + (self.pos(1) - 20)/(self.pos(2)-20)*(tankPos(2)- self.pos(2))))
                            if tankPos(1) >50
                                dx = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(1)-81);
                                dy = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(2)-19);
                            else
                                dx = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(1)-19);
                                dy = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(2)-19);
                            end 
                        end
                   elseif self.pos(2) > 80 && self.pos(1) >= 20 && self.pos(1) <= 80
                        if (tankPos(1) < ((80 - self.pos(1))/(80-self.pos(2))*(tankPos(2)-self.pos(2))+self.pos(1))) && tankPos(2) <= 80 && (tankPos(1) > (self.pos(1) + (self.pos(1)-20)/(80-self.pos(2))*(self.pos(2) - tankPos(2)))) 
                            if tankPos(1) >50
                                dx = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(1)-81);
                                dy = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(2)-81);
                            else
                                dx = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(1)-19);
                                dy = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(2)-81);
                            end 
                        end
                        % Movement while in Corners
                    elseif self.pos(1) < 20 && self.pos(2) < 20 
                        if tankPos(2) > (20 - self.pos(2))/(80 - self.pos(1))*(tankPos(1)-(self.pos(1))) + self.pos(2) && tankPos(2) < (80 - self.pos(2))/(20 - self.pos(1))*(tankPos(1) - self.pos(1)) + tankPos(2) && tankPos(1) >= 20 && tankPos(2) >= 20
                            if norm(tankPos - [20,80]) < norm(tankPos - [80,20])
                                dx = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(1)-19);
                                dy = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(2)-81);
                            else 
                                dx = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(1)-81);
                                dy = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(2)-19);
                            end 
                        end 
                    elseif self.pos(1) < 20 && self.pos(2) > 80 
                        if tankPos(2) < (80 - self.pos(2))/(self.pos(1)-80)*(tankPos(1)-(self.pos(1))) + self.pos(2) && tankPos(2) > (self.pos(2)-20)/(20 - self.pos(1))*(tankPos(1) - self.pos(1)) + tankPos(2) && tankPos(1) >= 20 && tankPos(2) <= 80
                            if norm(tankPos - [80,80]) < norm(tankPos - [20,20])
                                dx = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(1)-81);
                                dy = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(2)-81);
                            else 
                                dx = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(1)-19);
                                dy = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(2)-19);
                            end 
                        end   
                    elseif self.pos(1) >80 && self.pos(2) > 80 
                        if tankPos(2) < (self.pos(2)-80)/(20-self.pos(1))*((self.pos(1)-tankPos(1))) + self.pos(2) && tankPos(2) > (self.pos(2)-20)/(80 - self.pos(1))*(tankPos(1) - self.pos(1)) + tankPos(2) && tankPos(1) <= 80 && tankPos(2) <= 80
                            if norm(tankPos - [20,80]) < norm(tankPos - [80,20])
                                dx = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(1)-19);
                                dy = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(2)-81);
                            else 
                                dx = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(1)-81);
                                dy = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(2)-19);
                            end 
                        end
                    elseif self.pos(1) >80 && self.pos(2) <20 
                        if tankPos(2) < (80-self.pos(2))/(20-self.pos(1))*((self.pos(1)-tankPos(1))) + self.pos(2) && tankPos(2) > (20 - self.pos(2))/(20 - self.pos(1))*(tankPos(1) - self.pos(1)) + tankPos(2) && tankPos(1) <= 80 && tankPos(2) >= 20 
                            if norm(tankPos - [80,80]) < norm(tankPos - [20,20])
                                dx = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(1)-81);
                                dy = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(2)-81);
                            else 
                                dx = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(1)-19);
                                dy = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(2)-19);
                            end 
                        end 
                    end

            else
                if self.pos(1) < 20 && self.pos(2) >= 20 && self.pos(2) <= 80
                    if (enemy.pos(2) < (((80-self.pos(2))/(20-self.pos(1))*(enemy.pos(1)-self.pos(1))+self.pos(2)))) && enemy.pos(1) >= 20 && (enemy.pos(2) > (self.pos(2) + (20 - self.pos(2))/(20-self.pos(1))*(enemy.pos(1)-self.pos(1))))
                        if enemy.pos(2) >50
                            dx = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(2)-81);
                        else
                            dx = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(2)-19);
                        end
                    end

                elseif self.pos(1) > 80 && self.pos(2) >= 20 && self.pos(2) <= 80
                    if (enemy.pos(2) < ((80 - self.pos(2))/(80-self.pos(1))*(enemy.pos(1)-self.pos(1))+self.pos(2))) && enemy.pos(1) <= 80 && (enemy.pos(2) > (self.pos(2) + (self.pos(2)-20)/(80-self.pos(1))*(self.pos(1)-enemy.pos(1))))
                        if enemy.pos(2) >50
                            dx = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(2)-81);
                        else
                            dx = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end

                elseif self.pos(2) < 20 && self.pos(1) >= 20 && self.pos(1) <= 80
                    if (enemy.pos(1) < (((80-self.pos(1))/(20-self.pos(2))*(enemy.pos(2)-self.pos(2))+self.pos(1)))) && enemy.pos(2) >= 20 && enemy.pos(1) > ((self.pos(1)  + (self.pos(1) - 20)/(self.pos(2)-20)*(enemy.pos(2)- self.pos(2))))
                        if enemy.pos(1) >50
                            dx = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(2)-19);
                        else
                            dx = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end
                elseif self.pos(2) > 80 && self.pos(1) >= 20 && self.pos(1) <= 80
                    if (enemy.pos(1) < ((80 - self.pos(1))/(80-self.pos(2))*(enemy.pos(2)-self.pos(2))+self.pos(1))) && enemy.pos(2) <= 80 && (enemy.pos(1) > (self.pos(1) + (self.pos(1)-20)/(80-self.pos(2))*(self.pos(2) - enemy.pos(2)))) 
                        if enemy.pos(1) >50
                            dx = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(2)-81);
                        else
                            dx = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(2)-81);
                        end 
                    end
                    % Movement while in Corners
                elseif self.pos(1) < 20 && self.pos(2) < 20 
                    if enemy.pos(2) > (20 - self.pos(2))/(80 - self.pos(1))*(enemy.pos(1)-(self.pos(1))) + self.pos(2) && enemy.pos(2) < (80 - self.pos(2))/(20 - self.pos(1))*(enemy.pos(1) - self.pos(1)) + enemy.pos(2) && enemy.pos(1) >= 20 && enemy.pos(2) >= 20
                        if norm(enemy.pos - [20,80]) < norm(enemy.pos - [80,20])
                            dx = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(2)-81);
                        else 
                            dx = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end 
                elseif self.pos(1) < 20 && self.pos(2) > 80 
                    if enemy.pos(2) < (80 - self.pos(2))/(self.pos(1)-80)*(enemy.pos(1)-(self.pos(1))) + self.pos(2) && enemy.pos(2) > (self.pos(2)-20)/(20 - self.pos(1))*(enemy.pos(1) - self.pos(1)) + enemy.pos(2) && enemy.pos(1) >= 20 && enemy.pos(2) <= 80
                        if norm(enemy.pos - [80,80]) < norm(enemy.pos - [20,20])
                            dx = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(2)-81);
                        else 
                            dx = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end   
                elseif self.pos(1) >80 && self.pos(2) > 80 
                    if enemy.pos(2) < (self.pos(2)-80)/(20-self.pos(1))*((self.pos(1)-enemy.pos(1))) + self.pos(2) && enemy.pos(2) > (self.pos(2)-20)/(80 - self.pos(1))*(enemy.pos(1) - self.pos(1)) + enemy.pos(2) && enemy.pos(1) <= 80 && enemy.pos(2) <= 80
                        if norm(enemy.pos - [20,80]) < norm(enemy.pos - [80,20])
                            dx = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(2)-81);
                        else 
                            dx = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end
                elseif self.pos(1) >80 && self.pos(2) <20 
                    if enemy.pos(2) < (80-self.pos(2))/(20-self.pos(1))*((self.pos(1)-enemy.pos(1))) + self.pos(2) && enemy.pos(2) > (20 - self.pos(2))/(20 - self.pos(1))*(enemy.pos(1) - self.pos(1)) + enemy.pos(2) && enemy.pos(1) <= 80 && enemy.pos(2) >= 20 
                        if norm(enemy.pos - [80,80]) < norm(enemy.pos - [20,20])
                            dx = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(2)-81);
                        else 
                            dx = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end
                end
                end
            
                
                if Z ~= 0
                d = norm(self.pos - tank(Z).pos);
                dx = (params.speed_fuel/d)*(tank(Z).pos(1)-self.pos(1));
                dy = (params.speed_fuel/d)*(tank(Z).pos(2)-self.pos(2));
                end
            
            % assign output
            out = [dx, dy];
            end
           
         %one more fuel tank
        elseif length(tank) == 1
            d = norm(self.pos - tank.pos);
            if norm(self.pos - tank.pos) > norm(enemy.pos - tank.pos)
                if self.pos(1) >= 20 && self.pos(1) <= 80 && self.pos(2) >= 20 && self.pos(2) <= 80
                     if min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (81 - self.pos(1))
                        dy = 0;
                        dx = params.speed_fuel;
                    elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (self.pos(1) - 19)
                        dy = 0;
                        dx = -params.speed_fuel;
                    elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (81 - self.pos(2))
                        dy = params.speed_fuel;
                        dx = 0;
                    elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (self.pos(2) - 19)
                        dy = -params.speed_fuel;
                        dx = 0;
                     end 
                else
                    if enemy.fuel > 0
                        dx = 0;
                        dy = 0;
                    end

                end
                out = [dx, dy];
                return
            elseif norm(self.pos - tank.pos) < 3 && (self.fuel + tank.val) > enemy.fuel
                dx = 0;
                dy = 0;
                if tank.pos(1) >= 20 && tank.pos(1) <= 80 && tank.pos(2) >= 20 && tank.pos(2) <=80
                    if norm(enemy.pos - tank.pos) < 20
                        dx = (params.speed_fuel/d)*(tank.pos(1)-self.pos(1));
                        dy = (params.speed_fuel/d)*(tank.pos(2)-self.pos(2));
                    end
                elseif norm(enemy.pos - tank.pos) < 15
                    dx = (params.speed_fuel/d)*(tank.pos(1)-self.pos(1));
                    dy = (params.speed_fuel/d)*(tank.pos(2)-self.pos(2));
                end
            else
                dx = (params.speed_fuel/d)*(tank.pos(1)-self.pos(1));
                dy = (params.speed_fuel/d)*(tank.pos(2)-self.pos(2));
            end
            out = [dx, dy];
            
        %Move when enemy is closeby and has less fuel
        elseif enemy.fuel < self.fuel && norm(self.pos - enemy.pos) < 10 
            d = norm(self.pos - enemy.pos);
            dx = (params.speed_fuel/d)*(enemy.pos(1)-self.pos(1));
            dy = (params.speed_fuel/d)*(enemy.pos(2)-self.pos(2));

            out = [dx, dy]; 
            
        %Move when enemy is closeby and has less fuel and there are no more
        %fuel tanks
        elseif enemy.fuel < self.fuel && norm(self.pos - enemy.pos) < 10 && isempty(tank) == 1
            params.speed_fuel = 1.5;
            d = norm(self.pos - enemy.pos);
            dx = (params.speed_fuel/d)*(enemy.pos(1)-self.pos(1));
            dy = (params.speed_fuel/d)*(enemy.pos(2)-self.pos(2));

            out = [dx, dy]; 
   
        %If tank within 25, go toward tank          
        
        elseif d < 15
            d = norm(self.pos - tank(Z).pos);
            if self.fuel + tank(Z).val >= 1500 && norm(self.pos - tank(Z).pos) <= 3
                dy = 0;
                dx = 0;
            else
                dx = (params.speed_fuel/d)*(tank(Z).pos(1)-self.pos(1));
                dy = (params.speed_fuel/d)*(tank(Z).pos(2)-self.pos(2));
            end
             out = [dx, dy];
             
        else
                     
            [tankPos1, tankPos2, values] = radius(tank, 25, self);
            tankPos = [tankPos1, tankPos2];          
            values;
            d = norm(tankPos - self.pos);
            if self.pos(1) >=20 && self.pos(1) <= 79 && self.pos(2) <= 79 && self.pos(2) >= 20
                params.speed_fuel = 1;
            else
                params.speed_fuel = 2.5;
            end
            
            dx = (params.speed_fuel/d)*(tankPos(1)-self.pos(1));
            dy = (params.speed_fuel/d)*(tankPos(2)-self.pos(2));
            if max(values) <= 0
                if self.pos(1) >= 20 && self.pos(1) <= 80 && self.pos(2) >= 20 && self.pos(2) <= 80
                     if min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (81 - self.pos(1))
                        dy = 0;
                        dx = params.speed_fuel;
                    elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (self.pos(1) - 19)
                        dy = 0;
                        dx = -params.speed_fuel;
                    elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (81 - self.pos(2))
                        dy = params.speed_fuel;
                        dx = 0;
                    elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (self.pos(2) - 19)
                        dy = -params.speed_fuel;
                        dx = 0;
                     end 
                else
                    if enemy.fuel > 0
                        dx = 0;
                        dy = 0;
                    end

                end
                out = [dx, dy];
                return
            end
            
              
                if self.pos(1) >= 20 && self.pos(1) < 81 &&self.pos(2) >= 20 && self.pos(2) <81 && ((tankPos(1) >= 81 || tankPos(1) < 20 || tankPos(2) < 20 || tankPos(2) >= 81)) 
                    if min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (81 - self.pos(1))
                        dy = 0;
                        dx = params.speed_fuel;
                    elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (self.pos(1) - 19)
                        dy = 0;
                        dx = -params.speed_fuel;
                    elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (81 - self.pos(2))
                        dy = params.speed_fuel;
                        dx = 0;
                    elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (self.pos(2) - 19)
                        dy = -params.speed_fuel;
                        dx = 0;
                    end 
                    
            
            
                % going for a tank in the sticky zone 
                
                elseif tankPos(1) >= 20 && tankPos(1) <= 80 && tankPos(2) >= 20 && tankPos(2) <= 80 && (self.pos(1) < 20 || self.pos(1) > 80 || self.pos(2) < 20 || self.pos(2) > 80)
                if min( [81 - tankPos(1), tankPos(1) - 19, 81 - tankPos(2),tankPos(2) - 19]) == (81 - tankPos(1))
                    tankPos = [81,tankPos(2)];
                elseif min( [81 - tankPos(1), tankPos(1) - 19, 81 - tankPos(2),tankPos(2) - 19]) == (tankPos(1) - 19)
                    tankPos = [19,tankPos(2)];
                elseif min( [80 - tankPos(1), tankPos(1) - 19, 81 - tankPos(2),tankPos(2) - 19]) == (81 - tankPos(2))
                    tankPos = [tankPos(1), 81]; 
                elseif min( [81 - tankPos(1), tankPos(1) - 19, 81 - tankPos(2),tankPos(2) - 19]) == (tankPos(2) - 19)
                    tankPos = [tankPos(1), 19];
                end 
            end 
                        
            if tankPos(1) == 19 || tankPos(1) == 81 || tankPos(2) == 19 || tankPos(2) == 81
                if self.pos(1) < 20 && tankPos(1) == 19
                    tankPos = [20,tankPos(2)];
                    dx = -params.speed_fuel/norm(tankPos-self.pos)*(self.pos(1)-tankPos(1));
                    dy = -params.speed_fuel/norm(tankPos-self.pos)*(self.pos(2)-tankPos(2));
                elseif self.pos(1) > 80 && tankPos(1) == 81
                    tankPos = [80,tankPos(2)];
                    dx = -params.speed_fuel/norm(tankPos-self.pos)*(self.pos(1)-tankPos(1));
                    dy = -params.speed_fuel/norm(tankPos-self.pos)*(self.pos(2)-tankPos(2));
                elseif self.pos(2) < 20 && tankPos(2) == 19
                    tankPos = [tankPos(1), 20];
                    dx = -params.speed_fuel/norm(tankPos-self.pos)*(self.pos(1)-tankPos(1));
                    dy = -params.speed_fuel/norm(tankPos-self.pos)*(self.pos(2)-tankPos(2));
                elseif self.pos(2) > 80 && tankPos(2) == 81
                    tankPos = [tankPos(1), 80];
                    dx = -params.speed_fuel/norm(tankPos-self.pos)*(self.pos(1)-tankPos(1));
                    dy = -params.speed_fuel/norm(tankPos-self.pos)*(self.pos(2)-tankPos(2));
                elseif self.pos(1) >= 20 && self.pos(1) < 81 &&self.pos(2) >= 20 && self.pos(2) <81 && ((tankPos(1) >= 81 || tankPos(1) < 20 || tankPos(2) < 20 || tankPos(2) >= 81)) 
                    if min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (81 - self.pos(1))
                        dy = 0;
                        dx = params.speed_fuel;
                    elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (self.pos(1) - 19)
                        dy = 0;
                        dx = -params.speed_fuel;
                    elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (81 - self.pos(2))
                        dy = params.speed_fuel;
                        dx = 0;
                    elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (self.pos(2) - 19)
                        dy = -params.speed_fuel;
                        dx = 0;
                    end   
                elseif self.pos(1) < 20 && self.pos(2) >= 20 && self.pos(2) <= 80
                    if (tankPos(2) < (((80-self.pos(2))/(20-self.pos(1))*(tankPos(1)-self.pos(1))+self.pos(2)))) && tankPos(1) >= 20 && (tankPos(2) > (self.pos(2) + (20 - self.pos(2))/(20-self.pos(1))*(tankPos(1)-self.pos(1))))
                        if tankPos(2) >50
                            dx = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(2)-81);
                        else
                            dx = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(2)-19);
                        end
                    end

                elseif self.pos(1) > 80 && self.pos(2) >= 20 && self.pos(2) <= 80
                    if (tankPos(2) < ((80 - self.pos(2))/(80-self.pos(1))*(tankPos(1)-self.pos(1))+self.pos(2))) && tankPos(1) <= 80 && (tankPos(2) > (self.pos(2) + (self.pos(2)-20)/(80-self.pos(1))*(self.pos(1)-tankPos(1))))
                        if tankPos(2) >50
                            dx = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(2)-81);
                        else
                            dx = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end

               elseif self.pos(2) < 20 && self.pos(1) >= 20 && self.pos(1) <= 80
                    if (tankPos(1) < (((80-self.pos(1))/(20-self.pos(2))*(tankPos(2)-self.pos(2))+self.pos(1)))) && tankPos(2) >= 20 && tankPos(1) > ((self.pos(1)  + (self.pos(1) - 20)/(self.pos(2)-20)*(tankPos(2)- self.pos(2))))
                        if tankPos(1) >50
                            dx = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(2)-19);
                        else
                            dx = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end
               elseif self.pos(2) > 80 && self.pos(1) >= 20 && self.pos(1) <= 80
                    if (tankPos(1) < ((80 - self.pos(1))/(80-self.pos(2))*(tankPos(2)-self.pos(2))+self.pos(1))) && tankPos(2) <= 80 && (tankPos(1) > (self.pos(1) + (self.pos(1)-20)/(80-self.pos(2))*(self.pos(2) - tankPos(2)))) 
                        if tankPos(1) >50
                            dx = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(2)-81);
                        else
                            dx = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(2)-81);
                        end 
                    end
                    % Movement while in Corners
                elseif self.pos(1) < 20 && self.pos(2) < 20 
                    if tankPos(2) > (20 - self.pos(2))/(80 - self.pos(1))*(tankPos(1)-(self.pos(1))) + self.pos(2) && tankPos(2) < (80 - self.pos(2))/(20 - self.pos(1))*(tankPos(1) - self.pos(1)) + tankPos(2) && tankPos(1) >= 20 && tankPos(2) >= 20
                        if norm(tankPos - [20,80]) < norm(tankPos - [80,20])
                            dx = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(2)-81);
                        else 
                            dx = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end 
                elseif self.pos(1) < 20 && self.pos(2) > 80 
                    if tankPos(2) < (80 - self.pos(2))/(self.pos(1)-80)*(tankPos(1)-(self.pos(1))) + self.pos(2) && tankPos(2) > (self.pos(2)-20)/(20 - self.pos(1))*(tankPos(1) - self.pos(1)) + tankPos(2) && tankPos(1) >= 20 && tankPos(2) <= 80
                        if norm(tankPos - [80,80]) < norm(tankPos - [20,20])
                            dx = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(2)-81);
                        else 
                            dx = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end   
                elseif self.pos(1) >80 && self.pos(2) > 80 
                    if tankPos(2) < (self.pos(2)-80)/(20-self.pos(1))*((self.pos(1)-tankPos(1))) + self.pos(2) && tankPos(2) > (self.pos(2)-20)/(80 - self.pos(1))*(tankPos(1) - self.pos(1)) + tankPos(2) && tankPos(1) <= 80 && tankPos(2) <= 80
                        if norm(tankPos - [20,80]) < norm(tankPos - [80,20])
                            dx = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(2)-81);
                        else 
                            dx = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end
                elseif self.pos(1) >80 && self.pos(2) <20 
                    if tankPos(2) < (80-self.pos(2))/(20-self.pos(1))*((self.pos(1)-tankPos(1))) + self.pos(2) && tankPos(2) > (20 - self.pos(2))/(20 - self.pos(1))*(tankPos(1) - self.pos(1)) + tankPos(2) && tankPos(1) <= 80 && tankPos(2) >= 20 
                        if norm(tankPos - [80,80]) < norm(tankPos - [20,20])
                            dx = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(2)-81);
                        else 
                            dx = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end 
                end
            
                    
               
                
            %START OF HANDONG'S CODE    
        elseif self.pos(1) >= 20 && self.pos(1) < 81 &&self.pos(2) >= 20 && self.pos(2) <81 && ((tankPos(1) >= 81 || tankPos(1) < 20 || tankPos(2) < 20 || tankPos(2) >= 81)) 
                if min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (81 - self.pos(1))
                    dy = 0;
                    dx = params.speed_fuel;
                elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (self.pos(1) - 19)
                    dy = 0;
                    dx = -params.speed_fuel;
                elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (81 - self.pos(2))
                    dy = params.speed_fuel;
                    dx = 0;
                elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (self.pos(2) - 19)
                    dy = -params.speed_fuel;
                    dx = 0;
                end   

                elseif self.pos(1) < 20 && self.pos(2) >= 20 && self.pos(2) <= 80
                    if (tankPos(2) < (((80-self.pos(2))/(20-self.pos(1))*(tankPos(1)-self.pos(1))+self.pos(2)))) && tankPos(1) >= 20 && (tankPos(2) > (self.pos(2) + (20 - self.pos(2))/(20-self.pos(1))*(tankPos(1)-self.pos(1))))
                        if tankPos(2) >50
                            dx = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(2)-81);
                        else
                            dx = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(2)-19);
                        end
                    end

                elseif self.pos(1) > 80 && self.pos(2) >= 20 && self.pos(2) <= 80
                    if (tankPos(2) < ((80 - self.pos(2))/(80-self.pos(1))*(tankPos(1)-self.pos(1))+self.pos(2))) && tankPos(1) <= 80 && (tankPos(2) > (self.pos(2) + (self.pos(2)-20)/(80-self.pos(1))*(self.pos(1)-tankPos(1))))
                        if tankPos(2) >50
                            dx = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(2)-81);
                        else
                            dx = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end

               elseif self.pos(2) < 20 && self.pos(1) >= 20 && self.pos(1) <= 80
                    if (tankPos(1) < (((80-self.pos(1))/(20-self.pos(2))*(tankPos(2)-self.pos(2))+self.pos(1)))) && tankPos(2) >= 20 && tankPos(1) > ((self.pos(1)  + (self.pos(1) - 20)/(self.pos(2)-20)*(tankPos(2)- self.pos(2))))
                        if tankPos(1) >50
                            dx = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(2)-19);
                        else
                            dx = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end
               elseif self.pos(2) > 80 && self.pos(1) >= 20 && self.pos(1) <= 80
                    if (tankPos(1) < ((80 - self.pos(1))/(80-self.pos(2))*(tankPos(2)-self.pos(2))+self.pos(1))) && tankPos(2) <= 80 && (tankPos(1) > (self.pos(1) + (self.pos(1)-20)/(80-self.pos(2))*(self.pos(2) - tankPos(2)))) 
                        if tankPos(1) >50
                            dx = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(2)-81);
                        else
                            dx = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(2)-81);
                        end 
                    end
                    % Movement while in Corners
                elseif self.pos(1) < 20 && self.pos(2) < 20 
                    if tankPos(2) > (20 - self.pos(2))/(80 - self.pos(1))*(tankPos(1)-(self.pos(1))) + self.pos(2) && tankPos(2) < (80 - self.pos(2))/(20 - self.pos(1))*(tankPos(1) - self.pos(1)) + tankPos(2) && tankPos(1) >= 20 && tankPos(2) >= 20
                        if norm(tankPos - [20,80]) < norm(tankPos - [80,20])
                            dx = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(2)-81);
                        else 
                            dx = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end 
                elseif self.pos(1) < 20 && self.pos(2) > 80 
                    if tankPos(2) < (80 - self.pos(2))/(self.pos(1)-80)*(tankPos(1)-(self.pos(1))) + self.pos(2) && tankPos(2) > (self.pos(2)-20)/(20 - self.pos(1))*(tankPos(1) - self.pos(1)) + tankPos(2) && tankPos(1) >= 20 && tankPos(2) <= 80
                        if norm(tankPos - [80,80]) < norm(tankPos - [20,20])
                            dx = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(2)-81);
                        else 
                            dx = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end   
                elseif self.pos(1) >80 && self.pos(2) > 80 
                    if tankPos(2) < (self.pos(2)-80)/(20-self.pos(1))*((self.pos(1)-tankPos(1))) + self.pos(2) && tankPos(2) > (self.pos(2)-20)/(80 - self.pos(1))*(tankPos(1) - self.pos(1)) + tankPos(2) && tankPos(1) <= 80 && tankPos(2) <= 80
                        if norm(tankPos - [20,80]) < norm(tankPos - [80,20])
                            dx = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(2)-81);
                        else 
                            dx = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end
                elseif self.pos(1) >80 && self.pos(2) <20 
                    if tankPos(2) < (80-self.pos(2))/(20-self.pos(1))*((self.pos(1)-tankPos(1))) + self.pos(2) && tankPos(2) > (20 - self.pos(2))/(20 - self.pos(1))*(tankPos(1) - self.pos(1)) + tankPos(2) && tankPos(1) <= 80 && tankPos(2) >= 20 
                        if norm(tankPos - [80,80]) < norm(tankPos - [20,20])
                            dx = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(2)-81);
                        else 
                            dx = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(2)-19);
   
                        end 
                    end    
                out = [dx, dy];
            end
        end
        
        
    else
        if self.fuel > enemy.fuel
            if self.pos(1) >= 20 && self.pos(1) <= 79 && self.pos(2) >= 20 && self.pos(2) <= 79
                params.speed_fuel = 1;
            else
                params.speed_fuel = 1.5;
            end
            d = norm(self.pos - enemy.pos);
            dx = (params.speed_fuel/d)*(enemy.pos(1)-self.pos(1));
            dy = (params.speed_fuel/d)*(enemy.pos(2)-self.pos(2));
            tankPos = enemy.pos;
            
            if self.pos(1) >= 20 && self.pos(1) < 81 &&self.pos(2) >= 20 && self.pos(2) <81 && ((enemy.pos(1) >= 81 || enemy.pos(1) < 20 || enemy.pos(2) < 20 || enemy.pos(2) >= 81)) 
                    if min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (81 - self.pos(1))
                        dy = 0;
                        dx = params.speed_fuel;
                    elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (self.pos(1) - 19)
                        dy = 0;
                        dx = -params.speed_fuel;
                    elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (81 - self.pos(2))
                        dy = params.speed_fuel;
                        dx = 0;
                    elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (self.pos(2) - 19)
                        dy = -params.speed_fuel;
                        dx = 0;
                    end
            elseif tankPos(1) >= 20 && tankPos(1) <= 80 && tankPos(2) >= 20 && tankPos(2) <= 80 && (self.pos(1) < 20 || self.pos(1) > 80 || self.pos(2) < 20 || self.pos(2) > 80)
                    if min( [81 - tankPos(1), tankPos(1) - 19, 81 - tankPos(2),tankPos(2) - 19]) == (81 - tankPos(1))
                        tankPos = [81,tankPos(2)];
                    elseif min( [81 - tankPos(1), tankPos(1) - 19, 81 - tankPos(2),tankPos(2) - 19]) == (tankPos(1) - 19)
                        tankPos = [19,tankPos(2)];
                    elseif min( [80 - tankPos(1), tankPos(1) - 19, 81 - tankPos(2),tankPos(2) - 19]) == (81 - tankPos(2))
                        tankPos = [tankPos(1), 81]; 
                    elseif min( [81 - tankPos(1), tankPos(1) - 19, 81 - tankPos(2),tankPos(2) - 19]) == (tankPos(2) - 19)
                        tankPos = [tankPos(1), 19];
                    end 
            end 

            if tankPos(1) == 19 || tankPos(1) == 81 || tankPos(2) == 19 || tankPos(2) == 81
                if self.pos(1) < 20 && tankPos(1) == 19
                    tankPos = [20,tankPos(2)];
                    dx = -params.speed_fuel/norm(tankPos-self.pos)*(self.pos(1)-tankPos(1));
                    dy = -params.speed_fuel/norm(tankPos-self.pos)*(self.pos(2)-tankPos(2));
                elseif self.pos(1) > 80 && tankPos(1) == 81
                    tankPos = [80,tankPos(2)];
                    dx = -params.speed_fuel/norm(tankPos-self.pos)*(self.pos(1)-tankPos(1));
                    dy = -params.speed_fuel/norm(tankPos-self.pos)*(self.pos(2)-tankPos(2));
                elseif self.pos(2) < 20 && tankPos(2) == 19
                    tankPos = [tankPos(1), 20];
                    dx = -params.speed_fuel/norm(tankPos-self.pos)*(self.pos(1)-tankPos(1));
                    dy = -params.speed_fuel/norm(tankPos-self.pos)*(self.pos(2)-tankPos(2));
                elseif self.pos(2) > 80 && tankPos(2) == 81
                    tankPos = [tankPos(1), 80];
                    dx = -params.speed_fuel/norm(tankPos-self.pos)*(self.pos(1)-tankPos(1));
                    dy = -params.speed_fuel/norm(tankPos-self.pos)*(self.pos(2)-tankPos(2));
                elseif self.pos(1) >= 20 && self.pos(1) < 81 &&self.pos(2) >= 20 && self.pos(2) <81 && ((tankPos(1) >= 81 || tankPos(1) < 20 || tankPos(2) < 20 || tankPos(2) >= 81)) 
                    if min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (81 - self.pos(1))
                        dy = 0;
                        dx = params.speed_fuel;
                    elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (self.pos(1) - 19)
                        dy = 0;
                        dx = -params.speed_fuel;
                    elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (81 - self.pos(2))
                        dy = params.speed_fuel;
                        dx = 0;
                    elseif min( [81 - self.pos(1), self.pos(1) - 19, 81 - self.pos(2),self.pos(2) - 19]) == (self.pos(2) - 19)
                        dy = -params.speed_fuel;
                        dx = 0;
                    end   
                elseif self.pos(1) < 20 && self.pos(2) >= 20 && self.pos(2) <= 80
                    if (tankPos(2) < (((80-self.pos(2))/(20-self.pos(1))*(tankPos(1)-self.pos(1))+self.pos(2)))) && tankPos(1) >= 20 && (tankPos(2) > (self.pos(2) + (20 - self.pos(2))/(20-self.pos(1))*(tankPos(1)-self.pos(1))))
                        if tankPos(2) >50
                            dx = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(2)-81);
                        else
                            dx = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(2)-19);
                        end
                    end

                elseif self.pos(1) > 80 && self.pos(2) >= 20 && self.pos(2) <= 80
                    if (tankPos(2) < ((80 - self.pos(2))/(80-self.pos(1))*(tankPos(1)-self.pos(1))+self.pos(2))) && tankPos(1) <= 80 && (tankPos(2) > (self.pos(2) + (self.pos(2)-20)/(80-self.pos(1))*(self.pos(1)-tankPos(1))))
                        if tankPos(2) >50
                            dx = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(2)-81);
                        else
                            dx = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end

               elseif self.pos(2) < 20 && self.pos(1) >= 20 && self.pos(1) <= 80
                    if (tankPos(1) < (((80-self.pos(1))/(20-self.pos(2))*(tankPos(2)-self.pos(2))+self.pos(1)))) && tankPos(2) >= 20 && tankPos(1) > ((self.pos(1)  + (self.pos(1) - 20)/(self.pos(2)-20)*(tankPos(2)- self.pos(2))))
                        if tankPos(1) >50
                            dx = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(2)-19);
                        else
                            dx = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end
               elseif self.pos(2) > 80 && self.pos(1) >= 20 && self.pos(1) <= 80
                    if (tankPos(1) < ((80 - self.pos(1))/(80-self.pos(2))*(tankPos(2)-self.pos(2))+self.pos(1))) && tankPos(2) <= 80 && (tankPos(1) > (self.pos(1) + (self.pos(1)-20)/(80-self.pos(2))*(self.pos(2) - tankPos(2)))) 
                        if tankPos(1) >50
                            dx = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(2)-81);
                        else
                            dx = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(2)-81);
                        end 
                    end
                    % Movement while in Corners
                elseif self.pos(1) < 20 && self.pos(2) < 20 
                    if tankPos(2) > (20 - self.pos(2))/(80 - self.pos(1))*(tankPos(1)-(self.pos(1))) + self.pos(2) && tankPos(2) < (80 - self.pos(2))/(20 - self.pos(1))*(tankPos(1) - self.pos(1)) + tankPos(2) && tankPos(1) >= 20 && tankPos(2) >= 20
                        if norm(tankPos - [20,80]) < norm(tankPos - [80,20])
                            dx = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(2)-81);
                        else 
                            dx = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end 
                elseif self.pos(1) < 20 && self.pos(2) > 80 
                    if tankPos(2) < (80 - self.pos(2))/(self.pos(1)-80)*(tankPos(1)-(self.pos(1))) + self.pos(2) && tankPos(2) > (self.pos(2)-20)/(20 - self.pos(1))*(tankPos(1) - self.pos(1)) + tankPos(2) && tankPos(1) >= 20 && tankPos(2) <= 80
                        if norm(tankPos - [80,80]) < norm(tankPos - [20,20])
                            dx = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(2)-81);
                        else 
                            dx = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end   
                elseif self.pos(1) >80 && self.pos(2) > 80 
                    if tankPos(2) < (self.pos(2)-80)/(20-self.pos(1))*((self.pos(1)-tankPos(1))) + self.pos(2) && tankPos(2) > (self.pos(2)-20)/(80 - self.pos(1))*(tankPos(1) - self.pos(1)) + tankPos(2) && tankPos(1) <= 80 && tankPos(2) <= 80
                        if norm(tankPos - [20,80]) < norm(tankPos - [80,20])
                            dx = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(2)-81);
                        else 
                            dx = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end
                elseif self.pos(1) >80 && self.pos(2) <20 
                    if tankPos(2) < (80-self.pos(2))/(20-self.pos(1))*((self.pos(1)-tankPos(1))) + self.pos(2) && tankPos(2) > (20 - self.pos(2))/(20 - self.pos(1))*(tankPos(1) - self.pos(1)) + tankPos(2) && tankPos(1) <= 80 && tankPos(2) >= 20 
                        if norm(tankPos - [80,80]) < norm(tankPos - [20,20])
                            dx = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(2)-81);
                        else 
                            dx = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end 
                end

            else
                if self.pos(1) < 20 && self.pos(2) >= 20 && self.pos(2) <= 80
                    if (enemy.pos(2) < (((80-self.pos(2))/(20-self.pos(1))*(enemy.pos(1)-self.pos(1))+self.pos(2)))) && enemy.pos(1) >= 20 && (enemy.pos(2) > (self.pos(2) + (20 - self.pos(2))/(20-self.pos(1))*(enemy.pos(1)-self.pos(1))))
                        if enemy.pos(2) >50
                            dx = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(2)-81);
                        else
                            dx = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(2)-19);
                        end
                    end

                elseif self.pos(1) > 80 && self.pos(2) >= 20 && self.pos(2) <= 80
                    if (enemy.pos(2) < ((80 - self.pos(2))/(80-self.pos(1))*(enemy.pos(1)-self.pos(1))+self.pos(2))) && enemy.pos(1) <= 80 && (enemy.pos(2) > (self.pos(2) + (self.pos(2)-20)/(80-self.pos(1))*(self.pos(1)-enemy.pos(1))))
                        if enemy.pos(2) >50
                            dx = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(2)-81);
                        else
                            dx = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end

                elseif self.pos(2) < 20 && self.pos(1) >= 20 && self.pos(1) <= 80
                    if (enemy.pos(1) < (((80-self.pos(1))/(20-self.pos(2))*(enemy.pos(2)-self.pos(2))+self.pos(1)))) && enemy.pos(2) >= 20 && enemy.pos(1) > ((self.pos(1)  + (self.pos(1) - 20)/(self.pos(2)-20)*(enemy.pos(2)- self.pos(2))))
                        if enemy.pos(1) >50
                            dx = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(2)-19);
                        else
                            dx = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end
                elseif self.pos(2) > 80 && self.pos(1) >= 20 && self.pos(1) <= 80
                    if (enemy.pos(1) < ((80 - self.pos(1))/(80-self.pos(2))*(enemy.pos(2)-self.pos(2))+self.pos(1))) && enemy.pos(2) <= 80 && (enemy.pos(1) > (self.pos(1) + (self.pos(1)-20)/(80-self.pos(2))*(self.pos(2) - enemy.pos(2)))) 
                        if enemy.pos(1) >50
                            dx = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(2)-81);
                        else
                            dx = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(2)-81);
                        end 
                    end
                    % Movement while in Corners
                elseif self.pos(1) < 20 && self.pos(2) < 20 
                    if enemy.pos(2) > (20 - self.pos(2))/(80 - self.pos(1))*(enemy.pos(1)-(self.pos(1))) + self.pos(2) && enemy.pos(2) < (80 - self.pos(2))/(20 - self.pos(1))*(enemy.pos(1) - self.pos(1)) + enemy.pos(2) && enemy.pos(1) >= 20 && enemy.pos(2) >= 20
                        if norm(enemy.pos - [20,80]) < norm(enemy.pos - [80,20])
                            dx = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(2)-81);
                        else 
                            dx = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end 
                elseif self.pos(1) < 20 && self.pos(2) > 80 
                    if enemy.pos(2) < (80 - self.pos(2))/(self.pos(1)-80)*(enemy.pos(1)-(self.pos(1))) + self.pos(2) && enemy.pos(2) > (self.pos(2)-20)/(20 - self.pos(1))*(enemy.pos(1) - self.pos(1)) + enemy.pos(2) && enemy.pos(1) >= 20 && enemy.pos(2) <= 80
                        if norm(enemy.pos - [80,80]) < norm(enemy.pos - [20,20])
                            dx = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(2)-81);
                        else 
                            dx = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end   
                elseif self.pos(1) >80 && self.pos(2) > 80 
                    if enemy.pos(2) < (self.pos(2)-80)/(20-self.pos(1))*((self.pos(1)-enemy.pos(1))) + self.pos(2) && enemy.pos(2) > (self.pos(2)-20)/(80 - self.pos(1))*(enemy.pos(1) - self.pos(1)) + enemy.pos(2) && enemy.pos(1) <= 80 && enemy.pos(2) <= 80
                        if norm(enemy.pos - [20,80]) < norm(enemy.pos - [80,20])
                            dx = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,81]-self.pos)*(self.pos(2)-81);
                        else 
                            dx = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end
                elseif self.pos(1) >80 && self.pos(2) <20 
                    if enemy.pos(2) < (80-self.pos(2))/(20-self.pos(1))*((self.pos(1)-enemy.pos(1))) + self.pos(2) && enemy.pos(2) > (20 - self.pos(2))/(20 - self.pos(1))*(enemy.pos(1) - self.pos(1)) + enemy.pos(2) && enemy.pos(1) <= 80 && enemy.pos(2) >= 20 
                        if norm(enemy.pos - [80,80]) < norm(enemy.pos - [20,20])
                            dx = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(1)-81);
                            dy = -params.speed_fuel/norm([81,81]-self.pos)*(self.pos(2)-81);
                        else 
                            dx = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(1)-19);
                            dy = -params.speed_fuel/norm([19,19]-self.pos)*(self.pos(2)-19);
                        end 
                    end
            % assign output

                end
                out = [dx, dy];
            end
        else
            dx = -params.speed_fuel/norm(enemy.pos-self.pos)*(self.pos(1)-enemy.pos(1));
            dy = -params.speed_fuel/norm(enemy.pos-self.pos)*(self.pos(2)-enemy.pos(2));
            
            if norm(self.pos - enemy.pos) < 20 && enemy.fuel > 0
                if self.pos(1) == 0 && self.pos(2) == 0
                    if self.prev(2) == 0
                        dx = 0;
                        dy = params.speed_fuel;
                        out = [dx, dy];
                        return
                    else
                        dx = params.speed_fuel;
                        dy = 0;
                        out = [dx, dy];
                        return
                    end
                elseif self.pos(1) == 0 && self.pos(2) == 100
                    if self.prev(2) == 0
                        dx = 0;
                        dy = -params.speed_fuel;
                        out = [dx, dy];
                        return
                    else
                        dx = params.speed_fuel;
                        dy = 0;
                        out = [dx, dy];
                        return
                    end
               elseif self.pos(1) == 100 && self.pos(2) == 100
                    if self.prev(2) == 0
                        dx = 0;
                        dy = -params.speed_fuel;
                        out = [dx, dy];
                        return
                    else
                        dx = -params.speed_fuel;
                        dy = 0; 
                        out = [dx, dy];
                        return
                    end
               elseif self.pos(1) == 100 && self.pos(2) == 0
                    if self.prev(2) == 0
                        dx = 0;
                        dy = params.speed_fuel;
                        out = [dx, dy];
                        return
                    else
                        dx = -params.speed_fuel;
                        dy = 0;
                        out = [dx, dy];
                        return
                    end
                elseif( self.pos(1) == 0 || self.pos(1) == 100 ) && enemy.pos(2) < self.pos(2)
                    dx = 0;
                    dy = params.speed_fuel;
                    out = [dx, dy];
                    return
                elseif ( self.pos(1) == 0 || self.pos(1) == 100 ) && enemy.pos(2) > self.pos(2)
                    dx = 0;
                    dy = -params.speed_fuel;
                    out = [dx, dy];
                    return
                elseif ( self.pos(2) == 0 || self.pos(2) == 100 ) && enemy.pos(1) < self.pos(1)
                    dx = params.speed_fuel;
                    dy = 0;
                    out = [dx, dy];
                    return
                elseif ( self.pos(2) == 0 || self.pos(2) == 100 ) && enemy.pos(1) > self.pos(1)
                    dx = -params.speed_fuel;
                    dy = 0;
                    out = [dx, dy];
                    return
                else
                    out = [ -dx, -dy ];
                    return
                end
            elseif norm(self.pos - enemy.pos) > 40
                out = [0, 0];
                return
            else
                out = [ -dx, -dy ];
                return
            end
        end
    end
    
    %MINE CODE
    theta = atand((dy/dx));
    count = 0;
    index = [];
    
    for i = 1:length(mine)
        
        if norm([self.pos(1) + dx, self.pos(2) + dy] - mine(i).pos) <= 8
            count = count + 1;
            index = horzcat(index, i);
        end
    end
    
    for i = 1:length(mine)
        if count > 1
            dx = dx;
            dy = dy;
        elseif self.pos(1) <= 79 && self.pos(1) >= 20 && self.pos(2) <= 79 && self.pos(2) >= 20 && (mine(i).pos(1) < 20 || mine(i).pos(1) > 79 || mine(i).pos(2) < 20 || mine(i).pos(1) >79) && norm(self.pos - mine(i).pos) <= 8
            dx = dx;
            dy = dy;
        else
            do = 0;
            if norm([self.pos(1) + dx, self.pos(2) + dy] - mine(i).pos) <= 5    
                if dx >= 0 
                    theta = theta;
                else
                    theta = theta + 180;
                end
                    if mine(i).pos(1) < 20 && mine(i).pos(2) >= mine(i).pos(1) && mine(i).pos(2) < 100 - mine(i).pos(1) 
                        if dy >= 0 
                            do = 1;
                        end
                    elseif mine(i).pos(1) > 79 && mine(i).pos(2) <= mine(i).pos(1) && mine(i).pos(2) > 100 - mine(i).pos(1) 
                        if dy <= 0
                            do = 1;
                        end
                    elseif mine(i).pos(2) < 20 && mine(i).pos(1) >= mine(i).pos(2) && mine(i).pos(1) < 100 - mine(i).pos(2)
                        if dx <= 0
                            do = 1;
                        end
                    elseif mine(i).pos(2) > 79 && mine(i).pos(1) <= mine(i).pos(2) && mine(i).pos(1) > 100 - mine(i).pos(2)
                        if dx >= 0 
                            do = 1;
                        end
                    end
                    
                    if self.pos(1) >= 20 && self.pos(1) <= 80 && self.pos(2) >= 20 && self.pos(2) <= 80
                        if self.pos(1) < 20 && self.pos(2) >= self.pos(1) && self.pos(2) < 100 - self.pos(1) 
                            if dy >= 0 
                                do = 1;
                            end
                        elseif self.pos(1) > 79 && self.pos(2) <= self.pos(1) && self.pos(2) > 100 - self.pos(1) 
                            if dy <= 0
                                do = 1;
                            end
                        elseif self.pos(2) < 20 && self.pos(1) >= self.pos(2) && self.pos(1) < 100 - self.pos(2)
                            if dx <= 0
                                do = 1;
                            end
                        elseif self.pos(2) > 79 && self.pos(1) <= self.pos(2) && self.pos(1) > 100 - self.pos(2)
                            if dx >= 0 
                                do = 1;
                            end
                        end 
           
                end 
                    %}
                
                if do == 1
                    for p = 1:10:360   
                        if norm([self.pos(1) + (params.speed_fuel)*cosd(theta + p), self.pos(2) + (params.speed_fuel)*sind(theta + p)] - mine(i).pos) > 5
                                dx = (params.speed_fuel)*cosd(theta + p);
                                dy = (params.speed_fuel)*sind(theta + p);
                                break
                        end
                    end
                elseif do == 0 
                    for p = 1:10:360   
                        if norm([self.pos(1) + (params.speed_fuel)*cosd(theta - p), self.pos(2) + (params.speed_fuel)*sind(theta - p)] - mine(i).pos) > 5
                                dx = (params.speed_fuel)*cosd(theta - p);
                                dy = (params.speed_fuel)*sind(theta - p);
                                break
                        end
                    end
                end 
            end
        end
        
        out = [dx, dy];
        
    end            
      
    if sqrt(dy^2 +dx^2) > 3 || abs(dy) > 3 || abs(dx) > 3
        out = [self.prev(1), self.prev(2)];
    end
end