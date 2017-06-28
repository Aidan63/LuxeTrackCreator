package components;

import luxe.Component;
import luxe.Mesh;
import luxe.Vector;
import components.CurvePoints;
import utils.Tilesets;

class CurveTileRenderer extends Component
{
    private var tiles : Array<CurveTile>;
    
    public function new()
    {
        super({ name : 'tile_drawer' });
    }

    override public function onadded()
    {
        clean();
        render();
    }

    override public function onremoved()
    {
        clean();
    }

    public function updateTexture(_position : Int)
    {
        if (Tilesets.currentTile != null)
        {
            tiles[_position].mesh.geometry.texture = Luxe.resources.texture(Tilesets.currentTile.path);
        }
    }

    public function render()
    {
        if (has('points'))
        {
            var points : CurvePoints = cast get('points');

            clean();
            tiles = new Array<CurveTile>();

            tiles.push(new CurveTile([
                points.startPoint.position,
                points.startPoint.negativePoint,
                points.subPoints[0].negativePoint,
                points.subPoints[0].position
            ]));
            tiles.push(new CurveTile([
                points.startPoint.position,
                points.startPoint.positivePoint,
                points.subPoints[0].positivePoint,
                points.subPoints[0].position
            ]));

            var prevPoint : Point = null;
            for (point in points.subPoints)
            {
                if (prevPoint != null)
                {
                    tiles.push(new CurveTile([
                        prevPoint.position,
                        prevPoint.negativePoint,
                        point.negativePoint,
                        point.position
                    ]));
                    tiles.push(new CurveTile([
                        prevPoint.position,
                        prevPoint.positivePoint,
                        point.positivePoint,
                        point.position
                    ]));
                }

                prevPoint = point;
            }

            tiles.push(new CurveTile([
                prevPoint.position,
                prevPoint.negativePoint,
                points.endPoint.negativePoint,
                points.endPoint.position
            ]));
            tiles.push(new CurveTile([
                prevPoint.position,
                prevPoint.positivePoint,
                points.endPoint.positivePoint,
                points.endPoint.position
            ]));
        }
    }

    private function clean()
    {
        if (tiles != null)
        {
            for (tile in tiles)
            {
                tile.mesh.destroy();
            }
            tiles = null;
        }
    }
}

class CurveTile
{
    public var mesh : Mesh;

    public function new(_position : Array<Vector>)
    {
        mesh = new luxe.Mesh({ file : 'assets/tile.obj', texture : Luxe.resources.texture('assets/track.png') });
        
        // Bottom left vertex
        mesh.geometry.vertices[2].pos.set_xy(_position[0].x, _position[0].y);

        // Top left verticies
        mesh.geometry.vertices[0].pos.set_xy(_position[1].x, _position[1].y);
        mesh.geometry.vertices[3].pos.set_xy(_position[1].x, _position[1].y);

        // Top right vertex
        mesh.geometry.vertices[4].pos.set_xy(_position[2].x, _position[2].y);

        // Bottom right verticies
        mesh.geometry.vertices[5].pos.set_xy(_position[3].x, _position[3].y);
        mesh.geometry.vertices[1].pos.set_xy(_position[3].x, _position[3].y);
    }
}
