package components.mouse;

import luxe.Component;
import luxe.Vector;
import entities.Cursor;
import utils.SegmentConstructor;

class SegmentCreator extends Component
{
    private var owner : Cursor;

    override public function onadded()
    {
        owner = cast entity;
    }

    override public function update(_dt : Float)
    {
        if (Luxe.input.mousepressed(left))
        {
            var mouse = Luxe.camera.screen_point_to_world(Luxe.screen.cursor.pos);
            switch (owner.segmentType)
            {
                case 'linear':
                    SegmentConstructor.linear([
                        new Vector(mouse.x - 128, mouse.y),
                        new Vector(mouse.x + 128, mouse.y)
                    ]);

                case 'quadratic':
                    SegmentConstructor.quadratic([
                        new Vector(mouse.x - 128, mouse.y),
                        new Vector(mouse.x      , mouse.y),
                        new Vector(mouse.x + 128, mouse.y)
                    ]);

                case 'cubic':
                    SegmentConstructor.cubic([
                        new Vector(mouse.x - 128, mouse.y),
                        new Vector(mouse.x - 48 , mouse.y),
                        new Vector(mouse.x + 48 , mouse.y),
                        new Vector(mouse.x + 128, mouse.y)
                    ]);
            }

            owner.fsm.changeState('blank');
        }
    }
}
