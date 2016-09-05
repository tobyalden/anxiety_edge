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
			var level:Level = new Level("levels/level1.tmx");
			add(level);
			for (entity in level.entities) {
				add(entity);
			}
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
