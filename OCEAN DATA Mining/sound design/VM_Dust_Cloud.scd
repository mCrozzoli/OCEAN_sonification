// Dust myCloud

Server.default.options.inDevice_("Scarlett 6i6 USB");

s.boot
s.meter
s.plotTree


{RLPF.ar(Dust.ar([5, 10]), LFNoise1.ar([4, 5]).range(100, 3000), 0.2)}.play;

s.makeWindow;

//
(
SynthDef(\myCloud){|densityL = 4, densityR = 3 freqL= 5, freqR=10, rqrate= 10, mul = 1, lowfreq=45, lowres=12, lowdb=0.9|
	var sig, amp, rq;
	rq = LFNoise1.ar(rqrate).range(0.003, 0.09);
	amp = Rand(0, 0.9);
	sig = RLPF.ar(Blip.ar([densityL, densityR]), LFNoise1.ar([freqL, freqR]).range(150, 5000), rq, mul);
	sig = BLowShelf.ar(sig, lowfreq, lowres, lowdb);
	sig = sig * amp;
	Out.ar(0, sig);
}.add
)

x = Synth(\myCloud, [\rqrate, 12, \densityL, 0.3, \densityR, 1, \freqL, 80, \freqR, 900, \mul, 2]);
x.free


x.set(\mul, 2);
x.set(\freqL, 80, \freqR, 1200);
x.set(\densityL, 4, \densityR, 2)

x.set(\densityL, 12, \densityR, 9)

// create modulation on density

x.set(\rqrate, 12)
x.set(\densityL, 0.3, \densityR, 1)

x.set(\densityL, 1, \densityR, 0.8 )
x.set(\lowdb, 1, \lowres, 90, \lowfreq, 56)
x.set(\freqL, 90, \freqR, 30);
x.free

(
Ndef(\modfreq){|dens=10, mul=1 numharm=1000, amp=0.1|
    var in;
    in = Blip.ar(SinOsc.kr(dens, mul), numharm, amp);
	Pan2.ar(Formlet.ar(in, XLine.kr(1500,700,8), 0.002, 0.05, 1), 0);
}.play;
)

s.plotTree
s.meter


x.free

s.makeGui


