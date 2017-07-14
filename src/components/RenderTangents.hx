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

            for (point in points.data.points)
            {
                verticies.push(point.position.getLuxeVector());
                verticies.push(new Vector(
                    point.position.x + (10 * point.tangent.x),
                    point.position.y + (10 * point.tangent.y)
                ));
            }

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
