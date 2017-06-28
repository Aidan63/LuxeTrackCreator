package ui.windows;

import mint.Canvas;
import mint.Control;
import mint.Panel;
import mint.Label;
import mint.Dropdown;
import mint.List;
import mint.types.Types;
import utils.Tilesets;

class UISegmentTiles extends Panel
{
    private var tilesetDropdown : Dropdown;
    private var tilesList : List;

    public function new(_canvas : Canvas)
    {
        super({
            parent : _canvas,
            name   : 'UISegmentTiles',
            x : 8, y : 180, w : 248, h : 309
        });

        new Label({
            name : 'TitleLabel',
            parent : this,
            text_size : 12,
            x : 2, y : 2, w : 244, h : 32,
            text : 'Segment Tile Painter',
            align : center,
            align_vertical : center
        });

        tilesetDropdown = new Dropdown({
            parent : this,
            name : 'tileset_dropdown',
            text : 'Tileset',
            x : 2, y : 36, w : 244, h : 44
        });

        tilesList = new List({
            parent : this,
            name : 'tiles_list',
            x : 2, y : 82, w : 244, h : 225,
            options: { view: { color:new luxe.Color().rgb(0x19191c) } },
        });

        var tilesets : Array<String> = Tilesets.getTilesets();

        inline function add_tileset(_name : String) {
            var first = tilesets.indexOf(_name) == 0;
            tilesetDropdown.add_item(
                new Label({
                    parent : this,
                    name   : 'tileset-$_name',
                    text   : _name,
                    align  : left,
                    w : 200, h : 24,
                    text_size : 14
                }), 10, (first) ? 0 : 10
            );
        }

        for (tileset in tilesets) add_tileset(tileset);
        tilesetDropdown.onselect.listen(function (_idx, _, _) {
            tilesetDropdown.label.text = tilesets[_idx];
            updateTileList(tilesetDropdown.label.text);
        });
    }

    private function updateTileList(_tileset : String)
    {
        tilesList.clear();
        for (tile in Tilesets.getTilesFromTileset(_tileset))
        {
            var panel = new Panel({
                parent      : tilesList,
                mouse_input : true,
                name        : 'panel',
                x : 0, y : 0, w : 232, h : 48
            });

            new mint.Image({
                parent      : panel,
                name        : 'icon',
                mouse_input : true,
                path        : tile.path,
                x : 2, y : 2, w : 44, h : 44,
            });

            new Label({
                parent         : panel,
                name           : 'label',
                mouse_input    : true,
                text           : tile.name,
                align          : left,
                align_vertical : center,
                x : 52, y : 2, w : 176, h : 44,
            });

            panel.onmousedown.listen(function (_mouse : MouseEvent, _control : Control) {
                for (child in _control.children)
                {
                    if (child.name == 'label')
                    {
                        Tilesets.setTile(tilesetDropdown.label.text, cast(child, Label).text);
                    }
                }
            });

            tilesList.add_item(panel, 2, 2);
        }
    }
}
