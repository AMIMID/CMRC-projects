////////////////////////////////////speaker setup///other
////////
)
(
Server.default = s = Server.local;
////server setup
s.options.numOutputBusChannels=4;
s.options.memSize = 8192*8

(
s.waitForBoot{
	Buffer.freeAll;
	(
	~a = VBAPSpeakerArray.new(3, [[45, 35.264390.neg], [135.neg, 35.264390.neg], [45.neg, 35.264390], [135, 35.264390]]);
	 ~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
)

(
SynthDef.new(\drone,{

	arg gain=1,low=7168,high=0,tone=0,mix=0,room=0;
	var freqa,freqb,funda,fundb,n=0,m,ph,linex,liney,interval=3/2,n1,n2,amp1,amp2;
	var goldenR=0,silverR=0,sig1,sig2,note=28,bank=7,sig,copperR=0,out1,out2,fm1,fm2;


bank.do{


n1=2.pow(tone/56).round(0.00000001);
//n2=2.pow((tone*(496/28))/992).round(0.00000001);
n2=2.pow((tone*(1/1))/992).round(0.00000001);
//n2=2.pow((tone*(28/6))/992).round(0.00000001);

funda=note*n1;
fundb=note*n2;

	n=n+1;
	m=n*(1+2.sqrt);
	m.postln;

	ph=goldenR.degrad;
	//ph=goldenR.degrad;
	//linex=exp(Complex(0,1)*copperR.degrad).real.round(0.00000001);
	//liney=exp(Complex(0,1)*copperR.degrad).imag.round(0.00000001);

			copperR=(copperR+(360/bank)).round(0.00000001);

		goldenR=(goldenR+(360-(360/1.6180339887499))).wrap(0,360).round(0.00000001);
				if(goldenR>180,{goldenR=180-goldenR},{goldenR=goldenR});

		silverR=(silverR+(360-(360/(1+2.sqrt)))).wrap(0,360).round(0.00000001);
				if(silverR>180,{silverR=180-silverR},{silverR=silverR});

	linex=exp(Complex(0,1)*silverR.degrad).real.round(0.00000001);
	liney=exp(Complex(0,1)*silverR.degrad).imag.round(0.00000001);

	ph=goldenR.degrad;

	freqa=funda*m;
	freqb=fundb*m;

	amp1=m.reciprocal*n1.reciprocal;
	amp2=m.reciprocal*n2.reciprocal;

	fm1=LFNoise1.ar(amp1.reciprocal,amp1);
	fm2=LFNoise1.ar(amp2.reciprocal,amp2);

				//sig1=(LPF.ar(Pulse.ar(freqa*3,width:0.5,mul:amp1).abs,low/4)*SinOsc.ar(freqa,ph,amp1));
					//sig2=(LPF.ar(Pulse.ar(freqb*3,width:0.5,mul:amp2).abs,low/4)*SinOsc.ar(freqb,ph,amp2));
					sig1=(LPF.ar(Pulse.ar((freqa*8)+fm1,width:0.5,mul:amp1).abs,low/4)*SinOsc.ar(freqa+fm1,ph,amp1));
					sig2=(LPF.ar(Pulse.ar((freqb*8)+fm2,width:0.5,mul:amp2).abs,low/4)*SinOsc.ar(freqb+fm2,ph,amp2));

sig1=FreeVerb.ar(sig1,mix,room,high);
sig2=FreeVerb.ar(sig2,mix,room,high);

					out1=VBAP.ar(4,LPF.ar(sig1,low,1);,~b.bufnum,silverR,silverR.wrap(90.neg,90));
					out2=VBAP.ar(4,LPF.ar(sig2,low,1);,~b.bufnum,silverR,silverR.wrap(90.neg,90));

					Out.ar(0,LeakDC.ar(out1),gain);Out.ar(0,LeakDC.ar(out2),gain);
			}
}).add;);

	~synth=Synth.new(\drone,[\gain,1,\tone,0,\low,16256,\high,0,\mix,0,\room,0]).register;//s.record

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
	h=val.linlin(0,127,1,0).round(0.00000001);
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
		t=val.linlin(0,127,0,112).round(1).asInteger;
		t.postln;
		if(~synth.isPlaying,{~synth.set(\tone,t)});
},20);
	);

)

}
)
)