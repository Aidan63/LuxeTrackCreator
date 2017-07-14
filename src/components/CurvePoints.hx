package components;

import luxe.Component;
import data.SegmentData;
import data.SegmentPoint;
import data.SegmentVector;
import components.Neighbours;
import components.curves.Curve;

class CurvePoints extends Component
{
    public var data : SegmentData;

    public function new()
    {
        super({ name : 'points' });
    }

    /**
     * Once added attempt to build the curve points.
     */
    override public function onadded()
    {
        data = new SegmentData();
        
        data.divisions = 64;

        data.startPositiveDistance = 64;
        data.endPositiveDistance   = 64;

        data.startNegativeDistance = 64;
        data.endNegativeDistance   = 64;

        build();
    }

    /**
     * Builds all of the segments points.
     */
    public function build()
    {
        data.points = new Array<SegmentPoint>();

        // Get this entities curve component.
        if (has('curve'))
        {
            var curve : Curve = cast get('curve');

            var iterations : Int = Math.ceil(curve.length / data.divisions);

            var positiveDiff : Float = data.endPositiveDistance - data.startPositiveDistance;
            var negativeDiff : Float = data.endNegativeDistance - data.startNegativeDistance;
            var positiveIncrement : Float = positiveDiff / iterations;
            var negativeIncrement : Float = negativeDiff / iterations;

            // Create the start point.
            var dataP0 : CurvePosition = curve.getPoint(0);
            data.points.push(new SegmentPoint(
                SegmentVector.fromLuxeVector(dataP0.position),
                SegmentVector.fromLuxeVector(dataP0.tangent),
                SegmentVector.fromLuxeVector(dataP0.normal),
                data.startPositiveDistance, data.startNegativeDistance
            ));

            // Create all of the sub points.
            for (i in 0...iterations)
            {
                // Skip t = 0 as that will be the start point.
                if (i == 0) continue;

                // Get the curves data at the current time and create a new point for it.
                var subPointData : CurvePosition = curve.getPoint(i / iterations);
                data.points.push(new SegmentPoint(
                    SegmentVector.fromLuxeVector(subPointData.position),
                    SegmentVector.fromLuxeVector(subPointData.tangent),
                    SegmentVector.fromLuxeVector(subPointData.normal),
                    data.startPositiveDistance + (i * positiveIncrement),
                    data.startNegativeDistance + (i * negativeIncrement)
                ));
            }

            // If there is a next neighbour use it's start point as our end point
            if (has('neighbours') && cast(get('neighbours'), Neighbours).next != null)
            {
                var neighbours : Neighbours = cast get('neighbours');
                var nextPoints : CurvePoints = cast neighbours.next.get('points');

                data.points.push(nextPoints.data.get_firstPoint());
            }
            else
            {
                // else create a default end point from this curve.
                var dataP1 : CurvePosition = curve.getPoint(1);
                data.points.push(new SegmentPoint(
                    SegmentVector.fromLuxeVector(dataP1.position),
                    SegmentVector.fromLuxeVector(dataP1.tangent),
                    SegmentVector.fromLuxeVector(dataP1.normal),
                    data.endPositiveDistance, data.endNegativeDistance
                ));
            }
        }
    }
}
