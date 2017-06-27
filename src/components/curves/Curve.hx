package components.curves;

import luxe.Vector;
import luxe.Component;

class Curve extends Component
{
    /**
     * The control points for the curve.
     */
    public var controlPoints : Array<Vector>;

    /**
     * The approximate length of the curve.
     */
    public var length : Float;

    /**
     * Array of the length of the curve along 1000 divisions, used to convert from linear to bezier time.
     */
    public var lengthMappings : Array<Float>;

    /**
     * [Description]
     * @param _points - 
     */
    public function new(_points : Array<Vector>)
    {
        super({ name : 'curve' });

        controlPoints = _points;

        var lenResults : CurveLength = calculateLength();
        length         = lenResults.length;
        lengthMappings = lenResults.lengthMappings;
    }

    /**
     * Returns position and normal of the point on the curve.
     * 
     * @param _time The time along the curve to get data on. ( 0 - 1 )
     * @return CurvePosition strucutre containing the position and normal.
     */
    public function getPoint(_time : Float) : CurvePosition
    {
        var pos    : Vector;
        var tanget : Vector;
        var normal : Vector;
        
        if (_time == 0 || _time == 1)
        {
            pos    = interpolate(_time);
            tanget = getTangent(_time);
            normal = getNormal(_time);
        }
        else
        {
            var bezTime : Float  = parametize(_time);
            pos    = interpolate(bezTime);
            tanget = getTangent(bezTime);
            normal = getNormal(bezTime);
        }

        return { position : pos, tangent : tanget, normal : normal };
    }

    /**
     * Takes a linear separation time value and converts it into a bezier non linar position.
     * 
     * @param _time The linear time along the curve to convert from.
     * @return Converted bezier time position.
     */
    private function parametize(_time : Float) : Float
    {
        var targetLength : Float = _time * lengthMappings[lengthMappings.length - 1];

        return bsearch(targetLength);
    }

    /**
     * Calculate the normal of the curve at the provided time.
     * 
     * @param _time The time along the path.
     * @return Vector containing the normal.
     */
    public function getNormal(_time : Float) : Vector
    {
        var d : Vector = derivative(_time);
        var q : Float  = Math.sqrt(d.x * d.x + d.y * d.y);

        var x = -d.y / q;
        var y =  d.x / q;

        return new Vector(x, y);
    }

    /**
     * Calculate the tangent of the curve at the provided time.
     * 
     * @param _time The time along the path.
     * @return Vector containing the tangent.
     */
    public function getTangent(_time : Float) : Vector
    {
        var d : Vector = derivative(_time);
        var q : Float  = Math.sqrt(d.x * d.x + d.y * d.y);

        var x = d.x / q;
        var y = d.y / q;

        return new Vector(x, y);
    }

    /**
     * Calculate the approximate curve length.
     * 
     * @return Float length of the curve.
     */
    public function calculateLength() : CurveLength
    {
        var lengths = new Array<Float>();
        var sum       : Float  = 0;
        var prevPoint : Vector = controlPoints[0];

        for (i in 0...1000)
        {
            var currPoint : Vector = interpolate(i / 1000);
            sum += Math.sqrt(Math.pow(currPoint.x - prevPoint.x, 2) + Math.pow(currPoint.y - prevPoint.y, 2));
            lengths.push(sum);

            prevPoint = currPoint;
        }

        var currPoint = controlPoints[controlPoints.length - 1];
        sum += Math.sqrt(Math.pow(currPoint.x - prevPoint.x, 2) + Math.pow(currPoint.y - prevPoint.y, 2));
        lengths.push(sum);

        return { length : sum, lengthMappings : lengths };
    }

    /**
     * Performs a binary search on the list of lengths to find the closest to the provided target.
     * 
     * @param _mappings Array of all the lengths.
     * @param _target The target value.
     * @return Closest value.
     */
    private function bsearch(_target : Float) : Float
    {
        var low   : Int = 0;
        var high  : Int = lengthMappings.length;
        var index : Int = 0;

        while (low < high)
        {
            index = cast low + ((high - low) / 2);
            if (lengthMappings[index] < _target)
            {
                low = index + 1;
            }
            else
            {
                high = index;
            }
        }

        if (lengthMappings[index] > _target)
        {
            index --;
        }

        var lengthBefore = lengthMappings[index];
        if (lengthBefore == _target)
        {
            return index / lengthMappings.length;
        }
        else
        {
            return (index + (_target - lengthBefore) / (lengthMappings[index + 1] - lengthBefore)) / lengthMappings.length;
        }
    }

    /**
     * Interpolate function to be overriden by child curves.
     */
    private function interpolate(_time : Float) : Vector
    {
        return new Vector();
    }

    /**
     * Derivative function to be overriden by child curves.
     */
    private function derivative(_time : Float) : Vector
    {
        return new Vector();
    }
}

typedef CurvePosition = {
    var position : Vector;
    var tangent  : Vector;
    var normal   : Vector;
}

typedef CurveLength = {
    var length : Float;
    var lengthMappings : Array<Float>;
}
