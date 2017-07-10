package components;

import luxe.Component;
import luxe.Color;
import phoenix.geometry.Geometry;
import components.CurveTiles;

class CurveTileHighlighter extends Component
{

    /**
     * Array which holds all of the tile geometries.
     */
    private var geometry : Array<Geometry>;

    public function new()
    {
        super({ name : 'tile_highlighter' });
    }

    override public function onadded()
    {
        render();
    }

    override public function onremoved()
    {
        clean();
    }

    override public function update(_dt : Float)
    {       
        // Convert mouse screen position to world space
        var mouse = Luxe.camera.screen_point_to_world(Luxe.screen.cursor.pos);

        // Loop over every polygon and check if the mouse is over.
        // If so set the equivilent polygon to semi transparent if it is over.
        for (i in 0...geometry.length)
        {
            if (Luxe.utils.geometry.point_in_geometry(mouse, geometry[i]))
            {
                geometry[i].color.a = 0.5;

                // Check for mouse press and update the pressed tile to the current selected tile.
                if (Luxe.input.mousedown(left))
                {
                    if (has('tiles')) cast(get('tiles'), CurveTiles).updateTile(i);
                }
            }
            else
            {
                geometry[i].color.a = 0;
            }
        }
    }

    public function render()
    {
        clean();

        if (has('tiles'))
        {
            var tiles : CurveTiles = cast get('tiles');

            geometry = new Array<Geometry>();

            for (tile in tiles.tiles)
            {
                geometry.push(Luxe.draw.poly({
                    points : tile.points,
                    color  : new Color().rgb(0x008aff),
                    depth  : 1
                }));
            }
        }
    }

    private function clean()
    {
        // Drop all of the geometries and set the array to null for future checks.
        if (geometry != null)
        {
            for (i in 0...geometry.length)
            {
                geometry[i].drop();
                geometry[i] = null;
            }
            geometry = null;
        }
    }
}
