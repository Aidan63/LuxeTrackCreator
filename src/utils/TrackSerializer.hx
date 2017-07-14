/*
 * Copyright (c) 2017 Aidan Lee
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

package utils;

import luxe.Entity;
import components.CurvePoints;
import components.Neighbours;
import data.SegmentData;
import tjson.TJSON;

class TrackSerializer
{
    private static var trackData : Array<SegmentData>;
    private static var initialSegment : Entity;

    public static function serialize(_initialSegment : Entity, _savePath : String)
    {
        trackData = new Array<SegmentData>();
        initialSegment = _initialSegment;

        build(initialSegment);
        if (sys.FileSystem.exists(_savePath))
        {
            sys.io.File.saveContent(_savePath, TJSON.encode(trackData, 'fancy'));
        }
        else
        {
            trace('Provided path is not a valid location');
        }
    }

    private static function build(_segment : Entity)
    {
        if (_segment.has('points'))
        {
            var points : CurvePoints = cast _segment.get('points');

            // push initial point
            trackData.push(points.data);

            // Push this segments end point or call build again with the next segment entity.
            if (_segment.has('neighbours'))
            {
                var neighbours : Neighbours = cast _segment.get('neighbours');
                if (neighbours.next != null && neighbours.next.id != initialSegment.id)
                {
                    build(neighbours.next);
                }
            }
        }
    }
}
