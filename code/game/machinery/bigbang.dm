var/list/big_bangs = list()

/obj/machinery/big_bang
	name = "tachyon-doppler array"
	desc = "A highly precise directional sensor array which measures the release of quants from decaying tachyons. The doppler shifting of the mirror-image formed by these quants can reveal the size, location and temporal affects of energetic disturbances within a large radius ahead of the array."
	icon = 'icons/obj/computer.dmi'
	icon_state = "forensic"
	var/list/bangs = list()

/obj/machinery/big_bang/New()
	big_bangs += src

/obj/machinery/big_bang/Del()
	big_bangs -= src

/obj/machinery/big_bang/process()
	return PROCESS_KILL

/obj/machinery/big_bang/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/big_bang/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/big_bang/attack_hand(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/machinery/big_bang/interact(mob/user as mob)
	var/listing={"
<html>
	<head>
		<title>Nanotrasen Bhangmeter Mk. V</title>
	</head>
	<body>
		<h1>Recent Explosions</h1>
		<table>
			<tr>
				<th>Grid</th>
				<th>Power</th>
				<th>Temporal Displacement</th>
			</tr>
"}
	for(var/item in bangs)
		listing += item
	listing += {"
		</table>
	</body>
</html>"}
	user << browse(listing, "window=bhangmeter")
	onclose(user, "bhangmeter")
	return
/obj/machinery/big_bang/proc/sense_explosion(var/x0,var/y0,var/z0,var/devastation_range,var/heavy_impact_range,var/light_impact_range,var/took)
	if(stat & NOPOWER)	return
	if(z != z0)			return


	var/dx = abs(x0-x)
	var/dy = abs(y0-y)
	var/distance
	var/direct

	if(dx > dy)
		distance = dx
		if(x0 > x)	direct = EAST
		else		direct = WEST
	else
		distance = dy
		if(y0 > y)	direct = NORTH
		else		direct = SOUTH

	if(distance > 100)		return
	if(!(direct & dir))	return


	var/message = "Explosive disturbance detected - Epicenter at: grid ([x0],[y0]). Epicenter radius: [devastation_range]. Outer radius: [heavy_impact_range]. Shockwave radius: [light_impact_range]. Temporal displacement of tachyons: [took]seconds.  Data logged."
	src.visible_message( \
		"<span class='game say'><span class='name'>[src]</span> states coldly, \"[message]\"</span>", \
		"You hear muffled speech." \
	)
	var/bang = "<tr><td>([x0],[y0])</td><td>([devastation_range],[heavy_impact_range],[light_impact_range])</td><td>[took]s</td></tr>"
	bangs+=bang


/obj/machinery/big_bang/power_change()
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]b"
	else
		if( powered() )
			icon_state = initial(icon_state)
			stat &= ~NOPOWER
		else
			icon_state = "[initial(icon_state)]0"
			stat |= NOPOWER