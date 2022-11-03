(
SynthDef(\undercurrent, {
	arg freq1=40, freq2=80, atk=1, rel=1, sus=5 ;
	var sig, res1, res2, amp, env; //gate, rev, res, pan;

	Out.ar(0,sig);
}).play; //.add
);


// 1******************************************************* //
(
(
{Pan2.ar(
	RLPF.ar(
		SinOscFB.ar([40, 75], LinLin.ar(LFPar.ar(0.01), 0.5, 0.7), 0.01),
		LinCongL.ar(0.5, LFNoise2.kr(0.01), LFNoise2.kr(0.01), LFNoise2.kr(0.008), xi: 0, mul:70,add:90),
		rq: 0.75),
	level: 0.05//pos: level:
)}.play; //0.5
);

// 2******************************************************* //

(
{GVerb.ar(
	Pan2.ar(
		RHPF.ar(
			SinOsc.ar([950,1200.5], LinLin.kr(LFTri.kr(1), 1, 1, 0.001, 0.009)),
			LinCongL.ar(300, SinOsc.kr(0.01), LFNoise2.kr(0.01), LFNoise2.kr(0.08), 0, mul:600,add: 900))
	), //pos: level:

	roomsize: 250,
	revtime: 50,
	spread: 0.1,
	drylevel: 0,
	damping:0.5,
	earlyreflevel: -50,
	taillevel: -70,
	maxroomsize:300

)*0.000005}.play;
);

// 3******************************************************* //

(
{GVerb.ar(
	Pan2.ar(
		HPF.ar(
			SinOscFB.ar([750,825], LFNoise2.kr(0.05, 3).exprange(0.05, 1.5)), //in
			SinOsc.kr(XLine.kr(0.07, 30, 20), 0, 35, 40)),//freq
	    LFNoise1.kr(0.5).exprange(-1,1), 0.005), //Pos +  ...Pan2

    roomsize: 100,
    maxroomsize: 170,
	revtime: FSinOsc.kr(0.05).exprange(0.5, 10),
	drylevel: FSinOsc.kr(0.05).exprange(0.7, 0),
	taillevel: -25,
	earlyreflevel: -10
)*0.005}.play;
);

// 4******************************************************* //
)
