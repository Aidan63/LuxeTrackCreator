package components.mouse;

import luxe.Component;
import entities.TrackSegment;

class SegmentConnector extends Component
{
    private var firstSegment : SegmentClicked;
    private var secondSegment : SegmentClicked;

    override public function onadded()
    {
        Luxe.events.listen('connect.segment', onSegmentClicked);

        firstSegment  = null;
        secondSegment = null;
    }

    override public function onremoved()
    {
        Luxe.events.unlisten('connect.segment');
    }

    private function onSegmentClicked(_data : SegmentClicked)
    {
        if (firstSegment == null)
        {
            firstSegment = _data;
        }
        else
        {
            if (firstSegment.segment.id != _data.segment.id && firstSegment.type != _data.type)
            {
                secondSegment = _data;
            }
        }

        if (firstSegment != null && secondSegment != null)
        {
            if (firstSegment.type == 'start')
            {
                firstSegment.segment.events.queue( 'neighbour.prev.connect', secondSegment.segment);
                secondSegment.segment.events.queue('neighbour.next.connect', firstSegment.segment );
            }
            else
            {
                firstSegment.segment.events.queue( 'neighbour.next.connect', secondSegment.segment);
                secondSegment.segment.events.queue('neighbour.prev.connect', firstSegment.segment );
            }

            Luxe.events.fire('cursor.select');
        }
    }
}

typedef SegmentClicked = {
    var segment : TrackSegment;
    var type    : String;
}
