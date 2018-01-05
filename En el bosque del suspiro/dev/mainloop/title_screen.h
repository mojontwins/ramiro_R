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
	print_str (10, 7, 7, "EN EL BOSQUE");
	print_str (10, 8, 7, "DEL SUSPIRO!");
#else
	print_str (6, 4, 71, "RAMIRE, THE VAMPIRE");
	print_str (10, 7, 7, "IN THE WOODS");
	print_str (10, 8, 7, "OF WHISPERS!");
#endif

	print_str (5, 19, 71, "MOJON TWINS 2013, 2016");
	print_str (9, 20, 7, "MT MK2 V.0.90B");

	sp_UpdateNow ();
// } END_OF_CUSTOM

#ifdef MODE_128K
		_AY_PL_MUS (0);
#endif
		select_joyfunc ();
#ifdef MODE_128K
		_AY_ST_ALL ();
#endif
		