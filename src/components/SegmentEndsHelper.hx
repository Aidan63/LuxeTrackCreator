package components;

import luxe.Component;
import luxe.Color;
import phoenix.geometry.Geometry;

class SegmentEndsHelper extends Component
{
    private var startText : Geometry;
    private var endText : Geometry;

    public function new()
    {
        super({ name : 'ends_helper' });
    }

    override public function onadded()
    {
        build();
    }

    override public function onremoved()
    {
        clean();
    }

    public function build()
    {
        clean();

        if (has('points'))
        {
            var points : CurvePoints = get('points');

            startText = Luxe.draw.text({
                color      : new Color().rgb(0xffffff),
                pos        : points.startPoint.position,
                point_size : 14,
                text       : 'start',
                depth      : 3,
                align      : center,
                align_vertical : center
            });
            endText   = Luxe.draw.text({
                color      : new Color().rgb(0xffffff),
                pos        : points.endPoint.position,
                point_size : 14,
                text       : 'end',
                depth      : 3,
                align      : center,
                align_vertical : center
            });
        }
    }

    private function clean()
    {
        if (startText != null)
        {
            startText.drop();
            startText = null;
        }

        if (endText != null)
        {
            endText.drop();
            endText = null;
        }
    }
}
