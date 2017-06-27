package components;

import luxe.Component;
import luxe.Color;
import luxe.Sprite;
import luxe.tween.Actuate;

import components.curves.Curve;

class ControlPoints extends Component
{
    /**
     * The point geometry being dragged.
     */
    private var dragging : Sprite;

    /**
     * All of the control point geometries.
     */
    public var controls : Array<Sprite>;

    public function new()
    {
        super({ name : 'control_points' });
    }

    override public function onadded()
    {
        controls = new Array<Sprite>();
        if (has('curve'))
        {
            // Get the track segment component and create a control point visual for each 
            var curve : Curve = cast get('curve');

            for (point in curve.controlPoints)
            {
                controls.push(new Sprite({
                    pos      : point,
                    color    : new Color().rgb(0xd800ff),
                    depth    : 3,
                    geometry : Luxe.draw.ring({
                        r : 8
                    })
                }));
            }
        }
    }

    /**
     * Remove any control point geometry when removed.
     */
    override public function onremoved()
    {
        dragging = null;
        for (i in 0...controls.length)
        {
            controls[i].geometry.drop();
            controls[i] = null;
        }
    }

    override public function update(_dt : Float)
    {
        if (Luxe.input.mousepressed(left))
        {
            for (control in controls)
            {
                var mouse = Luxe.camera.screen_point_to_world(Luxe.screen.cursor.pos);
                if (control.point_inside(mouse))
                {
                    dragging = control;

                    Actuate.stop (dragging.scale);
                    Actuate.tween(dragging.scale, 0.2, { x : 2, y : 2 });
                    dragging.color.tween(0.2, { r : 255, g : 240, b : 0 });
                }
            }
        }

        if (Luxe.input.mousedown(left))
        {
            if (dragging != null)
            {
                var grid : entities.Grid = cast Luxe.scene.get('grid');
                if (grid != null && grid.gridSnap)
                {
                    var mouse = Luxe.camera.screen_point_to_world(Luxe.screen.cursor.pos);
                    mouse.x = Math.floor(mouse.x / grid.vertical) * grid.vertical;
                    mouse.y = Math.floor(mouse.y / grid.horizontal) * grid.horizontal;

                    dragging.pos = mouse;
                }
                else
                {
                    var mouse = Luxe.camera.screen_point_to_world(Luxe.screen.cursor.pos);
                    dragging.pos = mouse;
                }
            }
        }

        if (Luxe.input.mousereleased(left))
        {
            if (dragging != null)
            {
                // Scale the sprite back down
                Actuate.stop (dragging.scale);
                Actuate.tween(dragging.scale, 0.2, { x : 1, y : 1 });
                dragging.color.tween(0.2, { r : 216, g : 0, b : 255 });

                dragging = null;

                entity.events.queue('segment.moved');
            }
        }
    }
}
