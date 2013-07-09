/obj/machinery/door/poddoor/dangerdoor
	name = "Danger Door"
	desc = "A heavy duty blast door used in dangerous environments that opens mechanically."
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = "ddoor1"
	explosion_resistance = 30

/obj/machinery/door/poddoor/dangerdoor/Bumped(atom/AM)
	if(!density)
		return ..()
	else
		return 0

/obj/machinery/door/poddoor/dangerdoor/attackby(obj/item/weapon/C as obj, mob/user as mob)
	src.add_fingerprint(user)
	if (!( istype(C, /obj/item/weapon/crowbar) || (istype(C, /obj/item/weapon/twohanded/fireaxe) && C:wielded == 1) ))
		return
	if ((src.density && (stat & NOPOWER) && !( src.operating )))
		spawn( 0 )
			src.operating = 1
			flick("ddoorc0", src)
			src.icon_state = "ddoor0"
			src.SetOpacity(0)
			sleep(15)
			src.density = 0
			src.operating = 0
			return
	return

/obj/machinery/door/poddoor/dangerdoor/open()
	if (src.operating == 1) //doors can still open when emag-disabled
		return
	if (!ticker)
		return 0
	if(!src.operating) //in case of emag
		src.operating = 1
	flick("ddoorc0", src)
	src.icon_state = "ddoor0"
	src.SetOpacity(0)
	sleep(10)
	src.density = 0
	update_nearby_tiles()

	if(operating == 1) //emag again
		src.operating = 0
	if(autoclose)
		spawn(150)
			autoclose()
	return 1

/obj/machinery/door/poddoor/dangerdoor/close()
	if (src.operating)
		return
	src.operating = 1
	flick("ddoorc1", src)
	src.icon_state = "ddoor1"
	src.density = 1
	src.SetOpacity(initial(opacity))
	update_nearby_tiles()

	sleep(10)
	src.operating = 0
	return