package components;

import luxe.Component;
import luxe.Color;
import luxe.Vector;
import luxe.collision.Collision;
import luxe.collision.shapes.Polygon;
import phoenix.geometry.Geometry;

class CollisionPolygon extends Component
{
    /**
     Geometry for showing if the user has their mouse over the segment.
     */
    private var visual : Geometry;

    /**
     The collision polygon used to detect if the mouse is over the segment.
     */
    private var polygon : Polygon;

    public function new()
    {
        super({ name : 'collision' });
    }

    override public function onadded()
    {       
        build();
    }

    override public function onremoved()
    {
        clean();
    }

    override public function update(_dt : Float)
    {
        visual.color.a = 0;
        
        var mouse = Luxe.camera.screen_point_to_world(Luxe.screen.cursor.pos);
        if (Collision.pointInPoly(mouse.x, mouse.y, polygon))
        {
            if (Luxe.input.mousepressed(left))
            {
                entity.events.queue('segment.clicked');
            }

            visual.color.a = 0.5;
        }
    }

    private function clean()
    {
        if (visual != null)
        {
            visual.drop();
            visual = null;
        }
        if (polygon != null)
        {
            polygon.destroy();
            polygon = null;
        }
    }

    public function build()
    {
        clean();

        if (has('points'))
        {
            var points : CurvePoints = cast get('points');

            // Build collision polygon
            var verticies = new Array<Vector>();

            for (point in points.data.points)
            {
                verticies.push(point.negativePoint.getLuxeVector());
            }

            var i : Int = points.data.points.length - 1;
            while (i >= 0)
            {
                var point = points.data.points[i];

                verticies.push(point.positivePoint.getLuxeVector());

                i --;
            }

            polygon = new Polygon(0, 0, verticies);

            // Build geometry visual
            var verticies = new Array<Vector>();
            for (point in points.data.points)
            {
                verticies.push(point.negativePoint.getLuxeVector());
                verticies.push(point.positivePoint.getLuxeVector());
            }

            visual = Luxe.draw.poly({
                points         : verticies,
                primitive_type : triangle_strip,
                color          : new Color().rgb(0x008aff),
                depth          : 3
            });
        }
    }
}
