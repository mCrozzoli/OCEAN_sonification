(
var duration = 60 * 5;
var freqDrift = { |freq| LFDNoise3.ar(0.2, 0.1, freq.cpsmidi).midicps };
var masterVolume = -2.dbamp;

play {
	var rootFreq = freqDrift.(26.midicps);
	var gate = EnvGen.ar(Env([0, 1, 1, 0], [0.1, duration, 0.25]), gate: 1, doneAction: 0);
	var leveler = LinLin.ar(LFTri.ar(duration.reciprocal, 1), -1, 1, -24, 0).dbamp;
	var sig = HPF.ar(
		({ |k|
			Pan2.ar(({ |i|
				Pulse.ar(
					i * k + 2 / (k + 1) * rootFreq * (i + 1) * 0.0625 * 16,
					LinLin.ar(LFTri.ar(rootFreq * (i + 1) / 1024), -1, 1, 0.5, 0.95)
				)} ! (k/2 + 1).asInteger).product
				* (k + 1).reciprocal
				* LinExp.ar(Blip.ar(
					(k + 5).nthPrime.reciprocal * rootFreq * 0.125, 3), -1, 1, -48.dbamp, 1).neg,
				LFTri.ar((k + 1).nthPrime * rootFreq / 256)
			)
		} ! 16).sum * -12.dbamp,
		40
	);
	var compsig = Compander.ar(
		sig, sig, -48.dbamp, 1, XLine.ar(1, 0.125, duration), mul: Line.ar(0, 36, duration).dbamp
	);
	var final = LeakDC.ar(SinOsc.ar(
		rootFreq * 2,
		GVerb.ar(
			compsig.sum,
			revtime: 2.5,
			drylevel: 0,
			earlyreflevel: 0,
			taillevel: -12.dbamp,
			mul: LinExp.ar(LFTri.ar(duration.reciprocal, 1), -1, 1, pi, pi * 0.25),
			add: compsig
		),
		mul: 0.5 * gate,
	), mul:  leveler);
	var verb = GVerb.ar(final.sum, 300, 4.5, drylevel: 0, earlyreflevel: -6.dbamp, taillevel: -12.dbamp, add: final);
	var env = DetectSilence.ar(gate + verb, doneAction: 2);
	verb * masterVolume
};

play {
	var rootFreq = freqDrift.(Lag.ar(26.midicps * 4 * LinLin.ar(LFTri.ar(duration.reciprocal * 5), -1, 1, 3, 13).floor / LinLin.ar(LFTri.ar(duration.reciprocal * 3), -1, 1, 13, 3).floor, 0.25));
	var gate = EnvGen.ar(Env([0, 1, 1, 0], [0.1, duration * 0.9, 0.25]), gate: 1, doneAction: 0);
	var leveler = LinLin.ar(LFTri.ar(duration.reciprocal * 15, 2), -1, 1, -72, 6).dbamp;
	var sig = HPF.ar(
		({ |k|
			Pan2.ar(({ |i|
				Pulse.ar(
					i * k + 2 / (k + 1) * rootFreq * (i + 1) * 0.0625 * 16,
					LinLin.ar(LFTri.ar(rootFreq * (i + 1) / 1024), -1, 1, 0.5, 0.95)
				)} ! (k/2 + 1).asInteger).product
				* LinExp.ar(Blip.ar(
					(k + 5).nthPrime.reciprocal * rootFreq * 0.125, 3), -1, 1, -48.dbamp, 1).neg,
				LFTri.ar((k + 1).nthPrime * rootFreq / 256)
			)
		} ! 16).sum * -12.dbamp,
		40
	);
	var compsig = Compander.ar(
		sig, sig, -48.dbamp, 1, XLine.ar(1, 0.125, duration), mul: Line.ar(0, 36, duration).dbamp
	);
	var final = LeakDC.ar(SinOsc.ar(
		rootFreq * 4,
		GVerb.ar(
			compsig.sum,
			revtime: 2.5,
			drylevel: 0,
			earlyreflevel: 0,
			taillevel: -12.dbamp,
			mul: Line.ar(pi * 2, pi, duration),
			add: compsig
		),
		mul: 0.5 * gate,
	), mul: leveler * AmpCompA.kr(root: rootFreq * 4));
	var verb = GVerb.ar(final.sum, 300, 4.5, drylevel: 0, earlyreflevel: 0.dbamp, taillevel: -24.dbamp, add: final);
	var env = DetectSilence.ar(gate + verb, doneAction: 2);
	verb * -18.dbamp * masterVolume
};


(
var duration = 60 * 5;
var freqDrift = { |freq| LFDNoise3.ar(0.2, 0.1, freq.cpsmidi).midicps };
var masterVolume = -2.dbamp;

play {
	var rootFreq = 26.midicps;
	var depthMod = LFSaw.kr(0.05).exprange(0.05, 5.0);
	var gate = EnvGen.ar(Env([0, 1, 1, 0], [0.1, duration * 0.9, 0.25]), gate: 1, doneAction: 0);
	var leveler = LinLin.ar(LFTri.ar(duration.reciprocal, 3), -1, 1, -24, 6).dbamp;
	var sig = HPF.ar(
		({ |k|
			Pan2.ar(({ |i|
				SinOsc.ar(i * k + 2 / (k + 1) * rootFreq * (i + 1))} ! 4).product
				* (k+1).reciprocal
				* LFSaw.kr(
					(k + 5).nthPrime.reciprocal * rootFreq * 0.25, k/7 * 2
				).exprange(-24.dbamp, 1),
				LFTri.ar((k + 1).nthPrime * rootFreq)
			)
		} ! 16).sum * -18.dbamp,
		40
	);
	var siggap = Amplitude.ar(sig).reciprocal.min(0.0625);
	var verb = GVerb.ar(
		sig.sum,
		roomsize: [80, 135, 283],
		revtime: depthMod * 2,
		drylevel: 0,
		taillevel: 0.dbamp * siggap,
		earlyreflevel: -6.dbamp * siggap,
		add: sig
	).sum * leveler * gate;
	var env = DetectSilence.ar(verb, doneAction: 2);
	verb * masterVolume
};
)