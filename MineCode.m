newPosx = self.pos(1) + out(1);
newPosy = self.pos(2) + out(2);
newPos = [newPosx, newPosy];
for n = 1:length(mine)

    mineRangex1 = mine(n).pos(1) - 5;
    mineRangex2 = mine(n).pos(1) + 5;
    mineRangey1 = mine(n).pos(2) - 5;
    mineRangey2 = mine(n).pos(2) + 5;

    if norm(newPos - mine(n).pos) <= 5
        if self.pos(1) < mineRangex1 && self.pos(2) >= mineRangey1 && self.pos(2) <= mineRangey2
            if (tankPos(2) < (((mineRangey2-self.pos(2))/(mineRangex1-self.pos(1))*(tankPos(1)-self.pos(1))+self.pos(2)))) && tankPos(1) >= mineRangex1 && (tankPos(2) > (self.pos(2) + (mineRangey1 - self.pos(2))/(mineRangex1-self.pos(1))*(tankPos(1)-self.pos(1))))
                if tankPos(2) > mine(n).pos(2)
                    dx = -params.speed_fuel/norm([mineRangex1,mineRangey2]-self.pos)*(self.pos(1)-mineRangex1);
                    dy = -params.speed_fuel/norm([mineRangex1,mineRangey2]-self.pos)*(self.pos(2)-mineRangey2);
                else
                    dx = -params.speed_fuel/norm([mineRangex1,mineRangey1]-self.pos)*(self.pos(1)-mineRangex1);
                    dy = -params.speed_fuel/norm([mineRangex1,mineRangey1]-self.pos)*(self.pos(2)-mineRangey1);
                end
            end

        elseif self.pos(1) > mineRangex2 && self.pos(2) >= mineRangey1 && self.pos(2) <= mineRangey2
            if (tankPos(2) < ((mineRangey2 - self.pos(2))/(mineRangex2-self.pos(1))*(tankPos(1)-self.pos(1))+self.pos(2))) && tankPos(1) <= mineRangex2 && (tankPos(2) > (self.pos(2) + (self.pos(2)-mineRangey1)/(mineRangex2-self.pos(1))*(self.pos(1)-tankPos(1))))
                if tankPos(2) > mine(n).pos(2)
                    dx = -params.speed_fuel/norm([mineRangex2,mineRangey2]-self.pos)*(self.pos(1)-mineRangex2);
                    dy = -params.speed_fuel/norm([mineRangex2,mineRangey2]-self.pos)*(self.pos(2)-mineRangey2);
                else
                    dx = -params.speed_fuel/norm([mineRangex2,mineRangey1]-self.pos)*(self.pos(1)-mineRangex2);
                    dy = -params.speed_fuel/norm([mineRangex2,mineRangey1]-self.pos)*(self.pos(2)-mineRangey1);
                end 
            end

        elseif self.pos(2) < mineRangey1 && self.pos(1) >= mineRangex1 && self.pos(1) <= mineRangey2
            if (tankPos(1) < (((mineRangex2-self.pos(1))/(mineRangey1-self.pos(2))*(tankPos(2)-self.pos(2))+self.pos(1)))) && tankPos(2) >= mineRangey1 && tankPos(1) > ((self.pos(1) + (self.pos(1) - mineRangex1)/(self.pos(2)-mineRangey1)*(tankPos(2)- self.pos(2))))
                if tankPos(1) > mine(n).pos(1)
                    dx = -params.speed_fuel/norm([mineRangex2,mineRangey1]-self.pos)*(self.pos(1)-mineRangex2);
                    dy = -params.speed_fuel/norm([mineRangex2,mineRangey1]-self.pos)*(self.pos(2)-mineRangey1);
                else
                    dx = -params.speed_fuel/norm([mineRangex1,mineRangey1]-self.pos)*(self.pos(1)-mineRangex1);
                    dy = -params.speed_fuel/norm([mineRangex1,mineRangey1]-self.pos)*(self.pos(2)-mineRangey1);
                end 
            end
        elseif self.pos(2) > 80 && self.pos(1) >= mineRangex1 && self.pos(1) <= mineRangex2
            if (tankPos(1) < ((mineRangex2 - self.pos(1))/(mineRangey2-self.pos(2))*(tankPos(2)-self.pos(2))+self.pos(1))) && tankPos(2) <= 80 && (tankPos(1) > (self.pos(1) + (self.pos(1)-mineRangex1)/(mineRangey2-self.pos(2))*(self.pos(2) - tankPos(2)))) 
                if tankPos(1) > mine(n).pos(1)
                    dx = -params.speed_fuel/norm([mineRangex2,mineRangey2]-self.pos)*(self.pos(1)-mineRangex2);
                    dy = -params.speed_fuel/norm([mineRangex2,mineRangey2]-self.pos)*(self.pos(2)-mineRangey2);
                else
                    dx = -params.speed_fuel/norm([mineRangex1,mineRangey2]-self.pos)*(self.pos(1)-mineRangex1);
                    dy = -params.speed_fuel/norm([mineRangex1,mineRangey2]-self.pos)*(self.pos(2)-mineRangey2);
                end 
            end
            % Movement while in Corners
        elseif self.pos(1) < mineRangex1 && self.pos(2) < mineRangey1 
            if tankPos(2) > (mineRangey1 - self.pos(2))/(mineRangex2 - self.pos(1))*(tankPos(1)-(self.pos(1))) + self.pos(2) && tankPos(2) < (80 - self.pos(2))/(mineRangex1 - self.pos(1))*(tankPos(1) - self.pos(1)) + tankPos(2) && tankPos(1) >= mineRangex1 && tankPos(2) >= mineRangey1
                if norm(tankPos - [mineRangex1,mineRangey2]) < norm(tankPos - [mineRangex2,mineRangey1])
                    dx = -params.speed_fuel/norm([mineRangex1,mineRangey2]-self.pos)*(self.pos(1)-mineRangex1);
                    dy = -params.speed_fuel/norm([mineRangex1,mineRangey2]-self.pos)*(self.pos(2)-mineRangey2);
                else 
                    dx = -params.speed_fuel/norm([mineRangex2,mineRangey1]-self.pos)*(self.pos(1)-mineRangex2);
                    dy = -params.speed_fuel/norm([mineRangex2,mineRangey1]-self.pos)*(self.pos(2)-mineRangey1);
                end 
            end 
        elseif self.pos(1) < mineRangex1 && self.pos(2) > mineRangey2 
            if tankPos(2) < (mineRangey2 - self.pos(2))/(self.pos(1)-mineRangex2)*(tankPos(1)-(self.pos(1))) + self.pos(2) && tankPos(2) > (self.pos(2)-mineRangey1)/(mineRangex1 - self.pos(1))*(tankPos(1) - self.pos(1)) + tankPos(2) && tankPos(1) >= mineRangex1 && tankPos(2) <= mineRangey2
                if norm(tankPos - [mineRangex2,mineRangey2]) < norm(tankPos - [mineRangex1,mineRangey1])
                    dx = -params.speed_fuel/norm([mineRangex2,mineRangey2]-self.pos)*(self.pos(1)-mineRangex2);
                    dy = -params.speed_fuel/norm([mineRangex2,mineRangey2]-self.pos)*(self.pos(2)-mineRangey2);
                else 
                    dx = -params.speed_fuel/norm([mineRangex1,mineRangey1]-self.pos)*(self.pos(1)-mineRangex1);
                    dy = -params.speed_fuel/norm([mineRangex1,mineRangey1]-self.pos)*(self.pos(2)-mineRangey1);
                end 
            end   
        elseif self.pos(1) >mineRangex2 && self.pos(2) > mineRangey2 
            if tankPos(2) < (self.pos(2)-mineRangey2)/(mineRangex1-self.pos(1))*((self.pos(1)-tankPos(1))) + self.pos(2) && tankPos(2) > (self.pos(2)-mineRangey1)/(mineRangex2 - self.pos(1))*(tankPos(1) - self.pos(1)) + tankPos(2) && tankPos(1) <= mineRangex2 && tankPos(2) <= mineRangey2
                if norm(tankPos - [mineRangex1,mineRangey2]) < norm(tankPos - [mineRangex2,mineRangey1])
                    dx = -params.speed_fuel/norm([mineRangex1,mineRangey2]-self.pos)*(self.pos(1)-mineRangex1);
                    dy = -params.speed_fuel/norm([mineRangex1,mineRangey2]-self.pos)*(self.pos(2)-mineRangey2);
                else 
                    dx = -params.speed_fuel/norm([mineRangex2,mineRangey1]-self.pos)*(self.pos(1)-mineRangex2);
                    dy = -params.speed_fuel/norm([mineRangex2,mineRangey1]-self.pos)*(self.pos(2)-mineRangey1);
                end 
            end
        elseif self.pos(1) >mineRangex2 && self.pos(2) < mineRangey1 
            if tankPos(2) < (mineRangey2-self.pos(2))/(mineRangex1-self.pos(1))*((self.pos(1)-tankPos(1))) + self.pos(2) && tankPos(2) > (20 - self.pos(2))/(mineRangex1 - self.pos(1))*(tankPos(1) - self.pos(1)) + tankPos(2) && tankPos(1) <= mineRangex2 && tankPos(2) >= mineRangey1 
                if norm(tankPos - [mineRangex2,mineRangey2]) < norm(tankPos - [mineRangex1,mineRangey1])
                    dx = -params.speed_fuel/norm([mineRangex2,mineRangey2]-self.pos)*(self.pos(1)-mineRangex2);
                    dy = -params.speed_fuel/norm([mineRangex2,mineRangey2]-self.pos)*(self.pos(2)-mineRangey2);
                else 
                    dx = -params.speed_fuel/norm([mineRangex1,mineRangey1]-self.pos)*(self.pos(1)-mineRangex1);
                    dy = -params.speed_fuel/norm([mineRangex1,mineRangey1]-self.pos)*(self.pos(2)-mineRangey1);
                end 
            end    
        end
    end
    out = [dx, dy];
end