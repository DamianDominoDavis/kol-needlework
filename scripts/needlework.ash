if (get_property("questM02Artist") != "finished")
	abort("Quest first.");

string cache_autoSatisfyWithCloset = get_property("autoSatisfyWithCloset");
int[item] cache_closet = get_closet();
buffer artist, tatspage = visit_url("account_tattoos.php");
boolean[string] unlocked;

try {
	cli_execute("checkpoint");
	outfit("nothing");
	if (!to_boolean(get_property("autoSatisfyWithCloset")))
		set_property("autoSatisfyWithCloset", "true");
	foreach _,o in all_normal_outfits()
		if (!contains_text(tatspage, outfit_tattoo(o)) && have_outfit(o) && outfit(o)) {
			artist = visit_url("place.php?whichplace=town_wrong&action=townwrong_artist_quest");
			if (contains_text(artist, "You have unlocked a new tattoo"))
				unlocked[o] = true;
		}
	print(`Unlocked {count(unlocked)} tattoos.`, "blue");
	foreach o in unlocked
		print(`Unlocked "{outfit_tattoo(o)}" ({o})`);
}

finally {
	outfit("checkpoint");
	if (get_property("autoSatisfyWithCloset") != cache_autoSatisfyWithCloset)
		set_property("autoSatisfyWithCloset", cache_autoSatisfyWithCloset);
	foreach it,qty in cache_closet
		if (qty > closet_amount(it))
			put_closet(it, qty - closet_amount(it));
}
