//morfing: a constant movement of
//harmony, proximity-space (reverb and amplitude),
//find a relaition between amp and rev. //closer to 1: more amp, smaller room, less rev time,
//Drops. Use Panning and presence of drops (amp and pan).


//play them!
(
Pdef(\under).play;
Pdef(\midI).play;
Pdef(\midII).play;
Pdef(\drops).play;
)

(
~length = 7; //amount of seconds between each row.
~synthenvsustain = 300;//length of sonification = total number of rows
~rep = 1; //inf
//)

//(//open all pdefs
(
Pdef(\under, Pmono(
	\undercurrent, \dur, ~length,

	\freq1, Pseq(~underC.freq1, ~rep),
	\freq2, Pseq(~underC.freq2, ~rep),

	\atk, 5, \sus, ~synthenvsustain, \rel, 60,
	\mix, Pseq(~underC.mix, ~rep), \room, Pseq(~underC.room, ~rep),

	\rq, Pseq(~underC.rq, ~rep),
	\amp, Pseq(~underC.amp, ~rep),
    ));
);

(
Pdef(\midI, Pmono(
	\midcurrent1, \dur, ~length,

	\freq1, Pseq(~midCI.freq1, ~rep), //inf
	\freq2, Pseq(~midCI.freq2, ~rep),

	\atk, 5, \sus, ~synthenvsustain, \rel, 60,
	//\room, Pseq(~midCI.room, ~rep), \revtime, Pseq(~midCI.revtime, ~rep),
	\mix, Pseq(~midCI.mix, ~rep),

	\rq, Pseq(~midCI.rq, ),
	\amp, Pseq(~midCI.amp, inf),
    ));
);

(
Pdef(\midII, Pmono(
	\midcurrent2, \dur, ~length,

	\freq1, Pseq(~midCII.freq1, ~rep),
	\freq2, Pseq(~midCII.freq2, ~rep),

	\atk, 5, \sus, ~synthenvsustain, \rel, 60,
	//\room, Pseq(~midCII.room, ~rep),
	//\revmintime, Pseq(~midCII.revmintime, ~rep), \revmaxtime, Pseq(~midCII.revmaxtime, ~rep),
	\mix, Pseq(~midCII.mix, ~rep),

	\duration, Pseq(~midCII.resmoddur, ~rep),
	\amp, Pseq(~midCII.amp, ~rep),
    ));
);

(
Pdef(\drops, Pmono(
	\drops, \dur, ~length,
	\dens, Pseq(~drops.dens, ~rep),
	\freqmin, Pseq(~drops.freqmin, ~rep),
	\freqmax, Pseq(~drops.freqmax, ~rep),
	\atk, 5, \sus, ~synthenvsustain, \rel, 60,
	\del1time,  Pseq(~drops.deltime, ~rep), \del2decay, Pseq(~drops.deldecay, ~rep),
	\pos, Pseq(~drops.pos, ~rep).trace,
	\amp, Pseq(~drops.amp, ~rep),
    ));
);
)


