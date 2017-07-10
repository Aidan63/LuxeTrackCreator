package entities;

import luxe.Entity;
import utils.fsm.EntityStateMachine;
import components.curves.Curve;
import components.ControlPoints;
import components.CurveTiles;
import components.CurvePoints;
import components.CollisionPolygon;
import components.Neighbours;
import components.RenderSkeleton;
import components.RenderTangents;
import components.CurveTileHighlighter;
import components.NeighbourHighlighter;
import components.CurveTileRenderer;
import components.SegmentEndsHelper;
import components.SegmentOffsetHelper;

class TrackSegment extends Entity
{
    public var fsm : EntityStateMachine;
    
    override public function init()
    {
        // Set up local events listeners from components.
        events.listen('segment.moved'  , onSegmentMoved);
        events.listen('segment.changed', onSegmentChanged);
        events.listen('segment.clicked', onSegmentClicked);

        // Neighbour events.
        events.listen('neighbour.next.connect', onNextNeighbourConnected);
        events.listen('neighbour.prev.connect', onPrevNeighbourConnected);
        events.listen('neighbour.next.move'   , onNextNeighbourMoved);
        events.listen('neighbour.prev.move'   , onPrevNeighbourMoved);
        events.listen('neighbour.next.changed', onNextNeighbourChanged);
        events.listen('neighbour.prev.changed', onPrevNeighbourChanged);

        // Property setters
        events.listen('skeleton.set', toggleSkeleton);
        events.listen('tangents.set', toggleTangents);

        // Set up global event listeners for events outside of its compononents.
        Luxe.events.listen('segment.selected', onSegmentSelected);
        
        Luxe.events.listen('cursor.select' , onCursorSelect );
        Luxe.events.listen('cursor.remove' , onCursorRemove );
        Luxe.events.listen('cursor.connect', onCursorConnect);
        Luxe.events.listen('cursor.paint'  , onCursorPaint  );

        // Setup the state machine and set to the initial unselected state.
        fsm = new EntityStateMachine();
        fsm.createState('unselected' );
        fsm.createState('selectable' ).add(new CollisionPolygon());
        fsm.createState('selected'   ).add(new ControlPoints()).add(new SegmentEndsHelper()).add(new SegmentOffsetHelper());
        fsm.createState('destroyable').add(new CollisionPolygon());
        fsm.createState('neighbours' ).add(new NeighbourHighlighter()).add(new SegmentEndsHelper());
        fsm.createState('paintable'  ).add(new CurveTileHighlighter());

        add(fsm);

        fsm.changeState('selectable');
    }

    /**
     * When a control has been moved we need to update the curve by calling the appropriate function on any possible components.
     */
    private function onSegmentMoved(_)
    {
        // Update the curve component with the position of all of the control sprites.
        if (has('curve') && has('control_points'))
        {
            var curve    : Curve         = cast get('curve');
            var controls : ControlPoints = cast get('control_points');

            curve.controlPoints = [ for (point in controls.controls) point.pos ];
        }

        // Once the control points have been updated we build the next track segment first as the last point of this one is the first of the next.
        if (has('neighbours'))
        {
            var neighbours : Neighbours = cast get('neighbours');
            if (neighbours.next != null)
            {
                neighbours.next.events.fire('neighbour.prev.move');
            }
        }

        // Then we rebuild this segment.
        build();

        // Lastly the previous segment is rebuilt if there is one.
        if (has('neighbours'))
        {
            var neighbours : Neighbours = cast get('neighbours');
            if (neighbours.previous != null)
            {
                neighbours.previous.events.fire('neighbour.next.move');
            }
        }
    }

    /**
     * Sets this segments first control point to the last control point of the previous segments.
     */
    private function getFirstControlPoint()
    {
        if (has('neighbours') && has('curve'))
        {
            var neighbours : Neighbours = cast get('neighbours');
            var curve      : Curve      = cast get('curve');

            if (neighbours.previous != null && neighbours.previous.has('curve'))
            {
                var prevNeighbourCurve : Curve = cast neighbours.previous.get('curve');
                var firstPoint = prevNeighbourCurve.controlPoints[prevNeighbourCurve.controlPoints.length - 1];

                curve.controlPoints[0] = firstPoint;
            }
        }
    }

    /**
     * Sets this segments last control point to the first control point of the next segment.
     */
    private function getLastControlPoint()
    {
        if (has('neighbours') && has('curve'))
        {
            var neighbours : Neighbours = cast get('neighbours');
            var curve      : Curve      = cast get('curve');

            if (neighbours.next != null && neighbours.next.has('curve'))
            {
                var nextNeighbourCurve : Curve = cast neighbours.next.get('curve');
                var lastPoint = nextNeighbourCurve.controlPoints[0];

                curve.controlPoints[curve.controlPoints.length - 1] = lastPoint;
            }
        }
    }

    private function onNextNeighbourMoved(_)
    {
        getLastControlPoint();
        build();
    }

    private function onPrevNeighbourMoved(_)
    {
        getFirstControlPoint();
        build();
    }

    private function onNextNeighbourConnected(_segment : TrackSegment)
    {
        if (has('neighbours'))
        {
            var neighbour : Neighbours = cast get('neighbours');
            neighbour.next = _segment;
        }

        onNextNeighbourMoved(null);
    }

    private function onPrevNeighbourConnected(_segment : TrackSegment)
    {
        if (has('neighbours'))
        {
            var neighbour : Neighbours = cast get('neighbours');
            neighbour.previous = _segment;
        }

        onPrevNeighbourMoved(null);
    }

    private function onNextNeighbourChanged(_properties : SegmentProperties)
    {
        if (has('points'))
        {
            var points : CurvePoints = cast get('points');
            points.endNegativeDistance = _properties.startNegative;
            points.endPositiveDistance = _properties.startPositive;

            build();
        }
    }

    private function onPrevNeighbourChanged(_properties : SegmentProperties)
    {
        if (has('points'))
        {
            var points : CurvePoints = cast get('points');
            points.startNegativeDistance = _properties.endNegative;
            points.startPositiveDistance = _properties.endPositive;

            build();
        }
    }

    /**
     * When the collision polygon has been pressed toggle between selected and non selected mode.
     */
    private function onSegmentClicked(_)
    {
        if (has('states'))
        {
            switch (fsm.currentStateName)
            {
                case 'selectable':
                    fsm.changeState('selected');
                    Luxe.events.queue('segment.selected', this);

                case 'destroyable':
                    trace('DESTROY');
            }
        }
    }

    private function onSegmentSelected(_entity : Entity)
    {
        if (_entity.id != id)
        {
            fsm.changeState('selectable');
        }
    }

    private function onSegmentChanged(_properties : SegmentProperties)
    {
        if (has('points'))
        {
            var points : CurvePoints = get('points');
            points.startPositiveDistance = _properties.startPositive;
            points.startNegativeDistance = _properties.startNegative;
            points.endPositiveDistance = _properties.endPositive;
            points.endNegativeDistance = _properties.endNegative;
            points.divisions = _properties.segmentSize;

            build();
        }

        if (has('neighbours'))
        {
            var neighbours : Neighbours = cast get('neighbours');
            if (neighbours.next != null)
            {
                neighbours.next.events.fire('neighbour.prev.changed', _properties);
            }
            if (neighbours.previous != null)
            {
                neighbours.previous.events.fire('neighbour.next.changed', _properties);
            }
        }
    }

    private function onCursorConnect(_)
    {
        fsm.changeState('neighbours');
    }

    private function onCursorSelect(_)
    {
        fsm.changeState('selectable');
    }

    private function onCursorRemove(_)
    {
        fsm.changeState('destroyable');
    }

    private function onCursorPaint(_)
    {
        fsm.changeState('paintable');
    }

    /**
     * Rebuilds the entire track segment.
     */
    public function build()
    {
        if (has('curve'))
        {
            var curve : Curve = cast get('curve');

            var lengths = curve.calculateLength();
            curve.length         = lengths.length;
            curve.lengthMappings = lengths.lengthMappings;
        }

        // Build data
        if (has('points'   )) { cast(get('points'   ), CurvePoints     ).build(); }
        if (has('tiles'    )) { cast(get('tiles'    ), CurveTiles      ).build(); }
        if (has('collision')) { cast(get('collision'), CollisionPolygon).build(); }

        // Drawing stuff
        if (has('tile_drawer'     )) { cast(get('tile_drawer'     ), CurveTileRenderer   ).render(); }
        if (has('tile_highlighter')) { cast(get('tile_highlighter'), CurveTileHighlighter).render(); }
        if (has('skeleton_drawer' )) { cast(get('skeleton_drawer' ), RenderSkeleton      ).render(); }
        if (has('tangent_drawer'  )) { cast(get('tangent_drawer'  ), RenderSkeleton      ).render(); }

        // Extra stuff
        if (has('ends_helper'  )) { cast(get('ends_helper'  ), SegmentEndsHelper  ).build(); }
        if (has('offset_helper')) { cast(get('offset_helper'), SegmentOffsetHelper).build(); }
    }

    /**
     * Returns if this track segment has a skeleton renderer.
     * @return Bool
     */
    public function hasSkeleton() : Bool
    {
        return has('skeleton_drawer');
    }

    /**
     * Returns if this track segment has a tangents renderer.
     * @return Bool
     */
    public function hasTangents() : Bool
    {
        return has('tangent_drawer');
    }

    /**
     * Toggles adding / removing a skeleton renderer from this track segment.
     */
    public function toggleSkeleton(_value : Bool)
    {
        if (_value)
        {
            if (!has('skeleton_drawer')) { add(new RenderSkeleton()); }
        }
        else
        {
            if (has('skeleton_drawer')) { remove('skeleton_drawer'); }
        }
    }

    /**
     * Toggles adding / removing a tangent renderer from this track segment.
     */
    public function toggleTangents(_value : Bool)
    {
        if (_value)
        {
            if (!has('tangent_drawer')) { add(new RenderTangents()); }
        }
        else
        {
            if (has('tangent_drawer')) { remove('tangent_drawer'); }
        }
    }
}

typedef SegmentProperties = {
    var startPositive : Float;
    var startNegative : Float;
    var endPositive : Float;
    var endNegative : Float;
    var segmentSize : Int;
}

typedef NeighbourProperties = {
    var segment : TrackSegment;
    var type    : String;
}
