package components.curves;

import luxe.Vector;
import components.curves.Curve;

class CubicCurve extends Curve
{
    /**
     * Returns the position of the time along the curve.
     * 
     * @param _time The time along the path to get the position of.
     * @return Vector containing the position.
     */
    override private function interpolate(_time : Float) : Vector
    {
        var start    : Vector = controlPoints[0];
        var control1 : Vector = controlPoints[1];
        var control2 : Vector = controlPoints[2];
        var end      : Vector = controlPoints[3];

        var x : Float = (1 - _time) * (1 - _time) * (1 - _time) * start.x + 3 * (1 - _time) * (1 - _time) * _time * control1.x + 3 * (1 - _time) * _time * _time * control2.x + _time * _time * _time * end.x;
        var y : Float = (1 - _time) * (1 - _time) * (1 - _time) * start.y + 3 * (1 - _time) * (1 - _time) * _time * control1.y + 3 * (1 - _time) * _time * _time * control2.y + _time * _time * _time * end.y;

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
        var start    : Vector = controlPoints[0];
        var control1 : Vector = controlPoints[1];
        var control2 : Vector = controlPoints[2];
        var end      : Vector = controlPoints[3];

        var x : Float = 3 * (1 - _time) * (1 - _time) * (control1.x - start.x) + 6 * (1 - _time) * _time * (control2.x - control1.x) + 3 * _time * _time * (end.x - control2.x);
        var y : Float = 3 * (1 - _time) * (1 - _time) * (control1.y - start.y) + 6 * (1 - _time) * _time * (control2.y - control1.y) + 3 * _time * _time * (end.y - control2.y);

        return new Vector(x, y);
    }
}
