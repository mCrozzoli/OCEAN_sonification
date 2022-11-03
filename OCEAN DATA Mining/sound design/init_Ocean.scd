
//s.options.memSize_(2.pow(20));
//s.boot


(
(
SynthDef(\undercurrent, {
	arg freq1=60, freq2=90, atk=0.1, rel=1, sus=5, amp=2, rq=0.75;
	var in, sig, resmod, env;//gate, rev, res, pan;

	env = EnvGen.kr(Env([0, 1, 0], [atk, sus, rel]), doneAction:2);
	in = SinOscFB.ar([freq1, freq2], LinLin.ar(LFPar.ar(0.01), 0.5, 0.7), 0.1);
	resmod = LinCongL.ar(0.5, LFNoise2.kr(0.01), LFNoise2.kr(0.01), LFNoise2.kr(0.008), xi: 0, mul:60,add:90);
	sig = RLPF.ar(in, resmod, rq);
	sig = Pan2.ar(sig*env, amp);
	Out.ar(0,sig);
}).add
);


(
SynthDef(\midcurrent, {
	arg freq1, freq2, rq, amp, atk, sus, rel;
	var in, sig, phasemod, resmod, rev, env;

	env = EnvGen.kr(Env([0, 1, 0], [atk, sus, rel]), doneAction:2);
	phasemod = LinLin.kr(LFTri.kr(1), 0.5, 4, 0.001, 0.009);
	resmod = LinCongL.ar(300, SinOsc.kr(0.01), LFNoise2.kr(0.01), LFNoise2.kr(0.08), 0, mul:600, add: 900);
	in = SinOsc.ar([freq1, freq2], phasemod);

	sig = RHPF.ar(in, resmod, rq);
	sig = Pan2.ar(sig*env, 0, amp);
	sig = GVerb.ar(sig,
		roomsize: 250,
		revtime: 50,
		spread: 0.1,
		drylevel: 0,
		damping: 0.5,
		earlyreflevel: -50,
		taillevel: -70,
		maxroomsize: 300
	);

	Out.ar(0, sig)
}).add
);


(
SynthDef(\midcurrent2, {
	arg atk, sus, rel, dur=20, freq1=750, freq2=825, amp;
	var resmod, in, sig, panmov, env;

	env = EnvGen.kr(Env([0, 1, 0], [atk, sus, rel]), doneAction:2);
	resmod = SinOsc.kr(XLine.kr(0.07, 30, dur), 0, 35, 40);
	in = SinOscFB.ar([freq1, freq2], LFNoise2.kr(0.05, 3).exprange(0.05, 1.5));
	panmov =  LFNoise1.kr(0.5).exprange(-1,1);

	sig = HPF.ar(in, resmod);
	sig = Pan2.ar(sig, panmov, amp);
	sig = GVerb.ar(sig,
		roomsize: 100,
		maxroomsize: 170,
		revtime: FSinOsc.kr(0.05).exprange(0.5, 10),
		drylevel: FSinOsc.kr(0.05).exprange(0.7, 0),
		taillevel: -25,
		earlyreflevel: -10
	);

	Out.ar(0, sig);
}).add
);
)


//drops with vale
(
SynthDef(\drops){|freqL= 5, freqR=3, rqrate= 10, mul = 1, lowfreq=45, lowres=12, lowdb=0.9, freqmin=45, freqmax=200, densL=2, densR=7, numharm=100, mixverb=0.5, atk, sus, rel|
	var sig, amp, rq, harm, env;
	//env = EnvGen.kr(Env.perc(0.5, 1), doneAction:2);
	env = EnvGen.kr(Env([0, 1, 0], [atk, sus, rel]), doneAction:2);
	rq = LFNoise1.ar(rqrate).range(0.003, 0.09);
	amp = Rand(0, 0.9);
	harm = Blip.ar([LFNoise2.kr(densL), LFNoise2.kr(densR)], numharm);
	sig = RLPF.ar(harm, LFNoise1.ar([0.5, 2]).range(freqmin, freqmax), mul);
	sig = BAllPass.ar(sig, lowfreq, lowres, lowdb);
	//sig = sig * env * amp;
	//sig = JPverb.ar(sig, 15, 0.7, 0.9, 10, 0.15, 0.65, 0.75, 0.85, 250, 8000);
	Out.ar(0, sig);
}.play
);

//another drops
(
SynthDef(\drops2){
	arg freqmin=400, freqmax=3000, atk=0.005, rel=2, del2decay=15;
	var in, resmod, res, sig1, del1time, del1, sig2, del2time, del2, sig3, sig4, final, amp, env;

	//env = EnvGen.kr(Env.perc(atk, rel), gate:1, doneAction:2);

	in = Dust.ar([0.2, 0.2], 50); //to play with density
	resmod =  200 + 3000.0.rand; //this needs to change!!!
	res = Resonz.ar(in, resmod, 0.003);
	sig1 = Mix.ar(Array.fill(10, res));

	del1time = LFNoise2.kr(0.1.rand, 0.04, 0.05).range(0.048, 0.048);
	del1 = DelayN.ar(sig1, 0.0048); //0.048
	sig2 = del1;

	del2time = LFNoise2.kr(0.1.rand, 0.04, 0.05);
	del2 = CombL.ar(sig2, 0.1, del2time, 15);
	sig3 = Mix.ar(Array.fill(7, del2));

	4.do({
		sig3 = AllpassN.ar(sig3, 0.050, [0.050.rand, 0.050.rand], 1);
	});

	amp = LFNoise1(10).range(0.01, 0.1);

	final = (0.02*sig3) + (0.03*sig2) + (0.1*sig1);//Mix.ar([sig1, sig2, sig3, sig4]); //sig*env;
	final = final; // * env; // * amp;

	Out.ar(0, final);
}.add;
)


(
x = Synth(\midcurrent, [\freq1, 950, \freq2, 1200.5, \rq, 0.5, \amp, 0.00001, \rel, 5, \atk, 5, \sus, 60]);

y = Synth(\midcurrent2, [\amp, 0.000001, \rel, 5, \atk, 5, \sus, 60]);

w = Synth(\undercurrent, [\freq1, 400, \freq2, 600, \rq, 0.75, \amp, 1.6, \rel, 5, \atk, 5, \sus, 60]);

z = Synth(\drops, [\numharm, 200,
	\freqmin, 450, \freqmax, 800,
	\densL, 15, \densR, 8,
	\rqrate, 50, \mul, 1,
	\lowfreq, 200, \lowres, 0.5, \lowdb, 0.2,
	\amp, 0.0001, \mixverb, 0.85, \atk, 5, \sus, 60, \rel, 5])
)







//when perc env
(
z = Pbind(\instrument, \drops,
	\dur, 4,
	\atk, 1,
	\numharm, 1500,
	\freqmin, 450, \freqmax, 8000,
	\densL, 5, \densR, 6,
	\rqrate, 12, \mul, 2.5,
	\lowfreq, 2000, \lowres, 12, \lowdb, 0.5,
	\amp, 0.2, \mixverb, 0.85).play
)



(
SynthDef(\birds){|freqL= 5, freqR=3, rqrate= 10, mul = 1, lowfreq=45, lowres=12, lowdb=0.9, freqmin=45, freqmax=200, densL=2, densR=7, numharm=100, mixverb=0.5, atk, sus, rel|
	var sig, amp, rq, harm, env;
	//env = EnvGen.kr(Env.perc(0.5, 1), doneAction:2);
	env = EnvGen.kr(Env([0, 1, 0], [atk, sus, rel]), doneAction:2);
	rq = LFNoise1.ar(rqrate).range(0.003, 0.09);
	amp = Rand(0, 0.9);
	harm = Pulse.ar([LFNoise2.kr(densL).range(500, 3000), LFNoise2.kr(densR).range(800, 7000)], 0.35);
	sig = RLPF.ar(harm, LFNoise1.ar([0.5, 2]).range(freqmin, freqmax), rq, mul);
	sig = BAllPass.ar(sig, lowfreq, lowres, lowdb);
	sig = sig * env * amp;
	sig = JPverb.ar(sig, 15, 0.7, 0.8, 50, 0.15, 0.5, 1, 1, 1, 250, 12000);
	Out.ar(0, sig);
}.add
);

env = EnvGen.kr(Env.perc(atk, rel), gate:1, doneAction:2);

s.meter
s.plotTree

Server.killAll