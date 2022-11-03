//CODE AMP!!!!!!!!!!!!

//OSCFunc.trace(false); //check python port while listening

(//data opening values
//heat and level
~underC = ();
~underC.freq1 = 40; // ~predheat.linexp(-0.03, 1.03, 40, 85, clip: 'minmax');
~underC.freq2 = 70; //~predheat.linexp(-0.03, 1.03, 70, 115, clip: 'minmax');
~underC.mix = 0;
~underC.room = 0;
~underC.rq = 0.7; //~predlevel.linlin(-0.03, 1.03, 0.70, 1, clip: 'minmax');
~underC.amp = 0.5;// ~predlevel.linlin(-0.03, 1.03, 1.5, 2, clip: 'minmax');
//temp and level
~midCI = ();
~midCI.freq1 = 9264850; //~predtemp.linexp(-0.03, 1.03, 950, 1200.5, clip: 'minmax');
~midCI.freq2 = 1200; //~predtemp.linexp(-0.03, 1.03, 1200, 1501.5, clip: 'minmax');
~midCI.room = 250;
~midCI.revtime = 50;//!
~midCI.mix = 0.05;
~midCI.rq = 0.3; //~predlevel.linlin(-0.03, 1.03, 0.3, 0.6, clip: 'minmax');
~midCI.amp = 0.00001; //~predlevel.linlin(-0.03, 1.03, 0.00001, 0.00009, clip: 'minmax');
//temp and level
~midCII = ();
~midCII.freq1 = 750; //~predtemp.linexp(-0.03, 1.03, 750, 850, clip: 'minmax');
~midCII.freq2 = 825; //~predtemp.linexp(-0.03, 1.03, 825, 925, clip: 'minmax');
~midCII.resmoddur = 12; //~predlevel.linlin(-0.03, 1.03, 12, 22, clip: 'minmax');
~midCII.room = 100;//!
~midCII.revmintime = 0.5;//!
~midCII.revmaxtime = 10;//!
~midCII.mix = 0.7;
~midCII.amp = 0.00001; //~predlevel.linlin(-0.03, 1.03, 0.00001, 0.00009, clip: 'minmax');
//co and level
~drops = ();
~drops.dens = 0.2; //~predco.linexp(-0.03, 1.03, 0.2, 0.9, clip: 'minmax');
~drops.freqmin = 400; //~predco.linexp(-0.03, 1.03, 400, 2400, clip: 'minmax');
~drops.freqmax = 750; //~predco.linexp(-0.03, 1.03, 750, 3000, clip: 'minmax');
~drops.pos = [-1,1];
~drops.deltime = 0.048; //~predlevel.linlin(-0.03, 1.03, 0.046, 0.098, clip: 'minmax');
~drops.deldecay = 15; //~predlevel.linlin(-0.03, 1.03, 15, 25, clip: 'minmax');
~drops.amp = 0.19; //~predlevel.linlin(-0.03, 1.03, 0.19, 0.5, clip: 'minmax');
);

//~drops


(//OSC communication and data relation
~comOSCpython = {
	|msg|
	var id, predvalue;
	if(msg[0] != '/status.reply')
	    {
		id = msg[0];
		predvalue = msg[1];
		//postln(predvalue);

		if(id == 'Fade underc: ')
		{
			~fade = predvalue;
			~underC.amp = ~fade.linlin(0, 1, 0, 2);
			//postln(~fade);
		};
		if(id == 'Fade midI: ')
		{
			~fade = predvalue;
			~midCI.amp = ~fade.linlin(0, 1, 0, 0.00009);
			//postln(~fade);
		};
		if(id == 'Fade midII: ')
		{
			~fade = predvalue;
			~midCII.amp = ~fade.linlin(0, 1, 0, 0.00009);
			//postln(~fade);
		};
		if(id == 'Fade drops: ')
		{
			~fade = predvalue;
			~drops.amp = ~fade.linlin(0, 1, 0, 0.5);
			//postln(~fade);
		};


		if(id == 'Ocean Level: ')
		{
			~predlevel = predvalue;

			~underC.mix = ~predlevel.linlin(-0.03, 1.03, 0, 0.5);
			~underC.room = ~predlevel.linlin(-0.03, 1.03, 0, 0.5);
			~underC.rq = ~predlevel.linlin(-0.03, 1.03, 0.70, 1, clip: 'minmax');
			//~underC.amp = ~predlevel.linlin(-0.03, 1.03, 1.5, 2, clip: 'minmax');

			~midCI.room = ~predlevel.linlin(-0.03, 1.03, 250, 250); //!
			~midCI.revtime = ~predlevel.linlin(-0.03, 1.03, 50, 50);//!
			~midCI.mix = ~predlevel.linlin(-0.03, 1.03, 0.05, 0.1);
			~midCI.rq = ~predlevel.linlin(-0.03, 1.03, 0.3, 0.6, clip: 'minmax');
			//~midCI.amp = ~predlevel.linlin(-0.03, 1.03, 0.00001, 0.00009, clip: 'minmax');

			~midCII.resmoddur = ~predlevel.linlin(-0.03, 1.03, 12, 22, clip: 'minmax');
			~midCII.room = ~predlevel.linlin(-0.03, 1.03, 100, 100);//!
			~midCII.revmintime = ~predlevel.linlin(-0.03, 1.03, 0.5, 0.5);//!
			~midCII.revmaxtime = ~predlevel.linlin(-0.03, 1.03, 10, 10);//!
			~midCII.mix = ~predlevel.linlin(-0.03, 1.03, 0.7, 0.2);
			//~midCII.amp = ~predlevel.linlin(-0.03, 1.03, 0.00001, 0.00009, clip: 'minmax');

			~drops.pos = ~predlevel.linlin(-0.03, 1.03, [-1,1], [0,0]); //for movement
			~drops.deltime = ~predlevel.linlin(-0.03, 1.03, 0.048, 0.098);
			~drops.deldecay =~predlevel.linlin(-0.03, 1.03, 15, 25);
			~drops.deltime = ~predlevel.linlin(-0.03, 1.03, 0.046, 0.098, clip: 'minmax');
			~drops.deldecay = ~predlevel.linlin(-0.03, 1.03, 15, 25, clip: 'minmax');
			//~drops.amp = ~predlevel.linlin(-0.03, 1.03, 0.19, 0.5, clip: 'minmax');

			postln(id);
			postln(predvalue);
		};

		if(id == 'Ocean Heat: ')
		{
			~predheat = predvalue;
			~underC.freq1 =  ~predheat.linexp(-0.03, 1.03, 40, 85, clip: 'minmax');
			~underC.freq2 = ~predheat.linexp(-0.03, 1.03, 70, 115, clip: 'minmax');
			postln(id);
			postln(predvalue);
		};


		if(id == 'Ocean Temperature: ')
		{
			~predtemp = predvalue;
			~midCI.freq1 = ~predtemp.linexp(-0.03, 1.03, 950, 1200.5, clip: 'minmax');
			~midCI.freq2 = ~predtemp.linexp(-0.03, 1.03, 1200, 1501.5, clip: 'minmax');
			~midCII.freq1 = ~predtemp.linexp(-0.03, 1.03, 750, 850, clip: 'minmax');
			~midCII.freq2 = ~predtemp.linexp(-0.03, 1.03, 825, 925, clip: 'minmax');
			postln(id);
			postln(predvalue);
		};

		if(id == 'Carbon Dioxide: ')
		{
			~predco = predvalue;
			~drops.dens = ~predco.linexp(-0.03, 1.03, 0.2, 0.9, clip: 'minmax');
			~drops.freqmin = ~predco.linexp(-0.03, 1.03, 400, 2400, clip: 'minmax');
			~drops.freqmax = ~predco.linexp(-0.03, 1.03, 750, 3000, clip: 'minmax');
			postln(id);
			postln(predvalue);
		};

		if(id == 'UnderC')
		{
			if(Pdef(\under).isActive != true,
				{Pdef(\under).play; postln('UnderCurrent ON');},
				{Pdef(\under).stop; postln('UnderCurrent OFF');}
			);
		};
		if(id == 'MidI')
		{
			if(Pdef(\midI).isActive != true,
				{Pdef(\midI).play; postln('MidCurrent I ON');},
				{Pdef(\midI).stop; postln('MidCurrent I OFF');}
			);
		};
		if(id == 'MidII')
		{
			if(Pdef(\midII).isActive != true,
				{Pdef(\midII).play; postln('MidCurrent II ON');},
				{Pdef(\midII).stop; postln('MidCurrent II OFF');}
			);
		};
		if(id == 'Drops')
		{
			if(Pdef(\drops).isActive != true,
				{Pdef(\drops).play; postln('Drops ON');},
				{Pdef(\drops).stop; postln('Drops OFF');}
			);
		};
	}
    };

thisProcess.addOSCRecvFunc(~comOSCpython);
);
