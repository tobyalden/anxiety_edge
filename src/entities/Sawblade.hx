package entities;

import flash.geom.Point;
import com.haxepunk.graphics.*;
import com.haxepunk.utils.*;
import com.haxepunk.*;

class Sawblade extends ActiveEntity
{

  public static inline var SPEED = 5;

  private var orientation:String;
  private var needsOrientation:Bool;
  private var reversed:Bool;

  public function new(x:Float, y:Float)
  {
    super(x, y);
    reversed = false;
    orientation = "floor";
    needsOrientation = true;
    sprite = new Spritemap("graphics/sawblade.png", 32, 32);
    sprite.add("spin", [1, 2]);
    sprite.play("spin");
    graphic = sprite;
    setHitbox(32, 32);
    type = "hazard";
    layer = 100;
  }

  public override function update()
  {
    if(needsOrientation) {
      if(
        scene.collidePoint("walls", x, y + height) != null ||
        scene.collidePoint("walls", x + width, y + height) != null
      ) {
        orientation = "floor";
        setHitbox(32, 16);
      }
      else if(
        scene.collidePoint("walls", x, y) != null ||
        scene.collidePoint("walls", x + width, y) != null
      ) {
        orientation = "ceiling";
        setHitbox(32, 16, 0, -16);
      }
      needsOrientation = false;
    }
    if(shouldReverse()) {
      reversed = !reversed;
    }

    var speed = SPEED;
    if(reversed) {
      speed = -SPEED;
    }
    if(orientation == "floor" || orientation == "ceiling") {
      velocity.x = speed;
    }

    moveBy(velocity.x, velocity.y);
  }

  private function shouldReverse()
  {
      var mountPointA:Point;
      var mountPointB:Point;
      if(orientation == "floor") {
        mountPointA = new Point(x, y + height + 1);
        mountPointB = new Point(x + width, y + height + 1);
      } else { // ceiling
        mountPointA = new Point(x, y + halfHeight - 1);
        mountPointB = new Point(x + width, y + halfHeight + - 1);
      }

      return collide("walls", x + velocity.x, y + velocity.y) != null ||
      scene.collidePoint("walls", mountPointA.x + velocity.x, mountPointA.y + velocity.y) == null ||
      scene.collidePoint("walls", mountPointB.x + velocity.x, mountPointB.y + velocity.y) == null;
  }
}
