/obj/item/clothing/accessory/holster
	name = "shoulder holster"
	desc = "A handgun holster."
	icon_state = "holster"
	_color = "holster"
	slot = "utility"
	var/holster_allow = /obj/item/weapon/gun
	var/obj/item/weapon/gun/holstered = null
	icon_action_button = "action_holster"
	w_class = 3.0 // so it doesn't fit in pockets

//subtypes can override this to specify what can be holstered
/obj/item/clothing/accessory/holster/proc/can_holster(obj/item/weapon/gun/W)
	if(!W.isHandgun())
		return 0
	else if(!istype(W,holster_allow))
		return 0
	else
		return 1

/obj/item/clothing/accessory/holster/attack_self()
	var/holsteritem = usr.get_active_hand()
	if(!holstered)
		holster(holsteritem, usr)
	else
		unholster(usr)

/obj/item/clothing/accessory/holster/proc/holster(obj/item/I, mob/user as mob)
	if(holstered)
		user << "<span class='warning'>There is already a [holstered] holstered here!</span>"
		return

	if (!istype(I, /obj/item/weapon/gun))
		user << "<span class='warning'>Only guns can be holstered!</span>"
		return

	var/obj/item/weapon/gun/W = I
	if (!can_holster(W))
		user << "<span class='warning'>This [W] won't fit in the [src]!</span>"
		return

	holstered = W
	user.unEquip(holstered)
	holstered.loc = src
	holstered.add_fingerprint(user)
	user.visible_message("<span class='notice'>[user] holsters the [holstered].</span>", "<span class='notice'>You holster the [holstered].</span>")

/obj/item/clothing/accessory/holster/proc/unholster(mob/user as mob)
	if(!holstered)
		return

	if(istype(user.get_active_hand(),/obj) && istype(user.get_inactive_hand(),/obj))
		user << "<span class='warning'>You need an empty hand to draw the [holstered]!</span>"
	else
		if(user.a_intent == "hurt")
			usr.visible_message("\red [user] draws the [holstered], ready to shoot!</span>", \
			"<span class='warning'>You draw the [holstered], ready to shoot!</span>")
		else
			user.visible_message("<span class='notice'>[user] draws the [holstered], pointing it at the ground.</span>", \
			"<span class='notice'>You draw the [holstered], pointing it at the ground.</span>")
		user.put_in_hands(holstered)
		holstered.add_fingerprint(user)
		holstered = null

/obj/item/clothing/accessory/holster/attack_hand(mob/user as mob)
	if (has_suit)	//if we are part of a suit
		if (holstered)
			unholster(user)
		return

	..(user)

/obj/item/clothing/accessory/holster/attackby(obj/item/W as obj, mob/user as mob, params)
	holster(W, user)

/obj/item/clothing/accessory/holster/emp_act(severity)
	if (holstered)
		holstered.emp_act(severity)
	..()

/obj/item/clothing/accessory/holster/examine(mob/user)
	..(user)
	if (holstered)
		user << "A [holstered] is holstered here."
	else
		user << "It is empty."

/obj/item/clothing/accessory/holster/on_attached(obj/item/clothing/under/S, mob/user as mob)
	..()
	has_suit.verbs += /obj/item/clothing/accessory/holster/verb/holster_verb

/obj/item/clothing/accessory/holster/on_removed(mob/user as mob)
	has_suit.verbs -= /obj/item/clothing/accessory/holster/verb/holster_verb
	..()

//For the holster hotkey
/obj/item/clothing/accessory/holster/verb/holster_verb()
	set name = "Holster"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	var/obj/item/clothing/accessory/holster/H = null
	if (istype(src, /obj/item/clothing/accessory/holster))
		H = src
	else if (istype(src, /obj/item/clothing/under))
		var/obj/item/clothing/under/S = src
		if (S.accessories.len)
			H = locate() in S.accessories

	if (!H)
		usr << "<span class='warning'>Something is very wrong.</span>"

	if(!H.holstered)
		if(!istype(usr.get_active_hand(), /obj/item/weapon/gun))
			usr << "<span class='warning'>You need your gun equiped to holster it.</span>"
			return
		var/obj/item/weapon/gun/W = usr.get_active_hand()
		H.holster(W, usr)
	else
		H.unholster(usr)

/obj/item/clothing/accessory/holster/armpit
	name = "shoulder holster"
	desc = "A worn-out handgun holster. Perfect for concealed carry"
	icon_state = "holster"
	_color = "holster"
	holster_allow = /obj/item/weapon/gun/projectile

/obj/item/clothing/accessory/holster/waist
	name = "shoulder holster"
	desc = "A handgun holster. Made of expensive leather."
	icon_state = "holster"
	_color = "holster_low"