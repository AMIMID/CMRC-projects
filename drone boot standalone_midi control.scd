///perfect numbers  6, 28, 496, 8128
//28*2.pow((12*4)/12)
///am max freq 28*16*10*4
)
(
Server.default = s = Server.local;
////server setup
(
s.waitForBoot{
	(
(
SynthDef.new(\drone,{

	arg gain=1,low=7168,high=0,tone=0,mix=0,room=0;
	var freqa,freqb,funda,fundb,n=0,m,ph,linex,liney,freqc;
	var golden=0,silver=0,sig1,sig2,note=28,bank=4,sig,copper=0,out1,out2;


bank.do{

funda=note*2.pow(tone/12).round(0.00000001);
fundb=note*2.pow(tone/56).round(0.00000001);

	n=n+1;
	m=n*(1+2.sqrt);
	m.postln;

	ph=golden.degrad;

	linex=exp(Complex(0,1)*copper.degrad).real.wrap(0,1).round(0.00000001);
	liney=exp(Complex(0,1)*copper.degrad).imag.wrap(0,1.neg).round(0.00000001);

		copper=(copper+(360/bank)).wrap(0,360).round(0.00000001);
		golden=(golden+(360-(360/1.6180339887499))).wrap(0,360).round(0.00000001);
		//silver=(golden+(360-(360/(1+2.sqrt)))).wrap(0,360).round(0.00000001);
	freqa=funda*m;
	freqb=fundb*m;
	//freqc=(fundb*m)/2;

					sig1=(LPF.ar(Pulse.ar(freqa*4,width:0.5,mul:m.reciprocal).abs,low/4)*SinOsc.ar(freqa,ph,m.reciprocal));
					sig2=(LPF.ar(Pulse.ar(freqb*4,width:0.5,mul:m.reciprocal).abs,low/4)*SinOsc.ar(freqb,ph,m.reciprocal));
					//sig1=(LPF.ar(Pulse.ar(freqc*4,width:0.5,mul:m.reciprocal).abs,low/4)*SinOsc.ar(freqc,ph,m.reciprocal));
					//sig2=(LPF.ar(Pulse.ar(freqb*4,width:0.5,mul:m.reciprocal).abs,low/4)*SinOsc.ar(freqb+sig1,ph,m.reciprocal));

sig1=FreeVerb.ar(sig1,mix,room,high);
sig2=FreeVerb.ar(sig2,mix,room,high);

out1=LPF.ar(sig1,low);
out2=LPF.ar(sig2,low);
					//sig=sig1+sig2;

Out.ar(0,Pan2.ar(out1,linex,gain));Out.ar(0,Pan2.ar(out1,liney,gain));
Out.ar(0,Pan2.ar(out2,linex,gain));Out.ar(0,Pan2.ar(out2,liney,gain));
//Out.ar(0,Pan2.ar(sig,linex,gain));Out.ar(0,Pan2.ar(sig,liney,gain));
			}
}).add;);
	~synth=Synth.new(\drone,[\gain,1,\tone,48,\low,256,\high,0,\mix,0,\room,0]).register;//s.record

	(
MIDIClient.init;
MIDIIn.connectAll;
		(
MIDIdef.cc(\midi1,{ |val, num, chan, src|
		var l;
	//[val, num, chan, src].postln;
		l=val.linlin(0,127,4480,28).round(0.00000001);
		l.postln;
		if(~synth.isPlaying,{~synth.set(\low,l)});
},25);
	);
	(
MIDIdef.cc(\midi2,{ |val, num, chan, src|
		 var h;
	//[val, num, chan, src].postln;
	h=val.linlin(0,127,0,1).round(0.00000001);
		h.postln;
		if(~synth.isPlaying,{~synth.set(\high,h)});
},24);
	);
		(
MIDIdef.cc(\midi3,{ |val, num, chan, src|
		var g;
	//[val, num, chan, src].postln;
	g=val.linlin(0,127,0,1).round(0.00000001);
		g.postln;
		if(~synth.isPlaying,{~synth.set(\gain,g)});
},23);
	);

	(
MIDIdef.cc(\midi4,{ |val, num, chan, src|
		var m;
	//[val, num, chan, src].postln;
	m=val.linlin(0,127,0,1).round(0.00000001);
		m.postln;
		if(~synth.isPlaying,{~synth.set(\mix,m)});
},22);
	);
		(
MIDIdef.cc(\midi5,{ |val, num, chan, src|
		var r;
	//[val, num, chan, src].postln;
	r=val.linlin(0,127,0,1).round(0.00000001);
		r.postln;
		if(~synth.isPlaying,{~synth.set(\room,r)});
},21);
	);
					(
MIDIdef.cc(\midi6,{ |val, num, chan, src|
		var t;
	//[val, num, chan, src].postln;
		t=val.linlin(0,127,0,48).round(1).asInteger;
		t.postln;
		if(~synth.isPlaying,{~synth.set(\tone,t)});
},20);
	);

)
)

}
)
)