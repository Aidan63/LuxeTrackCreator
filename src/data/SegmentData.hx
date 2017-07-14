package data;

class SegmentData
{
    /**
     The distance between each curve sub point.
     */
    public var divisions : Int;

    /**
     The distance to the start positive offset from the curve point.
     */
    public var startPositiveDistance : Float;

    /**
     The distance to the start negative offset from the curve point.
     */
    public var startNegativeDistance : Float;

    /**
     The distance to the end positive offset from the curve point.
     */
    public var endPositiveDistance : Float;

    /**
     The distance to the end negative offset from the curve point.
     */
    public var endNegativeDistance : Float;

    /**
     All of the points in this segment.
     */
    public var points : Array<SegmentPoint>;

    // Default constructor
    public function new() {}

    /**
     Gets the first point in the curve.
     
     @return first SegmentPoint
     */
    public function get_firstPoint() : SegmentPoint
    {
        return points[0];
    }

    /**
     Gets the last point in the curve.

     @return SegmentPoint
     */
    public function get_lastPoint() : SegmentPoint
    {
        return points[points.length - 1];
    }
}
