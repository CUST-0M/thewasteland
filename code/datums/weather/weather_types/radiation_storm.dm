/datum/weather/rad_storm
	name = "radiation storm"
	desc = "A cloud of intense radiation passes through the area dealing rad damage to those who are unprotected."
	probability = 6

	telegraph_duration = 400
	telegraph_message = "<span class='danger'>The skies slowly turn into a glowing green.</span>"

	weather_message = "<span class='danger'><i>You feel waves of heat wash over you! Find shelter!</i></span>"
	weather_overlay = "ash_storm"
	weather_duration_lower = 600
	weather_duration_upper = 1500
	weather_color = "green"
	weather_sound = 'sound/weather/thunder.ogg'

	end_duration = 100
	end_message = "<span class='notice'>The air seems to be cooling off again, the sky returning to it's normal color.</span>"

	area_types = list(/area/f13/wasteland, /area/f13/desert, /area/f13/farm, /area/f13/forest, /area/f13/ruins)
	protected_areas = list(/area/maintenance, /area/ai_monitored/turret_protected/ai_upload, /area/ai_monitored/turret_protected/ai_upload_foyer,
	/area/ai_monitored/turret_protected/ai, /area/storage/emergency/starboard, /area/storage/emergency/port, /area/shuttle, /area/security/prison, /area/ruin, /area/space/nearstation, /area/icemoon)
	target_trait = ZTRAIT_STATION

	immunity_type = "rad"
	
	var/radiation_intensity = 100

/datum/weather/rad_storm/telegraph()
	..()
	status_alarm(TRUE)

/datum/weather/rad_storm/weather_act(mob/living/L)
	var/resist = L.getarmor(null, "rad")
	var/ratio = 1 - (min(resist, 100) / 100)
	L.rad_act(radiation_intensity * ratio)

/datum/weather/rad_storm/end()
	if(..())
		return
	status_alarm(FALSE)

/datum/weather/rad_storm/proc/status_alarm(active)	//Makes the status displays show the radiation warning for those who missed the announcement.
	var/datum/radio_frequency/frequency = SSradio.return_frequency(FREQ_STATUS_DISPLAYS)
	if(!frequency)
		return

	var/datum/signal/signal = new
	if (active)
		signal.data["command"] = "alert"
		signal.data["picture_state"] = "radiation"
	else
		signal.data["command"] = "shuttle"

	var/atom/movable/virtualspeaker/virt = new(null)
	frequency.post_signal(virt, signal)
