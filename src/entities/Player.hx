package entities;

import com.haxepunk.graphics.*;
import com.haxepunk.utils.*;
import com.haxepunk.*;

class Player extends ActiveEntity
{

  public static inline var RUN_SPEED = 1;
  public static inline var AIR_RUN_SPEED = 0.5;
  public static inline var MAX_RUN_SPEED = 10;
  public static inline var DECCEL_SPEED = 1;

  public static inline var AIR_DECCEL_SPEED = 0.25;

  public static inline var GRAVITY = 10;
  public static inline var MAX_FALL_SPEED = 20;
  public static inline var MAX_UPWARDS_SPEED = 30;

  public static inline var JUMP_POWER = 10;
  public static inline var JUMP_CANCEL_POWER = 5;

  public static inline var BOOST_POWER = 0.6;
  public static inline var MAX_JETPACK_FUEL = 50;

  private var fuel:Int;
  private var canBoost:Bool;

  private var fuelBar:Image;
  private var allGraphics:Graphiclist;

  public function new(x:Int, y:Int)
  {
    super(x, y);
    allGraphics = new Graphiclist(new Array<Graphic>());
    sprite = new Spritemap("graphics/player.png", 30, 30);
    sprite.add("idle", [0]);
    sprite.add("run", [1, 2, 3, 4], 12);
    sprite.add("jump", [5]);
    sprite.add("boost", [6]);
    sprite.add("skid", [7]);

    fuelBar = new Image("graphics/fuelbar.png");
    fuelBar.alpha = 0.5;

    allGraphics.add(fuelBar);
    allGraphics.add(sprite);
    graphic = allGraphics;
    setHitbox(16, 16, -7, -14);
    fuel = MAX_JETPACK_FUEL;
    canBoost = false;
  }

  public override function update()
  {
      super.update();

      if(isOnWall())
      {
        velocity.x = 0;
      }

      var runSpeed:Float;
      if(isOnGround()) {
        runSpeed = RUN_SPEED;
      }
      else {
        runSpeed = AIR_RUN_SPEED;
      }

      if(Input.check(Key.LEFT)) {
        velocity.x = Math.max(velocity.x - runSpeed, -MAX_RUN_SPEED);
        if(velocity.x > 0) {
          sprite.play("skid");
        }
        else {
          sprite.play("run");
        }
        sprite.flipped = true;
      }
      else if(Input.check(Key.RIGHT)) {
        velocity.x = Math.min(velocity.x + runSpeed, MAX_RUN_SPEED);
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
        canBoost = false;
        fuel = MAX_JETPACK_FUEL;
        if(Input.check(Key.Z)) {
          velocity.y = -JUMP_POWER;
        }
      }
      else {
        sprite.play("jump");
        if(isOnCeiling()) {
          velocity.y = JUMP_POWER/5;
        }
        if(velocity.y > -JUMP_CANCEL_POWER  && !Input.check(Key.Z)) {
          canBoost = true;
        }
        else if(Input.released(Key.Z) && velocity.y < -JUMP_CANCEL_POWER && !canBoost) {
          velocity.y = -JUMP_CANCEL_POWER;
          canBoost = true;
        }
        if(canBoost && Input.check(Key.Z)) {
          if(fuel > 0)
          {
            velocity.y -= BOOST_POWER;
            fuel -= 1;
            sprite.play("boost");
          }
        }
        velocity.y = Math.min(velocity.y + GRAVITY * HXP.elapsed, MAX_FALL_SPEED);
        velocity.y = Math.max(velocity.y, -MAX_UPWARDS_SPEED);
      }

      moveBy(velocity.x, velocity.y , "walls");

      fuelBar.scaleX = fuel / MAX_JETPACK_FUEL;
      fuelBar.visible = fuel < MAX_JETPACK_FUEL;
  }

}
