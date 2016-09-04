package entities;

import com.haxepunk.graphics.*;
import com.haxepunk.utils.*;
import com.haxepunk.*;

class Player extends ActiveEntity
{

  public static inline var RUN_SPEED = 1;
  public static inline var MAX_RUN_SPEED = 10;
  public static inline var DECCEL_SPEED = 1;

  public static inline var GRAVITY = 10;
  public static inline var MAX_FALL_SPEED = 20;


  public function new(x:Int, y:Int)
  {
    super(x, y);
    sprite = new Spritemap("graphics/player.png", 30, 30);
    sprite.add("idle", [0]);
    graphic = sprite;
    setHitbox(16, 16, -7, -14);
  }

  public override function update()
  {
      super.update();

      if(Input.check(Key.LEFT)) {
        velocity.x = Math.max(velocity.x - RUN_SPEED, -MAX_RUN_SPEED);
        sprite.flipped = true;
      }
      else if(Input.check(Key.RIGHT)) {
        velocity.x = Math.min(velocity.x + RUN_SPEED, MAX_RUN_SPEED);
        sprite.flipped = false;
      }
      else {
        if(velocity.x > 0) {
          velocity.x = Math.max(velocity.x - DECCEL_SPEED, 0);
        }
        else {
          velocity.x = Math.min(velocity.x + DECCEL_SPEED, 0);
        }
      }

      if(isOnGround()) {
        velocity.y = 0;
      }
      else {
        velocity.y = Math.min(velocity.y + GRAVITY * HXP.elapsed, MAX_FALL_SPEED);
      }

      moveBy(velocity.x, velocity.y , "walls");
  }

}
