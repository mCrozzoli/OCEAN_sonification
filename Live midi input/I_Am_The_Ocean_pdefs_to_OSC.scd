
(
~synthenvsustain = 600;//length of sonification = total number of rows
//)

//(//open all pdefs
(
Pdef(\under, Pmono(
	\undercurrent,

	\freq1, Pfunc{~underC.freq1}, //.trace
	\freq2, Pfunc{~underC.freq2},

	\atk, 5, \sus, ~synthenvsustain, \rel, 10,
	\mix, Pfunc{~underC.mix}, \room, Pfunc{~underC.room},

	\rq, Pfunc{~underC.rq},
	\amp, Pfunc{~underC.amp},
    ));
);

(
Pdef(\midI, Pmono(
	\midcurrent1,

	\freq1, Pfunc{~midCI.freq1}, //inf
	\freq2, Pfunc{~midCI.freq2},

	\atk, 5, \sus, ~synthenvsustain, \rel, 10,
	//\room, Pfunc{~midCI.room}, \revtime, Pfunc{~midCI.revtime},
	\mix, Pfunc{~midCI.mix},

	\rq, Pfunc{~midCI.rq},
	\amp, Pfunc{~midCI.amp},
    ));
);

(
Pdef(\midII, Pmono(
	\midcurrent2,

	\freq1, Pfunc{~midCII.freq1},
	\freq2, Pfunc{~midCII.freq2},

	\atk, 5, \sus, ~synthenvsustain, \rel, 10,
	//\room, Pfunc{~midCII.room},
	//\revmintime, Pfunc{~midCII.revmintime}, \revmaxtime, Pfunc{~midCII.revmaxtime},
	\mix, Pfunc{~midCII.mix},


	\duration, Pfunc{~midCII.resmoddur},
	\amp, Pfunc{~midCII.amp},
    ));
);

(
Pdef(\drops, Pmono(
	\drops,

	\dens, Pfunc{~drops.dens},
	\freqmin, Pfunc{~drops.freqmin},
	\freqmax, Pfunc{~drops.freqmax},

	\atk, 5, \sus, ~synthenvsustain, \rel, 10,
	\del1time, Pfunc{~drops.deltime}, \del2decay, Pfunc{~drops.deldecay},
	\pos, Pfunc{~drops.pos},

	\amp, Pfunc{~drops.amp},
    ));
);
)


//play them!
(
Pdef(\under).release;
Pdef(\midI).play;
Pdef(\midII).play;
Pdef(\drops).play;
)