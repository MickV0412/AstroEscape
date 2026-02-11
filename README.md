# Simple Godot Platform Game - Setup Guide

## What You Have
- `project.godot` - Main project configuration
- `scripts/player.gd` - Player movement script
- `assets/background.png` - Your background image
- Controls: A/Left Arrow = Move Left, D/Right Arrow = Move Right

## Steps to Set Up in Godot

### 1. Open the Project
- Open Godot Engine (version 4.x)
- Click "Import" and navigate to the `project.godot` file
- Click "Import & Edit"

### 2. Create the Player Scene
- Click the + button to create a new scene
- Choose "Other Node" and select **CharacterBody2D** as the root node
- Rename it to "Player"
- Right-click on Player and add these child nodes:
  - **Sprite2D** (for your character sprite)
  - **CollisionShape2D** (for collision detection)

### 3. Set Up the Player
- Select the **Sprite2D** node
  - In the Inspector, drag your character sprite into the "Texture" property
  - Adjust the scale if needed
  
- Select the **CollisionShape2D** node
  - In the Inspector, click the "Shape" dropdown
  - Choose "New RectangleShape2D" or "New CapsuleShape2D"
  - Adjust the size to match your character sprite

- Select the **Player** (root) node
  - In the Inspector, attach the script: click the script icon and select `scripts/player.gd`
  - OR drag the `player.gd` file from the FileSystem onto the Player node

- Save this scene as `scenes/player.tscn`

### 4. Create the Main Scene
- Create a new scene with **Node2D** as root
- Rename it to "Main"
- Add these child nodes:
  - **Sprite2D** (for the background)
  - **StaticBody2D** (for the ground)

### 5. Set Up the Background
- Select the **Sprite2D** node
  - Drag `assets/background.png` into the Texture property
  - Check "Centered" is OFF in the Inspector
  - You may need to adjust the scale to fit your window (1280x720)

### 6. Create the Ground
- Select the **StaticBody2D** node and rename it to "Ground"
- Add a child **CollisionShape2D** to the Ground node
- Select the CollisionShape2D:
  - Set Shape to "New RectangleShape2D"
  - Adjust the size to create a platform (make it wide and flat)
  - Position it at the bottom of the screen where you want the ground

### 7. Add the Player to Main Scene
- In the Main scene, click the chain link icon (Instance Child Scene)
- Select `scenes/player.tscn`
- Position the player above the ground

### 8. Set Main Scene
- Go to Project → Project Settings → Application → Run
- Set Main Scene to `res://scenes/main.tscn`
- Close Project Settings

### 9. Test Your Game!
- Press F5 or click the Play button
- Use A/D or Arrow Keys to move left and right

## Tips
- To adjust movement speed: Select Player node → Inspector → Script Variables → Speed
- To add more platforms: Duplicate the Ground node and reposition it
- Make sure the CollisionShape2D sizes match your sprites for proper collision

## Next Steps
- Add jumping (modify player.gd to detect jump input)
- Add more platforms and obstacles
- Create animated sprites for walking
- Add enemies or collectibles
"# AstroEscape" 
