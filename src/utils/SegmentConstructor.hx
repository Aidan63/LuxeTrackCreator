package utils;

import luxe.Vector;

class SegmentConstructor
{
    public static function linear(_points : Array<Vector>) : entities.TrackSegment
    {
        var entity = new entities.TrackSegment();
        entity.add(new components.curves.LinearCurve(_points));
        entity.add(new components.Neighbours());
        entity.add(new components.CurvePoints());
        entity.add(new components.RenderSkeleton());
        entity.add(new components.RenderTangents());
        entity.add(new components.CurveTileRenderer());

        return entity;
    }

    public static function quadratic(_points : Array<Vector>) : entities.TrackSegment
    {
        var entity = new entities.TrackSegment();
        entity.add(new components.curves.QuadraticCurve(_points));
        entity.add(new components.Neighbours());
        entity.add(new components.CurvePoints());
        entity.add(new components.RenderSkeleton());
        entity.add(new components.RenderTangents());
        entity.add(new components.CurveTileRenderer());

        return entity;
    }

    public static function cubic(_points : Array<Vector>) : entities.TrackSegment
    {
        var entity = new entities.TrackSegment();
        entity.add(new components.curves.CubicCurve(_points));
        entity.add(new components.Neighbours());
        entity.add(new components.CurvePoints());
        entity.add(new components.RenderSkeleton());
        entity.add(new components.RenderTangents());
        entity.add(new components.CurveTileRenderer());

        return entity;
    }
}
