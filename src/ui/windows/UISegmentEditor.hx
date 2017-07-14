package ui.windows;

import luxe.Entity;
import mint.TextEdit;
import mint.Checkbox;
import mint.Button;
import mint.Panel;
import mint.Canvas;

class UISegmentEditor extends Panel
{
    private var numbersReg : EReg;
    private var segment : Entity;

    private var edit_startPositive : TextEdit;
    private var edit_startNegative : TextEdit;
    private var edit_endPositive : TextEdit;
    private var edit_endNegative : TextEdit;
    private var edit_segmentSize : TextEdit;
    private var show_skeleton : Checkbox;
    private var show_tangents : Checkbox;
    private var button_update : Button;

    public function new(_canvas : Canvas)
    {
        super({
            parent : _canvas,
            name   : 'UISegmentEditorWindow',
            x : 8, y : 180, w : 248, h : 380,
        });

        numbersReg = new EReg('^[0-9]+[.]?[0-9]{0,2}$','gi');

        // Panel title
        new mint.Label({
            name : 'TitleLabel',
            parent : this,
            text_size : 12,
            x : 2, y : 2, w : 244, h : 32,
            text : 'Segment Editor',
            align : center,
            align_vertical : center
        });

        // Add title labels
        new mint.Label({
            name : 'LabelPositiveOffsets',
            parent : this,
            text_size : 10,
            x : 2, y : 36, w : 244, h : 16,
            text : 'Positive Offsets',
            align : left,
            align_vertical : center
        });
        new mint.Label({
            name : 'LabelNegativeOffsets',
            parent : this,
            text_size : 10,
            x : 8, y : 122, w : 244, h : 16,
            text : 'Negative Offsets',
            align : left,
            align_vertical : center
        });

        // Add text edit labels.
        new mint.Label({
            name : 'LabelStartPositive',
            parent : this,
            text_size : 12,
            x : 18, y : 54, w : 164, h : 32,
            text : 'Start',
            align : left,
            align_vertical : center
        });
        new mint.Label({
            name : 'LabelEndPositive',
            parent : this,
            text_size : 12,
            x : 18, y : 88, w : 164, h : 32,
            text : 'End',
            align : left,
            align_vertical : center
        });
        new mint.Label({
            name : 'LabelStartNegative',
            parent : this,
            text_size : 12,
            x : 18, y : 140, w : 164, h : 32,
            text : 'Start',
            align : left,
            align_vertical : center
        });
        new mint.Label({
            name : 'LabelEndNegative',
            parent : this,
            text_size : 12,
            x : 18, y : 174, w : 164, h : 32,
            text : 'End',
            align : left,
            align_vertical : center
        });

        new mint.Label({
            name : 'LabelSegmentSize',
            parent : this,
            text_size : 12,
            x : 18, y : 226, w : 164, h : 32,
            text : 'Segment Size',
            align : left,
            align_vertical : center
        });

        new mint.Label({
            name : 'LabelDebugOptions',
            parent : this,
            text_size : 10,
            x : 2, y : 260, w : 244, h : 16,
            text : 'debug',
            align : left,
            align_vertical : center
        });

        new mint.Label({
            name : 'LabelShowSkeleton',
            parent : this,
            text_size : 12,
            x : 18, y : 278, w : 196, h : 32,
            text : 'show skeleton',
            align : left,
            align_vertical : center
        });
        new mint.Label({
            name : 'LabelShowSkeleton',
            parent : this,
            text_size : 12,
            x : 18, y : 312, w : 196, h : 32,
            text : 'show tangents',
            align : left,
            align_vertical : center
        });

        // Add text edit options for start and end offsets
        edit_startPositive = new mint.TextEdit({
            name : 'EditStartPositive',
            parent : this,
            text_size : 16,
            x : 182, y : 54, w : 64, h : 32,
            text : '',
            filter : function(char, future, prev) {
                return numbersReg.match(future);
            }
        });
        edit_endPositive = new mint.TextEdit({
            name : 'EditEndPositive',
            parent : this,
            text_size : 16,
            x : 182, y : 88, w : 64, h : 32,
            text : '',
            filter : function(char, future, prev) {
                return numbersReg.match(future);
            }
        });
        edit_startNegative = new mint.TextEdit({
            name : 'EditStartNegative',
            parent : this,
            text_size : 16,
            x : 182, y : 140, w : 64, h : 32,
            text : '',
            filter : function(char, future, prev) {
                return numbersReg.match(future);
            }
        });
        edit_endNegative = new mint.TextEdit({
            name : 'EditEndNegative',
            parent : this,
            text_size : 16,
            x : 182, y : 174, w : 64, h : 32,
            text : '',
            filter : function(char, future, prev) {
                return numbersReg.match(future);
            }
        });

        edit_segmentSize = new mint.TextEdit({
            name : 'EditSegmentSize',
            parent : this,
            text_size : 16,
            x : 182, y : 226, w : 64, h : 32,
            text : '',
            filter : function(char, future, prev) {
                return numbersReg.match(future);
            }
        });

        show_skeleton = new mint.Checkbox({
            name : 'ShowSkeleton',
            parent : this,
            x : 214, y : 278, w : 32, h : 32,
            onchange : function(_newState : Bool, _) {
                if (segment != null) { segment.events.queue('skeleton.set', _newState); }
            }
        });
        show_tangents = new mint.Checkbox({
            name : 'ShowTangents',
            parent : this,
            x : 214, y : 312, w : 32, h : 32,
            onchange : function(_newState : Bool, _) {
                if (segment != null) { segment.events.queue('tangents.set', _newState); }
            }
        });

        // Update button
        button_update = new mint.Button({
            name : 'ButtonUpdate',
            parent : this,
            text_size : 12,
            x : 2, y : 346, w : 244, h : 32,
            text : 'Apply',
            onclick : onUpdateClicked
        });
    }

    public function setEntity(_segment : Entity)
    {
        segment = cast _segment;
        reloadControls();
    }

    private function reloadControls()
    {
        if (segment != null)
        {
            if (segment.has('points'))
            {
                var curve : components.CurvePoints = cast segment.get('points');

                edit_startPositive.text = cast curve.data.startPositiveDistance;
                edit_startNegative.text = cast curve.data.startNegativeDistance;
                edit_endPositive.text = cast curve.data.endPositiveDistance;
                edit_endNegative.text = cast curve.data.endNegativeDistance;
                edit_segmentSize.text = cast curve.data.divisions;
            }

            show_skeleton.state = segment.has('skeleton_drawer');
            show_tangents.state = segment.has('tangent_drawer');
        }
    }

    private function onUpdateClicked(_, _)
    {
        if (segment != null)
        {
            segment.events.queue('segment.changed', {
                startPositive : Std.parseFloat(edit_startPositive.text),
                startNegative : Std.parseFloat(edit_startNegative.text),
                endPositive   : Std.parseFloat(edit_endPositive.text),
                endNegative   : Std.parseFloat(edit_endNegative.text),
                segmentSize   : Std.parseInt(edit_segmentSize.text)
            });
        }
    }
}
