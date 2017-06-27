package components.curves;

import luxe.Vector;
import components.curves.Curve;

class QuadraticCurve extends Curve
{
    /**
     * Returns the position of the time along the curve.
     * 
     * @param _time The time along the path to get the position of.
     * @return Vector containing the position.
     */
    override private function interpolate(_time : Float) : Vector
    {
        var start   : Vector = controlPoints[0];
        var control : Vector = controlPoints[1];
        var end     : Vector = controlPoints[2];

        var x : Float = (1 - _time) * (1 - _time) * start.x + 2 * (1 - _time) * _time * control.x + _time * _time * end.x;
        var y : Float = (1 - _time) * (1 - _time) * start.y + 2 * (1 - _time) * _time * control.y + _time * _time * end.y;

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
        var start   : Vector = controlPoints[0];
        var control : Vector = controlPoints[1];
        var end     : Vector = controlPoints[2];

        var x : Float = 2 * (1 - _time) * (control.x - start.x) + 2 * _time * (end.x - control.x);
        var y : Float = 2 * (1 - _time) * (control.y - start.y) + 2 * _time * (end.y - control.y);

        return new Vector(x, y);
    }
}