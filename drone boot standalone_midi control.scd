///perfect numbers  6, 28, 496, 8128
///make as boot file
///put low pass and high pass
//put reverb
///put midi in: 1 knob gain, 1knob fundamettnal *2.pow(n/56), 1 knob low pass 28/496, 1 knob highpass 496/8128, 1 knob reverb mix, 1 knob rewverb room size


///build

(
Server.default = s = Server.local;
////server setup
(
s.waitForBoot{

	(

(
SynthDef.new(\drone,{ arg gain,low,high,tone,mix,room; var

}).add;);
	~synth=Synth.new(\inst4,[
\gain,,\tone,,\low,,\high,,\mix,,\room,]).register;

	(
MIDIClient.init;
MIDIIn.connectAll;

		(
MIDIdef.cc(\midi1,{ |val, num, chan, src|
		var band;
	//[val, num, chan, src].postln;
	band=val.linlin(0,1,0.0001,1);
		band.postln;
		if(~synth.isPlaying,{~synth.set(\gain,band)});
},25);
	);

		(
MIDIdef.cc(\midi2,{ |val, num, chan, src|
		var pass;
	//[val, num, chan, src].postln;
	pass=val.linlin(0,127,360.neg,360);
		pass.postln;
		if(~synth.isPlaying,{~synth.set(\low,pass)});
},24);
	);
	(
MIDIdef.cc(\midi3,{ |val, num, chan, src|
		var pass;
	//[val, num, chan, src].postln;
	pass=val.linlin(0,127,0,1);
		pass.postln;
		if(~synth.isPlaying,{~synth.set(\high,pass)});
},23);
	);
		(
MIDIdef.cc(\midi4,{ |val, num, chan, src|
		var mix;
	//[val, num, chan, src].postln;
	mix=val.linlin(0,127,0,1);
		mix.postln;
		if(~synth.isPlaying,{~synth.set(\tone,mix)});
},22);
	);
	(
MIDIdef.cc(\midi5,{ |val, num, chan, src|
		var mix;
	//[val, num, chan, src].postln;
	mix=val.linlin(0,127,0,1);
		mix.postln;
		if(~synth.isPlaying,{~synth.set(\mix,mix)});
},21);
	);
		(
MIDIdef.cc(\midi6,{ |val, num, chan, src|
		var mix;
	//[val, num, chan, src].postln;
	mix=val.linlin(0,127,0,1);
		mix.postln;
		if(~synth.isPlaying,{~synth.set(\room,mix)});
},20);
	);

)
)

}
)
)