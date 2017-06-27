package components.curves;

import luxe.Vector;
import components.curves.Curve;

class LinearCurve extends Curve
{
    /**
     * Calculates the length of the linear curve.
     * 
     * @return Length of the curve.
     */
     /*
    override public function calculateLength() : Float
    {
        return Math.sqrt(Math.pow(controlPoints[0].x - controlPoints[1].x, 2) + Math.pow(controlPoints[0].y - controlPoints[1].y, 2));
    }
    */

    /**
     * Returns the position of the time along the curve.
     * 
     * @param _time The time along the path to get the position of.
     * @return Vector containing the position.
     */
    override private function interpolate(_time : Float) : Vector
    {
        var x : Float = (1 - _time) * controlPoints[0].x + _time * controlPoints[1].x;
        var y : Float = (1 - _time) * controlPoints[0].y + _time * controlPoints[1].y;

        return new Vector(x, y);
    }

    /**
     * Calculate the first derivative of the curve at the provided time.
     * 
     * @param _time The time along the curve.
     * @return Vector containing the derivative.
     */
    override private function derivative(_time : Float) : Vector
    {
        return new Vector(controlPoints[1].x - controlPoints[0].x, controlPoints[1].y - controlPoints[0].y);
    }
}
