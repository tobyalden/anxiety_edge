import com.haxepunk.*;
import com.haxepunk.utils.*;
import flash.system.System;

import entities.*;

class MainScene extends Scene
{

	public function new()
	{
			super();
	}

	public override function begin()
	{
			add(new Level("levels/level1.tmx"));
			add(new Player(Math.floor(HXP.screen.width / 2), Math.floor(HXP.screen.height / 2)));
	}

	public override function update()
	{
		super.update();

		if(Input.pressed(Key.ESCAPE))
		{
			System.exit(0);
		}
	}
}
