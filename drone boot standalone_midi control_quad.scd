////////////////////////////////////speaker setup///other
////////
)
(
Server.default = s = Server.local;
////server setup
s.options.numOutputBusChannels=4;

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
	var freqa,freqb,funda,fundb,n=0,m,ph,linex,liney,interval=1.6180339887499;
	var golden=0,silver=0,sig1,sig2,note=28,bank=4,sig,copper=0,out1,out2,fm1,fm2;


bank.do{

funda=note*2.pow(tone/12).round(0.00000001);
fundb=note*2.pow((tone*(496/28))/992).round(0.00000001);

	n=n+1;
	m=n*(1+2.sqrt);
	m.postln;

	ph=golden.degrad;

	linex=exp(Complex(0,1)*copper.degrad).real.wrap(0,1).round(0.00000001);
	liney=exp(Complex(0,1)*copper.degrad).imag.wrap(0,1.neg).round(0.00000001);

		copper=(copper+(360/bank)).wrap(0,360).round(0.00000001);
		golden=(golden+(360-(360/1.6180339887499))).wrap(0,360).round(0.00000001);
		silver=(golden+(360-(360/(1+2.sqrt)))).wrap(0,360).round(0.00000001);
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

					out1=VBAP.ar(4,LPF.ar(sig1,low),~b.bufnum,silver.linlin(0,360,180.neg,180),silver.linlin(0,360,90.neg,90));
					out2=VBAP.ar(4,LPF.ar(sig2,low),~b.bufnum,silver.linlin(0,360,180.neg,180),silver.linlin(0,360,90.neg,90));


					Out.ar(0,LeakDC.ar(out1),gain);Out.ar(0,LeakDC.ar(out2),gain);

			}
}).add;);

	~synth=Synth.new(\drone,[\gain,1,\tone,56,\low,5629/32,\high,0,\mix,0,\room,0]).register;//s.record

	(
MIDIClient.init;
MIDIIn.connectAll;
		(
MIDIdef.cc(\midi1,{ |val, num, chan, src|
		var l;
	//[val, num, chan, src].postln;
		l=val.linlin(0,127,5629,28).round(0.00000001);
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

}
)
)