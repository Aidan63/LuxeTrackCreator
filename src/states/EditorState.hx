package states;

import luxe.States;
import luxe.Vector;
import luxe.Entity;

import ui.EditorUI;
import entities.Grid;
import entities.Cursor;
import utils.SegmentConstructor;

class EditorState extends State
{
    var testEntity : luxe.Entity;

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

        SegmentConstructor.cubic([ new Vector(128, 128), new Vector(256, 256), new Vector(384, 384), new Vector(512, 512) ]);
        SegmentConstructor.linear([ new Vector(128, 800), new Vector(800, 800) ]);
    }
}
