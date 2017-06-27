package ui.windows;

import mint.Canvas;
import mint.Panel;
import mint.Checkbox;
import mint.TextEdit;

class UIGridWindow extends Panel
{
    private var showCheckbox : Checkbox;
    private var snapCheckbox : Checkbox;
    private var editHorizontal : TextEdit;
    private var editVertical : TextEdit;

    private var numbersReg : EReg;

    public function new(_canvas : Canvas)
    {
        super({
            parent : _canvas,
            name : 'UIGridWindow',
            x : 8, y : 720, w : 248, h : 172
        });

        new mint.Label({
            parent : this,
            name : 'Title',
            text_size : 12,
            x : 2, y : 2, w : 244, h : 32,
            text : 'Grid Options',
            align : center,
            align_vertical : center
        });

        new mint.Label({
            parent : this,
            name : 'LabelShowGrid',
            text_size : 12,
            x : 8, y : 36, w : 212, h : 32,
            text : 'Show grid',
            align : left,
            align_vertical : center
        });
        new mint.Label({
            parent : this,
            name : 'LabelSnapGrid',
            text_size : 12,
            x : 8, y : 70, w : 212, h : 32,
            text : 'Snap to grid',
            align : left,
            align_vertical : center
        });
        new mint.Label({
            parent : this,
            name : 'LabelHorizontal',
            text_size : 12,
            x : 8, y : 104, w : 212, h : 32,
            text : 'Horizontal divide',
            align : left,
            align_vertical : center
        });
        new mint.Label({
            parent : this,
            name : 'LabelVertical',
            text_size : 12,
            x : 8, y : 138, w : 212, h : 32,
            text : 'Vertical divide',
            align : left,
            align_vertical : center
        });

        numbersReg = new EReg('^[0-9]+[.]?[0-9]{0,2}$','gi');

        showCheckbox = new Checkbox({
            parent : this,
            name : 'showCheckbox',
            x : 214, y : 36, w : 32, h : 32,
            onchange : function(_newState : Bool, _prevState : Bool) {
                Luxe.events.fire('grid.show.toggle', _newState);
            }
        });
        snapCheckbox = new Checkbox({
            parent : this,
            name : 'snapCheckbox',
            x : 214, y : 70, w : 32, h : 32,
            onchange : function(_newState : Bool, _prevState : Bool) {
                Luxe.events.fire('grid.snap.toggle', _newState);
            }
        });

        editHorizontal = new TextEdit({
            parent : this,
            name : 'editHorizontal',
            text_size : 16,
            text : '',
            x : 182, y : 104, w : 64, h : 32,
            filter : function(char, future, prev) {
                return numbersReg.match(future);
            }
        });
        editVertical = new TextEdit({
            parent : this,
            name : 'editVertical',
            text_size : 16,
            text : '',
            x : 182, y : 138, w : 64, h : 32,
            filter : function(char, future, prev) {
                return numbersReg.match(future);
            }
        });

        editHorizontal.onchange.listen(function(_text : String, _displayText : String, _fromTyping : Bool) {
            if (_fromTyping && _text != '')
            {
                Luxe.events.fire('grid.horizontal', Std.parseInt(_text));
            }
        });
        editVertical.onchange.listen(function(_text : String, _displayText : String, _fromTyping : Bool) {
            if (_fromTyping && _text != '')
            {
                Luxe.events.fire('grid.vertical', Std.parseInt(_text));
            }
        });

        reloadControls();
    }

    public function reloadControls()
    {
        var grid : entities.Grid = cast Luxe.scene.get('grid');
        if (grid != null)
        {
            grid.drawGrid ? showCheckbox.mark() : showCheckbox.unmark();
            grid.gridSnap ? snapCheckbox.mark() : snapCheckbox.unmark();
            editHorizontal.text = Std.string(grid.horizontal);
            editVertical.text = Std.string(grid.vertical);
        }
    }
}
