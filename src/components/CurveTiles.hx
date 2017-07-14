package components;

import luxe.Component;
import luxe.Vector;

import components.CurvePoints;
import data.SegmentData;
import data.SegmentPoint;
import data.SegmentVector;
import utils.Tilesets;

class CurveTiles extends Component
{
    public var tiles : Array<Tile>;

    public function new()
    {
        super({ name : 'tiles' });
    }

    override public function onadded()
    {
        build();
    }

    public function build()
    {
        // Create new tiles
        var newTiles = new Array<Tile>();

        if (has('points'))
        {
            var points : CurvePoints = cast get('points');

            /*
            newTiles.push(new Tile([
                points.data.startPoint.position,
                points.data.startPoint.negativePoint,
                points.data.subPoints[0].negativePoint,
                points.data.subPoints[0].position
            ]));
            newTiles.push(new Tile([
                points.startPoint.position,
                points.startPoint.positivePoint,
                points.subPoints[0].positivePoint,
                points.subPoints[0].position
            ]));
            */

            var prevPoint : SegmentPoint = null;
            for (point in points.data.points)
            {
                if (prevPoint != null)
                {
                    newTiles.push(new Tile([
                        prevPoint.position.getLuxeVector(),
                        prevPoint.negativePoint.getLuxeVector(),
                        point.negativePoint.getLuxeVector(),
                        point.position.getLuxeVector()
                    ]));
                    newTiles.push(new Tile([
                        prevPoint.position.getLuxeVector(),
                        prevPoint.positivePoint.getLuxeVector(),
                        point.positivePoint.getLuxeVector(),
                        point.position.getLuxeVector()
                    ]));
                }

                prevPoint = point;
            }

            /*
            newTiles.push(new Tile([
                prevPoint.position,
                prevPoint.negativePoint,
                points.endPoint.negativePoint,
                points.endPoint.position
            ]));
            newTiles.push(new Tile([
                prevPoint.position,
                prevPoint.positivePoint,
                points.endPoint.positivePoint,
                points.endPoint.position
            ]));
            */
        }

        // Copy over the tileset and image to the new ones.
        if (tiles != null)
        {
            for (i in 0...tiles.length)
            {
                if (i < newTiles.length)
                {
                    newTiles[i].image   = tiles[i].image;
                    newTiles[i].tileset = tiles[i].tileset;
                }
            }
        }

        // set the tiles to the now complete new tiles array.
        tiles = newTiles;
    }

    public function updateTile(_position : Int)
    {
        if (Tilesets.currentTile != null)
        {
            //meshes[_position].mesh.geometry.texture = Luxe.resources.texture(Tilesets.currentTile.path);
            tiles[_position].image   = Tilesets.currentTile.name;
            tiles[_position].tileset = Tilesets.currentTile.path;

            if (has('tile_drawer'))
            {
                cast(get('tile_drawer'), CurveTileRenderer).updateTile(_position);
            }
        }
    }
}

private class Tile
{
    /**
     *  The tileset for this tiles image.
     */
    public var tileset : String;

    /**
     *  The image name for this tile.
     */
    public var image : String;

    /**
     *  The four vectors which make the corners for this tile.
     */
    public var points(get, null) : Array<Vector>;

    public function new(_points : Array<Vector>)
    {
        tileset = "";
        image   = "";
        points  = _points;
    }

    function get_points()
    {
        return points;
    }
}
