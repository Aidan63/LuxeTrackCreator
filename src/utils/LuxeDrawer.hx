package utils;

import luxe.collision.ShapeDrawer;
import luxe.collision.shapes.Circle;
import luxe.Vector;
import luxe.Log.*;

class LuxeDrawer extends ShapeDrawer
{
    var color = new luxe.Color().rgb(0xf6007b);
    var geom  = new Array<phoenix.geometry.Geometry>();

    override public function drawCircle(circle : Circle)
    {
        assertnull(circle);

        geom.push(Luxe.draw.ring({
            x: circle.position.x,
            y: circle.position.y,
            r: circle.transformedRadius,
            color: color,
            depth: 20
        }));
    }

    override public function drawLine(p0x : Float, p0y : Float, p1x : Float, p1y : Float, ?startPoint : Bool = true)
    {
        geom.push(Luxe.draw.line({
            p0 : new Vector(p0x, p0y),
            p1 : new Vector(p1x, p1y),
            color : color,
            depth : 20
        }));
    }

    public function clear()
    {
        for (g in geom)
        {
            g.drop(true);
        }
    }
}
