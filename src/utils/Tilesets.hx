package utils;

import haxe.ds.StringMap;
import utils.FileManager;

class Tilesets
{
    /**
     *  Information on all loaded tilesets and their tiles.
     */
    private static var tilesets = new StringMap<Array<TileInformation>>();

    /**
     *  The most recently clicked tile.
     */
    public static var currentTile : TileInformation;

    /**
     *  Searches for tilesets and their tiles and adds them to the tileset database.
     */
    public static function discoverTilesets()
    {
        for (tset in FileManager.listTilesets())
        {
            var tiles = new Array<TileInformation>();
            for (tile in FileManager.getTiles(tset))
            {
                tiles.push(new TileInformation(tile.name, tile.path));
            }

            tilesets.set(tset, tiles);
        }
    }

    /**
     *  Gets all of the tiles for every tileset, used for loaded the textures.
     *  @return Array of all tile information.
     */
    public static function getAllTiles() : Array<TileInformation>
    {
        var allTiles = new Array<TileInformation>();

        for (tiles in tilesets.iterator())
        {
            allTiles = allTiles.concat(tiles);
        }

        return allTiles;
    }

    /**
     *  Gets all of the loaded tilesets.
     *  @return array of all of the tileset names.
     */
    public static function getTilesets() : Array<String>
    {
        var setNames = new Array<String>();

        for (key in tilesets.keys())
        {
            setNames.push(key);
        }

        return setNames;
    }

    /**
     *  Sets the current tile to the tile of the provided name from the provided tileset.
     *  @param _tileset The tileset to search for.
     *  @param _tileName The tile name to search for.
     */
    public static function setTile(_tileset : String, _tileName : String)
    {
        if (tilesets.exists(_tileset))
        {
            for (tile in tilesets.get(_tileset))
            {
                if (tile.name == _tileName)
                {
                    currentTile = tile;
                    break;
                }
            }
        }
    }

    /**
     *  Gets information on all of the tiles in the specified tileset
     *  @param _tileset The tileset to get tile info for.
     *  @return Array of TileInformation classes containing the name and path.
     */
    public static function getTilesFromTileset(_tileset : String) : Array<TileInformation>
    {
        if (tilesets.exists(_tileset))
        {
            return tilesets.get(_tileset);
        }

        return [];
    }
}

class TileInformation
{
    public var name : String;
    public var path : String;

    public function new(_name : String, _path : String)
    {
        name = _name;
        path = _path;
    }
}
