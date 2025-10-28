////notes
///perfect numbers  6, 28, 496, 8128
 /*(
 var copperR=0,bank=5;
 bank.do{ 	copperR=(copperR+(360-(360/1.6180339887499))).wrap(0,360).round(0.0001);
	//exp(Complex(0,1)*copperR.degrad).real.wrap(0,1).round(0.0001).postln;
		(Complex(0,1)*copperR.degrad).imag.round(0.0001).postln;
 } )

(
 var copperR=0,bank=5,angle;
 bank.do{ 	copperR=(copperR+(360-(360/1.6180339887499))).wrap(0, 360).round(0.0001);
	if(copperR>180,{copperR=180-copperR},{copperR=copperR});
	copperR=copperR.wrap(90.neg,90);
	copperR.postln;
 } )*/
//2.pow((992*4)/992)
//2.pow((56*4)/56)
//2.pow(6/12)=2.sqrt
//(56*4)*(496/28)
//am max freq
//2.pow((56*(28/6))/992).round(0.0001);
///interval for sawtooth is either tran
//scedebtal bumber like goldenR or silverR rario or pi,or a lamdoma table interval

(
Server.default = s = Server.local;
////server setup
s.options.memSize = 8192*8;
s.options.numInputBusChannels=0;
MIDIClient.init;
MIDIIn.connectAll;
(
s.waitForBoot{
	Tdef(\cmrc, {
	(
SynthDef.new(\drone,{

	arg gain=1,low=7168,high=0,tone=0,mix=0,room=0;
	var freqa,freqb,funda,fundb,n=0,m,ph,linex,liney,interval=2.pow(6/12),n1,n2,amp1,amp2;
	var goldenR=45,silverR=45,sig1,sig2,note=28*2.pow(6/12),bank=9,sig,copperR=0,out1,out2,fm1,fm2;


bank.do{

n1=2.pow(tone/56).round(0.0001);
//n2=2.pow((tone*(1/1))/992).round(0.0001);
n2=2.pow((tone*10)/992).round(0.0001);

funda=note*n1;
fundb=note*n2;

	n=n+1;
	m=n*interval;

							ph=goldenR.degrad;
linex=exp(Complex(0,1)*silverR.degrad).real.round(0.0001).abs;
liney=exp(Complex(0,1)*silverR.degrad).imag.round(0.0001).abs.neg;

	copperR=(copperR+(360/bank)).round(0.0001);
		goldenR=(goldenR+(360-(360/((1+5.sqrt)/2)))).wrap(180.neg,180).round(0.0001);
		silverR=(silverR+(360-(360/(1+2.sqrt)))).wrap(180.neg,180).round(0.0001);

	freqa=funda*m;
	freqb=fundb*m;

	amp1=m.reciprocal*n1.reciprocal;
	amp2=m.reciprocal*n2.reciprocal;

	fm1=LFNoise1.ar(amp1.reciprocal,amp1);
	fm2=LFNoise1.ar(amp2.reciprocal,amp2);

					//sig1=(LPF.ar(Pulse.ar(freqa*3,width:0.5,mul:amp1).abs,low/4)*SinOsc.ar(freqa,ph,amp1));
					//sig2=(LPF.ar(Pulse.ar(freqb*3,width:0.5,mul:amp2).abs,low/4)*SinOsc.ar(freqb,ph,amp2));
					sig1=(LPF.ar(Pulse.ar((freqa*3)+fm1,width:0.5,mul:amp1).abs,low/8)*SinOsc.ar(freqa+fm1,ph,amp1));
					sig2=(LPF.ar(Pulse.ar((freqb*3)+fm2,width:0.5,mul:amp2).abs,low/8)*SinOsc.ar(freqb+fm2,ph,amp2));

sig1=LPF.ar(sig1,low);
sig2=LPF.ar(sig2,low);
sig1=HPF.ar(sig1,high);
sig2=HPF.ar(sig2,high);

out1=FreeVerb.ar(sig1,mix,room,mul:mix*2);
out2=FreeVerb.ar(sig2,mix,room,mul:mix*2);

					//sig=sig1+sig2;

//	Out.ar(0,Pan2.ar(out1,linex,gain));Out.ar(0,Pan2.ar(out2,liney,gain));
Out.ar(0,Pan2.ar(out1,linex,gain));Out.ar(0,Pan2.ar(out1,liney,gain));
Out.ar(0,Pan2.ar(out2,linex,gain));Out.ar(0,Pan2.ar(out2,liney,gain));
//Out.ar(0,Pan2.ar(sig,linex,gain));Out.ar(0,Pan2.ar(sig,liney,gain));
			}
}).add;);
			1.wait;
	~synth=Synth.new(\drone,[\gain,0.25,\tone,0,\low,16256,\high,56,\mix,0,\room,0]).register;//s.record
	//1.wait;

	(
		(
MIDIdef.cc(\midi1,{ |val, num, chan, src|
		var l;
	//[val, num, chan, src].postln;
		l=val.linlin(0,127,16256,56).round(0.0001);
		l.postln;
		if(~synth.isPlaying,{~synth.set(\low,l)});
},25);
	);
	(
MIDIdef.cc(\midi2,{ |val, num, chan, src|
		 var h;
	//[val, num, chan, src].postln;
	h=val.linlin(0,127,56,992).round(0.0001);
		h.postln;
		if(~synth.isPlaying,{~synth.set(\high,h)});
},24);
	);
		(
MIDIdef.cc(\midi3,{ |val, num, chan, src|
		var g;
	//[val, num, chan, src].postln;
	g=val.linlin(0,127,0,1).round(0.0001);
		g.postln;
		if(~synth.isPlaying,{~synth.set(\gain,g)});
},23);
	);

	(
MIDIdef.cc(\midi4,{ |val, num, chan, src|
		var m;
	//[val, num, chan, src].postln;
	m=val.linlin(0,127,0.1,1).round(0.1);
		m.postln;
		if(~synth.isPlaying,{~synth.set(\mix,m)});
},22);
	);
		(
MIDIdef.cc(\midi5,{ |val, num, chan, src|
		var r;
	//[val, num, chan, src].postln;
	r=val.linlin(0,127,0,1).round(0.0001);
		r.postln;
		if(~synth.isPlaying,{~synth.set(\room,r)});
},21);
	);
					(
MIDIdef.cc(\midi6,{ |val, num, chan, src|
		var t;
	//[val, num, chan, src].postln;
		t=val.linlin(0,127,0,56).round(1).asInteger;
		t.postln;
		if(~synth.isPlaying,{~synth.set(\tone,t)});
},20);
	);

)
});
	Tdef(\cmrc).play;
}
))
