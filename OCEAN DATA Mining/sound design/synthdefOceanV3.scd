( //open all synths!

(
SynthDef(\undercurrent, {
	arg freq1=60, freq2=90, atk=0.1, rel=1, sus=60, amp=2, rq=0.75;
	var in, sig, resmod, env;//gate, rev, res, pan;

	env = EnvGen.kr(Env([0, 1, 0], [atk, sus, rel]), doneAction:2);

	resmod = LinCongL.ar(0.5, LFNoise2.kr(0.01), LFNoise2.kr(0.01), LFNoise2.kr(0.008), xi: 0, mul:60,add:90);
	in = SinOscFB.ar([freq1, freq2], LinLin.ar(LFPar.ar(0.01), 0.5, 0.7), 0.1);

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
	panmov =  LFNoise1.kr(0.5).exprange(-1,1);
	in = SinOscFB.ar([freq1, freq2], LFNoise2.kr(0.05, 3).exprange(0.05, 1.5));


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

(
SynthDef(\drops){
	arg dens=0.2, freqmin=400, freqmax=3000, atk=0.05, rel=1, del1time=0.048, del2decay=15, amp=0.5;
	var env, resmod, sig1, sig2, sig3, final;

	env = EnvGen.kr(Env.perc(atk, rel), doneAction:2);

	resmod = LFNoise1.kr(0.005).range(freqmin, freqmax); //use an array of freqs? Imput from data

	sig1 = Mix.ar(Array.fill(7, { Resonz.ar(Dust.ar(dens, 50), resmod, 0.003)}) );
	sig2 = DelayN.ar(sig1, del1time);
	sig3 = Mix.ar(Array.fill(3,{ CombL.ar(sig2, 0.1, LFNoise1.kr(0.1.rand, 0.04, 0.05), del2decay) }));

	4.do({ sig3 = AllpassN.ar(sig3, 0.050, [0.050.rand, 0.050.rand], 1) });

	/* //TRY TO INCREMENT SERVERS MEMORY!!! but this is the sound :)
	sig1 = GVerb.ar(sig1,
		roomsize: 10,
		maxroomsize: 17,
		revtime: FSinOsc.kr(0.05).exprange(0.5, 3),
		drylevel: FSinOsc.kr(0.05).exprange(0.5, 0.7),
		taillevel: -0.5,
		earlyreflevel: -0.5
	);
	*/

	final = (sig1) + (0.2*sig3);
	final = final *amp *env;

	Out.ar(0, final)
}.add;
)

) //all synths




//just to try them > work with pdef file!!!

(
x = Synth(\midcurrent, [\freq1, 950, \freq2, 1200.5, \rq, 0.5, \amp, 0.00001, \rel, 5, \atk, 5, \sus, 180]);

y = Synth(\midcurrent2, [\amp, 0.000001, \rel, 5, \atk, 5, \sus, 180]);

w = Synth(\undercurrent, [\freq1, 400, \freq2, 600, \rq, 0.75, \amp, 1.6, \rel, 5, \atk, 5, \sus, 180]);

)

(
z = Pbind(\instrument, \drops,
	\atk, 0.05, \rel, 3,
	\freqmin, 200, \freqmax, 3000,
	\dens, 0.2,
	\del1time, 0.048, \del2decay, 15,
	\amp, 0.5 //0.19 works great!
	).play;
)