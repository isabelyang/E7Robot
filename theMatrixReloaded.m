function [out]=theMatrixReloaded(self, enemy, tank, mine)
params.speed_fuel = 2.75;
params.speed_glue = 1;
params.speed_end = 1;
d = inf;
I = 0;
if ~isempty(tank)
    for i = 1:length(tank)
        D = norm(tank(i).pos - self.pos);
        if  (D < d) && ((tank(i).pos(1)<=17)||(tank(i).pos(1)>=83)||(tank(i).pos(2)<=17)||(tank(i).pos(2)>=83)) 
            d = D;
            I = i;
        end
    end
end
if (self.pos(1)>17 && self.pos(1)<=83) && (self.pos(2)>=17 && self.pos(2)<=83)
   if enemy.fuel == 0
       if (enemy.pos(1)>17 && enemy.pos(1)<=83) && (enemy.pos(2)>=17 && enemy.pos(2)<=83)
           d = norm(self.pos - enemy.pos);  
           dx = (params.speed_end/d)*(enemy.pos(1)-self.pos(1));
           dy = (params.speed_end/d)*(enemy.pos(2)-self.pos(2));  
           out = [dx, dy];
       else
           out=leavegluezone(self,params.speed_glue);
       end
   else
       out=leavegluezone(self,params.speed_glue);
   end
else
    if enemy.fuel==0
        if (enemy.pos(1)>20 && enemy.pos(1)<=80) && (enemy.pos(2)>=20 && enemy.pos(2)<=80)
           d = norm(self.pos - enemy.pos);  
           dx = (params.speed_end/d)*(enemy.pos(1)-self.pos(1));
           dy = (params.speed_end/d)*(enemy.pos(2)-self.pos(2));  
           out = [dx, dy];
        else
           d = norm(self.pos - enemy.pos);  
           dx = (params.speed_end/d)*(enemy.pos(1)-self.pos(1));
           dy = (params.speed_end/d)*(enemy.pos(2)-self.pos(2));  
           out = [dx, dy];
           out=goincircle(self,out);
        end
    else
        if (d==inf)||isempty(tank)
            out=[0,0];
        else
            dx = (params.speed_fuel/d)*(tank(I).pos(1)-self.pos(1));
            dy = (params.speed_fuel/d)*(tank(I).pos(2)-self.pos(2));
            out = [dx, dy];  
            out=goincircle(self,out);
        end    
    end
end
out = runaway(self, enemy, out);
end

function [out]=leavegluezone(self, speed)
    u = norm(self.pos(2)-17);
    v = norm(self.pos(2)-83);
    s = norm(self.pos(1)-17);
    t = norm(self.pos(1)-83);
    p = u-v;
    q = s-t;
    if p<=0
        ydest = u;
    elseif p>0 
        ydest = v;
    end
    if q<=0
        xdest = s;
    elseif q>0
        xdest = t;
    end 
    z = xdest-ydest;
    if z<=0
        dest = xdest;
    elseif z>0
        dest = ydest;
    end
    if dest == u
        dy = (speed/dest)*(17-self.pos(2));
        dx = 0;
    elseif dest == v
        dy = (speed/dest)*(83-self.pos(2));
        dx = 0;
    elseif dest == s 
        dy = 0;
        dx = (speed/dest)*(17-self.pos(1));
    elseif dest == t
        dy = 0;
        dx = (speed/dest)*(83-self.pos(1));
    end
    out = [dx,dy];
end

function [out]=goincircle(self,blah)
newpos=self.pos+blah;
dx=blah(1);
dy=blah(2);
if (newpos(1)>17 && newpos(1)<=83) && (newpos(2)>=17 && newpos(2)<=83)
    if (newpos(1)>newpos(2))&&(newpos(2)<(100-newpos(1)))||(newpos(2)>newpos(1))&&(newpos(2)>(100-newpos(1)))
        if dx>0
            out=[2.75,0];
        elseif dx<0
            out=[-2.75,0];
        elseif dx==0
            if newpos(1)<=50
                out=[-2.75,0];
            elseif newpos(1)>50
                out=[2.75,0];
            end
        end
    elseif (newpos(2)>newpos(1))&&(newpos(2)<(100-newpos(1)))||(newpos(2)<newpos(1))&&(newpos(2)>(100-newpos(1)))
        if dy>0
            out=[0,2.75];
        elseif dy<0
            out=[0,-2.75];
        elseif dy==0        
            if newpos(2)<=50
                out=[0,-2.75];
            elseif newpos(2)>50
                out=[0,2.75];
            end
        end
    elseif (newpos(1)==newpos(2))||(newpos(2)==(100-newpos(1)))
       if dx>0
            out=[2.75,0];
        elseif dx<0
            out=[-2.75,0];
        elseif dx==0
            if newpos(1)<=50
                out=[-2.75,0];
            elseif newpos(1)>50
                out=[2.75,0];
            end
        end
    end
else
    out=blah;
end

%{
newpos=self.pos+out;
if (newpos(1)>=17)&&(newpos(1)<=20)
    if (newpos(2)>=17)&&(newpos(2)<=83)
        out=[0,-2.5];
    end 
elseif (newpos(1)>=80)&&(newpos(1)<=83)
    if (newpos(2)>=17)&&(newpos(2)<=83)       
        out=[0,2.5];
    end
elseif (newpos(2)>=17)&&(newpos(2)<=20)
    if (newpos(1)>=17)&&(newpos(1)<=83)
        out=[2.5,0];
    end
elseif (newpos(2)>=80)&&(newpos(2)<=83)
    if (newpos(1)>=17)&&(newpos(1)<=83)
        out=[-2.5,0];
    end
end
%}
end

function [out] = runaway(self, enemy, out)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if enemy.fuel >= self.fuel
    d = norm(self.pos - enemy.pos);
    if d < 10
        out = [enemy.prev];
        newpos = self.pos + out;
        if (newpos(1)>=0)&&(newpos(1)<=1)
            if (newpos(2)>=1)&&(newpos(2)<=99)
                out=[0,-2.75];
            end 
        elseif (newpos(1)>=99)&&(newpos(1)<=100)
            if (newpos(2)>=1)&&(newpos(2)<=99)       
                out=[0,2.75];
            end
        elseif (newpos(2)>=0)&&(newpos(2)<=1)
            if (newpos(1)>=1)&&(newpos(1)<=99)
                out=[2.75,0];
            end
        elseif (newpos(2)>=99)&&(newpos(2)<=100)
            if (newpos(1)>=1)&&(newpos(1)<=99)
                out=[-2.75,0];
            end
        end
    else
        out = out;
    end
end
    
end
