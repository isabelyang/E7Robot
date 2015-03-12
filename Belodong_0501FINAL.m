function [out] = Belodong(self, enemy, tank, mine)

%subfunctions

%Radius Function
    function [x,y,ind] = radius(tanks, r, self)
        
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

tankPos = [0, 0];
Z = 0;

if self.pos(1) >=20 && self.pos(1) <= 79 && self.pos(2) <= 79 && self.pos(2) >= 20
    params.speed_fuel = 1;
else
    params.speed_fuel = 2.5;
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
            dx = (params.speed_fuel/d)*(enemy.pos(1)-self.pos(1));
            dy = (params.speed_fuel/d)*(enemy.pos(2)-self.pos(2));
            if Z == 0
                %HANDONG'S CODE APPLIED
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

                elseif self.pos(1) < 20 && self.pos(2) >= 20 && self.pos(2) <= 80
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
                else
                    d = norm(self.pos - enemy.pos);
                    dx = (params.speed_fuel/d)*(enemy.pos(1)-self.pos(1));
                    dy = (params.speed_fuel/d)*(enemy.pos(2)-self.pos(2));                
                end
            else
                d = norm(self.pos - tank(Z).pos);
                dx = (params.speed_fuel/d)*(tank(Z).pos(1)-self.pos(1));
                dy = (params.speed_fuel/d)*(tank(Z).pos(2)-self.pos(2));
            end
            % assign output
            out = [dx, dy];
            
            
        %one more fuel tank
        
        elseif length(tank) == 1
            d = norm(self.pos - tank.pos);
            if norm(self.pos - tank.pos) > norm(enemy.pos - tank.pos)
                dx = 0;
                dy = 0;
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
                      
            bestTank = 0;
            bestTankPos = [];
            bestValue=0; 
            if isempty(tank) == 0
                for i=1:length(tank) 
                    if (self.pos(1)<20 && tank(i).pos(1)<20)||(self.pos(1)>80 && tank(i).pos(1)>80)||(self.pos(2)<20 && tank(i).pos(2)<20)||(self.pos(2)>80 && tank(i).pos(2)>80) %If tank and bot is on the same "side" of sticky zone
                        value=tank(i).val-((norm(self.pos-tank(i).pos))/params.speed_fuel)*(params.speed_fuel^2 +2);
                        bestValue(i,1)=value;
                        bestValue(i,2)=i; 
                    elseif self.pos(1)>=20  && self.pos(1)<=79 && self.pos(2)>=20 && self.pos(2)<=79 && tank(i).pos(1)>=20 && tank(i).pos(1)<=79  && tank(i).pos(2)>=20  && tank(i).pos(2)<=79 %If tank and bot are both in sticky zone
                        value=tank(i).val-((norm(self.pos-tank(i).pos))/params.speed_fuel)*5*(params.speed_fuel^2 +2); 
                        bestValue(i,1)=value;
                        bestValue(i,2)=i;        
                    elseif self.pos(1)<20 && tank(i).pos(2)<20  && tank(i).pos(1)>=20  && tank(i).pos(2)<=79 %If bot is left side and tank is bottom side
                        value=tank(i).val-(((norm(self.pos-[20,20])/params.speed_fuel)+norm([20,20]-tank(i).pos))*(params.speed_fuel^2 +2)); 
                        bestValue(i,1)=value;
                        bestValue(i,2)=i;
                    elseif self.pos(1)<20 && tank(i).pos(2)>=80  && tank(i).pos(1)>=20  && tank(i).pos(2)<=79 %If bot is left side and tank is top side
                        value=tank(i).val-(((norm(self.pos-[20,80])/params.speed_fuel)+norm([20,80]-tank(i).pos))*(params.speed_fuel^2 +2)); 
                        bestValue(i,1)=value;
                        bestValue(i,2)=i;
                    elseif self.pos(1)>=80 && tank(i).pos(2)<20  && tank(i).pos(1)>=20  && tank(i).pos(2)<=79 %If bot is right side and tank is bottom side
                        value=tank(i).val-(((norm(self.pos-[80,20])/params.speed_fuel)+norm([80,20]-tank(i).pos))*(params.speed_fuel^2 +2)); 
                        bestValue(i,1)=value;
                        bestValue(i,2)=i;
                    elseif self.pos(1)>=80 && tank(i).pos(2)>=80  && tank(i).pos(1)>=20  && tank(i).pos(2)<=79 %If bot is right side and tank is top side
                        value=tank(i).val-(((norm(self.pos-[80,80])/params.speed_fuel)+norm([80,80]-tank(i).pos))*(params.speed_fuel^2 +2)); 
                        bestValue(i,1)=value;
                        bestValue(i,2)=i;
                    elseif self.pos(2)<20 && tank(i).pos(1)<20  && tank(i).pos(2)>=20  && tank(i).pos(2)<=79 %If bot is bottom side and tank is left side
                        value=tank(i).val-(((norm(self.pos-[20,20])/params.speed_fuel)+norm([20,20]-tank(i).pos))*(params.speed_fuel^2 +2)); 
                        bestValue(i,1)=value;
                        bestValue(i,2)=i;
                    elseif self.pos(2)<20 && tank(i).pos(1)>=80  && tank(i).pos(2)>=20  && tank(i).pos(2)<=79 %If bot is bottom side and tank is right side
                        value=tank(i).val-(((norm(self.pos-[80,20])/params.speed_fuel)+norm([80,20]-tank(i).pos))*(params.speed_fuel^2 +2)); 
                        bestValue(i,1)=value;
                        bestValue(i,2)=i;
                    elseif self.pos(2)>=80 && tank(i).pos(1)<20  && tank(i).pos(2)>=20  && tank(i).pos(2)<=79 %If bot is top side and tank is left side
                        value=tank(i).val-(((norm(self.pos-[20,80])/params.speed_fuel)+norm([20,80]-tank(i).pos))*(params.speed_fuel^2 +2)); 
                        bestValue(i,1)=value;
                        bestValue(i,2)=i;
                    elseif self.pos(2)>=80 && tank(i).pos(1)>=80  && tank(i).pos(2)>=20  && tank(i).pos(2)<=79 %If bot is top side and tank is right side
                        value=tank(i).val-(((norm(self.pos-[80,80])/params.speed_fuel)+norm([80,80]-tank(i).pos))*(params.speed_fuel^2 +2)); 
                        bestValue(i,1)=value;
                        bestValue(i,2)=i;
                    elseif self.pos(1)<20 && tank(i).pos(1)>=20 && tank(i).pos(1) <=50 && tank(i).pos(2)>=20 && tank(i).pos(2)<80 %If bot is on left side and tank is in sticy zone left side
                        if (tank(i).pos(1)-20)<= (80-tank(i).pos(2)) && (tank(i).pos(1)-20)<= (tank(i).pos(2)-20) %If tank is closest to left side
                            value=tank(i).val-((norm(self.pos-[20,tank(i).pos(2)])/params.speed_fuel)*(params.speed_fuel^2+2)+norm([20,tank(i).pos(2)]-tank(i).pos)*5*(params.speed_fuel^2 +2)); 
                            bestValue(i,1)=value;
                            bestValue(i,2)=i;
                        elseif (tank(i).pos(2)-20)<= (80-tank(i).pos(2)) && (tank(i).pos(2)-20)<= (tank(i).pos(1)-20) %If tank is closest to bottom side
                                if self.pos(2)<20 %If bot can reach in straight line
                                    value=tank(i).val-((((norm(self.pos-[tank(i).pos(1),20])/params.speed_fuel)*(params.speed_fuel^2+2)))+norm([tank(i).pos(1),20]-tank(i).pos)*5*(params.speed_fuel^2 +2)); 
                                    bestValue(i,1)=value;
                                    bestValue(i,2)=i;
                                else %If bot has to hit corner first
                                    value=tank(i).val-((((norm(self.pos-[20,20])/params.speed_fuel)+(norm([20,20]-[tank(i).pos(1), 20])/params.speed_fuel))*(params.speed_fuel^2+2))+norm([tank(i).pos(1),20]-tank(i).pos)*5*(params.speed_fuel^2 +2)); 
                                    bestValue(i,1)=value;
                                    bestValue(i,2)=i;
                                end
                        elseif (80-tank(i).pos(2))<= (tank(i).pos(2)-20) && (80-tank(i).pos(2))<= (tank(i).pos(1)-20) %If tank is closest to top side
                                if self.pos(2)>=80 %If bot can reach in straight line
                                    value=tank(i).val-((((norm(self.pos-[tank(i).pos(1),80])/params.speed_fuel)*(params.speed_fuel^2+2)))+norm([tank(i).pos(1),80]-tank(i).pos)*5*(params.speed_fuel^2 +2)); 
                                    bestValue(i,1)=value;
                                    bestValue(i,2)=i;
                                else %If bot has to hit corner first
                                    value=tank(i).val-((((norm(self.pos-[20,80])/params.speed_fuel)+(norm([20,80]-[tank(i).pos(1),80])/params.speed_fuel))*(params.speed_fuel^2+2))+norm([tank(i).pos(1),20]-tank(i).pos)*5*(params.speed_fuel^2 +2)); 
                                    bestValue(i,1)=value;
                                    bestValue(i,2)=i;
                                end
                        end
                    elseif self.pos(1)>80 && tank(i).pos(1)<=80 && tank(i).pos(1) >50 && tank(i).pos(2)>=20 && tank(i).pos(2)<80 %If bot is on right side and tank is in sticy zone right side
                        if (80-tank(i).pos(1))<= (80-tank(i).pos(2)) && (80-tank(i).pos(1))<= (tank(i).pos(2)-20) %If tank is closest to rightside
                            value=tank(i).val-((norm(self.pos-[80,tank(i).pos(2)])/params.speed_fuel)*(params.speed_fuel^2+2)+norm([20,tank(i).pos(2)]-tank(i).pos)*5*(params.speed_fuel^2 +2)); 
                            bestValue(i,1)=value;
                            bestValue(i,2)=i;
                        elseif (tank(i).pos(2)-20)<= (80-tank(i).pos(2)) && (tank(i).pos(2)-20)<= (80-tank(i).pos(1)) %If tank is closest to bottom side
                                if self.pos(2)<20 %If bot can reach in straight line
                                    value=tank(i).val-((((norm(self.pos-[tank(i).pos(1),20])/params.speed_fuel)*(params.speed_fuel^2+2)))+norm([tank(i).pos(1),20]-tank(i).pos)*5*(params.speed_fuel^2 +2)); 
                                    bestValue(i,1)=value;
                                    bestValue(i,2)=i;
                                else %If bot has to hit corner first
                                    value=tank(i).val-((((norm(self.pos-[80,20])/params.speed_fuel)+(norm([80,20]-[tank(i).pos(1), 20])/params.speed_fuel))*(params.speed_fuel^2+2))+norm([tank(i).pos(1),20]-tank(i).pos)*5*(params.speed_fuel^2 +2)); 
                                    bestValue(i,1)=value;
                                    bestValue(i,2)=i;
                                end
                        elseif (80-tank(i).pos(2))<= (tank(i).pos(2)-20) && (80-tank(i).pos(2))<= (80-tank(i).pos(1)) %If tank is closest to top side
                                if self.pos(2)>=80 %If bot can reach in straight line
                                    value=tank(i).val-((((norm(self.pos-[tank(i).pos(1),80])/params.speed_fuel)*(params.speed_fuel^2+2)))+norm([tank(i).pos(1),80]-tank(i).pos)*5*(params.speed_fuel^2 +2)); 
                                    bestValue(i,1)=value;
                                    bestValue(i,2)=i;
                                else %If bot has to hit corner first
                                    value=tank(i).val-((((norm(self.pos-[80,80])/params.speed_fuel)+(norm([80,80]-[tank(i).pos(1),80])/params.speed_fuel))*(params.speed_fuel^2+2))+norm([tank(i).pos(1),80]-tank(i).pos)*5*(params.speed_fuel^2 +2)); 
                                    bestValue(i,1)=value;
                                    bestValue(i,2)=i;
                                end
                        end
                        
                   elseif self.pos(2)<20 && tank(i).pos(2)>=20 && tank(i).pos(2) <=50 && tank(i).pos(1)>=20 && tank(i).pos(1)<80 %If bot is on bottom side and tank is in sticy zone bottom side
                        if (tank(i).pos(2)-20)<= (80-tank(i).pos(1)) && (tank(i).pos(2)-20)<= (tank(i).pos(1)-20) %If tank is closest to bottom side
                            value=tank(i).val-((norm(self.pos-[tank(i).pos(1),20])/params.speed_fuel)*(params.speed_fuel^2+2)+norm([tank(i).pos(1),20]-tank(i).pos)*5*(params.speed_fuel^2 +2)); 
                            bestValue(i,1)=value;
                            bestValue(i,2)=i;
                        elseif (tank(i).pos(1)-20)<= (80-tank(i).pos(1)) && (tank(i).pos(1)-20)<= (tank(i).pos(2)-20) %If tank is closest to left side
                                if self.pos(1)<20 %If bot can reach in straight line
                                    value=tank(i).val-((((norm(self.pos-[20,tank(i).pos(2)])/params.speed_fuel)*(params.speed_fuel^2+2)))+norm([20,tank(i).pos(2)]-tank(i).pos)*5*(params.speed_fuel^2 +2)); 
                                    bestValue(i,1)=value;
                                    bestValue(i,2)=i;
                                else %If bot has to hit corner first
                                    value=tank(i).val-((((norm(self.pos-[20,20])/params.speed_fuel)+(norm([20,20]-[20,tank(i).pos(2)])/params.speed_fuel))*(params.speed_fuel^2+2))+norm([20,tank(i).pos(2)]-tank(i).pos)*5*(params.speed_fuel^2 +2)); 
                                    bestValue(i,1)=value;
                                    bestValue(i,2)=i;
                                end
                        elseif (80-tank(i).pos(1))<= (tank(i).pos(1)-20) && (80-tank(i).pos(1))<= (tank(i).pos(2)-20) %If tank is closest to right side
                                if self.pos(1)>=80 %If bot can reach in straight line
                                    value=tank(i).val-((((norm(self.pos-[80,tank(i).pos(2)])/params.speed_fuel)*(params.speed_fuel^2+2)))+norm([80,tank(i).pos(2)]-tank(i).pos)*5*(params.speed_fuel^2 +2)); 
                                    bestValue(i,1)=value;
                                    bestValue(i,2)=i;
                                else %If bot has to hit corner first
                                    value=tank(i).val-((((norm(self.pos-[80,20])/params.speed_fuel)+(norm([80,20]-[80,tank(i).pos(2)])/params.speed_fuel))*(params.speed_fuel^2+2))+norm([80,tank(i).pos(2)]-tank(i).pos)*5*(params.speed_fuel^2 +2)); 
                                    bestValue(i,1)=value;
                                    bestValue(i,2)=i;
                                end
                        end 
                    elseif self.pos(2)>80 && tank(i).pos(2)>50 && tank(i).pos(2) <80 && tank(i).pos(1)>=20 && tank(i).pos(1)<80 %If bot is on top side and tank is in sticy zone top side
                        if (80-tank(i).pos(2))<= (80-tank(i).pos(1)) && (80-tank(i).pos(2))<= (tank(i).pos(1)-20) %If tank is closest to top side
                            value=tank(i).val-((norm(self.pos-[tank(i).pos(1),80])/params.speed_fuel)*(params.speed_fuel^2+2)+norm([tank(i).pos(1),80]-tank(i).pos)*5*(params.speed_fuel^2 +2)); 
                            bestValue(i,1)=value;
                            bestValue(i,2)=i;
                        elseif (tank(i).pos(1)-20)<= (80-tank(i).pos(2)) && (tank(i).pos(1)-20)<= (80-tank(i).pos(1)) %If tank is closest to left side
                                if self.pos(1)<20 %If bot can reach in straight line
                                    value=tank(i).val-((((norm(self.pos-[20,tank(i).pos(2)])/params.speed_fuel)*(params.speed_fuel^2+2)))+norm([20,tank(i).pos(2)]-tank(i).pos)*5*(params.speed_fuel^2 +2)); 
                                    bestValue(i,1)=value;
                                    bestValue(i,2)=i;
                                else %If bot has to hit corner first
                                    value=tank(i).val-((((norm(self.pos-[20,80])/params.speed_fuel)+(norm([20,80]-[20,tank(i).pos(2)])/params.speed_fuel))*(params.speed_fuel^2+2))+norm([20,tank(i).pos(2)]-tank(i).pos)*5*(params.speed_fuel^2 +2)); 
                                    bestValue(i,1)=value;
                                    bestValue(i,2)=i;
                                end
                        elseif (80-tank(i).pos(1))<= (tank(i).pos(1)-20) && (80-tank(i).pos(1))<= (80-tank(i).pos(2)) %If tank is closest to right side
                                if self.pos(1)>=80 %If bot can reach in straight line
                                    value=tank(i).val-((((norm(self.pos-[80,tank(i).pos(2)])/params.speed_fuel)*(params.speed_fuel^2+2)))+norm([80,tank(i).pos(2)]-tank(i).pos)*5*(params.speed_fuel^2 +2)); 
                                    bestValue(i,1)=value;
                                    bestValue(i,2)=i;
                                else %If bot has to hit corner first
                                    value=tank(i).val-((((norm(self.pos-[80,80])/params.speed_fuel)+(norm([80,80]-[80,tank(i).pos(2)])/params.speed_fuel))*(params.speed_fuel^2+2))+norm([80,tank(i).pos(2)]-tank(i).pos)*5*(params.speed_fuel^2 +2)); 
                                    bestValue(i,1)=value;
                                    bestValue(i,2)=i;
                                end
                        end   
 
            
                    end
                
%                 if bestValue~=0
%                 bestValue;
%                 bestValueSorted=sortrows(bestValue);
%                 bestValueSorted

                    if isempty(bestValue)==0
                        bestValueSorted=sortrows(bestValue);
                        if bestValueSorted(end, 1) > 0
                        bestTank = bestValueSorted(end,2);
                        tankPos = tank(bestTank).pos;
                        else 
                        dx=0;
                        dy=0;
                        end

                    else 
                        [tankPos1, tankPos2, ind1] = radius(tank, 25, self);
                        tankPos = [tankPos1, tankPos2];
                        
                    end
%                 else
%             
%                 [tankPos1, tankPos2, ind1] = radius(tank, 25, self);
%                 tankPos = [tankPos1, tankPos2];
%                 end
%                 end
                end
            
                        
        end
            [tankPos1, tankPos2, ind1] = radius(tank, 25, self);
            tankPos = [tankPos1, tankPos2];          

            d = norm(tankPos - self.pos);
            
            dx = (params.speed_fuel/d)*(tankPos(1)-self.pos(1));
            dy = (params.speed_fuel/d)*(tankPos(2)-self.pos(2));
                % going for a tank in the sticky zone 
                
            if tankPos(1) >= 20 && tankPos(1) <= 80 && tankPos(2) >= 20 && tankPos(2) <= 80 && (self.pos(1) < 20 || self.pos(1) > 80 || self.pos(2) < 20 || self.pos(2) > 80)
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
              end


                out = [dx, dy];

        end 
        
        else
            d = norm(self.pos - enemy.pos);
            dx = (params.speed_fuel/d)*(enemy.pos(1)-self.pos(1));
            dy = (params.speed_fuel/d)*(enemy.pos(2)-self.pos(2));

            if self.fuel >= enemy.fuel
                params.speed_fuel = 1.5;
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

                    elseif self.pos(1) < 20 && self.pos(2) >= 20 && self.pos(2) <= 80
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
                        if (enemy.pos(1) < (((80-self.pos(1))/(20-self.pos(2))*(enemy.pos(2)-self.pos(2))+self.pos(1)))) && enemy.pos(2) >= 20 && (enemy.pos(1) > (self.pos(1)  + (self.pos(1) - 20)/(self.pos(2)-20)*(enemy.pos(2)-self.pos(2))))
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
                end
                       
                %{
                if norm(self.pos - enemy.pos) < 20
                    dx = (params.speed_fuel/d)*(enemy.pos(1)-self.pos(1));
                    dy = (params.speed_fuel/d)*(enemy.pos(2)-self.pos(2));

                end
                %}
                out = [dx, dy];
        else
            if norm(self.pos - enemy.pos) < 20
                if self.pos(1) == 0 && self.pos(2) == 0
                    if self.prev(2) == 0
                        dx = 0;
                        dy = params.speed_fuel;
                        out = [dx, dy];
                    else
                        dx = params.speed_fuel;
                        dy = 0;
                        out = [dx, dy];
                    end
                elseif self.pos(1) == 0 && self.pos(2) == 100
                    if self.prev(2) == 0
                        dx = 0;
                        dy = -params.speed_fuel;
                        out = [dx, dy];
                    else
                        dx = params.speed_fuel;
                        dy = 0;
                        out = [dx, dy];
                    end
               elseif self.pos(1) == 100 && self.pos(2) == 100
                    if self.prev(2) == 0
                        dx = 0;
                        dy = -params.speed_fuel;
                        out = [dx, dy];
                    else
                        dx = -params.speed_fuel;
                        dy = 0; 
                        out = [dx, dy];
                    end
               elseif self.pos(1) == 100 && self.pos(2) == 0
                    if self.prev(2) == 0
                        dx = 0;
                        dy = params.speed_fuel;
                        out = [dx, dy];
                    else
                        dx = -params.speed_fuel;
                        dy = 0;
                        out = [dx, dy];
                    end
                elseif( self.pos(1) == 0 || self.pos(1) == 100 ) && enemy.pos(2) < self.pos(2)
                    dx = 0;
                    dy = params.speed_fuel;
                    out = [dx, dy];
                elseif ( self.pos(1) == 0 || self.pos(1) == 100 ) && enemy.pos(2) > self.pos(2)
                    dx = 0;
                    dy = -params.speed_fuel;
                    out = [dx, dy];
                elseif ( self.pos(2) == 0 || self.pos(2) == 100 ) && enemy.pos(1) < self.pos(1)
                    dx = params.speed_fuel;
                    dy = 0;
                    out = [dx, dy];
                elseif ( self.pos(2) == 0 || self.pos(2) == 100 ) && enemy.pos(1) > self.pos(1)
                    dx = -params.speed_fuel;
                    dy = params.speed_fuel;
                    out = [dx, dy];
                else
                    out = [ -dx, -dy ];
                end
            elseif self.pos(1) == 0 || self.pos(1) == 100
                out = [0, 0];
            elseif self.pos(2) == 0 || self.pos(2) == 100
                out = [0, 0];
            else
                out = [ -dx, -dy ];
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
            if norm([self.pos(1) + dx, self.pos(2) + dy] - mine(i).pos) <= 5    
                if dx >= 0 
                    theta = theta;
                else
                    theta = theta + 180;
                end 

                for p = 1:10:360   
                    if norm([self.pos(1) + (params.speed_fuel)*cosd(theta + p), self.pos(2) + (params.speed_fuel)*sind(theta + p)] - mine(i).pos) > 5
                            dx = (params.speed_fuel)*cosd(theta + p);
                            dy = (params.speed_fuel)*sind(theta + p);
                            break
                    end
                end

            end
        end
        
        out = [dx, dy];
        
     end            
end