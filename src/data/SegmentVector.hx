package data;

import luxe.Vector;

/**
 Vector class for segments.
 Contains only x and y class members for cleaner serialization.
 
 Contains functions for converting to and from Luxe vector.
 */
class SegmentVector
{
    /**
     The x component of the vector.
     */
    public var x : Float;

    /**
     The y component of the vector.
     */
    public var y : Float;

    public function new(_x : Float = 0, _y : Float = 0)
    {
        x = _x;
        y = _y;
    }

    /**
     Creates a luxe vector from this segment vector
     
     @return Luxe vector containing the same x and y component values.
     */
    public function getLuxeVector() : Vector
    {
        return new Vector(x, y);
    }

    /**
     Creates a segment vector from the provided luxe vector.

     @param _vector The luxe vector to get values from.
     @return segment vector containing the same x and y as the luxe vector.
     */
    public static function fromLuxeVector(_vector : Vector) : SegmentVector
    {
        return new SegmentVector(_vector.x, _vector.y);
    }
}
