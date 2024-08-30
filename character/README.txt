Editing the Character-Animations.blend file will cause a large import process that could last a few minutes.
Edit only when needed.

NOTE: Adding new animations? Open the scene containing them (such as Character-Personalities.blend) 
and confirm these Advanced Import Settings (by double clicking the .blend file):
	
Actions: Set Animation Save Paths: res://addons/puggos_world_character/character/animations
If the animations are loops, set them accordingly under the importer's AnimationPlayer node.

Next, open res://addons/puggos_world_character/avatar/avatar.tscn
- Select AnimationPlayer and open the animation window below (between Audio and Shader Editor)
- Select Animation button, beside the animations dropdown.
- Select Manage Animations
- Select the FOLDER ICON by the "Character" animations library.
- Select the new animations to be added from the newly imported animations in the 
res://addons/puggos_world_character/character/animations folder.
