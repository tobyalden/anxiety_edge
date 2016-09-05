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
      assignOrientation();
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
    else if(orientation == "left" || orientation == "right") {
      velocity.y = speed;
    }

    moveBy(velocity.x, velocity.y);
  }

  private function assignOrientation()
  {
    if(
      scene.collidePoint("walls", x, y + height - 1) != null &&
      scene.collidePoint("walls", x + width, y + height - 1) != null
    ) {
      orientation = "floor";
      setHitbox(32, 16);
    }
    else if(
      scene.collidePoint("walls", x, y + 1) != null &&
      scene.collidePoint("walls", x + width, y + 1) != null
    ) {
      orientation = "ceiling";
      setHitbox(32, 16, 0, -16);
    }
    else if(
      scene.collidePoint("walls", x + width - 1, y) != null &&
      scene.collidePoint("walls", x + width - 1, y + height) != null
    ) {
      trace("added right blade");
      orientation = "right";
      setHitbox(16, 32);
    }
    else if(
      scene.collidePoint("walls", x, y) != null &&
      scene.collidePoint("walls", x, y + height) != null
    ) {
      orientation = "left";
      setHitbox(16, 32, -16, 0);
    }
    needsOrientation = false;
  }

  private function shouldReverse()
  {
      var mountPointA:Point;
      var mountPointB:Point;
      if(orientation == "floor") {
        mountPointA = new Point(x, y + height + 1);
        mountPointB = new Point(x + width, y + height + 1);
      }
      else if(orientation == "ceiling") {
        mountPointA = new Point(x, y + height - 1);
        mountPointB = new Point(x + width, y + height - 1);
      }
      else if(orientation == "right") {
        mountPointA = new Point(x + width + 1, y);
        mountPointB = new Point(x + width + 1, y + height);
      }
      else { // left
        mountPointA = new Point(x + width - 1, y);
        mountPointB = new Point(x + width - 1, y + height);
      }

      return collide("walls", x + velocity.x, y + velocity.y) != null ||
      scene.collidePoint("walls", mountPointA.x + velocity.x, mountPointA.y + velocity.y) == null ||
      scene.collidePoint("walls", mountPointB.x + velocity.x, mountPointB.y + velocity.y) == null;
  }
}
