(
({
~pell = { |n|
    var pell = [0, 1]; // start with P0 and P1
    n.do { |i|
        if (i > 1) {
            pell = pell.add(2 * pell[i - 1] + pell[i - 2]);
        };
    };
    pell.keep(n); // return the first n values
};

// Example: print the first 10 Pell numbers
~seq=1.collect{~pell.(6)}.postln;
}.value);

///fund F#/Gb 23.12Hz, 46.25Hz, 92.5Hz, 185Hz, 369.99Hz
({
	var n=0,m=(1+2.sqrt),m1,m2,m3,freq1,freq2,freq3,freq,ph,fund=23.12,linex,liney,golden=0,silver=0,sig1,sig2,sig3,sig;


(5).do{

	golden=(golden+(360-(360/1.6180339887499))).wrap(0,360); silver=(silver+(360-(360/(1+2.sqrt)))).wrap(0,360);

	n=n+1;

m=m+(1+2.sqrt);
		//m1=n*(1+2.sqrt);
		//m2=~seq.[0].[n];
		//m3=1+(n/(1+2.sqrt));

	ph=golden.degrad;

	linex=exp(Complex(0,1)*silver.degrad).real;   liney=exp(Complex(0,1)*silver.degrad).imag;

	freq=fund*m;
		//freq1=fund*m1;
		//freq2=fund*m2;
		//freq3=fund*m3;

{sig=SinOsc.ar(freq,ph,m.reciprocal);Out.ar(0,Pan2.ar(sig,linex,0.1));Out.ar(0,Pan2.ar(sig,liney,0.1))}.play;
	//{sig1=SinOsc.ar(freq1,ph,m1.reciprocal);Out.ar(0,Pan2.ar(sig1,linex,0.1));Out.ar(0,Pan2.ar(sig1,liney,0.1))}.play;
	//{sig2=SinOsc.ar(freq2,ph,m2.reciprocal);Out.ar(0,Pan2.ar(sig2,linex,0.1));Out.ar(0,Pan2.ar(sig2,liney,0.1))}.play;
	//{sig3=SinOsc.ar(freq3,ph,m3.reciprocal);Out.ar(0,Pan2.ar(sig3,linex,0.1));Out.ar(0,Pan2.ar(sig3,liney,0.1))}.play;

	m.postln;

	};
//s.record
}.value)
)

