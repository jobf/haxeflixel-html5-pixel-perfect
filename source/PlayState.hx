package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.system.scaleModes.FillScaleMode;
import flixel.system.scaleModes.FixedScaleMode;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.system.scaleModes.RelativeScaleMode;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	var currentPolicy:FlxText;
	var scaleModes:Array<ScaleMode> = [RATIO_DEFAULT, RATIO_FILL_SCREEN, FIXED, RELATIVE, FILL];
	var scaleModeIndex:Int = 0;
	var sprites:Array<FlxSprite>;
	var pixelPerfectPosition:Bool;
	var antiAliasing:Bool;
	var frozen:Bool;

	override public function create():Void
	{
		add(new FlxSprite(0, 0, "assets/bg.png"));

		currentPolicy = new FlxText(0, 10, FlxG.width, '${ScaleMode.RATIO_DEFAULT}${pixelPerfectMode()}');
		currentPolicy.alignment = CENTER;
		currentPolicy.size = 8;
		add(currentPolicy);

		var info:FlxText = new FlxText(0, FlxG.height - 40, FlxG.width,
			"Click changes scale mode, p/r/a toggles perfection, (f)reeze frames or (n)ew sprites");
		info.setFormat(null, 8, FlxColor.WHITE, CENTER);
		info.alpha = 0.75;
		add(info);

		setupSprites();
	}

	function setupSprites()
	{
		if (sprites != null)
		{
			for (s in sprites)
			{
				s.kill();
				remove(s);
			}
		}

		sprites = [];
		var speed = 45.5;
		var verticalShip = new Ship(0, 0);
		verticalShip.velocity.y = speed;
		sprites.push(verticalShip);
		add(verticalShip);

		var horizontalShip = new Ship(0, 0);
		horizontalShip.velocity.x = speed;
		sprites.push(horizontalShip);
		add(horizontalShip);

		var diagonalShip = new Ship(0, 0);
		diagonalShip.velocity.y = (speed) / 2;
		diagonalShip.velocity.x = (speed) / 2;
		sprites.push(diagonalShip);
		add(diagonalShip);

		var rotationShip = new Ship(0, 0);
		rotationShip.angularVelocity = speed;
		sprites.push(rotationShip);
		add(rotationShip);
		var sprite:FlxSprite;
		sprite = new FlxSprite(FlxG.width * 0.5 - 8, FlxG.height * 0.5 - 8);
		sprite.makeGraphic(16, 16, FlxColor.GREEN);
		sprite.angularVelocity = 20;
		sprites.push(sprite);
		add(sprite);
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.mouse.justPressed)
		{
			scaleModeIndex = FlxMath.wrap(scaleModeIndex + 1, 0, scaleModes.length - 1);
			setScaleMode(scaleModes[scaleModeIndex]);
		}

		if (FlxG.keys.justPressed.R)
		{
			FlxG.camera.pixelPerfectRender = !FlxG.camera.pixelPerfectRender;
			setScaleMode(scaleModes[scaleModeIndex]);
		}

		if (FlxG.keys.justPressed.A)
		{
			antiAliasing = !antiAliasing;
			for (s in sprites)
			{
				s.antialiasing = antiAliasing;
			}
			setScaleMode(scaleModes[scaleModeIndex]);
		}

		if (FlxG.keys.justPressed.P)
		{
			pixelPerfectPosition = !pixelPerfectPosition;
			for (s in sprites)
			{
				s.pixelPerfectPosition = pixelPerfectPosition;
			}
			setScaleMode(scaleModes[scaleModeIndex]);
		}

		if (FlxG.keys.justPressed.N)
		{
			setupSprites();
		}

		if (FlxG.keys.justPressed.F)
		{
			frozen = !frozen;
		}
		if (!frozen)
		{
			super.update(elapsed);
		}
	}

	function pixelPerfectMode():String
	{
		var pixelrender = FlxG.camera.pixelPerfectRender ? " on " : " off ";
		var pixelpos = pixelPerfectPosition ? " on " : " off ";
		var antialiasing = antiAliasing ? " on " : " off ";
		return '\n(r)ender perfect:${pixelrender}\n(p)osition perfect:${pixelpos}\n(a)nti aliasing${antialiasing}';
	}

	function setScaleMode(scaleMode:ScaleMode)
	{
		currentPolicy.text = scaleMode + pixelPerfectMode();

		FlxG.scaleMode = switch (scaleMode)
		{
			case ScaleMode.RATIO_DEFAULT:
				new RatioScaleMode();

			case ScaleMode.RATIO_FILL_SCREEN:
				new RatioScaleMode(true);

			case ScaleMode.FIXED:
				new FixedScaleMode();

			case ScaleMode.RELATIVE:
				new RelativeScaleMode(0.75, 0.75);

			case ScaleMode.FILL:
				new FillScaleMode();
		}
	}
}

@:enum
abstract ScaleMode(String) to String
{
	var RATIO_DEFAULT = "ratio";
	var RATIO_FILL_SCREEN = "ratio (screenfill)";
	var FIXED = "fixed";
	var RELATIVE = "relative 75%";
	var FILL = "fill";
}
