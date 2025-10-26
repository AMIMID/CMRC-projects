////notes
///perfect numbers  6, 28, 496, 8128
 /*(
 var copperR=0,bank=5;
 bank.do{ 	copperR=(copperR+(360-(360/1.6180339887499))).wrap(0,360).round(0.00000001);
	//exp(Complex(0,1)*copperR.degrad).real.wrap(0,1).round(0.00000001).postln;
		(Complex(0,1)*copperR.degrad).imag.round(0.00000001).postln;
 } )

(
 var copperR=0,bank=5,angle;
 bank.do{ 	copperR=(copperR+(360-(360/1.6180339887499))).wrap(0, 360).round(0.00000001);
	if(copperR>180,{copperR=180-copperR},{copperR=copperR});
	copperR=copperR.wrap(90.neg,90);
	copperR.postln;
 } )*/
//2.pow((992*4)/992)
//2.pow((56*4)/56)
//2.pow(6/12)=2.sqrt
//(56*4)*(496/28)
//am max freq
28*16*pi*1.5*3
///interval for sawtooth is either transcedebtal bumber like goldenR or silverR rario or pi,or a lamdoma table interval
(
Server.default = s = Server.local;
////server setup
(
s.waitForBoot{
	(
SynthDef.new(\drone,{

	arg gain=1,low=7168,high=0,tone=0,mix=0,room=0;
			var freqa,freqb,funda,fundb,n=0,m,ph,linex,liney,interval=2.pow(6/12);
	var goldenR=0,silverR=0,sig1,sig2,note=28,bank=5,sig,copperR=0,out1,out2,fm1,fm2;

bank.do{

funda=note*2.pow(tone/56).round(0.00000001);
	fundb=note*2.pow((tone*(496/28))/992).round(0.00000001);

	n=n+1;
	m=n*interval;
	m.postln;

	ph=goldenR.degrad;

		copperR=(copperR+(360/bank)).round(0.00000001);
		goldenR=(goldenR+(360-(360/1.6180339887499))).wrap(0,360).round(0.00000001);
				if(goldenR>180,{goldenR=180-goldenR},{goldenR=goldenR});
		silverR=(silverR+(360-(360/(1+2.sqrt)))).wrap(0,360).round(0.00000001);
				if(silverR>180,{silverR=180-silverR},{silverR=silverR});

	linex=exp(Complex(0,1)*silverR.degrad).real.round(0.00000001);
	liney=exp(Complex(0,1)*silverR.degrad).imag.round(0.00000001);

	freqa=funda*m;
	freqb=fundb*m;
	fm1=LFNoise1.ar(freqa.reciprocal,freqa);
	fm2=LFNoise1.ar(freqb.reciprocal,freqb);

					//sig1=(LPF.ar(Pulse.ar(freqa*3,width:0.5,mul:m.reciprocal).abs,low/4)*SinOsc.ar(freqa,ph,m.reciprocal));
					//sig2=(LPF.ar(Pulse.ar(freqb*3,width:0.5,mul:m.reciprocal).abs,low/4)*SinOsc.ar(freqb,ph,m.reciprocal));
					sig1=(LPF.ar(Pulse.ar((freqa*3)+fm1,width:0.5,mul:m.reciprocal).abs,low/4)*SinOsc.ar(freqa+fm1,ph,m.reciprocal));
					sig2=(LPF.ar(Pulse.ar((freqb*3)+fm2,width:0.5,mul:m.reciprocal).abs,low/4)*SinOsc.ar(freqb+fm2,ph,m.reciprocal));

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
	~synth=Synth.new(\drone,[\gain,1,\tone,0,\low,16256/16,\high,1,\mix,0.2,\room,0.2]).register;//s.record

	(
MIDIClient.init;
MIDIIn.connectAll;
		(
MIDIdef.cc(\midi1,{ |val, num, chan, src|
		var l;
	//[val, num, chan, src].postln;
		l=val.linlin(0,127,16256,56).round(0.00000001);
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
		t=val.linlin(0,127,0,224).round(1).asInteger;
		t.postln;
		if(~synth.isPlaying,{~synth.set(\tone,t)});
},20);
	);

)
)

}
)
