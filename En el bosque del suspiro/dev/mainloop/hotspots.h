// AT LAST! A rewrite.
// Original code is left at hotspots-old-orig.h so you can have a laugh

// Note that the old behaviour in which a refill appeared at
// random in place of an already gotten object/key has been
// sent to the most complete oblivion, as we haven't used such
// configuration since I can't remember. So...

			if (collide (gpx, gpy, hotspot_x, hotspot_y)) {
				draw_coloured_tile (VIEWPORT_X + (hotspot_x >> 3), VIEWPORT_Y + (hotspot_y >> 3), orig_tile);
				gpit = 0;
				hotspots [n_pant].act = 0;
				switch (hotspots [n_pant].tipo) {
				// 1: Object
#ifndef DEACTIVATE_OBJECTS
					case 1:
#ifdef ONLY_ONE_OBJECT
						if (p_objs == 0) {
							p_objs ++;
#ifdef MODE_128K
							_AY_PL_SND (SFX_OBJECT);
#else
							beep_fx (SFX_OBJECT);
#endif
						} else {
#ifdef MODE_128K
							_AY_PL_SND (SFX_WRONG);
#else
							beep_fx (SFX_WRONG);
#endif
							draw_coloured_tile (VIEWPORT_X + (hotspot_x >> 3), VIEWPORT_Y + (hotspot_y >> 3), 17);
							gpit = 1;
						}					
#else
						p_objs ++;
						if (p_objs == 10) {
							do_extern_action (84);
							o_pant = 99; 
						}
#ifdef OBJECT_COUNT
						flags [OBJECT_COUNT] = player.objs;
#endif
#ifdef MODE_128K
						_AY_PL_SND (SFX_OBJECT);
#else
						beep_fx (SFX_OBJECT);
#endif
#endif						
						break;
#endif

				// 2: Key
#ifndef DEACTIVATE_KEYS
					case 2:
						p_keys ++;
#ifdef MODE_128K
						_AY_PL_SND (SFX_KEY);
#else
						beep_fx (SFX_KEY);
#endif
						break;
#endif

				// 3: Refill
#ifndef DEACTIVATE_REFILLS
					case 3:
						p_life += PLAYER_REFILL;
#ifndef DONT_LIMIT_LIFE
						if (p_life > PLAYER_LIFE)
							p_life = PLAYER_LIFE;
#endif
#ifdef MODE_128K
						_AY_PL_SND (SFX_REFILL);
#else
						beep_fx (SFX_REFILL);
#endif
						break;
#endif

				// 4: Ammo
#ifdef MAX_AMMO
					case 4:
						if (MAX_AMMO - p_ammo > AMMO_REFILL)
							p_ammo += AMMO_REFILL;
						else
							p_ammo = MAX_AMMO;
#ifdef MODE_128K
						_AY_PL_SND (SFX_AMMO);
#else
						beep_fx (SFX_AMMO);
#endif
						break;
#endif

				// 5: Time
#ifdef TIMER_REFILL
					case 5:
						if (99 - ctimer.t > TIMER_REFILL)
							ctimer.t += TIMER_REFILL;
						else
							ctimer.t = 99;
#ifdef MODE_128K
						_AY_PL_SND (SFX_TIME);
#else
						beep_fx (SFX_TIME);
#endif
						break;
#endif

				// 6: Fuel
#ifdef JETPAC_REFILLS
					case 6:
						p_fuel += JETPAC_FUEL_REFILL;
						if (p_fuel > JETPAC_FUEL_MAX) p_fuel = JETPAC_FUEL_MAX;
#ifdef MODE_128K
						_AY_PL_SND (SFX_FUEL);
#else
						beep_fx (SFX_FUEL);
#endif
						break;
#endif

				}
				hotspot_y = 240;
			}
