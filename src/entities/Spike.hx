package entities;

import com.haxepunk.graphics.*;
import com.haxepunk.utils.*;
import com.haxepunk.*;

class Spike extends ActiveEntity
{

  private var needsSprite:Bool;

  public function new(x:Int, y:Int)
  {
    super(x, y-32);
    sprite = new Spritemap("graphics/spikes.png", 32, 32);
    sprite.add("up", [0]);
    sprite.add("right", [1]);
    sprite.add("down", [2]);
    sprite.add("left", [3]);
    graphic = sprite;
    setHitbox(32, 32);
    needsSprite = true;
    type = "hazard";
  }

  public override function update()
  {
    if(needsSprite)
    {
      if(isOnCeiling())
      {
        sprite.play("down");
      }
      else if(isOnLeftWall())
      {
        sprite.play("right");
      }
      else if(isOnGround())
      {
        sprite.play("up");
      }
      else
      {
        sprite.play("left");
      }
      needsSprite = false;
    }
  }
}
