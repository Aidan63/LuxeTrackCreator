package data;

class SegmentPoint
{
    /**
     The position of this sub point in the world.
     */
    public var position : SegmentVector;

    /**
     The tangent of the point.
     */
    public var tangent : SegmentVector;

    /**
     The normal of the tangent of this point.
     */
    public var normal : SegmentVector;

    /**
     The distance to the positive offset position from this point.
     */
    public var positiveOffset : Float;

    /**
     The distance to the negative offset position from this point.
     */
    public var negativeOffset : Float;

    /**
     The positive offset point for this sub point.
     */
    public var positivePoint : SegmentVector;

    /**
     The negative offset point for this sub point.
     */
    public var negativePoint : SegmentVector;

    public function new(_position : SegmentVector, _tangent : SegmentVector, _normal : SegmentVector, _posOffset : Float, _negOffset : Float)
    {
        position = _position;
        tangent  = _tangent;
        normal   = _normal;
        positiveOffset = _posOffset;
        negativeOffset = _negOffset;

        positivePoint = new SegmentVector(position.x + (normal.x * positiveOffset), position.y + (normal.y * positiveOffset));
        negativePoint = new SegmentVector(position.x - (normal.x * negativeOffset), position.y - (normal.y * negativeOffset));
    }
}
