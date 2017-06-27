package components;

import luxe.Component;
import luxe.Color;
import luxe.Vector;
import phoenix.geometry.Geometry;

class RenderTangents extends Component
{
    private var geometry : Geometry;

    public function new()
    {
        super({ name : 'tangent_drawer' });
    }

    override public function onadded()
    {
        render();
    }

    override public function onremoved()
    {
        cleanup();
    }

    public function render()
    {
        cleanup();

        if (has('points'))
        {
            var points : CurvePoints = cast get('points');

            var verticies = new Array<Vector>();

            verticies.push(new Vector(
                points.startPoint.position.x,
                points.startPoint.position.y
            ));
            verticies.push(new Vector(
                points.startPoint.position.x + (10 * points.startPoint.tangent.x),
                points.startPoint.position.y + (10 * points.startPoint.tangent.y)
            ));

            for (point in points.subPoints)
            {
                verticies.push(new Vector(
                    point.position.x,
                    point.position.y
                ));
                verticies.push(new Vector(
                    point.position.x + (10 * point.tangent.x),
                    point.position.y + (10 * point.tangent.y)
                ));
            }

            verticies.push(new Vector(
                points.endPoint.position.x,
                points.endPoint.position.y
            ));
            verticies.push(new Vector(
                points.endPoint.position.x + (10 * points.endPoint.tangent.x),
                points.endPoint.position.y + (10 * points.endPoint.tangent.y)
            ));

            geometry = Luxe.draw.poly({
                points         : verticies,
                primitive_type : lines,
                depth          : 2,
                color          : new Color().rgb(0xff3f3f)
            });
        }
    }

    public function cleanup()
    {
        if (geometry != null)
        {
            geometry.drop();
            geometry = null;
        }
    }
}
