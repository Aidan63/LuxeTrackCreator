package components;

import luxe.Component;
import luxe.Color;
import luxe.collision.Collision;
import luxe.collision.shapes.Polygon;
import phoenix.geometry.Geometry;
import components.CurvePoints;

class CurveQuadCollisions extends Component
{
    /**
     * Array of all of the collision polygons
     */
    private var polygons : Array<Polygon>;

    /**
     * Array which holds all of the quad geometries.
     */
    private var geometry : Array<Geometry>;

    public function new()
    {
        super({ name : 'curve_quads' });
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
        var mouse = Luxe.camera.screen_point_to_world(Luxe.screen.cursor.pos);
        for (i in 0...polygons.length)
        {
            if (Collision.pointInPoly(mouse.x, mouse.y, polygons[i]))
            {
                geometry[i].color.a = 0.5;

                if (Luxe.input.mousedown(left))
                {
                    if (has('tile_drawer'))
                    {
                        cast(get('tile_drawer'), CurveTileRenderer).updateTexture(i);
                    }
                }
            }
            else
            {
                geometry[i].color.a = 0;
            }
        }
    }

    public function build()
    {
        if (has('points'))
        {
            var points : CurvePoints = cast get('points');

            clean();
            geometry = new Array<Geometry>();
            polygons = new Array<Polygon>();

            // Initial two quads
            var negativeVerticies = [
                points.startPoint.position,
                points.startPoint.negativePoint,
                points.subPoints[0].negativePoint,
                points.subPoints[0].position
            ];
            var positiveVerticies = [
                points.startPoint.position,
                points.startPoint.positivePoint,
                points.subPoints[0].positivePoint,
                points.subPoints[0].position
            ];

            geometry.push(Luxe.draw.poly({
                points   : negativeVerticies,
                color    : new Color().rgb(0x008aff),
                depth    : 1
            }));
            geometry.push(Luxe.draw.poly({
                points   : positiveVerticies,
                color    : new Color().rgb(0x008aff),
                depth    : 1
            }));

            polygons.push(new Polygon(0, 0, negativeVerticies));
            polygons.push(new Polygon(0, 0, positiveVerticies));

            // Sub point quads
            var prevPoints : Point = null;
            for (point in points.subPoints)
            {
                if (prevPoints != null)
                {
                    var negativeVerticies = [
                        prevPoints.position,
                        prevPoints.negativePoint,
                        point.negativePoint,
                        point.position
                    ];
                    var positiveVerticies = [
                        prevPoints.position,
                        prevPoints.positivePoint,
                        point.positivePoint,
                        point.position
                    ];

                    geometry.push(Luxe.draw.poly({
                        points   : negativeVerticies,
                        color    : new Color().rgb(0x008aff),
                        depth    : 1
                    }));
                    geometry.push(Luxe.draw.poly({
                        points   : positiveVerticies,
                        color    : new Color().rgb(0x008aff),
                        depth    : 1
                    }));

                    polygons.push(new Polygon(0, 0, negativeVerticies));
                    polygons.push(new Polygon(0, 0, positiveVerticies));
                }

                prevPoints = point;
            }

            // Last two quads
            var negativeVerticies = [
                prevPoints.position,
                prevPoints.negativePoint,
                points.endPoint.negativePoint,
                points.endPoint.position
            ];
            var positiveVerticies = [
                prevPoints.position,
                prevPoints.positivePoint,
                points.endPoint.positivePoint,
                points.endPoint.position
            ];

            geometry.push(Luxe.draw.poly({
                points   : negativeVerticies,
                color    : new Color().rgb(0x008aff),
                depth    : 1
            }));
            geometry.push(Luxe.draw.poly({
                points   : positiveVerticies,
                color    : new Color().rgb(0x008aff),
                depth    : 1
            }));
            
            polygons.push(new Polygon(0, 0, negativeVerticies));
            polygons.push(new Polygon(0, 0, positiveVerticies));
        }
    }

    private function clean()
    {
        // Remove the collision polygons and set the array to null for future checks.
        if (polygons != null)
        {
            for (i in 0...polygons.length)
            {
                polygons[i].destroy();
            }
            polygons = null;
        }

        // Drop all of the geometries and set the array to null for future checks.
        if (geometry != null)
        {
            for (i in 0...geometry.length)
            {
                geometry[i].drop();
                geometry[i] = null;
            }
            geometry = null;
        }
    }
}
