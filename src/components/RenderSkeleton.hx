package components;

import luxe.Component;
import luxe.Color;
import luxe.Vector;
import phoenix.geometry.Geometry;

import components.CurvePoints;

class RenderSkeleton extends Component
{
    /**
     * Array to hold all of the point visuals
     */
    private var dots : Array<Geometry>;

    /**
     * Outline geometry.
     */
    private var outline : Geometry;

    public function new()
    {
        super({ name : 'skeleton_drawer' });
    }

    override public function onadded()
    {
        render();
    }

    override public function onremoved()
    {
        clean();
    }

    public function render()
    {
        clean();

        if (has('points'))
        {
            var points : CurvePoints = cast get('points');

            // Draw the lines
            var verticies = new Array<Vector>();

            // Sub point negative points
            for (point in points.data.points)
            {
                verticies.push(point.negativePoint.getLuxeVector());
            }

            // sub point positive points
            var i : Int = points.data.points.length - 1;
            while (i >= 0)
            {
                var point = points.data.points[i];

                verticies.push(point.positivePoint.getLuxeVector());

                i --;
            }

            outline = Luxe.draw.poly({
                points         : verticies,
                primitive_type : line_loop,
                color          : new Color().rgb(0x3c65ff),
                depth          : 2
            });

            // Draw the dots
            /*
            dots = new Array<Visual>();

            // Start dots
            dots.push(new Visual({
                color    : new Color().rgb(0xffd33c),
                geometry : Luxe.draw.circle({
                    x : points.startPoint.negativePoint.x,
                    y : points.startPoint.negativePoint.y,
                    r : 2
                })
            }));
            dots.push(new Visual({
                color    : new Color().rgb(0xffd33c),
                geometry : Luxe.draw.circle({
                    x : points.startPoint.positivePoint.x,
                    y : points.startPoint.positivePoint.y,
                    r : 2
                })
            }));

            // Sub point dots
            for (point in points.subPoints)
            {
                dots.push(new Visual({
                    color    : new Color().rgb(0xffd33c),
                    geometry : Luxe.draw.circle({
                        x : point.negativePoint.x,
                        y : point.negativePoint.y,
                        r : 2
                    })
                }));
                dots.push(new Visual({
                    color    : new Color().rgb(0xffd33c),
                    geometry : Luxe.draw.circle({
                        x : point.positivePoint.x,
                        y : point.positivePoint.y,
                        r : 2
                    })
                }));
            }

            // end dots.
            dots.push(new Visual({
                color    : new Color().rgb(0xffd33c),
                geometry : Luxe.draw.circle({
                    x : points.endPoint.negativePoint.x,
                    y : points.endPoint.negativePoint.y,
                    r : 2
                })
            }));
            dots.push(new Visual({
                color    : new Color().rgb(0xffd33c),
                geometry : Luxe.draw.circle({
                    x : points.endPoint.positivePoint.x,
                    y : points.endPoint.positivePoint.y,
                    r : 2
                })
            }));
            */
        }
    }

    public function clean()
    {
        if (dots != null)
        {
            for (i in 0...dots.length)
            {
                dots[i].drop();
                dots[i] = null;
            }
            dots = null;
        }

        if (outline != null)
        {
            outline.drop();
            outline = null;
        }
    }
}
