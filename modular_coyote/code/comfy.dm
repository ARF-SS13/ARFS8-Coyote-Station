// Comfy Concept
/*
Comfy as a mechanic was originally designed on Coyote Bayou to stop the age old issue of getting extremely hungry or thirsty mid scene.  We hypothesized at the time
that it could also be used to make the Event Scheudler subsystem in normal station play be made aware of player's play intention, eg. Are they trying to ERP/RP?

If it could then we could make it so events are more flexible to the desires of the players currently engaged within a round, and a large part of this entire codebases purpose is to test that hypothesis.

As such, the comfy system - which is separate from our RPWalk system - should do the following things.

Activation
- Toggle itself automatically once a player has sat in one x,y coord for a specific amount of time.
- Remain on if they only move via walking (as the two are intertwined)
- Only toggle off if they move X amount of tiles while running - so as to not immediatly toggle back on if they fat finger a quicker movement option.

Effect
- Limit thirst/hunger drain
- Remove the player from the event manager subsystem while they are comfy

It may need to do more, I'll discuss it with Dan and Fuzzy, but this entire dm file exists basically just as a note keeping record of the basic concept before Dan has time to
come in and turn it into proper code.  But I beg that we keep it simple at a baseline, as the system really only needs to be telling the event manager if someone is engaged in a way that doesn't need an event to keep them playing the game.
<3 ~ Fenny
*/
