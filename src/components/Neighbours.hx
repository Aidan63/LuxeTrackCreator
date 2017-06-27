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
}
