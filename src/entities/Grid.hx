package entities;

import luxe.Entity;

class Grid extends Entity
{
    /**
     * If the grid is to be drawn.
     */
    public var drawGrid : Bool;

    /**
     * If snap to grid is enabled.
     */
    public var gridSnap : Bool;

    /**
     * Horizontal distance between lines.
     */
    public var horizontal : Int;

    /**
     * Vertical distance between lines.
     */
    public var vertical : Int;

    public function new()
    {
        super({ name : 'grid' });

        drawGrid = true;
        gridSnap = true;
        horizontal = 32;
        vertical = 32;

        add(new components.RenderGrid());

        Luxe.events.listen('grid.show.toggle', onToggleShow);
        Luxe.events.listen('grid.snap.toggle', onToggleSnap);
        Luxe.events.listen('grid.horizontal' , onChangeHorizontal);
        Luxe.events.listen('grid.vertical'   , onchangeVertical);
    }

    private function onToggleShow(_state : Bool)
    {
        drawGrid = _state;

        var grid : components.RenderGrid = cast get('render_grid');
        grid.toggleVisibility();
    }

    private function onToggleSnap(_state : Bool)
    {
        gridSnap = _state;
    }

    private function onChangeHorizontal(_value : Int)
    {
        horizontal = _value;

        var grid : components.RenderGrid = cast get('render_grid');
        grid.draw();
    }

    private function onchangeVertical(_value : Int)
    {
        vertical = _value;
        
        var grid : components.RenderGrid = cast get('render_grid');
        grid.draw();
    }
}
