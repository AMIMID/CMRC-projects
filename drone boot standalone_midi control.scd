///perfect numbers  6, 28, 496, 8128


(
Server.default = s = Server.local;
////server setup
(
s.waitForBoot{

	(

(
SynthDef.new(\drone,{

	arg gain=1,low=992,high=16256,note,tone=28,mix=0,room=0;
	var freqa,freqb,funda,fundb,n=0,m,ph,linex,liney,golden=0,silver=0,sig1,sig2;


(24).do{

	note=28*2.pow(tone/56)

funda=note*2.pow(6/12);
fundb=note*2.pow(6.neg/12);

	n=n+1;
	m=n*(1+2.sqrt);
	m.postln;

	ph=golden.degrad;

	linex=exp(Complex(0,1)*silver.degrad).real.wrap(0,1);
	liney=exp(Complex(0,1)*silver.degrad).imag.wrap(0,1.neg);

		silver=(silver+(360/5)).wrap(0,360);
		golden=(golden+(360-(360/1.6180339887499))).wrap(0,360);
	freqa=funda*m;
	freqb=fundb*m;

sig1=SinOsc.ar(freqa,ph,m.reciprocal);
sig2=SinOsc.ar(freqb,ph,m.reciprocal);

sig1=FreeVerb.ar(sig1,mix,room,high,gain);
sig2=FreeVerb.ar(sig2,mix,room,high,gain);

sig1=LPF.ar(sig1,low);
sig2=LPF.ar(sig2,low);

Out.ar(0,Pan2.ar(sig1,linex,0.1));Out.ar(0,Pan2.ar(sig1,linex,0.1));
Out.ar(0,Pan2.ar(sig2,linex,0.1));Out.ar(0,Pan2.ar(sig2,liney,0.1));

			}
}).add;);

	~synth=Synth.new(\drone,[\gain,1,\tone,28,\low,496,\high,16256,\mix,0,\room,0]).register;s.record

	(
MIDIClient.init;
MIDIIn.connectAll;
		(
MIDIdef.cc(\midi1,{ |val, num, chan, src|
		var l;
	//[val, num, chan, src].postln;
	l=val.linlin(0,127,28,16256);
		l.postln;
		if(~synth.isPlaying,{~synth.set(\low,l)});
},24);
	);
	(
MIDIdef.cc(\midi2,{ |val, num, chan, src|
		 var h;
	//[val, num, chan, src].postln;
	h=val.linlin(0,127,16256,28);
		h.postln;
		if(~synth.isPlaying,{~synth.set(\high,h)});
},23);
	);
		(
MIDIdef.cc(\midi3,{ |val, num, chan, src|
		var g;
	//[val, num, chan, src].postln;
	g=val.linlin(0,127,0.00001,1);
		g.postln;
		if(~synth.isPlaying,{~synth.set(\gain,g)});
},25);
	);

	(
MIDIdef.cc(\midi4,{ |val, num, chan, src|
		var m;
	//[val, num, chan, src].postln;
	m=val.linlin(0,127,0,1);
		m.postln;
		if(~synth.isPlaying,{~synth.set(\mix,m)});
},21);
	);
		(
MIDIdef.cc(\midi5,{ |val, num, chan, src|
		var r;
	//[val, num, chan, src].postln;
	r=val.linlin(0,127,0,1);
		r.postln;
		if(~synth.isPlaying,{~synth.set(\room,r)});
},20);
	);
					(
MIDIdef.cc(\midi6,{ |val, num, chan, src|
		var t;
	//[val, num, chan, src].postln;
		t=val.linlin(0,127,0,7168).round(1);
		t.postln;
		if(~synth.isPlaying,{~synth.set(\tone,t)});
},22);
	);

)
)

}
)
)