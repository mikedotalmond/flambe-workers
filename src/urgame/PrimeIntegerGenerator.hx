package urgame;

import net.rezmason.utils.workers.BasicWorker;

class PrimeIntegerGenerator extends BasicWorker<Dynamic, Int> {

    override function receive(data:Dynamic):Void {
		
		var n	:Int = data.start;
		var end	:Int = data.end;
		
        while (!dead) {

            // Apparently, Flash workers won't terminate if they run too tightly
			// #if flash for (j in 0...10000000) {} #end
			
			if (isPrime(n) && n >= end) {
				// only send the last prime; the nearest value that is >= to the data.end value
				send(n);
			}
			
			n++;
        }
    }
	
	function isPrime(val:Int):Bool {
		if (val < 2) return false;
		var i:Int = 2;
		while (i*i < val) {
			if (val % i == 0) return false;
			i++;
		}
		return true;
	}
}
