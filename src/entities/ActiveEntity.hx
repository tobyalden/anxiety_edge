package entities;

import flash.geom.Point;
import com.haxepunk.*;
import com.haxepunk.graphics.*;

class ActiveEntity extends Entity
{
    private var sprite:Spritemap;
    private var velocity:Point;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        velocity = new Point(0, 0);
    }

    public override function update()
    {
        super.update();
        unstuck();
    }

    public function getPositionOnScreen()
    {
      return new Point(x % HXP.screen.width, y % HXP.screen.height);
    }

    private function unstuck()
    {
        while(collide('walls', x, y) != null) {
          moveBy(0, -10);
        }
    }

    private function isOnGround()
    {
        return collide("walls", x, y + 1) != null;
    }

    private function isOnCeiling()
    {
        return collide("walls", x, y - 1) != null;
    }

    private function isOnWall()
    {
        return collide("walls", x - 1, y) != null || collide("walls", x + 1, y) != null;
    }

    private function isOnRightWall()
    {
        return collide("walls", x + 1, y) != null;
    }

    private function isOnLeftWall()
    {
        return collide("walls", x - 1, y) != null;
    }
}
