package utils.fsm;

import luxe.Component;

class EntityState
{
    public var components : Map<String, Component>;

    public function new()
    {
        components = new Map<String, Component>();
    }

    public function add(_type : Component) : EntityState
    {
        components.set(_type.name, _type);
        return this;
    }
}
