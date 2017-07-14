package components;

import luxe.Component;
import luxe.Color;
import phoenix.geometry.Geometry;
import entities.TrackSegment;

class NeighbourHighlighter extends Component
{
    private var startPoint : Geometry;
    private var endPoint : Geometry;

    public function new()
    {
        super({ name : 'neighbour_drawer' });
    }

    override public function onadded()
    {
        if (has('points') && has('neighbours'))
        {
            var points     : CurvePoints = cast get('points');
            var neighbours : Neighbours  = cast get('neighbours');

            if (neighbours.previous == null)
            {
                startPoint = Luxe.draw.circle({
                    x     : points.data.get_firstPoint().position.x,
                    y     : points.data.get_firstPoint().position.y,
                    r     : 16,
                    depth : 3,
                    color : new Color().set(1, 0.3, 0.3, 0.5),
                });
            }
            if (neighbours.next == null)
            {
                endPoint = Luxe.draw.circle({
                    x     : points.data.get_lastPoint().position.x,
                    y     : points.data.get_lastPoint().position.y,
                    r     : 16,
                    depth : 3,
                    color : new Color().set(1, 0.3, 0.3, 0.5),
                });
            }
        }
    }

    override public function onremoved()
    {
        if (startPoint != null)
        {
            startPoint.drop();
            startPoint = null;
        }
        if (endPoint != null)
        {
            endPoint.drop();
            endPoint = null;
        }
    }

    override public function update(_dt : Float)
    {
        if (Luxe.input.mousepressed(left))
        {
            var mouse = Luxe.camera.screen_point_to_world(Luxe.screen.cursor.pos);
            if (startPoint != null && Luxe.utils.geometry.point_in_geometry(mouse, startPoint))
            {
                Luxe.events.fire('connect.segment', {
                    segment : cast(entity, TrackSegment),
                    type    : 'start'
                });
            }
            if (endPoint != null && Luxe.utils.geometry.point_in_geometry(mouse, endPoint))
            {
                Luxe.events.fire('connect.segment', {
                    segment : cast(entity, TrackSegment),
                    type    : 'end'
                });
            }
        }
    }
}
