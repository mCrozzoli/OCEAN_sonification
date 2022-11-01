(//open data
~columns;
~dataset = CSVFileReader.read("C:/Users/migue/Documents/RMC achives/Soloist archive 2020/0. Sonifications/I Am The Ocean/oceanNormData.csv",true);
~dataset.removeAt(0);
~columns = ~dataset.flop.asFloat;

~ocean = (
	year: ~columns[1],
	oceanheat: ~columns[2],
	oceanlevel: ~columns[3],
	oceantemp: ~columns[4],
	co: ~columns[5],
    );

~ocean.year.asInt;
);

(//data relations
//heat and level
~underC = ();
~underC.freq1 =  ~ocean.oceanheat.linexp(~ocean.oceanheat.minItem, ~ocean.oceanheat.maxItem, 40, 85);
~underC.freq2 = ~ocean.oceanheat.linexp(~ocean.oceanheat.minItem, ~ocean.oceanheat.maxItem, 70, 115);

~underC.mix = ~ocean.oceanlevel.linlin(~ocean.oceanlevel.minItem, ~ocean.oceanlevel.maxItem, 0, 0.5);
~underC.room = ~ocean.oceanlevel.linlin(~ocean.oceanlevel.minItem, ~ocean.oceanlevel.maxItem, 0, 0.5);
~underC.rq = ~ocean.oceanlevel.linlin(~ocean.oceanlevel.minItem, ~ocean.oceanlevel.maxItem, 0.70, 1);
~underC.amp = ~ocean.oceanlevel.linlin(~ocean.oceanlevel.minItem, ~ocean.oceanlevel.maxItem, 1.5, 2.2);

//temp and level
~midCI = ();
~midCI.freq1 = ~ocean.oceantemp.linexp(~ocean.oceantemp.minItem, ~ocean.oceantemp.maxItem, 950, 1200.5);
~midCI.freq2 = ~ocean.oceantemp.linexp(~ocean.oceantemp.minItem, ~ocean.oceantemp.maxItem, 1200, 1501.5);

~midCI.room = ~ocean.oceanlevel.linlin(~ocean.oceanlevel.minItem, ~ocean.oceanlevel.maxItem, 250, 250); //!fragile
~midCI.revtime = ~ocean.oceanlevel.linlin(~ocean.oceanlevel.minItem, ~ocean.oceanlevel.maxItem, 50, 50);//!fragile
~midCI.mix = ~ocean.oceanlevel.linlin(~ocean.oceanlevel.minItem, ~ocean.oceanlevel.maxItem, 0.05, 0.1);

~midCI.rq = ~ocean.oceanlevel.linlin(~ocean.oceanlevel.minItem, ~ocean.oceanlevel.maxItem, 0.3, 0.6);
~midCI.amp = ~ocean.oceanlevel.linlin(~ocean.oceanlevel.minItem, ~ocean.oceanlevel.maxItem, 0.00001, 0.00009);

//temp and level
~midCII = ();
~midCII.freq1 = ~ocean.oceantemp.linexp(~ocean.oceantemp.minItem, ~ocean.oceantemp.maxItem, 750, 850);
~midCII.freq2 = ~ocean.oceantemp.linexp(~ocean.oceantemp.minItem, ~ocean.oceantemp.maxItem, 825, 925);

~midCII.resmoddur = ~ocean.oceanlevel.linlin(~ocean.oceanlevel.minItem, ~ocean.oceanlevel.maxItem, 12, 22);

~midCII.room = ~ocean.oceanlevel.linlin(~ocean.oceanlevel.minItem, ~ocean.oceanlevel.maxItem, 100, 100);//!fragile
~midCII.revmintime = ~ocean.oceanlevel.linlin(~ocean.oceanlevel.minItem, ~ocean.oceanlevel.maxItem, 0.5, 0.5);//!fragile
~midCII.revmaxtime = ~ocean.oceanlevel.linlin(~ocean.oceanlevel.minItem, ~ocean.oceanlevel.maxItem, 10, 10);//!fragile
~midCII.mix = ~ocean.oceanlevel.linlin(~ocean.oceanlevel.minItem, ~ocean.oceanlevel.maxItem, 0.7, 0.2);

~midCII.amp = ~ocean.oceanlevel.linlin(~ocean.oceanlevel.minItem, ~ocean.oceanlevel.maxItem, 0.00001, 0.00009);

//co and level
~drops = ();
~drops.dens = ~ocean.co.linexp(~ocean.co.minItem, ~ocean.co.maxItem, 0.2, 0.9);
~drops.freqmin = ~ocean.co.linexp(~ocean.co.minItem, ~ocean.co.maxItem, 400, 2400);
~drops.freqmax = ~ocean.co.linexp(~ocean.co.minItem, ~ocean.co.maxItem, 750, 3000);

~drops.pos = ~ocean.oceanlevel.linlin(~ocean.oceanlevel.minItem, ~ocean.oceanlevel.maxItem, [-1,1], [0,0]); //for center to sides
~drops.deltime = ~ocean.oceanlevel.linlin(~ocean.oceanlevel.minItem, ~ocean.oceanlevel.maxItem, 0.048, 0.098);
~drops.deldecay = ~ocean.oceanlevel.linlin(~ocean.oceanlevel.minItem, ~ocean.oceanlevel.maxItem, 15, 25);
~drops.amp = ~ocean.oceanlevel.linlin(~ocean.oceanlevel.minItem, ~ocean.oceanlevel.maxItem, 0.22, 0.9);
);

~underC.freq1;
