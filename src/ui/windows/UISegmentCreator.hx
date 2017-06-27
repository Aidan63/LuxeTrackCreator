package ui.windows;

import mint.Canvas;
import mint.Panel;
import mint.Button;
import mint.Label;

class UISegmentCreator extends Panel
{
    private var bttnLinear : Button;
    private var bttnQuadratic : Button;
    private var bttnCubic : Button;
    
    public function new(_canvas : Canvas)
    {
        super({
            parent : _canvas,
            name : 'UISegmentCreator',
            x : 8, y : 8, w : 248, h : 78
        });

        new Label({
            name : 'TitleLabel',
            parent : this,
            text_size : 12,
            x : 2, y : 2, w : 244, h : 32,
            text : 'Segment Creator',
            align : center,
            align_vertical : center
        });

        bttnLinear = new Button({
            name : 'ButtonLinear',
            parent : this,
            text_size : 12,
            x : 2, y : 36, w : 80, h : 40,
            text : 'Linear',
            onclick : function(_, _) {
                Luxe.events.fire('cursor.create', 'linear');
            }
        });
        bttnQuadratic = new Button({
            name : 'ButtonQuadratic',
            parent : this,
            text_size : 12,
            x : 84, y : 36, w : 80, h : 40,
            text : 'Quadratic',
            onclick : function(_, _) {
                Luxe.events.fire('cursor.create', 'quadratic');
            }
        });
        bttnCubic = new Button({
            name : 'buttonCubic',
            parent : this,
            text_size : 12,
            x : 166, y : 36, w : 80, h : 40,
            text : 'Cubic',
            onclick : function(_, _) {
                Luxe.events.fire('cursor.create', 'cubic');
            }
        });
    }
}
