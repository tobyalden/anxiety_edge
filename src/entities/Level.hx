package entities;

import com.haxepunk.tmx.*;
import com.haxepunk.*;
import com.haxepunk.graphics.*;

class Level extends TmxEntity
{
  public var entities:Array<Entity>;

  public function new(filename:String)
  {
      super(filename);
      entities = new Array<Entity>();
      loadGraphic("graphics/tiles.png", ["walls"]);
      loadMask("walls", "walls");
      map = TmxMap.loadFromFile(filename);
      for(entity in map.getObjectGroup("entities").objects)
      {
          if(entity.gid == 3) {
            entities.push(new Player(entity.x, entity.y-32));
          }
          else if(entity.gid == 4) {
            entities.push(new Cannon(entity.x, entity.y-32, "horizontal"));
          }
          else if(entity.gid == 5) {
            entities.push(new Cannon(entity.x, entity.y-32, "vertical"));
          }
          else if(entity.gid == 6) {
            entities.push(new Sawblade(entity.x, entity.y-32));
          }
          else if(entity.gid >= 7 && entity.gid <= 10) {
            entities.push(new Spike(entity.x, entity.y-32));
          }
      }
  }

}
