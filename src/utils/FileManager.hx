package utils;

import sys.FileSystem;
import haxe.io.Path;

class FileManager
{
    /*
    public static function listTilesets()
    {
        var basePath = FileSystem.fullPath('assets/tilesets/');
        for (item in FileSystem.readDirectory(basePath))
        {
            var itemPath : String = Path.join([basePath, item]);
            if (FileSystem.isDirectory(itemPath))
            {
                trace(item);
                listTextures(itemPath);
            }
        }
    }

    public static function listTextures(_tilesetPath : String)
    {
        for (item in FileSystem.readDirectory(_tilesetPath))
        {
            if (!FileSystem.isDirectory(Path.join([_tilesetPath, item])))
            {
                trace('    $item');
            }
        }
    }
    */

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
