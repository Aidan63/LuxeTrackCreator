package data;

import luxe.Vector;

/**
 * Vector class for segments.
 * Contains only x and y class members for cleaner serialization.
 * 
 * Contains functions for converting to and from Luxe vector.
 */
class SegmentVector
{
    /**
     * The x component of the vector.
     */
    @:isVar public var x(get, set) : Float;

    /**
     * The y component of the vector.
     */
    @:isVar public var y(get, set) : Float;

    /**
     * Luxe vector instance containing the same x and y value as this segment vector.
     */
    private var luxeVector : Vector;

    public function new(_x : Float = 0, _y : Float = 0)
    {
        luxeVector = new Vector();

        x = _x;
        y = _y;
    }

    function set_x(_x : Float)
    {
        luxeVector.x = _x;
        return x = _x;
    }

    function get_x()
    {
        return x;
    }

    function set_y(_y : Float)
    {
        luxeVector.y = _y;
        return y = _y;
    }

    function get_y()
    {
        return y;
    }

    /**
     * Creates a luxe vector from this segment vector
     *
     * @return Luxe vector containing the same x and y component values.
     */
    public function getLuxeVector() : Vector
    {
        return luxeVector;
    }

    /**
     * Creates a segment vector from the provided luxe vector.
     *
     * @param _vector The luxe vector to get values from.
     * @return segment vector containing the same x and y as the luxe vector.
     */
    public static function fromLuxeVector(_vector : Vector) : SegmentVector
    {
        return new SegmentVector(_vector.x, _vector.y);
    }
}
