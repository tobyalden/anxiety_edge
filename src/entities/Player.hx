package entities;

import com.haxepunk.graphics.*;
import com.haxepunk.utils.*;
import com.haxepunk.*;

class Player extends ActiveEntity
{

  public static inline var RUN_SPEED = 1;
  public static inline var MAX_RUN_SPEED = 10;
  public static inline var DECCEL_SPEED = 1;

  public static inline var AIR_DECCEL_SPEED = 0.25;

  public static inline var GRAVITY = 10;
  public static inline var MAX_FALL_SPEED = 20;

  public static inline var JUMP_POWER = 10;
  public static inline var JUMP_CANCEL_POWER = 5;

  public function new(x:Int, y:Int)
  {
    super(x, y);
    sprite = new Spritemap("graphics/player.png", 30, 30);
    sprite.add("idle", [0]);
    sprite.add("run", [1, 2, 3, 4], 12);
    sprite.add("jump", [5]);
    sprite.add("boost", [6]);
    sprite.add("skid", [7]);
    graphic = sprite;
    setHitbox(16, 16, -7, -14);
  }

  public override function update()
  {
      super.update();

      if(isOnWall())
      {
        velocity.x = 0;
      }

      if(Input.check(Key.LEFT)) {
        velocity.x = Math.max(velocity.x - RUN_SPEED, -MAX_RUN_SPEED);
        if(velocity.x > 0) {
          sprite.play("skid");
        }
        else {
          sprite.play("run");
        }
        sprite.flipped = true;
      }
      else if(Input.check(Key.RIGHT)) {
        velocity.x = Math.min(velocity.x + RUN_SPEED, MAX_RUN_SPEED);
        if(velocity.x < 0) {
          sprite.play("skid");
        }
        else {
          sprite.play("run");
        }
        sprite.flipped = false;
      }
      else {
        var deccelSpeed:Float;
        if(isOnGround()) {
          deccelSpeed = DECCEL_SPEED;
        }
        else {
          deccelSpeed = AIR_DECCEL_SPEED;
        }
        if(velocity.x > 0) {
          velocity.x = Math.max(velocity.x - deccelSpeed, 0);
        }
        else {
          velocity.x = Math.min(velocity.x + deccelSpeed, 0);
        }
        if(velocity.x != 0) {
          sprite.play("skid");
        }
        else {
          sprite.play("idle");
        }
      }

      if(isOnGround()) {
        velocity.y = 0;
        if(Input.check(Key.Z)) {
          velocity.y = -JUMP_POWER;
        }
      }
      else {
        sprite.play("jump");
        if(isOnCeiling()) {
          velocity.y = JUMP_POWER/5;
        }
        else if(Input.released(Key.Z) && velocity.y < -JUMP_CANCEL_POWER) {
          velocity.y = -JUMP_CANCEL_POWER;
        }
        velocity.y = Math.min(velocity.y + GRAVITY * HXP.elapsed, MAX_FALL_SPEED);
      }

      moveBy(velocity.x, velocity.y , "walls");
  }

}
