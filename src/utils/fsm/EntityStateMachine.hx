package utils.fsm;

import luxe.Component;
import utils.fsm.EntityState;

class EntityStateMachine extends Component
{
    /**
     * All of the states in this state machine.
     */
    private var states : Map<String, EntityState>;

    /**
     * The current state.
     */
    private var currentState : EntityState;

    /**
     * The name of the current state.
     */
    public var currentStateName : String;

    public function new()
    {
        super({ name : 'states' });

        states = new Map<String, EntityState>();
    }

    public function addState(_name : String, _state : EntityState) : EntityStateMachine
    {
        states.set(_name, _state);
        return this;
    }

    public function createState(_name : String) : EntityState
    {
        var state = new EntityState();
        states.set(_name, state);
        return state;
    }

    public function changeState(_name : String)
    {
        if (states.exists(_name))
        {
            var newState = states.get(_name);
            
            if (newState == currentState)
            {
                return;
            }
            
            // Remove all existing components for the current state.
            if (currentState != null)
            {
                for (key in currentState.components.keys())
                {
                    if (!newState.components.exists(key))
                    {
                        remove(key);
                    }
                }
            }

            // Add components for the new state.
            for (key in newState.components.keys())
            {
                if (!has(key))
                {
                    add(newState.components.get(key));
                }
            }

            currentState     = newState;
            currentStateName = _name;
        }
        else
        {
            return;
        }
    }
}
