package ui;

import luxe.Entity;
import mint.focus.Focus;
import mint.layout.margins.Margins;
import mint.render.luxe.LuxeMintRender;

import ui.AutoCanvas;
import ui.windows.UIGridWindow;
import ui.windows.UISegmentEditor;
import ui.windows.UICursorMode;
import ui.windows.UISegmentCreator;

class EditorUI
{
    private var focus     : Focus;
    private var layout    : Margins;
    private var canvas    : AutoCanvas;
    private var rendering : LuxeMintRender;

    private var segmentCreator : UISegmentCreator;
    private var cursorMode     : UICursorMode;
    private var segmentEditor  : UISegmentEditor;
    private var gridEditor     : UIGridWindow;

    public function new()
    {
        // Listen to public events for the UI.
        Luxe.events.listen('segment.selected', onSegmentSelected);

        Luxe.events.listen('cursor.select' , hideSegmentEditor);
        Luxe.events.listen('cursor.remove' , hideSegmentEditor);
        Luxe.events.listen('cursor.paint'  , hideSegmentEditor);
        Luxe.events.listen('cursor.connect', hideSegmentEditor);

        // Create a seperate camera and batcher for the UI.
        var camera  = new phoenix.Camera();
        var batcher = new phoenix.Batcher(Luxe.renderer, 'ui_batcher');
        batcher.view  = camera;
        batcher.layer = 10;

        Luxe.renderer.add_batch(batcher);

        // Setup the mint canvas for drawing controls.
        rendering = new LuxeMintRender({ batcher : batcher });
        layout    = new Margins();
        canvas    = new AutoCanvas({
            name   : 'canvas',
            rendering : rendering,
            x : 0,
            y : 0,
            w : Luxe.screen.width  / Luxe.screen.device_pixel_ratio,
            h : Luxe.screen.height / Luxe.screen.device_pixel_ratio
        });

        focus = new Focus(canvas);
        canvas.auto_listen();

        // Create the persistent UI elements.
        segmentCreator = new UISegmentCreator(canvas);
        cursorMode     = new UICursorMode(canvas);
        gridEditor     = new UIGridWindow(canvas);
    }

    /**
     * When a segment is selected create a new segment editor UI and set the entity to that selected.
     * @param _entity The entity which has been selected.
     */
    private function onSegmentSelected(_entity : Entity)
    {
        if (segmentEditor == null)
        {
            segmentEditor = new UISegmentEditor(canvas);
        }
        segmentEditor.setEntity(_entity);
    }

    /**
     * Hide the segment editor UI when any of the cursor buttons have been pressed.
     */
    private function hideSegmentEditor(_)
    {
        if (segmentEditor != null)
        {
            segmentEditor.destroy();
            segmentEditor = null;
        }
    }
}
