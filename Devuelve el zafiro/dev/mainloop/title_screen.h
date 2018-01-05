		sp_UpdateNow();

		//blackout ();
#ifdef MODE_128K
		// Resource 0 = title.bin
		get_resource (0, 16384);
#else
		unpack ((unsigned int) (s_title), 16384);
#endif

// CUSTOM {
#ifndef INGLISHPITINGLISH
	print_str (7, 4, 71, "RAMIRO, EL VAMPIRO");
	print_str (12, 7, 7, "DEVUELVE");
	print_str (11, 8, 7, "EL ZAFIRO!");
#else
	print_str (6, 4, 71, "RAMIRE, THE VAMPIRE");
	print_str (12, 7, 7, "PUTS BACK");
	print_str (11, 8, 7, "THE ZAPHIRE");
#endif

	print_str (5, 19, 71, "MOJON TWINS 2013, 2016");
	print_str (9, 20, 7, "MT MK2 V.0.90C");

	sp_UpdateNow ();
// } END_OF_CUSTOM

#ifdef MODE_128K
		_AY_PL_MUS (0);
#endif
		select_joyfunc ();
#ifdef MODE_128K
		_AY_ST_ALL ();
#endif
		