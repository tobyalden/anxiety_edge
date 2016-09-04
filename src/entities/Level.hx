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
      /*for(entity in map.getObjectGroup("entities").objects)
      {

      }*/
  }
}
