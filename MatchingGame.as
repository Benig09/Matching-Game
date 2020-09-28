package
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.utils.*;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	 
	public class MatchingGame extends MovieClip
	{
		var score:int;
		var fClip:Logo;
		var sClip:Logo;
		var myTimer:Timer;
		var frames:Array;
		var gameMode:String;
		var rows_count:int;
		var columns_count:int;
		var t:int;
		var time_interval;
		var themes:int = 15 ;
		
		public function MatchingGame():void
		{
			// constructor code
			start_screen.btnEasy.addEventListener(MouseEvent.CLICK, easyMode);
			start_screen.btnMedium.addEventListener(MouseEvent.CLICK, mediumMode);
			start_screen.btnHard.addEventListener(MouseEvent.CLICK, hardMode);
			start_screen.btnMy.addEventListener(MouseEvent.CLICK, my);
			start_screen.btnJpn.addEventListener(MouseEvent.CLICK, jpn);
			start_screen.btnKorea.addEventListener(MouseEvent.CLICK, korea);
			btnBack.visible = false ;
		}
		private function my(e:MouseEvent) 
		{
			this.themes = 13 ;
		   
		}
		private function jpn(e:MouseEvent) 
		{
			this.themes = 12 ;
		}
		private function korea(e:MouseEvent) 
		{
			this.themes = 14 ;
		}
		private function easyMode(e:MouseEvent)
		{
			this.gameMode = "easy";
			start_screen.visible = false;
			frames = new Array(1, 1, 2, 2, 3, 3);
			this.init_game();
		}
		private function mediumMode(e:MouseEvent)
		{
			this.gameMode = "medium";
			start_screen.visible = false;
			frames = new Array(1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6);
			this.init_game();
		}
		private function hardMode(e:MouseEvent)
		{
			this.gameMode = "hard";
			start_screen.visible = false;
			frames = new Array(1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10);
			this.init_game();
		}
		
		private function init_game()
		{
		
			// rows and columns of game based on game mode
			if (this.gameMode == "hard")
			{
				rows_count = 5;
				columns_count = 4;
				
			}
			else if (this.gameMode == "medium")
			{
				rows_count = 4 ;
				columns_count = 3 ; 
				
			}
			else if (this.gameMode == "easy")
			{
				rows_count = 3;
				columns_count = 2;
				
			}
			for (var i:Number = 1; i <= rows_count; i++)
			{
				for (var j:Number = 1; j <= columns_count; j++)
				{
					var myLogo:Logo = new Logo();
					var index = Math.floor(Math.random() * frames.length)
					
					myLogo.frameNo = frames[index];
					frames.splice(index, 1);
					this.game_holder.addChild(myLogo);
					myLogo.x = j * 140;
					myLogo.y = i * 100;
					
					myLogo.gotoAndStop(themes);
					myLogo.addEventListener(MouseEvent.CLICK, openLogo);
				}
			}
			
			// game timer
			this.t = 40;
			this.time_interval = setInterval(this.TIMER, 1000);
			this.score_display.text = "0";
			this.TIMER();
			
			btnBack.visible = true ; 
			btnBack.addEventListener(MouseEvent.CLICK, back);
		}
		private function back(e :MouseEvent)  
		{
			
			start_screen.visible = true ; 
			btnBack.visible = false ;
			clearInterval(this.time_interval);
			this.frames = new Array(1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10);
			while (this.game_holder.numChildren)
			{
				this.game_holder.removeChildAt(0);
			}
			score_display.text = "";
			time_display.text = "";
			
		}
		
		private function TIMER():void
		{
			this.time_display.text = this.t.toString();
			if (this.t == 0)
			{
				clearInterval(this.time_interval);
				this.game_over();
			}
			else
			{
				this.t--;
			}
		}
		private function addScore(points:int)
		{
			this.score += points;
			this.score_display.text = String(this.score);
		}
		
		private function game_over()
		{
			clearInterval(this.time_interval);
			this.frames = new Array(1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10);
			while (this.game_holder.numChildren)
			{
				this.game_holder.removeChildAt(0);
			}
			this.game_over_display.visible = true;
			// adding time bouns to score (this.t)
			this.game_over_display.score_display2.text = String(this.score+this.t);
			this.game_over_display.restartBtn.addEventListener(MouseEvent.CLICK, reset_game);
			score_display.visible = false ;
			time_display.visible = false ;
			btnBack.visible = false ;
			
		}
		
		private function reset_game(e:MouseEvent)
		{
			this.game_over_display.visible = false;
			this.frames = new Array(1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10);
			while (this.game_holder.numChildren)
			{
				this.game_holder.removeChildAt(0);
			}
			score_display.text = "";
			time_display.text = "";
			this.score = 0;
			start_screen.visible = true;
			btnBack.visible = false ;
		}
		
		private function openLogo(e:MouseEvent)
		{
			var clickObj:Logo = Logo(e.target);
			
			if (fClip == null)
			{
				fClip = clickObj;
			
				fClip.gotoAndStop(fClip.frameNo);
			}
			else if (sClip == null && fClip != clickObj)
			{
				sClip = clickObj;
				sClip.gotoAndStop(sClip.frameNo);
				
				if (fClip.frameNo == sClip.frameNo)
				{
					myTimer = new Timer(500, 1);
					myTimer.start();
					myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, removeLogos);
					this.addScore(2);
				}
				else
				{
					myTimer = new Timer(500, 1);
					myTimer.start();
					myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, resetLogos);
				}
			}
		}
		
		private function removeLogos(e:TimerEvent)
		{
			this.game_holder.removeChild(fClip);
			this.game_holder.removeChild(sClip);
			myTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, removeLogos);
			fClip = null;
			sClip = null;
			if (this.game_holder.numChildren == 0)
			{
				this.game_over();
			}
		}
		
		private function resetLogos(e:TimerEvent)
		{
			fClip.gotoAndStop(themes);
			sClip.gotoAndStop(themes);
			myTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, resetLogos);
			fClip = null;
			sClip = null;
		}
	}
}



