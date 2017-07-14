package components;

import luxe.Component;
import luxe.Color;
import phoenix.geometry.Geometry;

class SegmentOffsetHelper extends Component
{
    private var startPositiveText : Geometry;
    private var startNegativeText : Geometry;

    private var endPositiveText : Geometry;
    private var endNegativeText : Geometry;

    public function new()
    {
        super({ name : 'offset_helper' });
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

            startPositiveText = Luxe.draw.text({
                color      : new Color().rgb(0xffffff),
                pos        : points.data.get_firstPoint().positivePoint.getLuxeVector(),
                point_size : 14,
                text       : '+ve',
                depth      : 3,
                align      : center,
                align_vertical : center
            });
            startNegativeText = Luxe.draw.text({
                color      : new Color().rgb(0xffffff),
                pos        : points.data.get_firstPoint().negativePoint.getLuxeVector(),
                point_size : 14,
                text       : '-ve',
                depth      : 3,
                align      : center,
                align_vertical : center
            });

            endPositiveText = Luxe.draw.text({
                color      : new Color().rgb(0xffffff),
                pos        : points.data.get_lastPoint().positivePoint.getLuxeVector(),
                point_size : 14,
                text       : '+ve',
                depth      : 3,
                align      : center,
                align_vertical : center
            });
            endNegativeText = Luxe.draw.text({
                color      : new Color().rgb(0xffffff),
                pos        : points.data.get_lastPoint().negativePoint.getLuxeVector(),
                point_size : 14,
                text       : '-ve',
                depth      : 3,
                align      : center,
                align_vertical : center
            });
        }
    }

    private function clean()
    {
        if (startPositiveText != null)
        {
            startPositiveText.drop();
            startPositiveText = null;
        }
        if (startNegativeText != null)
        {
            startNegativeText.drop();
            startNegativeText = null;
        }
        if (endPositiveText != null)
        {
            endPositiveText.drop();
            endPositiveText = null;
        }
        if (endNegativeText != null)
        {
            endNegativeText.drop();
            endNegativeText = null;
        }
    }
}
