package components;

import luxe.Component;
import luxe.Vector;
import luxe.Color;
import phoenix.geometry.Geometry;
import entities.Grid;

class RenderGrid extends Component
{
    /**
     * The grid instance this component is attached to.
     */
    private var grid : Grid;

    /**
     * Visual class holding all the vertical lines.
     */
    private var verticalLines : Geometry;
    
    /**
     * Visual class holding all the horizontal lines.
     */
    private var horizontalLines : Geometry;

    /**
     * The batcher for the two line geometries.
     */
    private var gridBatcher : phoenix.Batcher;

    public function new()
    {
        super({ name : 'render_grid' });
    }

    override public function onadded()
    {
        grid = cast entity;
        gridBatcher = Luxe.renderer.create_batcher({ name : 'grid_batcher', camera : Luxe.camera.view, layer : 5 , max_verts : 32768 });

        draw();
    }

    override public function onremoved()
    {
        clear();
        gridBatcher.destroy(true);
    }

    public function draw()
    {
        clear();

        var horLines : Int = Math.round(10000 / grid.horizontal);
        var verLines : Int = Math.round(10000 / grid.vertical);

        var startX = -(Math.floor(horLines / 2) * grid.horizontal);
        var startY = -(Math.floor(verLines / 2) * grid.vertical);

        var horizontalVerticies = new Array<Vector>();
        var verticalVerticies   = new Array<Vector>();

        for (i in 0...horLines)
        {
            horizontalVerticies.push(new Vector(startX        , startY + (i * grid.horizontal)));
            horizontalVerticies.push(new Vector(startX + 10000, startY + (i * grid.horizontal)));
        }
        for (i in 0...verLines)
        {
            verticalVerticies.push(new Vector(startX + (i * grid.vertical), startY));
            verticalVerticies.push(new Vector(startX + (i * grid.vertical), startY + 10000));
        }

        horizontalLines = Luxe.draw.poly({
            points         : horizontalVerticies,
            primitive_type : lines,
            color    : new Color().set(0.8, 0.8, 0.8, 0.1),
            batcher        : gridBatcher
        });
        verticalLines = Luxe.draw.poly({
            points         : verticalVerticies,
            primitive_type : lines,
            color    : new Color().set(0.8, 0.8, 0.8, 0.1),
            batcher        : gridBatcher
        });
    }

    private function clear()
    {
        if (horizontalLines != null)
        {
            horizontalLines.drop(true);
            horizontalLines = null;
        }
        if (verticalLines != null)
        {
            verticalLines.drop(true);
            verticalLines = null;
        }
    }

    public function toggleVisibility()
    {
        horizontalLines.visible = !horizontalLines.visible;
        verticalLines.visible   = !verticalLines.visible;
    }
}
