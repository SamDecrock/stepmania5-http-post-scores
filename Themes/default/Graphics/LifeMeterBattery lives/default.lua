local player = Var "Player"
local blinkTime = 1.2
local barWidth = 256;
local barHeight = 32;

local t = Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(diffuse,color("#666666");zoomto,barWidth,barHeight);
	};
	Def.Quad{
		InitCommand=cmd(diffuse,color("#000000");zoomto,barWidth,barHeight;fadetop,1);
	};
	LoadActor("_lives")..{
		InitCommand=cmd(pause;horizalign,left;x,-(barWidth/2));
		BeginCommand=function(self,param)
			local screen = SCREENMAN:GetTopScreen();
			local glifemeter = screen:GetLifeMeter(player);
				self:setstate(glifemeter:GetTotalLives()-1);
				
				if glifemeter:GetTotalLives() <= 4 then
					self:zoomx(barWidth/(4*64));
				else
					self:zoomx(barWidth/((glifemeter:GetTotalLives())*64));
				end
				self:cropright((640-(((glifemeter:GetTotalLives())*64)))/640);
		end;
		LifeChangedMessageCommand=function(self,param)
			if param.Player == player then
				if param.LivesLeft == 0 then
					self:visible(false)
				else
					self:setstate( math.max(param.LivesLeft-1,0) )
					self:visible(true)
				end
			end
		end;
		StartCommand=function(self,param)
			if param.Player == player then
				self:setstate( math.max(param.LivesLeft-1,0) );			
			end			
		end;
		FinishCommand=cmd(playcommand,"Start");
	};
	
};

return t;