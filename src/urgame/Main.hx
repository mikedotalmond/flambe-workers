package urgame;

import flambe.display.Font;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.script.AnimateBy;
import flambe.script.AnimateTo;
import flambe.script.Delay;
import flambe.script.Parallel;
import flambe.script.Repeat;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import haxe.Timer;

import net.rezmason.utils.workers.QuickBoss;
import net.rezmason.utils.workers.Golem;
typedef PIGBoss = QuickBoss<Dynamic, Int>;

class Main {	
	
    static function main () {       
		
		// Wind up all platform-specific stuff
        System.init();
		
        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.fromAssets("bootstrap");
        var loader = System.loadAssetPack(manifest);
		
		loader.get(onSuccess);
    }
	
	
    static function onSuccess (pack :AssetPack) {
		
        // Add a solid color background
        var background = new FillSprite(0x202020, System.stage.width, System.stage.height);
        System.root.addChild(new Entity().add(background));

        // Add a plane that moves along the screen
        var plane = new ImageSprite(pack.getTexture("plane")).centerAnchor();
        plane.x._ = System.stage.width/2;
        plane.y._ = System.stage.height/2;
        System.root.addChild(new Entity().add(plane));
		
		var script = new Script();
		script.run( new Repeat( new AnimateBy(plane.rotation, 270, 1) ) );
		System.root.add(script);
		
		var fnt:Font = new Font(pack, 'font/Prime16');
		txt = new TextSprite(fnt, "Working...");
		System.root.addChild(new Entity().add(txt));
		txt.x._ = 4;
		startTime = Timer.stamp();
		
		
		// create worker
		pig = new PIGBoss(Golem.rise('assets/bootstrap/prime_workers.hxml'), onPrimeComplete, onPrimeError);		
		// start the worker 
		pig.start();
		pig.send({start:1000000, end:2000000}); // should always end on 2000003 with these settings
    }
	
	
	
	static var txt		:TextSprite;
	static var startTime:Float;
	
    static var pig		:PIGBoss 	= null;
    static var workDone	:Bool 		= false;
	
    static function onPrimeComplete(i:Int) {	
		if (!workDone) {
			pig.die(); // in Flash Workers seem to continue running for a short while after terminate is called - perhaps need to check state for TERMINATED?
			workDone = true;
			txt.text = 'Finished at ${i} after ${(Timer.stamp()-startTime)}s';
		}
    }
	
    static function onPrimeError(err) {
		txt.text = 'onPrimeError ${err}';
		workDone = true;
	}
}
