package entities;

import luxe.Entity;
import utils.fsm.EntityStateMachine;

class Cursor extends Entity
{
    public var fsm : EntityStateMachine;
    public var segmentType : String;

    override public function init()
    {
        Luxe.events.listen('cursor.select' , onCursorSelect);
        Luxe.events.listen('cursor.create' , onCreateSegment);
        Luxe.events.listen('cursor.connect', onConnectSegments);

        fsm = new EntityStateMachine();
        fsm.createState('blank');
        fsm.createState('create_segment').add(new components.mouse.SegmentCreator());
        fsm.createState('connect_segments').add(new components.mouse.SegmentConnector());

        add(fsm);

        fsm.changeState('blank');
    }

    private function onCursorSelect(_)
    {
        fsm.changeState('blank');
    }

    private function onCreateSegment(_type : String)
    {
        segmentType = _type;
        fsm.changeState('create_segment');
    }

    private function onConnectSegments(_)
    {
        fsm.changeState('connect_segments');
    }
}
