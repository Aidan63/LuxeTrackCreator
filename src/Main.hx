import luxe.GameConfig;
import luxe.Input;
import luxe.States;

class Main extends luxe.Game
{
    public var states : States;

    override function config(_config : GameConfig)
    {
        _config.window.title      = 'luxe game';
        _config.window.width      = 1600;
        _config.window.height     = 900;
        _config.window.fullscreen = false;

        _config.render.antialiasing = 8;

        _config.preload.textures.push({ id : 'assets/track.png' });
        _config.preload.texts.push({ id : 'assets/tile.obj' });

        return _config;
    }

    override function ready()
    {
        states = new States();
        states.add(new states.EditorState({ name : 'TrackEditor' }));

        states.set('TrackEditor');
    }

    override function onkeyup(_event : KeyEvent)
    {
        if(_event.keycode == Key.escape)
        {
            Luxe.shutdown();
        }
    }

    override function update(_dt : Float)
    {
        //
    }
}
