package utils;

import sys.FileSystem;
import haxe.io.Path;

class FileManager
{
    /**
     *  Gets a list of all tilesets.
     *  @return Array of all tileset folder names.
     */
    public static function listTilesets() : Array<String>
    {
        var tilesets = new Array<String>();

        var basePath = FileSystem.fullPath('assets/tilesets/');
        for (item in FileSystem.readDirectory(basePath))
        {
            var itemPath : String = Path.join([basePath, item]);
            if (FileSystem.isDirectory(itemPath))
            {
                tilesets.push(item);
            }
        }

        return tilesets;
    }

    public static function getTiles(_tileset : String) : Array<TileData>
    {
        var tiles = new Array<TileData>();

        var basePath = FileSystem.fullPath('assets/tilesets/');
        for (item in FileSystem.readDirectory(basePath))
        {
            var itemPath : String = Path.join([basePath, item]);
            if (FileSystem.isDirectory(itemPath) && item == _tileset)
            {
                // 
                for (item in FileSystem.readDirectory(itemPath))
                {
                    if (!FileSystem.isDirectory(Path.join([itemPath, item])))
                    {
                        tiles.push({
                            name : item,
                            path : 'assets/tilesets/$_tileset/$item'
                        });
                    }
                }
            }
        }

        return tiles;
    }

    public static function getTilesetTextures() : Array<String>
    {
        var texturePaths = new Array<String>();
        var tileset : String;

        function addTextures(_tilesetPath : String) {
            for (item in FileSystem.readDirectory(_tilesetPath))
            {
                if (!FileSystem.isDirectory(Path.join([_tilesetPath, item])))
                {
                    trace('adding texture assets/tilesets/$tileset/$item');
                    texturePaths.push('assets/tilesets/$tileset/$item');
                }
            }
        }

        var basePath : String = FileSystem.fullPath('assets/tilesets/');
        for (item in FileSystem.readDirectory(basePath))
        {
            var fullPath : String = Path.join([basePath, item]);
            if (FileSystem.isDirectory(fullPath))
            {
                tileset = item;
                addTextures(fullPath);
            }
        }

        return texturePaths;
    }
}

typedef TileData = {
    var name : String;
    var path : String;
}
