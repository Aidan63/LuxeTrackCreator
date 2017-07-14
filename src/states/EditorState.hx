package states;

import luxe.States;
import luxe.Vector;
import luxe.Entity;
import luxe.Input;
import dialogs.Dialogs;

import ui.EditorUI;
import entities.Grid;
import entities.Cursor;
import utils.SegmentConstructor;

class EditorState extends State
{
    private var initialSegment : luxe.Entity;

    private var grid : Entity;
    private var cursor : Entity;
    private var ui : EditorUI;

    override public function onenter<T>(_ : T)
    {
        var drag = Luxe.camera.add(new utils.CameraDrag({ name : 'drag' }));
        drag.zoom_speed = 0.1;
        drag.button     = middle;
        drag.zoomable   = true;
        drag.draggable  = true;

        grid   = new Grid();
        cursor = new Cursor();
        ui     = new EditorUI();

        initialSegment = SegmentConstructor.linear([ new Vector(128, 800), new Vector(800, 800) ]);
    }

    override public function update(_dt : Float)
    {
        if (Luxe.input.keypressed(Key.space))
        {
            // Open dialog to get save location.
            var result = Dialogs.save('Save track json', { ext : 'json', desc : 'Track data' });
            
            if (result != null)
            {
                // Start serialization
                utils.TrackSerializer.serialize(initialSegment, result);
            }
        }
    }
}
