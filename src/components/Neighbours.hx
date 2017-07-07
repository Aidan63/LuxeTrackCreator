package components;

import luxe.Component;
import entities.TrackSegment;

class Neighbours extends Component
{
    /**
     * The next track entity.
     */
    public var next : TrackSegment;

    /**
     * The previous track entity.
     */
    public var previous : TrackSegment;

    public function new()
    {
        super({ name : 'neighbours' });
    }

    override public function onadded()
    {
        next = null;
        previous = null;
    }

    override public function onremoved()
    {
        if (next != null)
        {
            next.events.fire('neighbour.prev.removed');
            next = null;
        }
        if (previous != null)
        {
            previous.events.fire('neighbour.next.removed');
            previous = null;
        }
    }
}
