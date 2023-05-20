# Scope #
We will have 2 phases. In Phase 1 we want to get the core game done. Phase 2 will handle not only polish and new features, but also other details like main menu, settings, intro.
## Phase 1 ##
### Player ###
Animations for the material world: idle, move, jump, fall, wall attach, attack, hurt*, "death"

Animations for the spectral world: idle, move, jump, fall, dash, attack, hurt*, "death", materialize

(Note: Elements with * are optional.)

Base Mechanics:
- base movement
- jump
- dash
- attack material
- attack spectral
- hurt
- death spectral
- death material
- materialize
- collecting energy
- material decay
- peer into material world


Sound for:
- move (spectral and material)
- jump
- dash
- land
- wall attach (same as land?)
- hurt
- materialize
- fade to spectral
- die in spectral
- collect energy

### Enemies Spectral ###
We will need two enemies, one weaker, one stronger. This will be a spectral world, so we can think that would be scary for a person (maybe not so much for our character, at least no the weak one). The weak enemy will be basically a way of getting soul energy.

Animations: idle, move, attack, hurt*, death

(Note: Elements with * are optional.)

Additionally, we need a visual representation of the soul energy we will collect. The death of these enemies should be related to that.

Mechanics:
- patrol
- engage
- attack
- hurt
- death
- respawn


### Enemies Material ###
We will need two enemies, one weaker, one stronger. At least one of them must be living. The other one might be a skeleton, or not. The strongest might have a ranged attack, or just be stronger.

Animations: idle, move, attack, hurt*, death

(Note: Elements with * are optional.)

Mechanics:
- patrol
- engage
- attack
- hurt
- death
- respawn

### Necromancer ###
In this first version, the necromancer will be unbeatable and we have to sneak by him undetected to steal an orb. When we do that, he dies. If he see us, he should have a uberpowerful attack that kills us.

Animations: idle, move, lethal attack, death

Mechanics:
- patrol
- attack
- death

### World ###

The setting is dark medieval. We will need 2 settings. First one is in the cemetery, the second is in the castle.
We will want a tilemap for each. Most of the differentiation will be done by the shaders used for the spectral world, but some elements will be different in both dimensions, e.g. trees with leaves vs dead trees, lamps with light vs more ethereal sources of light.

Tiles:
- 9 tile island (cemetery, castle)
- 3 tile platform (cemetery, castle)
- tiles for floor (cemetery, castle)
- light sources spectral, cemetery and castle
- props


Mechanics:
- spectral and material transition
- peer into material world


### Level Design ###
Two levels. TBD





    


