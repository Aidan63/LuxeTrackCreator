package ui.windows;

import mint.Canvas;
import mint.Panel;
import mint.Button;

class UICursorMode extends Panel
{
    private var bttnSelect : Button;
    private var bttnPaint : Button;
    private var bttnConnect : Button;
    private var bttnDestroy : Button;

    public function new(_canvas : Canvas)
    {
        super({
            parent : _canvas,
            name   : 'UICursorMode',
            x : 8, y : 94, w : 248, h : 78
        });

        new mint.Label({
            parent : this,
            name : 'LabelTitle',
            text_size : 12,
            x : 2, y : 2, w : 244, h : 32,
            text : 'Cursor Mode',
            align : center,
            align_vertical : center
        });

        bttnSelect = new Button({
            parent : this,
            name : 'ButtonSelect',
            text_size : 12,
            x : 2, y : 36, w : 60, h : 40,
            text : 'Select',
            onclick : function(_, _) {
                Luxe.events.fire('cursor.select');
            }
        });
        bttnPaint = new Button({
            parent : this,
            name : 'ButtonPaint',
            text_size : 12,
            x : 64, y : 36, w : 60, h : 40,
            text : 'Paint',
            onclick : function(_, _) {
                Luxe.events.fire('cursor.paint');
            }
        });
        bttnConnect = new Button({
            parent : this,
            name : 'ButtonConnect',
            text_size : 12,
            x : 126, y : 36, w : 59, h : 40,
            text : 'Connect',
            onclick : function(_, _) {
                Luxe.events.fire('cursor.connect');
            }
        });
        bttnDestroy = new Button({
            parent : this,
            name : 'ButtonDestroy',
            text_size : 12,
            x : 187, y : 36, w : 59, h : 40,
            text : 'Remove',
            onclick : function(_, _) {
                Luxe.events.fire('cursor.remove');
            }
        });
    }
}
