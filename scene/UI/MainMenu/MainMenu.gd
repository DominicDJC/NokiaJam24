extends Control

# Hello again, Cromain. Just like with the in_game_ui.tscn stuff, try to stay in this scene.
# The start_game signal is already setup to start the game whenever you put it to use.
# So, once again, you shouldn't need to be doing anything outside of this scene.
# (Unless you're wanting to separate settings in to a different scene or something
# in that case just make sure you stay in your UI folders)

## Use this signal to start the game
## via 'start_game.emit()'.
signal start_game
