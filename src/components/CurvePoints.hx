package components;

import luxe.Component;
import luxe.Vector;

import components.Neighbours;
import components.curves.Curve;

class CurvePoints extends Component
{
    /**
     * The start point of this curve.
     * 
     * Will always be from time 0 of this entities curve.
     */
    public var startPoint : Point;

    /**
     * The end point of this curve.
     * 
     * If the next neighbour is not null this end point will be the next neighbours start point.
     */
    public var endPoint : Point;

    /**
     * The distance between each curve sub point.
     */
    public var divisions : Int;

    /**
     * The distance to the start positive offset from the curve point.
     */
    public var startPositiveDistance : Float;

    /**
     * The distance to the start negative offset from the curve point.
     */
    public var startNegativeDistance : Float;

    /**
     * The distance to the end positive offset from the curve point.
     */
    public var endPositiveDistance : Float;

    /**
     * The distance to the end negative offset from the curve point.
     */
    public var endNegativeDistance : Float;

    /**
     * All of the points between the start and end point.
     */
    public var subPoints : Array<Point>;

    public function new()
    {
        super({ name : 'points' });
    }

    /**
     * Once added attempt to build the curve points.
     */
    override public function onadded()
    {
        divisions = 64;

        startPositiveDistance = 64;
        endPositiveDistance   = 64;

        startNegativeDistance = 64;
        endNegativeDistance   = 64;

        build();
    }

    /**
     * Builds all of the segments points.
     */
    public function build()
    {
        subPoints = new Array<Point>();

        // Get this entities curve component.
        if (has('curve'))
        {
            var curve : Curve = cast get('curve');

            var iterations : Int = Math.ceil(curve.length / divisions);

            var positiveDiff : Float = endPositiveDistance - startPositiveDistance;
            var negativeDiff : Float = endNegativeDistance - startNegativeDistance;
            var positiveIncrement : Float = positiveDiff / iterations;
            var negativeIncrement : Float = negativeDiff / iterations;

            // Create all of the sub points.
            for (i in 0...iterations)
            {
                // Skip t = 0 as that will be the start point.
                if (i == 0) continue;

                // Get the curves data at the current time and create a new point for it.
                var data : CurvePosition = curve.getPoint(i / iterations);
                subPoints.push(new Point(
                    data.position,
                    data.tangent,
                    data.normal,
                    startPositiveDistance + (i * positiveIncrement),
                    startNegativeDistance + (i * negativeIncrement)
                ));
            }

            // Create the start point.
            var data : CurvePosition = curve.getPoint(0);
            startPoint = new Point(
                data.position,
                data.tangent,
                data.normal,
                startPositiveDistance, startNegativeDistance
            );

            // If there is a next neighbour use it's start point as our end point
            if (has('neighbours') && cast(get('neighbours'), Neighbours).next != null)
            {
                var neighbours : Neighbours = cast get('neighbours');
                var nextPoints : CurvePoints = cast neighbours.next.get('points');
                //endPoint = nextPoints.startPoint;

                endPoint = new Point(
                    nextPoints.startPoint.position,
                    nextPoints.startPoint.tangent,
                    nextPoints.startPoint.normal,
                    endPositiveDistance, endNegativeDistance
                );
            }
            else
            {
                // else create a default end point from this curve.
                var data : CurvePosition = curve.getPoint(1);
                endPoint = new Point(
                    data.position,
                    data.tangent,
                    data.normal,
                    endPositiveDistance, endNegativeDistance
                );
            }
        }
    }
}

class Point
{
    /**
     * The position of this sub point in the world.
     */
    public var position : Vector;

    /**
     * The tangent of the point.
     */
    public var tangent : Vector;

    /**
     * The normal of the tangent of this point.
     */
    public var normal : Vector;

    /**
     * The distance to the positive offset position from this point.
     */
    public var positiveOffset : Float;

    /**
     * The distance to the negative offset position from this point.
     */
    public var negativeOffset : Float;

    /**
     * The positive offset point for this sub point.
     */
    public var positivePoint : Vector;

    /**
     * The negative offset point for this sub point.
     */
    public var negativePoint : Vector;

    public function new(_position : Vector, _tangent : Vector, _normal : Vector, _posOffset : Float, _negOffset : Float)
    {
        position = _position;
        tangent  = _tangent;
        normal   = _normal;
        positiveOffset = _posOffset;
        negativeOffset = _negOffset;

        positivePoint = new Vector(position.x + (normal.x * positiveOffset), position.y + (normal.y * positiveOffset));
        negativePoint = new Vector(position.x - (normal.x * negativeOffset), position.y - (normal.y * negativeOffset));
    }
}
