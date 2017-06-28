package components;

import luxe.Component;
import luxe.Color;
import luxe.Vector;
import phoenix.geometry.Geometry;
import luxe.collision.Collision;
import luxe.collision.shapes.Polygon;

class CollisionPolygon extends Component
{
    public var trackPoly : Polygon;
    public var visual : Geometry;

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
        if (Collision.pointInPoly(mouse.x, mouse.y, trackPoly))
        {
            if (Luxe.input.mousepressed(left))
            {
                entity.events.queue('segment.clicked');
            }

            visual.color.a = 0.5;
        }
    }

    public function build()
    {
        clean();

        if (has('points'))
        {
            var points : CurvePoints = cast get('points');
            var verticies = new Array<Vector>();

            // Start negative points
            verticies.push(points.startPoint.negativePoint);

            // Sub point negative points
            for (point in points.subPoints)
            {
                verticies.push(point.negativePoint);
            }

            // end negative point
            verticies.push(points.endPoint.negativePoint);
            // end positive point
            verticies.push(points.endPoint.positivePoint);

            // sub point positive points
            var i : Int = points.subPoints.length - 1;
            while (i >= 0)
            {
                var point = points.subPoints[i];

                verticies.push(point.positivePoint);

                i --;
            }

            // positive start point
            verticies.push(points.startPoint.positivePoint);

            // Create the poly
            trackPoly = new Polygon(0, 0, verticies);
        }

        render();
    }

    private function clean()
    {
        if (visual != null)
        {
            visual.drop();
            visual = null;
        }
        if (trackPoly != null)
        {
            trackPoly.destroy();
            trackPoly = null;
        }
    }

    private function render()
    {
        if (has('points'))
        {
            var points : CurvePoints = cast get('points');
            var verticies = new Array<Vector>();

            verticies.push(points.startPoint.negativePoint);
            verticies.push(points.startPoint.positivePoint);

            for (point in points.subPoints)
            {
                verticies.push(point.negativePoint);
                verticies.push(point.positivePoint);
            }

            verticies.push(points.endPoint.negativePoint);
            verticies.push(points.endPoint.positivePoint);

            visual = Luxe.draw.poly({
                points         : verticies,
                primitive_type : triangle_strip,
                color          : new Color().rgb(0x008aff),
                depth          : 3
            });
        }
    }
}
