// A special pen for service droids. Can be toggled to switch between normal writing mode, and paper rename mode
// Allows service droids to rename paper items.

/obj/item/weapon/pen/robopen
	desc = "A black ink printing attachment with a paper naming mode."
	name = "Printing Pen"
	var/mode = 1

/obj/item/weapon/pen/robopen/attack_self(mob/user as mob)

	var/choice = input("Would you like to change colour or mode?") as null|anything in list("Colour","Mode")
	if(!choice) return

	playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)

	switch(choice)

		if("Colour")
			var/newcolour = input("Which colour would you like to use?") as null|anything in list("black","blue","red","green","yellow")
			if(newcolour) colour = newcolour

		if("Mode")
			if (mode == 1)
				mode = 2
			else
				mode = 1
			user << "Changed printing mode to '[mode == 2 ? "Rename Paper" : "Write Paper"]'"

	return

// Copied over from paper's rename verb
// see code\modules\paperwork\paper.dm line 62

/obj/item/weapon/pen/robopen/proc/RenamePaper(mob/user as mob,obj/paper as obj)
	if ( !user || !paper )
		return
	var/n_name = input(user, "What would you like to label the paper?", "Paper Labelling", null)  as text
	if ( !user || !paper )
		return

	n_name = copytext(n_name, 1, 32)
	if(( get_dist(user,paper) <= 1  && user.stat == 0))
		paper.name = "paper[(n_name ? text("- '[n_name]'") : null)]"
	add_fingerprint(user)
	return

//TODO: Add prewritten forms to dispense when you work out a good way to store the strings.
/obj/item/weapon/form_printer
	//name = "paperwork printer"
	name = "paper dispenser"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper_bin1"
	item_state = "sheet-metal"

/obj/item/weapon/form_printer/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	return

/obj/item/weapon/form_printer/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag, params)

	if(!target || !flag)
		return

	if(istype(target,/obj/structure/table))
		deploy_paper(get_turf(target))

/obj/item/weapon/form_printer/attack_self(mob/user as mob)
	deploy_paper(get_turf(src))

/obj/item/weapon/form_printer/proc/deploy_paper(var/turf/T)
	T.visible_message("\blue \The [src.loc] dispenses a sheet of crisp white paper.")
	new /obj/item/weapon/paper(T)


//Personal shielding for the combat module.
/obj/item/borg/combat/shield
	name = "personal shielding"
	desc = "A powerful experimental module that turns aside or absorbs incoming attacks at the cost of charge."
	icon = 'icons/obj/decals.dmi'
	icon_state = "shock"
	var/shield_level = 0.5 //Percentage of damage absorbed by the shield.

/obj/item/borg/combat/shield/verb/set_shield_level()
	set name = "Set shield level"
	set category = "Object"
	set src in range(0)

	var/N = input("How much damage should the shield absorb?") in list("5","10","25","50","75","100")
	if (N)
		shield_level = text2num(N)/100

/obj/item/borg/combat/mobility
	name = "mobility module"
	desc = "By retracting limbs and tucking in its head, a combat android can roll at high speeds."
	icon = 'icons/obj/decals.dmi'
	icon_state = "shock"