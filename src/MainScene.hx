import com.haxepunk.Scene;
import com.haxepunk.HXP;
import entities.*;

class MainScene extends Scene
{

	public function new()
	{
			super();
	}

	public override function begin()
	{
			add(new Player(Math.floor(HXP.screen.width / 2), Math.floor(HXP.screen.height / 2)));
	}

	public override function update()
	{
		super.update();
	}
}
