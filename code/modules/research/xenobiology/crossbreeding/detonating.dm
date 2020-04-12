/*
Detonating extracts:
Detonating extracts are primed like grenades, 
then provide a effect over a area after a fuse timer elapses.
*/
/obj/item/slimecross/detonating
    name = "detonating extract"
    desc = "It's currently boiling."
    effect = "detonating"
    icon_state = "detonating"

/obj/item/slimecross/detonating/Initialize()
    . = ..()
    create_reagents(10, INJECTABLE | DRAWABLE)

/obj/item/slimecross/detonating/attack_self(mob/user)
	if(!reagents.has_reagent(/datum/reagent/toxin/plasma,10))
		to_chat(user, "<span class='warning'>This extract needs to be full of plasma to activate!</span>")
		return
	reagents.remove_reagent(/datum/reagent/toxin/plasma,10)
	to_chat(user, "<span class='notice'>You squeeze the extract, and it absorbs the plasma!</span>")
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	do_effect(user)

/obj/item/slimecross/detonating/proc/do_effect(mob/user) //If, for whatever reason, you don't want to delete the extract, don't do ..()
	qdel(src)
	return

/obj/item/slimecross/detonating/grey
	colour = "grey"
	effect_desc = "Feeds the slimes in a 10x10 radius 600 nutrients. Must have nothing inbetween you."

/obj/item/slimecross/detonating/grey/do_effect(mob/user)
    for(var/mob/living/simple_animal/slime/S in view(10, get_turf(src)))
        sleep(30)
        visible_message("<span class='notice'> The slimes around [src] seem noticibly happier!")
        S.adjust_nutrition(600) // TODO: fix the fact it goes through windows
    ..()

/obj/item/slimecross/detonating/orange
    colour = "orange"
    effect_desc = "Creates a fire that is 7x7 wide. Does not explode, or expand."

/obj/item/slimecross/detonating/orange/do_effect(var/source, var/list/turfs, var/obj/structure/)
    for(var/turf/turf in range(7,get_turf(src))) // TODO: urgently needs to not go through walls, that's not good.
        if(istype(turf, /turf/closed))
            continue
        if(isobj(/obj/structure/window))
            continue
        if(!locate(/obj/effect/hotspot) in turf)
            new /obj/effect/hotspot(turf)
            turf.hotspot_expose(700,50,1)
        ..()
