package components;

import luxe.Component;
import luxe.Mesh;
import luxe.Vector;
import components.CurveTiles;

class CurveTileRenderer extends Component
{
    private var meshes : Array<TileMesh>;
    
    public function new()
    {
        super({ name : 'tile_drawer' });
    }

    override public function onadded()
    {
        render();
    }

    override public function onremoved()
    {
        clean();
    }

    public function render()
    {
        if (has('tiles'))
        {
            var tiles : CurveTiles = cast get('tiles');

            clean();
            meshes = new Array<TileMesh>();

            for (tile in tiles.tiles)
            {
                //meshes.push(new TileMesh(tile.points));
                var mesh = new TileMesh(tile.points);
                if (tile.tileset != "") mesh.mesh.geometry.texture = Luxe.resources.texture(tile.tileset);
                meshes.push(mesh);
            }
        }
    }

    public function updateTile(_position : Int)
    {
        if (has('tiles'))
        {
            var tiles : CurveTiles = cast get('tiles');
            meshes[_position].mesh.geometry.texture = Luxe.resources.texture(tiles.tiles[_position].tileset);
        }
    }

    private function clean()
    {
        if (meshes != null)
        {
            for (tile in meshes)
            {
                tile.mesh.destroy();
            }
            meshes = null;
        }
    }
}

class TileMesh
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
