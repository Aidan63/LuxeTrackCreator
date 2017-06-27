package utils;

import luxe.Component;
import luxe.Input.MouseButton;
import luxe.Input.MouseEvent;
import luxe.Vector;

/*
    for : http://luxeengine.com
    author : underscorediscovery
    desc : Simple camera drag + zoom component.
    Usage : apply to any luxe.Camera instance
    
        var drag = Luxe.camera.add( new CameraDrag({name:'drag'}) );
            drag.zoom_speed = 0.3;
            drag.button = MouseButton.left
    Options :
      zoom_speed : Float, how much to zoom on mouse wheel
      zoomable : Bool, if zooming is enabled at the time of scrolling
      draggable : Bool, if dragging is enabled at the time of mousedown
      button : MouseButton, the button to drag with 
    Drag with button specified, zoom with scroll wheel.
*/
class CameraDrag extends Component
{
    /**
     * If the camera can be dragged.
     */
    public var draggable : Bool = true;

    /**
     * If the camera can be zoomed.
     */
    public var zoomable : Bool = true;

    /**
     * The zoom speed of the camera.
     */
    public var zoom_speed : Float = 0.3;

    /**
     * The mouse button used to pan the camera.
     */
    public var button : MouseButton;

    /**
     * If the camera is being dragged.
     */
    var dragging : Bool = false;

    /**
     * The position of the camera when the dragging starts.
     */
    var drag_start : Vector;

    /**
     * //
     */
    var drag_start_pos : Vector;

    /**
     * The luxe camera for this component.
     */
    var camera : luxe.Camera;

    override function init()
    {
        drag_start = new Vector();
        drag_start_pos = new Vector();

        button = MouseButton.right;

        camera = cast entity;
        if(camera == null) throw "CameraDrag only applies to luxe.Camera type right now.";
    }

    override function onmousewheel(e:MouseEvent)
    {
        if(zoomable) {
            camera.zoom += e.y > 0 ? zoom_speed : -zoom_speed;
        }
    }

    override function onmousedown(e:MouseEvent)
    {
        if(draggable) {
            if( !dragging && e.button == button ) {
                dragging = true;
                drag_start.set_xy(e.pos.x, e.pos.y);
                drag_start_pos.set_xy(pos.x, pos.y);
            }
        }
    }

    override function onmouseup(e:MouseEvent)
    {
        if(draggable) {
            if(e.button == button && dragging) {
                dragging = false;
            }
        }
    }

    override function onmousemove(e:MouseEvent)
    {
        if (draggable && dragging)
        {
            var diffx = (e.pos.x - drag_start.x)/camera.zoom;
            var diffy = (e.pos.y - drag_start.y)/camera.zoom;

            pos.set_xy(drag_start_pos.x - diffx, drag_start_pos.y - diffy);
        }
    }
}
